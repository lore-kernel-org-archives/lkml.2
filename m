Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364Ab2JDUXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 16:23:40 -0400
Received: from smtp.outflux.net ([198.145.64.163]:41135 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753926Ab2JDUXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 16:23:36 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>,
        James Morris <james.l.morris@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        linux-security-module@vger.kernel.org
Subject: [PATCH 1/4] module: add syscall to load module from fd
Date: Thu,  4 Oct 2012 13:22:31 -0700
Message-Id: <1349382154-9804-2-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349382154-9804-1-git-send-email-keescook@chromium.org>
References: <1349382154-9804-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of the effort to create a stronger boundary between root and
kernel, Chrome OS wants to be able to enforce that kernel modules are
being loaded only from our read-only crypto-hash verified (dm_verity)
root filesystem. Since the init_module syscall hands the kernel a module
as a memory blob, no reasoning about the origin of the blob can be made.

Earlier proposals for appending signatures to kernel modules would not be
useful in Chrome OS, since it would involve adding an additional set of
keys to our kernel and builds for no good reason: we already trust the
contents of our root filesystem. We don't need to verify those kernel
modules a second time. Having to do signature checking on module loading
would slow us down and be redundant. All we need to know is where a
module is coming from so we can say yes/no to loading it.

If a file descriptor is used as the source of a kernel module, many more
things can be reasoned about. In Chrome OS's case, we could enforce that
the module lives on the filesystem we expect it to live on.  In the case
of IMA (or other LSMs), it would be possible, for example, to examine
extended attributes that may contain signatures over the contents of
the module.

This introduces a new syscall (on x86), similar to init_module, that has
only two arguments. The first argument is used as a file descriptor to
the module and the second argument is a pointer to the NULL terminated
string of module arguments.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
v5:
 - rebase onto rusty's module-next tree.
v4:
 - fixed misplaced ack (moved from ARM to asm-generic).
v3:
 - fix ret from copy_from_user, thanks to Fengguang Wu.
 - rename to finit_module, suggested by Peter Anvin.
 - various cleanups, suggested from Andrew Morton.
v2:
 - various cleanups, thanks to Rusty Russell.
---
 arch/x86/syscalls/syscall_32.tbl |    1 +
 arch/x86/syscalls/syscall_64.tbl |    1 +
 include/linux/syscalls.h         |    1 +
 kernel/module.c                  |  363 +++++++++++++++++++++++---------------
 kernel/sys_ni.c                  |    1 +
 5 files changed, 222 insertions(+), 145 deletions(-)

diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
index 7a35a6e..74ccf44 100644
--- a/arch/x86/syscalls/syscall_32.tbl
+++ b/arch/x86/syscalls/syscall_32.tbl
@@ -356,3 +356,4 @@
 347	i386	process_vm_readv	sys_process_vm_readv		compat_sys_process_vm_readv
 348	i386	process_vm_writev	sys_process_vm_writev		compat_sys_process_vm_writev
 349	i386	kcmp			sys_kcmp
+350	i386	finit_module		sys_finit_module
diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index a582bfe..7c58c84 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -319,6 +319,7 @@
 310	64	process_vm_readv	sys_process_vm_readv
 311	64	process_vm_writev	sys_process_vm_writev
 312	common	kcmp			sys_kcmp
+313	common	finit_module		sys_finit_module
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 19439c7..a377796 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -860,4 +860,5 @@ asmlinkage long sys_process_vm_writev(pid_t pid,
 
 asmlinkage long sys_kcmp(pid_t pid1, pid_t pid2, int type,
 			 unsigned long idx1, unsigned long idx2);
+asmlinkage long sys_finit_module(int fd, const char __user *uargs);
 #endif
diff --git a/kernel/module.c b/kernel/module.c
index 0e2da86..321c6b9 100644
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
@@ -2420,12 +2421,12 @@ static inline void kmemleak_load_module(const struct module *mod,
 #endif
 
 #ifdef CONFIG_MODULE_SIG
-static int module_sig_check(struct load_info *info,
-			    const void *mod, unsigned long *len)
+static int module_sig_check(struct load_info *info)
 {
 	int err = -ENOKEY;
 	const unsigned long markerlen = sizeof(MODULE_SIG_STRING) - 1;
-	const void *p = mod, *end = mod + *len;
+	const void *mod = info->hdr;
+	const void *p = mod, *end = mod + info->len;
 
 	/* Poor man's memmem. */
 	while ((p = memchr(p, MODULE_SIG_STRING[0], end - p))) {
@@ -2435,8 +2436,9 @@ static int module_sig_check(struct load_info *info,
 		if (memcmp(p, MODULE_SIG_STRING, markerlen) == 0) {
 			const void *sig = p + markerlen;
 			/* Truncate module up to signature. */
-			*len = p - mod;
-			err = mod_verify_sig(mod, *len, sig, end - sig);
+			info->len = p - mod;
+			err = mod_verify_sig(mod, info->len,
+					     sig, end - sig);
 			break;
 		}
 		p++;
@@ -2457,59 +2459,97 @@ static int module_sig_check(struct load_info *info,
 	return err;
 }
 #else /* !CONFIG_MODULE_SIG */
-static int module_sig_check(struct load_info *info,
-			    void *mod, unsigned long *len)
+static int module_sig_check(struct load_info *info)
 {
 	return 0;
 }
 #endif /* !CONFIG_MODULE_SIG */
 
-/* Sets info->hdr, info->len and info->sig_ok. */
-static int copy_and_check(struct load_info *info,
-			  const void __user *umod, unsigned long len,
-			  const char __user *uargs)
+/* Sanity checks against invalid binaries, wrong arch, weird elf version. */
+static int elf_header_check(struct load_info *info)
 {
-	int err;
-	Elf_Ehdr *hdr;
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
 
-	if (len < sizeof(*hdr))
+	return 0;
+}
+
+/* Sets info->hdr and info->len. */
+static int copy_module_from_user(const void __user *umod, unsigned long len,
+				  struct load_info *info)
+{
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
-		goto free_hdr;
+	if (copy_from_user(info->hdr, umod, info->len) != 0) {
+		vfree(info->hdr);
+		return -EFAULT;
 	}
 
-	err = module_sig_check(info, hdr, &len);
+	return 0;
+}
+
+/* Sets info->hdr and info->len. */
+static int copy_module_from_fd(int fd, struct load_info *info)
+{
+	struct file *file;
+	int err;
+	struct kstat stat;
+	loff_t pos;
+	ssize_t bytes = 0;
+
+	file = fget(fd);
+	if (!file)
+		return -ENOEXEC;
+
+	err = vfs_getattr(file->f_vfsmnt, file->f_dentry, &stat);
 	if (err)
-		goto free_hdr;
+		goto out;
 
-	/* Sanity checks against insmoding binaries or wrong arch,
-	   weird elf version */
-	if (memcmp(hdr->e_ident, ELFMAG, SELFMAG) != 0
-	    || hdr->e_type != ET_REL
-	    || !elf_check_arch(hdr)
-	    || hdr->e_shentsize != sizeof(Elf_Shdr)) {
-		err = -ENOEXEC;
-		goto free_hdr;
+	if (stat.size > INT_MAX) {
+		err = -EFBIG;
+		goto out;
 	}
-
-	if (hdr->e_shoff >= len ||
-	    hdr->e_shnum * sizeof(Elf_Shdr) > len - hdr->e_shoff) {
-		err = -ENOEXEC;
-		goto free_hdr;
+	info->hdr = vmalloc(stat.size);
+	if (!info->hdr) {
+		err = -ENOMEM;
+		goto out;
 	}
 
-	info->hdr = hdr;
-	info->len = len;
-	return 0;
+	pos = 0;
+	while (pos < stat.size) {
+		bytes = kernel_read(file, pos, (char *)(info->hdr) + pos,
+				    stat.size - pos);
+		if (bytes < 0) {
+			vfree(info->hdr);
+			err = bytes;
+			goto out;
+		}
+		if (bytes == 0)
+			break;
+		pos += bytes;
+	}
+	info->len = pos;
 
-free_hdr:
-	vfree(hdr);
+out:
+	fput(file);
 	return err;
 }
 
@@ -2948,33 +2988,123 @@ static bool finished_loading(const char *name)
 	return ret;
 }
 
+/* Call module constructors. */
+static void do_mod_ctors(struct module *mod)
+{
+#ifdef CONFIG_CONSTRUCTORS
+	unsigned long i;
+
+	for (i = 0; i < mod->num_ctors; i++)
+		mod->ctors[i]();
+#endif
+}
+
+/* This is where the real work happens */
+static int do_init_module(struct module *mod)
+{
+	int ret = 0;
+
+	blocking_notifier_call_chain(&module_notify_list,
+			MODULE_STATE_COMING, mod);
+
+	/* Set RO and NX regions for core */
+	set_section_ro_nx(mod->module_core,
+				mod->core_text_size,
+				mod->core_ro_size,
+				mod->core_size);
+
+	/* Set RO and NX regions for init */
+	set_section_ro_nx(mod->module_init,
+				mod->init_text_size,
+				mod->init_ro_size,
+				mod->init_size);
+
+	do_mod_ctors(mod);
+	/* Start the module */
+	if (mod->init != NULL)
+		ret = do_one_initcall(mod->init);
+	if (ret < 0) {
+		/* Init routine failed: abort.  Try to protect us from
+                   buggy refcounters. */
+		mod->state = MODULE_STATE_GOING;
+		synchronize_sched();
+		module_put(mod);
+		blocking_notifier_call_chain(&module_notify_list,
+					     MODULE_STATE_GOING, mod);
+		free_module(mod);
+		wake_up_all(&module_wq);
+		return ret;
+	}
+	if (ret > 0) {
+		printk(KERN_WARNING
+"%s: '%s'->init suspiciously returned %d, it should follow 0/-E convention\n"
+"%s: loading module anyway...\n",
+		       __func__, mod->name, ret,
+		       __func__);
+		dump_stack();
+	}
+
+	/* Now it's a first class citizen! */
+	mod->state = MODULE_STATE_LIVE;
+	blocking_notifier_call_chain(&module_notify_list,
+				     MODULE_STATE_LIVE, mod);
+
+	/* We need to finish all async code before the module init sequence is done */
+	async_synchronize_full();
+
+	mutex_lock(&module_mutex);
+	/* Drop initial reference. */
+	module_put(mod);
+	trim_init_extable(mod);
+#ifdef CONFIG_KALLSYMS
+	mod->num_symtab = mod->core_num_syms;
+	mod->symtab = mod->core_symtab;
+	mod->strtab = mod->core_strtab;
+#endif
+	unset_module_init_ro_nx(mod);
+	module_free(mod, mod->module_init);
+	mod->module_init = NULL;
+	mod->init_size = 0;
+	mod->init_ro_size = 0;
+	mod->init_text_size = 0;
+	mutex_unlock(&module_mutex);
+	wake_up_all(&module_wq);
+
+	return 0;
+}
+
+static int may_init_module(void)
+{
+	if (!capable(CAP_SYS_MODULE) || modules_disabled)
+		return -EPERM;
+
+	return 0;
+}
+
 /* Allocate and load the module: note that size of section 0 is always
    zero, and we rely on this for optional sections. */
-static struct module *load_module(void __user *umod,
-				  unsigned long len,
-				  const char __user *uargs)
+static int load_module(struct load_info *info, const char __user *uargs)
 {
-	struct load_info info = { NULL, };
 	struct module *mod, *old;
 	long err;
 
-	pr_debug("load_module: umod=%p, len=%lu, uargs=%p\n",
-	       umod, len, uargs);
+	err = module_sig_check(info);
+	if (err)
+		goto free_copy;
 
-	/* Copy in the blobs from userspace, check they are vaguely sane. */
-	err = copy_and_check(&info, umod, len, uargs);
+	err = elf_header_check(info);
 	if (err)
-		return ERR_PTR(err);
+		goto free_copy;
 
 	/* Figure out module layout, and allocate all the memory. */
-	mod = layout_and_allocate(&info);
+	mod = layout_and_allocate(info);
 	if (IS_ERR(mod)) {
 		err = PTR_ERR(mod);
 		goto free_copy;
 	}
 
 #ifdef CONFIG_MODULE_SIG
-	mod->sig_ok = info.sig_ok;
+	mod->sig_ok = info->sig_ok;
 	if (!mod->sig_ok)
 		add_taint_module(mod, TAINT_FORCED_MODULE);
 #endif
@@ -2986,25 +3116,25 @@ static struct module *load_module(void __user *umod,
 
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
 
@@ -3044,14 +3174,14 @@ again:
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
 
@@ -3062,16 +3192,17 @@ again:
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
@@ -3080,7 +3211,7 @@ again:
 	module_bug_cleanup(mod);
 	wake_up_all(&module_wq);
  ddebug:
-	dynamic_debug_remove(info.debug);
+	dynamic_debug_remove(info->debug);
  unlock:
 	mutex_unlock(&module_mutex);
 	synchronize_sched();
@@ -3092,106 +3223,48 @@ again:
  free_unload:
 	module_unload_free(mod);
  free_module:
-	module_deallocate(mod, &info);
+	module_deallocate(mod, info);
  free_copy:
-	free_copy(&info);
-	return ERR_PTR(err);
-}
-
-/* Call module constructors. */
-static void do_mod_ctors(struct module *mod)
-{
-#ifdef CONFIG_CONSTRUCTORS
-	unsigned long i;
-
-	for (i = 0; i < mod->num_ctors; i++)
-		mod->ctors[i]();
-#endif
+	free_copy(info);
+	return err;
 }
 
-/* This is where the real work happens */
 SYSCALL_DEFINE3(init_module, void __user *, umod,
 		unsigned long, len, const char __user *, uargs)
 {
-	struct module *mod;
-	int ret = 0;
-
-	/* Must have permission */
-	if (!capable(CAP_SYS_MODULE) || modules_disabled)
-		return -EPERM;
+	int err;
+	struct load_info info = { };
 
-	/* Do all the hard work */
-	mod = load_module(umod, len, uargs);
-	if (IS_ERR(mod))
-		return PTR_ERR(mod);
+	err = may_init_module();
+	if (err)
+		return err;
 
-	blocking_notifier_call_chain(&module_notify_list,
-			MODULE_STATE_COMING, mod);
+	pr_debug("init_module: umod=%p, len=%lu, uargs=%p\n",
+	       umod, len, uargs);
 
-	/* Set RO and NX regions for core */
-	set_section_ro_nx(mod->module_core,
-				mod->core_text_size,
-				mod->core_ro_size,
-				mod->core_size);
+	err = copy_module_from_user(umod, len, &info);
+	if (err)
+		return err;
 
-	/* Set RO and NX regions for init */
-	set_section_ro_nx(mod->module_init,
-				mod->init_text_size,
-				mod->init_ro_size,
-				mod->init_size);
+	return load_module(&info, uargs);
+}
 
-	do_mod_ctors(mod);
-	/* Start the module */
-	if (mod->init != NULL)
-		ret = do_one_initcall(mod->init);
-	if (ret < 0) {
-		/* Init routine failed: abort.  Try to protect us from
-                   buggy refcounters. */
-		mod->state = MODULE_STATE_GOING;
-		synchronize_sched();
-		module_put(mod);
-		blocking_notifier_call_chain(&module_notify_list,
-					     MODULE_STATE_GOING, mod);
-		free_module(mod);
-		wake_up_all(&module_wq);
-		return ret;
-	}
-	if (ret > 0) {
-		printk(KERN_WARNING
-"%s: '%s'->init suspiciously returned %d, it should follow 0/-E convention\n"
-"%s: loading module anyway...\n",
-		       __func__, mod->name, ret,
-		       __func__);
-		dump_stack();
-	}
+SYSCALL_DEFINE2(finit_module, int, fd, const char __user *, uargs)
+{
+	int err;
+	struct load_info info = { };
 
-	/* Now it's a first class citizen! */
-	mod->state = MODULE_STATE_LIVE;
-	blocking_notifier_call_chain(&module_notify_list,
-				     MODULE_STATE_LIVE, mod);
+	err = may_init_module();
+	if (err)
+		return err;
 
-	/* We need to finish all async code before the module init sequence is done */
-	async_synchronize_full();
+	pr_debug("finit_module: fd=%d, uargs=%p\n", fd, uargs);
 
-	mutex_lock(&module_mutex);
-	/* Drop initial reference. */
-	module_put(mod);
-	trim_init_extable(mod);
-#ifdef CONFIG_KALLSYMS
-	mod->num_symtab = mod->core_num_syms;
-	mod->symtab = mod->core_symtab;
-	mod->strtab = mod->core_strtab;
-#endif
-	unset_module_init_ro_nx(mod);
-	module_free(mod, mod->module_init);
-	mod->module_init = NULL;
-	mod->init_size = 0;
-	mod->init_ro_size = 0;
-	mod->init_text_size = 0;
-	mutex_unlock(&module_mutex);
-	wake_up_all(&module_wq);
+	err = copy_module_from_fd(fd, &info);
+	if (err)
+		return err;
 
-	return 0;
+	return load_module(&info, uargs);
 }
 
 static inline int within(unsigned long addr, void *start, unsigned long size)
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index dbff751..395084d 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -25,6 +25,7 @@ cond_syscall(sys_swapoff);
 cond_syscall(sys_kexec_load);
 cond_syscall(compat_sys_kexec_load);
 cond_syscall(sys_init_module);
+cond_syscall(sys_finit_module);
 cond_syscall(sys_delete_module);
 cond_syscall(sys_socketpair);
 cond_syscall(sys_bind);
-- 
1.7.9.5

