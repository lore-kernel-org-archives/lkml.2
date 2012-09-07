Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491Ab2IGSjH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 14:39:07 -0400
Received: from smtp.outflux.net ([198.145.64.163]:52148 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754352Ab2IGSid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 14:38:33 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        James Morris <james.l.morris@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Kees Cook <keescook@chromium.org>, Jiri Kosina <jkosina@suse.cz>,
        linux-security-module@vger.kernel.org
Subject: [PATCH 1/2] module: add syscall to load module from fd
Date: Fri,  7 Sep 2012 11:38:13 -0700
Message-Id: <1347043094-11120-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.0.4
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of (or in addition to) kernel module signing, being able to reason
about the origin of a kernel module would be valuable in situations
where an OS already trusts a specific file system, file, etc, due to
things like security labels or an existing root of trust to a partition
through things like dm-verity.

This introduces a new syscall (currently only on x86), similar to
init_module, that has only two arguments. The first argument is used as
a file descriptor to the module and the second argument is a pointer to
the NULL terminated string of module arguments.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
v2:
 - various cleanups, thanks to Rusty Russell.
---
 arch/x86/syscalls/syscall_32.tbl |    1 +
 arch/x86/syscalls/syscall_64.tbl |    1 +
 include/linux/syscalls.h         |    1 +
 kernel/module.c                  |  214 ++++++++++++++++++++++++++-----------
 kernel/sys_ni.c                  |    1 +
 5 files changed, 154 insertions(+), 64 deletions(-)

diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
index 7a35a6e..98e76bf 100644
--- a/arch/x86/syscalls/syscall_32.tbl
+++ b/arch/x86/syscalls/syscall_32.tbl
@@ -356,3 +356,4 @@
 347	i386	process_vm_readv	sys_process_vm_readv		compat_sys_process_vm_readv
 348	i386	process_vm_writev	sys_process_vm_writev		compat_sys_process_vm_writev
 349	i386	kcmp			sys_kcmp
+350	i386	init_module_fd		sys_init_module_fd
diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index a582bfe..722476b 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -319,6 +319,7 @@
 310	64	process_vm_readv	sys_process_vm_readv
 311	64	process_vm_writev	sys_process_vm_writev
 312	common	kcmp			sys_kcmp
+313	common	init_module_fd		sys_init_module_fd
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 19439c7..6ee6e31 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -860,4 +860,5 @@ asmlinkage long sys_process_vm_writev(pid_t pid,
 
 asmlinkage long sys_kcmp(pid_t pid1, pid_t pid2, int type,
 			 unsigned long idx1, unsigned long idx2);
+asmlinkage long sys_init_module_fd(int fd, const char __user *uargs);
 #endif
diff --git a/kernel/module.c b/kernel/module.c
index 4edbd9c..c1e446e 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -21,6 +21,7 @@
 #include <linux/ftrace_event.h>
 #include <linux/init.h>
 #include <linux/kallsyms.h>
+#include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/sysfs.h>
 #include <linux/kernel.h>
@@ -2399,48 +2400,102 @@ static inline void kmemleak_load_module(const struct module *mod,
 }
 #endif
 
+/* Sanity checks against invalid binaries, wrong arch, weird elf version. */
+static int check_info(struct load_info *info)
+{
+	if (info->len < sizeof(*(info->hdr)))
+		return -ENOEXEC;
+
+	if (memcmp(info->hdr->e_ident, ELFMAG, SELFMAG) != 0
+	    || info->hdr->e_type != ET_REL
+	    || !elf_check_arch(info->hdr)
+	    || info->hdr->e_shentsize != sizeof(Elf_Shdr))
+		return -ENOEXEC;
+
+	if (info->hdr->e_shoff >= info->len
+	    || (info->hdr->e_shnum * sizeof(Elf_Shdr) >
+		info->len - info->hdr->e_shoff))
+		return -ENOEXEC;
+
+	return 0;
+}
+
 /* Sets info->hdr and info->len. */
-static int copy_and_check(struct load_info *info,
-			  const void __user *umod, unsigned long len,
-			  const char __user *uargs)
+int copy_module_from_user(const void __user *umod, unsigned long len,
+			  struct load_info *info)
 {
 	int err;
-	Elf_Ehdr *hdr;
 
-	if (len < sizeof(*hdr))
+	info->len = len;
+	if (info->len < sizeof(*(info->hdr)))
 		return -ENOEXEC;
 
 	/* Suck in entire file: we'll want most of it. */
-	if ((hdr = vmalloc(len)) == NULL)
+	info->hdr = vmalloc(info->len);
+	if (!info->hdr)
 		return -ENOMEM;
 
-	if (copy_from_user(hdr, umod, len) != 0) {
-		err = -EFAULT;
+	err = copy_from_user(info->hdr, umod, info->len);
+	if (err)
 		goto free_hdr;
-	}
 
-	/* Sanity checks against insmoding binaries or wrong arch,
-	   weird elf version */
-	if (memcmp(hdr->e_ident, ELFMAG, SELFMAG) != 0
-	    || hdr->e_type != ET_REL
-	    || !elf_check_arch(hdr)
-	    || hdr->e_shentsize != sizeof(Elf_Shdr)) {
-		err = -ENOEXEC;
+	err = check_info(info);
+	if (err)
 		goto free_hdr;
+
+	return err;
+
+free_hdr:
+	vfree(info->hdr);
+	return err;
+}
+
+/* Sets info->hdr and info->len. */
+int copy_module_from_fd(int fd, struct load_info *info)
+{
+	struct file *file;
+	int err;
+	struct kstat stat;
+	unsigned long size;
+	off_t pos;
+	ssize_t bytes = 0;
+
+	file = fget(fd);
+	if (!file)
+		return -ENOEXEC;
+
+	err = vfs_getattr(file->f_vfsmnt, file->f_dentry, &stat);
+	if (err)
+		goto out;
+
+	size = stat.size;
+	info->hdr = vmalloc(size);
+	if (!info->hdr) {
+		err = -ENOMEM;
+		goto out;
 	}
 
-	if (hdr->e_shoff >= len ||
-	    hdr->e_shnum * sizeof(Elf_Shdr) > len - hdr->e_shoff) {
-		err = -ENOEXEC;
-		goto free_hdr;
+	pos = 0;
+	while (pos < size) {
+		bytes = kernel_read(file, pos, (char *)(info->hdr) + pos,
+				    size - pos);
+		if (bytes < 0) {
+			vfree(info->hdr);
+			err = bytes;
+			goto out;
+		}
+		if (bytes == 0)
+			break;
+		pos += bytes;
 	}
+	info->len = pos;
 
-	info->hdr = hdr;
-	info->len = len;
-	return 0;
+	err = check_info(info);
+	if (err)
+		vfree(info->hdr);
 
-free_hdr:
-	vfree(hdr);
+out:
+	fput(file);
 	return err;
 }
 
@@ -2861,26 +2916,17 @@ static int post_relocation(struct module *mod, const struct load_info *info)
 	return module_finalize(info->hdr, info->sechdrs, mod);
 }
 
+static int do_init_module(struct module *mod);
+
 /* Allocate and load the module: note that size of section 0 is always
    zero, and we rely on this for optional sections. */
-static struct module *load_module(void __user *umod,
-				  unsigned long len,
-				  const char __user *uargs)
+static int load_module(struct load_info *info, const char __user *uargs)
 {
-	struct load_info info = { NULL, };
 	struct module *mod;
 	long err;
 
-	pr_debug("load_module: umod=%p, len=%lu, uargs=%p\n",
-	       umod, len, uargs);
-
-	/* Copy in the blobs from userspace, check they are vaguely sane. */
-	err = copy_and_check(&info, umod, len, uargs);
-	if (err)
-		return ERR_PTR(err);
-
 	/* Figure out module layout, and allocate all the memory. */
-	mod = layout_and_allocate(&info);
+	mod = layout_and_allocate(info);
 	if (IS_ERR(mod)) {
 		err = PTR_ERR(mod);
 		goto free_copy;
@@ -2893,25 +2939,25 @@ static struct module *load_module(void __user *umod,
 
 	/* Now we've got everything in the final locations, we can
 	 * find optional sections. */
-	find_module_sections(mod, &info);
+	find_module_sections(mod, info);
 
 	err = check_module_license_and_versions(mod);
 	if (err)
 		goto free_unload;
 
 	/* Set up MODINFO_ATTR fields */
-	setup_modinfo(mod, &info);
+	setup_modinfo(mod, info);
 
 	/* Fix up syms, so that st_value is a pointer to location. */
-	err = simplify_symbols(mod, &info);
+	err = simplify_symbols(mod, info);
 	if (err < 0)
 		goto free_modinfo;
 
-	err = apply_relocations(mod, &info);
+	err = apply_relocations(mod, info);
 	if (err < 0)
 		goto free_modinfo;
 
-	err = post_relocation(mod, &info);
+	err = post_relocation(mod, info);
 	if (err < 0)
 		goto free_modinfo;
 
@@ -2941,14 +2987,14 @@ static struct module *load_module(void __user *umod,
 	}
 
 	/* This has to be done once we're sure module name is unique. */
-	dynamic_debug_setup(info.debug, info.num_debug);
+	dynamic_debug_setup(info->debug, info->num_debug);
 
 	/* Find duplicate symbols */
 	err = verify_export_symbols(mod);
 	if (err < 0)
 		goto ddebug;
 
-	module_bug_finalize(info.hdr, info.sechdrs, mod);
+	module_bug_finalize(info->hdr, info->sechdrs, mod);
 	list_add_rcu(&mod->list, &modules);
 	mutex_unlock(&module_mutex);
 
@@ -2959,16 +3005,17 @@ static struct module *load_module(void __user *umod,
 		goto unlink;
 
 	/* Link in to syfs. */
-	err = mod_sysfs_setup(mod, &info, mod->kp, mod->num_kp);
+	err = mod_sysfs_setup(mod, info, mod->kp, mod->num_kp);
 	if (err < 0)
 		goto unlink;
 
 	/* Get rid of temporary copy. */
-	free_copy(&info);
+	free_copy(info);
 
 	/* Done! */
 	trace_module_load(mod);
-	return mod;
+
+	return do_init_module(mod);
 
  unlink:
 	mutex_lock(&module_mutex);
@@ -2977,7 +3024,7 @@ static struct module *load_module(void __user *umod,
 	module_bug_cleanup(mod);
 
  ddebug:
-	dynamic_debug_remove(info.debug);
+	dynamic_debug_remove(info->debug);
  unlock:
 	mutex_unlock(&module_mutex);
 	synchronize_sched();
@@ -2989,10 +3036,10 @@ static struct module *load_module(void __user *umod,
  free_unload:
 	module_unload_free(mod);
  free_module:
-	module_deallocate(mod, &info);
+	module_deallocate(mod, info);
  free_copy:
-	free_copy(&info);
-	return ERR_PTR(err);
+	free_copy(info);
+	return err;
 }
 
 /* Call module constructors. */
@@ -3007,21 +3054,10 @@ static void do_mod_ctors(struct module *mod)
 }
 
 /* This is where the real work happens */
-SYSCALL_DEFINE3(init_module, void __user *, umod,
-		unsigned long, len, const char __user *, uargs)
+static int do_init_module(struct module *mod)
 {
-	struct module *mod;
 	int ret = 0;
 
-	/* Must have permission */
-	if (!capable(CAP_SYS_MODULE) || modules_disabled)
-		return -EPERM;
-
-	/* Do all the hard work */
-	mod = load_module(umod, len, uargs);
-	if (IS_ERR(mod))
-		return PTR_ERR(mod);
-
 	blocking_notifier_call_chain(&module_notify_list,
 			MODULE_STATE_COMING, mod);
 
@@ -3091,6 +3127,56 @@ SYSCALL_DEFINE3(init_module, void __user *, umod,
 	return 0;
 }
 
+static int init_module_permission(void)
+{
+	/* Must have permission */
+	if (!capable(CAP_SYS_MODULE) || modules_disabled)
+		return -EPERM;
+
+	return 0;
+}
+
+SYSCALL_DEFINE2(init_module_fd, int, fd, const char __user *, uargs)
+{
+	int err;
+	struct load_info info = { };
+
+	err = init_module_permission();
+	if (err)
+		return err;
+
+	pr_debug("init_module_fd: fd=%d, uargs=%p\n", fd, uargs);
+
+	if (fd < 0)
+		return -ENOEXEC;
+
+	err = copy_module_from_fd(fd, &info);
+	if (err)
+		return err;
+
+	return load_module(&info, uargs);
+}
+
+SYSCALL_DEFINE3(init_module, void __user *, umod,
+		unsigned long, len, const char __user *, uargs)
+{
+	int err;
+	struct load_info info = { };
+
+	err = init_module_permission();
+	if (err)
+		return err;
+
+	pr_debug("init_module: umod=%p, len=%lu, uargs=%p\n",
+	       umod, len, uargs);
+
+	err = copy_module_from_user(umod, len, &info);
+	if (err)
+		return err;
+
+	return load_module(&info, uargs);
+}
+
 static inline int within(unsigned long addr, void *start, unsigned long size)
 {
 	return ((void *)addr >= start && (void *)addr < start + size);
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index dbff751..3195f80 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -25,6 +25,7 @@ cond_syscall(sys_swapoff);
 cond_syscall(sys_kexec_load);
 cond_syscall(compat_sys_kexec_load);
 cond_syscall(sys_init_module);
+cond_syscall(sys_init_module_fd);
 cond_syscall(sys_delete_module);
 cond_syscall(sys_socketpair);
 cond_syscall(sys_bind);
-- 
1.7.0.4

