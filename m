Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525Ab2JWCC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 22:02:27 -0400
Received: from ozlabs.org ([203.10.76.45]:35129 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756500Ab2JWCA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 22:00:56 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: mtk.manpages@gmail.com
Cc: "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        jonathon@jonmasters.org
Subject: Re: [PATCH 1/4] module: add syscall to load module from fd
In-Reply-To: <CAKgNAkiVxUiqJ1pYNq3wW_yQxcyhqntUzcEWscFOhJ3GaVn1aQ@mail.gmail.com>
References: <1348179300-11653-1-git-send-email-keescook@chromium.org> <CAHO5Pa2fysDRS3sFSy785XBKApxydN0ONW5kAfVJNkrB+wOaBw@mail.gmail.com> <50749DE8.7010703@zytor.com> <CAKgNAkgLW+0aHwzoY6vxmeeK_K5w2RyhxW+jOaJDn274NVbajw@mail.gmail.com> <5074A0AB.8040207@zytor.com> <87d30o7iy6.fsf@rustcorp.com.au> <CAKgNAkh=99=x1=8Y=3odem-fXc9zEEbLvCc0WQku5Kyso4qHuQ@mail.gmail.com> <87ipa8o4mn.fsf@rustcorp.com.au> <CAKgNAkiVxUiqJ1pYNq3wW_yQxcyhqntUzcEWscFOhJ3GaVn1aQ@mail.gmail.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 22 Oct 2012 18:09:41 +1030
Message-ID: <87sj97hs5e.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
>> FIX: add flags arg to sys_finit_module()
>>
>> Thanks to Michael Kerrisk for keeping us honest.
>
> w00t! Thanks, Rusty ;-).
>
> Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>

Here's the version I ended up with when I added two flags.

Lucas, is this useful to you?

BTW Michael: why aren't the syscall man pages in the kernel source?

Thanks,
Rusty.

module: add flags arg to sys_finit_module()

Thanks to Michael Kerrisk for keeping us honest.  These flags are actually
useful for eliminating the only case where kmod has to mangle a module's
internals: for overriding module versioning.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 32bc035..8cf7b50 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -868,5 +868,5 @@ asmlinkage long sys_process_vm_writev(pid_t pid,
 
 asmlinkage long sys_kcmp(pid_t pid1, pid_t pid2, int type,
 			 unsigned long idx1, unsigned long idx2);
-asmlinkage long sys_finit_module(int fd, const char __user *uargs);
+asmlinkage long sys_finit_module(int fd, const char __user *uargs, int flags);
 #endif
diff --git a/include/uapi/linux/module.h b/include/uapi/linux/module.h
new file mode 100644
index 0000000..38da425
--- /dev/null
+++ b/include/uapi/linux/module.h
@@ -0,0 +1,8 @@
+#ifndef _UAPI_LINUX_MODULE_H
+#define _UAPI_LINUX_MODULE_H
+
+/* Flags for sys_finit_module: */
+#define MODULE_INIT_IGNORE_MODVERSIONS	1
+#define MODULE_INIT_IGNORE_VERMAGIC	2
+
+#endif /* _UAPI_LINUX_MODULE_H */
diff --git a/kernel/module.c b/kernel/module.c
index 261bf82..55b49cd 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -61,6 +61,7 @@
 #include <linux/pfn.h>
 #include <linux/bsearch.h>
 #include <linux/fips.h>
+#include <uapi/linux/module.h>
 #include "module-internal.h"
 
 #define CREATE_TRACE_POINTS
@@ -2569,7 +2570,7 @@ static void free_copy(struct load_info *info)
 	vfree(info->hdr);
 }
 
-static int rewrite_section_headers(struct load_info *info)
+static int rewrite_section_headers(struct load_info *info, int flags)
 {
 	unsigned int i;
 
@@ -2597,7 +2598,10 @@ static int rewrite_section_headers(struct load_info *info)
 	}
 
 	/* Track but don't keep modinfo and version sections. */
-	info->index.vers = find_sec(info, "__versions");
+	if (flags & MODULE_INIT_IGNORE_MODVERSIONS)
+		info->index.vers = 0; /* Pretend no __versions section! */
+	else
+		info->index.vers = find_sec(info, "__versions");
 	info->index.info = find_sec(info, ".modinfo");
 	info->sechdrs[info->index.info].sh_flags &= ~(unsigned long)SHF_ALLOC;
 	info->sechdrs[info->index.vers].sh_flags &= ~(unsigned long)SHF_ALLOC;
@@ -2612,7 +2617,7 @@ static int rewrite_section_headers(struct load_info *info)
  * Return the temporary module pointer (we'll replace it with the final
  * one when we move the module sections around).
  */
-static struct module *setup_load_info(struct load_info *info)
+static struct module *setup_load_info(struct load_info *info, int flags)
 {
 	unsigned int i;
 	int err;
@@ -2623,7 +2628,7 @@ static struct module *setup_load_info(struct load_info *info)
 	info->secstrings = (void *)info->hdr
 		+ info->sechdrs[info->hdr->e_shstrndx].sh_offset;
 
-	err = rewrite_section_headers(info);
+	err = rewrite_section_headers(info, flags);
 	if (err)
 		return ERR_PTR(err);
 
@@ -2661,11 +2666,14 @@ static struct module *setup_load_info(struct load_info *info)
 	return mod;
 }
 
-static int check_modinfo(struct module *mod, struct load_info *info)
+static int check_modinfo(struct module *mod, struct load_info *info, int flags)
 {
 	const char *modmagic = get_modinfo(info, "vermagic");
 	int err;
 
+	if (flags & MODULE_INIT_IGNORE_VERMAGIC)
+		modmagic = NULL;
+
 	/* This is allowed: modprobe --force will invalidate it. */
 	if (!modmagic) {
 		err = try_to_force_load(mod, "bad vermagic");
@@ -2901,18 +2909,18 @@ int __weak module_frob_arch_sections(Elf_Ehdr *hdr,
 	return 0;
 }
 
-static struct module *layout_and_allocate(struct load_info *info)
+static struct module *layout_and_allocate(struct load_info *info, int flags)
 {
 	/* Module within temporary copy. */
 	struct module *mod;
 	Elf_Shdr *pcpusec;
 	int err;
 
-	mod = setup_load_info(info);
+	mod = setup_load_info(info, flags);
 	if (IS_ERR(mod))
 		return mod;
 
-	err = check_modinfo(mod, info);
+	err = check_modinfo(mod, info, flags);
 	if (err)
 		return ERR_PTR(err);
 
@@ -3094,7 +3102,8 @@ static int may_init_module(void)
 
 /* Allocate and load the module: note that size of section 0 is always
    zero, and we rely on this for optional sections. */
-static int load_module(struct load_info *info, const char __user *uargs)
+static int load_module(struct load_info *info, const char __user *uargs,
+		       int flags)
 {
 	struct module *mod, *old;
 	long err;
@@ -3108,7 +3117,7 @@ static int load_module(struct load_info *info, const char __user *uargs)
 		goto free_copy;
 
 	/* Figure out module layout, and allocate all the memory. */
-	mod = layout_and_allocate(info);
+	mod = layout_and_allocate(info, flags);
 	if (IS_ERR(mod)) {
 		err = PTR_ERR(mod);
 		goto free_copy;
@@ -3257,10 +3269,10 @@ SYSCALL_DEFINE3(init_module, void __user *, umod,
 	if (err)
 		return err;
 
-	return load_module(&info, uargs);
+	return load_module(&info, uargs, 0);
 }
 
-SYSCALL_DEFINE2(finit_module, int, fd, const char __user *, uargs)
+SYSCALL_DEFINE3(finit_module, int, fd, const char __user *, uargs, int, flags)
 {
 	int err;
 	struct load_info info = { };
@@ -3269,13 +3281,17 @@ SYSCALL_DEFINE2(finit_module, int, fd, const char __user *, uargs)
 	if (err)
 		return err;
 
-	pr_debug("finit_module: fd=%d, uargs=%p\n", fd, uargs);
+	pr_debug("finit_module: fd=%d, uargs=%p, flags=%i\n", fd, uargs, flags);
+
+	if (flags & ~(MODULE_INIT_IGNORE_MODVERSIONS
+		      |MODULE_INIT_IGNORE_VERMAGIC))
+		return -EINVAL;
 
 	err = copy_module_from_fd(fd, &info);
 	if (err)
 		return err;
 
-	return load_module(&info, uargs);
+	return load_module(&info, uargs, flags);
 }
 
 static inline int within(unsigned long addr, void *start, unsigned long size)
