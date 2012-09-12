Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab2ILA4R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 20:56:17 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:42180 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab2ILA4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 20:56:15 -0400
From: Meredydd Luff <meredydd@senatehouse.org>
To: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Meredydd Luff <meredydd@senatehouse.org>
Subject: [PATCH signal#execve2] syscalls,x86: Add execveat() system call (v3)
Date: Wed, 12 Sep 2012 01:55:52 +0100
Message-Id: <1347411352-12392-1-git-send-email-meredydd@senatehouse.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al (in particular): I've reworked this on top of your generic
execve() changes, as well as incorporating feedback from HPA.
Could you take another look please (and merge if all is well)?

[v3: now rebased onto signal.git#execve2, and takes a flags
parameter which understands AT_SYMLINK_NOFOLLOW; all thanks to
feedback from https://lkml.org/lkml/2012/8/1/418]

HPA is already on record calling for an execveat() which also does
fexecve()'s job: https://lkml.org/lkml/2006/7/11/556.
And the current glibc hack for fexecve() is already causing problems
in the wild. Eg: https://bugzilla.redhat.com/show_bug.cgi?id=241609,
https://lkml.org/lkml/2006/12/27/123, and as recounted at
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=514043.

So here's an attempt at just that:

----------------------------------------------------------------------

This patch adds a new system call, execveat(2). execveat() is to
execve() as openat() is to open(): it takes a file descriptor that
refers to a directory, and resolves the filename relative to that.

In addition, if the filename is NULL, execveat() executes the file
to which the file descriptor refers. This replicates the functionality
of fexecve(), which is a system call in other UNIXen, but in Linux
glibc v2.16 it's a gross hack that depends on /proc being mounted.
That hack does not work in chrooted sandboxes, or stripped-down
systems without /proc mounted. execveat() does.

Only x86-64 and i386 ABIs are supported in this patch.

Signed-off-by: Meredydd Luff <meredydd@senatehouse.org>
---
 arch/alpha/kernel/binfmt_loader.c |    2 +-
 arch/x86/ia32/ia32entry.S         |    3 +-
 arch/x86/kernel/entry_64.S        |   14 +++++
 arch/x86/syscalls/syscall_32.tbl  |    1 +
 arch/x86/syscalls/syscall_64.tbl  |    1 +
 arch/x86/um/sys_call_table_64.c   |    1 +
 fs/binfmt_elf.c                   |    2 +-
 fs/binfmt_elf_fdpic.c             |    2 +-
 fs/binfmt_em86.c                  |    2 +-
 fs/binfmt_flat.c                  |    2 +-
 fs/binfmt_misc.c                  |    2 +-
 fs/binfmt_script.c                |    2 +-
 fs/exec.c                         |  117 +++++++++++++++++++++++++++++++++----
 include/asm-generic/syscalls.h    |    7 ++
 include/linux/compat.h            |    3 +
 include/linux/fs.h                |    2 +-
 include/linux/sched.h             |    4 +
 17 files changed, 147 insertions(+), 20 deletions(-)

diff --git a/arch/alpha/kernel/binfmt_loader.c b/arch/alpha/kernel/binfmt_loader.c
index d1f474d..7968491 100644
--- a/arch/alpha/kernel/binfmt_loader.c
+++ b/arch/alpha/kernel/binfmt_loader.c
@@ -24,7 +24,7 @@ static int load_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 
 	loader = bprm->vma->vm_end - sizeof(void *);
 
-	file = open_exec("/sbin/loader");
+	file = open_exec(AT_FDCWD, "/sbin/loader");
 	retval = PTR_ERR(file);
 	if (IS_ERR(file))
 		return retval;
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index e75f941..8f60920 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -460,7 +460,8 @@ GLOBAL(\label)
 	PTREGSCALL stub32_sigreturn, sys32_sigreturn, %rdi
 	PTREGSCALL stub32_sigaltstack, sys32_sigaltstack, %rdx
 	PTREGSCALL stub32_execve, compat_sys_execve, %rcx
-	PTREGSCALL stub32_fork, sys_fork, %rdi
+    PTREGSCALL stub32_execveat, compat_sys_execveat, %r9
+    PTREGSCALL stub32_fork, sys_fork, %rdi
 	PTREGSCALL stub32_clone, sys32_clone, %rdx
 	PTREGSCALL stub32_vfork, sys_vfork, %rdi
 	PTREGSCALL stub32_iopl, sys_iopl, %rsi
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 58f8543..3fa3ed2 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -765,6 +765,20 @@ ENTRY(stub_execve)
 	CFI_ENDPROC
 END(stub_execve)
 
+ENTRY(stub_execveat)
+	CFI_STARTPROC
+	addq $8, %rsp
+	PARTIAL_FRAME 0
+	SAVE_REST
+	FIXUP_TOP_OF_STACK %r11
+	call sys_execveat
+	RESTORE_TOP_OF_STACK %r11
+	movq %rax,RAX(%rsp)
+	RESTORE_REST
+	jmp int_ret_from_sys_call
+	CFI_ENDPROC
+END(stub_execveat)
+
 /*
  * sigreturn is special because it needs to restore all registers on return.
  * This cannot be done with SYSRET, so use the IRET return path instead.
diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
index a47103f..8fd4d3f 100644
--- a/arch/x86/syscalls/syscall_32.tbl
+++ b/arch/x86/syscalls/syscall_32.tbl
@@ -356,3 +356,4 @@
 347	i386	process_vm_readv	sys_process_vm_readv		compat_sys_process_vm_readv
 348	i386	process_vm_writev	sys_process_vm_writev		compat_sys_process_vm_writev
 349	i386	kcmp			sys_kcmp
+350	i386	execveat		sys_execveat			stub32_execveat
diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index a582bfe..f5e2558 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -319,6 +319,7 @@
 310	64	process_vm_readv	sys_process_vm_readv
 311	64	process_vm_writev	sys_process_vm_writev
 312	common	kcmp			sys_kcmp
+313	64	execveat		stub_execveat
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/arch/x86/um/sys_call_table_64.c b/arch/x86/um/sys_call_table_64.c
index 170bd92..68dbda7 100644
--- a/arch/x86/um/sys_call_table_64.c
+++ b/arch/x86/um/sys_call_table_64.c
@@ -31,6 +31,7 @@
 #define stub_fork sys_fork
 #define stub_vfork sys_vfork
 #define stub_execve sys_execve
+#define stub_execveat sys_execveat
 #define stub_sigaltstack sys_sigaltstack
 #define stub_rt_sigreturn sys_rt_sigreturn
 
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 2ab9190..2aebaeb 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -652,7 +652,7 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 			if (elf_interpreter[elf_ppnt->p_filesz - 1] != '\0')
 				goto out_free_interp;
 
-			interpreter = open_exec(elf_interpreter);
+			interpreter = open_exec(AT_FDCWD, elf_interpreter, 0);
 			retval = PTR_ERR(interpreter);
 			if (IS_ERR(interpreter))
 				goto out_free_interp;
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index c298f2e..9dfcc1b 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -234,7 +234,7 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm,
 			kdebug("Using ELF interpreter %s", interpreter_name);
 
 			/* replace the program with the interpreter */
-			interpreter = open_exec(interpreter_name);
+			interpreter = open_exec(AT_FDCWD, interpreter_name, 0);
 			retval = PTR_ERR(interpreter);
 			if (IS_ERR(interpreter)) {
 				interpreter = NULL;
diff --git a/fs/binfmt_em86.c b/fs/binfmt_em86.c
index 2790c7e..64ee6db 100644
--- a/fs/binfmt_em86.c
+++ b/fs/binfmt_em86.c
@@ -80,7 +80,7 @@ static int load_em86(struct linux_binprm *bprm,struct pt_regs *regs)
 	 * Note that we use open_exec() as the name is now in kernel
 	 * space, and we don't need to copy it.
 	 */
-	file = open_exec(interp);
+	file = open_exec(AT_FDCWD, interp, 0);
 	if (IS_ERR(file))
 		return PTR_ERR(file);
 
diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index 178cb70..90986f7 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -820,7 +820,7 @@ static int load_flat_shared_library(int id, struct lib_info *libs)
 
 	/* Open the file up */
 	bprm.filename = buf;
-	bprm.file = open_exec(bprm.filename);
+	bprm.file = open_exec(AT_FDCWD, bprm.filename, 0);
 	res = PTR_ERR(bprm.file);
 	if (IS_ERR(bprm.file))
 		return res;
diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 790b3cd..7ee1e57 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -178,7 +178,7 @@ static int load_misc_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 
 	bprm->interp = iname;	/* for binfmt_script */
 
-	interp_file = open_exec (iname);
+	interp_file = open_exec(AT_FDCWD, iname, 0);
 	retval = PTR_ERR (interp_file);
 	if (IS_ERR (interp_file))
 		goto _error;
diff --git a/fs/binfmt_script.c b/fs/binfmt_script.c
index d3b8c1f..da1ce3f 100644
--- a/fs/binfmt_script.c
+++ b/fs/binfmt_script.c
@@ -87,7 +87,7 @@ static int load_script(struct linux_binprm *bprm,struct pt_regs *regs)
 	/*
 	 * OK, now restart the process with the interpreter's dentry.
 	 */
-	file = open_exec(interp);
+	file = open_exec(AT_FDCWD, interp, 0);
 	if (IS_ERR(file))
 		return PTR_ERR(file);
 
diff --git a/fs/exec.c b/fs/exec.c
index 3947aef..ee5a2a0 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -757,7 +757,7 @@ EXPORT_SYMBOL(setup_arg_pages);
 
 #endif /* CONFIG_MMU */
 
-struct file *open_exec(const char *name)
+struct file *open_exec(int dfd, const char *name, int flags)
 {
 	struct file *file;
 	int err;
@@ -767,9 +767,30 @@ struct file *open_exec(const char *name)
 		.intent = LOOKUP_OPEN
 	};
 
-	file = do_filp_open(AT_FDCWD, name, &open_exec_flags, LOOKUP_FOLLOW);
-	if (IS_ERR(file))
-		goto out;
+	if (flags & ~AT_SYMLINK_NOFOLLOW)
+		return ERR_PTR(-EINVAL);
+
+	if (name) {
+		int how = LOOKUP_FOLLOW;
+
+		if (flags & AT_SYMLINK_NOFOLLOW)
+			how = 0;
+
+		file = do_filp_open(dfd, name, &open_exec_flags,
+				how);
+		if (IS_ERR(file))
+			goto out;
+	} else {
+		file = fget(dfd);
+		err = -EBADF;
+		if (!file)
+			goto exit_nofile;
+
+		err = inode_permission(file->f_path.dentry->d_inode,
+				open_exec_flags.acc_mode);
+		if (err)
+			goto exit;
+	}
 
 	err = -EACCES;
 	if (!S_ISREG(file->f_path.dentry->d_inode->i_mode))
@@ -778,7 +799,8 @@ struct file *open_exec(const char *name)
 	if (file->f_path.mnt->mnt_flags & MNT_NOEXEC)
 		goto exit;
 
-	fsnotify_open(file);
+	if (name)
+		fsnotify_open(file);
 
 	err = deny_write_access(file);
 	if (err)
@@ -789,6 +811,7 @@ out:
 
 exit:
 	fput(file);
+exit_nofile:
 	return ERR_PTR(err);
 }
 EXPORT_SYMBOL(open_exec);
@@ -1462,9 +1485,11 @@ EXPORT_SYMBOL(search_binary_handler);
 /*
  * sys_execve() executes a new program.
  */
-static int do_execve_common(const char *filename,
+static int do_execveat_common(int dfd,
+				const char *filename,
 				struct user_arg_ptr argv,
 				struct user_arg_ptr envp,
+				int flags,
 				struct pt_regs *regs)
 {
 	struct linux_binprm *bprm;
@@ -1509,7 +1534,7 @@ static int do_execve_common(const char *filename,
 	clear_in_exec = retval;
 	current->in_execve = 1;
 
-	file = open_exec(filename);
+	file = open_exec(dfd, filename, flags);
 	retval = PTR_ERR(file);
 	if (IS_ERR(file))
 		goto out_unmark;
@@ -1517,8 +1542,9 @@ static int do_execve_common(const char *filename,
 	sched_exec();
 
 	bprm->file = file;
-	bprm->filename = filename;
-	bprm->interp = filename;
+	bprm->filename = filename ?:
+			(const char *) file->f_path.dentry->d_name.name;
+	bprm->interp = bprm->filename;
 
 	retval = bprm_mm_init(bprm);
 	if (retval)
@@ -1596,7 +1622,18 @@ int do_execve(const char *filename,
 {
 	struct user_arg_ptr argv = { .ptr.native = __argv };
 	struct user_arg_ptr envp = { .ptr.native = __envp };
-	return do_execve_common(filename, argv, envp, regs);
+	return do_execveat_common(AT_FDCWD, filename, argv, envp, 0, regs);
+}
+
+int do_execveat(int dfd, const char *filename,
+	const char __user *const __user *__argv,
+	const char __user *const __user *__envp,
+	int flags,
+	struct pt_regs *regs)
+{
+	struct user_arg_ptr argv = { .ptr.native = __argv };
+	struct user_arg_ptr envp = { .ptr.native = __envp };
+	return do_execveat_common(dfd, filename, argv, envp, flags, regs);
 }
 
 #ifdef CONFIG_COMPAT
@@ -1613,7 +1650,24 @@ int compat_do_execve(const char *filename,
 		.is_compat = true,
 		.ptr.compat = __envp,
 	};
-	return do_execve_common(filename, argv, envp, regs);
+	return do_execveat_common(AT_FDCWD, filename, argv, envp, 0, regs);
+}
+
+int compat_do_execveat(int dfd, const char *filename,
+	const compat_uptr_t __user *__argv,
+	const compat_uptr_t __user *__envp,
+	int flags,
+	struct pt_regs *regs)
+{
+	struct user_arg_ptr argv = {
+		.is_compat = true,
+		.ptr.compat = __argv,
+	};
+	struct user_arg_ptr envp = {
+		.is_compat = true,
+		.ptr.compat = __envp,
+	};
+	return do_execveat_common(dfd, filename, argv, envp, flags, regs);
 }
 #endif
 
@@ -2333,6 +2387,26 @@ SYSCALL_DEFINE3(execve,
 	}
 	return error;
 }
+
+SYSCALL_DEFINE5(execveat,
+		int, dfd, const char __user *, filename,
+		const char __user *const __user *, argv,
+		const char __user *const __user *, envp,
+		int, flags)
+{
+	int error;
+	const char *path = NULL;
+	if (filename) {
+		path = getname(filename);
+		error = PTR_ERR(path);
+		if (IS_ERR(path))
+			return error;
+	}
+	error = do_execveat(dfd, path, argv, envp, flags, current_pt_regs());
+	if (path)
+		putname(path);
+	return error;
+}
 #ifdef CONFIG_COMPAT
 asmlinkage long compat_sys_execve(const char __user * filename,
 	const compat_uptr_t __user * argv,
@@ -2346,6 +2420,27 @@ asmlinkage long compat_sys_execve(const char __user * filename,
 	}
 	return error;
 }
+
+asmlinkage long compat_sys_execveat(int dfd,
+	const char __user * filename,
+	const compat_uptr_t __user * argv,
+	const compat_uptr_t __user * envp,
+	int flags)
+{
+	int error;
+	const char *path = NULL;
+	if (filename) {
+		path = getname(filename);
+		error = PTR_ERR(path);
+		if (IS_ERR(path))
+			return error;
+	}
+	error = compat_do_execveat(dfd, path, argv, envp, flags,
+			current_pt_regs());
+	if (path)
+		putname(path);
+	return error;
+}
 #endif
 #endif
 
diff --git a/include/asm-generic/syscalls.h b/include/asm-generic/syscalls.h
index d89dec8..18f4ec5 100644
--- a/include/asm-generic/syscalls.h
+++ b/include/asm-generic/syscalls.h
@@ -29,6 +29,13 @@ asmlinkage long sys_execve(const char __user *filename,
 			   struct pt_regs *regs);
 #endif
 
+#ifndef sys_execveat
+asmlinkage long sys_execveat(int dfd, const char __user *filename,
+			     const char __user *const __user *argv,
+			     const char __user *const __user *envp,
+			     int flags, struct pt_regs *regs);
+#endif
+
 #ifndef sys_mmap2
 asmlinkage long sys_mmap2(unsigned long addr, unsigned long len,
 			unsigned long prot, unsigned long flags,
diff --git a/include/linux/compat.h b/include/linux/compat.h
index c4be3f5..33a5eee 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -294,6 +294,9 @@ int compat_do_execve(const char *filename, const compat_uptr_t __user *argv,
 #ifdef __ARCH_WANT_SYS_EXECVE
 asmlinkage long compat_sys_execve(const char __user *filename, const compat_uptr_t __user *argv,
 		     const compat_uptr_t __user *envp);
+asmlinkage long compat_sys_execveat(int dfd, const char __user *filename,
+		     const compat_uptr_t __user *argv,
+		     const compat_uptr_t __user *envp, int flags);
 #endif
 
 asmlinkage long compat_sys_select(int n, compat_ulong_t __user *inp,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index aa11047..7fda54c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2466,7 +2466,7 @@ static inline void i_readcount_inc(struct inode *inode)
 extern int do_pipe_flags(int *, int);
 
 extern int kernel_read(struct file *, loff_t, char *, unsigned long);
-extern struct file * open_exec(const char *);
+extern struct file *open_exec(int dfd, const char *, int flags);
  
 /* fs/dcache.c -- generic fs support functions */
 extern int is_subdir(struct dentry *, struct dentry *);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index b8c8664..a9e7e48 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2324,6 +2324,10 @@ extern int disallow_signal(int);
 extern int do_execve(const char *,
 		     const char __user * const __user *,
 		     const char __user * const __user *, struct pt_regs *);
+extern int do_execveat(int dfd, const char *,
+		       const char __user * const __user *,
+		       const char __user * const __user *,
+		       int, struct pt_regs *);
 extern long do_fork(unsigned long, unsigned long, struct pt_regs *, unsigned long, int __user *, int __user *);
 struct task_struct *fork_idle(int);
 
-- 
1.7.4.1

