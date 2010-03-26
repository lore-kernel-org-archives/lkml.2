Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab0CZNjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 09:39:09 -0400
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:50200 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753101Ab0CZNjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 09:39:06 -0400
X-AuditID: 1209190e-b7b82ae000005260-14-4bacb8f7a7ea
From: Andy Lutomirski <luto@MIT.EDU>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: Eric Biederman <ebiederm@xmission.com>,
       "Andrew G. Morgan" <morgan@kernel.org>, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH 1/3] Add the execve_nosecurity syscall.
Date: Fri, 26 Mar 2010 07:38:34 -0600
Message-Id: <126cb78a0e259f4febae1a072cf6345effd7c244.1269610458.git.luto@mit.edu>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <cover.1269610458.git.luto@mit.edu>
References: <cover.1269610458.git.luto@mit.edu>
X-Brightmail-Tracker: AAAAARNt6nE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

execve_nosecurity does exactly what execve does, except for three differences:

 1. execve_nosecurity does not let LSMs change anything.  Anything
    includes: credentials, labels, and securebits.  This means that you
    probably want to do prctl(PR_SET_KEEPCAPS, 0, ...) before using it.
 2. execve_nosecurity requires both read and exec access.
 3. execve_nosecurity does not change dumpability.

Here's why:

execve looks at setuid/setgid bits, the nosuid mount flag, and whatever
else the LSM wants it to look at, all of which can change the security
context of the process.  To keep the system secure, this needs to interact
with coredumps and ptrace.

execve_nosecurity is a new syscall that does the same thing as execve but
without security implications: it does not change credentials, security
labels, ptrace status, or dumpability.  Because admins might expect
executable but non-readable programs not to leak their contents due to
either setuid/setgid bits or LSM labels, execve_nosecurity requires both
read and execute access.

In principle (even though the mechanisms aren't all there), programs ought
to be able to do what execve_nosecurity does without help from the kernel.

Some LSMs (in particular commoncap) might take certain actions on every
exec independently of preexisting credentials or labels and independently
of the file's label.  This is why SECURE_KEEP_CAPS gets cleared on every
exec.  It's a special case because SECURE_KEEP_CAPS is a strange API
that's specifically meant to change the behavior of the very next exec
call, and it has no effect when execve_nosecurity is called.  Since I
didn't want to add a brand new LSM hook just for execve_nosecurity (that
hook shouldn't do anything at all in a sensible LSM) and since it's a
new syscall and its users shouldn't be using SECURE_KEEP_CAPS anyway,
I just leave that bit along.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/ia32/sys_ia32.c         |    2 +-
 arch/x86/include/asm/unistd_64.h |    2 +
 arch/x86/kernel/entry_64.S       |   16 +++++
 arch/x86/kernel/process.c        |   28 +++++++++-
 fs/binfmt_elf.c                  |    6 +-
 fs/binfmt_elf_fdpic.c            |    6 +-
 fs/binfmt_em86.c                 |    2 +-
 fs/binfmt_flat.c                 |    7 ++-
 fs/binfmt_misc.c                 |    2 +-
 fs/binfmt_script.c               |    2 +-
 fs/compat.c                      |    6 +-
 fs/exec.c                        |  118 ++++++++++++++++++++++++--------------
 include/linux/binfmts.h          |    3 +
 include/linux/compat.h           |    2 +-
 include/linux/fs.h               |    2 +-
 include/linux/sched.h            |    2 +-
 16 files changed, 146 insertions(+), 60 deletions(-)

diff --git a/arch/x86/ia32/sys_ia32.c b/arch/x86/ia32/sys_ia32.c
index 422572c..e6f3dff 100644
--- a/arch/x86/ia32/sys_ia32.c
+++ b/arch/x86/ia32/sys_ia32.c
@@ -528,7 +528,7 @@ asmlinkage long sys32_execve(char __user *name, compat_uptr_t __user *argv,
 	error = PTR_ERR(filename);
 	if (IS_ERR(filename))
 		return error;
-	error = compat_do_execve(filename, argv, envp, regs);
+	error = compat_do_execve(filename, argv, envp, regs, true);
 	putname(filename);
 	return error;
 }
diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
index 4843f7b..d792a8c 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -663,6 +663,8 @@ __SYSCALL(__NR_rt_tgsigqueueinfo, sys_rt_tgsigqueueinfo)
 __SYSCALL(__NR_perf_event_open, sys_perf_event_open)
 #define __NR_recvmmsg				299
 __SYSCALL(__NR_recvmmsg, sys_recvmmsg)
+#define __NR_execve_nosecurity			300
+__SYSCALL(__NR_execve_nosecurity, stub_execve_nosecurity)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 0697ff1..77d0fd6 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -728,6 +728,22 @@ ENTRY(stub_execve)
 	CFI_ENDPROC
 END(stub_execve)
 
+ENTRY(stub_execve_nosecurity)
+	CFI_STARTPROC
+	popq %r11
+	CFI_ADJUST_CFA_OFFSET -8
+	CFI_REGISTER rip, r11
+	SAVE_REST
+	FIXUP_TOP_OF_STACK %r11
+	movq %rsp, %rcx
+	call sys_execve_nosecurity
+	RESTORE_TOP_OF_STACK %r11
+	movq %rax,RAX(%rsp)
+	RESTORE_REST
+	jmp int_ret_from_sys_call
+	CFI_ENDPROC
+END(stub_execve)
+
 /*
  * sigreturn is special because it needs to restore all registers on return.
  * This cannot be done with SYSRET, so use the IRET return path instead.
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index c9b3522..90c153b 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -303,7 +303,33 @@ long sys_execve(char __user *name, char __user * __user *argv,
 	error = PTR_ERR(filename);
 	if (IS_ERR(filename))
 		return error;
-	error = do_execve(filename, argv, envp, regs);
+	error = do_execve(filename, argv, envp, regs, true);
+
+#ifdef CONFIG_X86_32
+	if (error == 0) {
+		/* Make sure we don't return using sysenter.. */
+                set_thread_flag(TIF_IRET);
+        }
+#endif
+
+	putname(filename);
+	return error;
+}
+
+/*
+ * sys_execve_nosecurity() executes a new program without security changes.
+ */
+long sys_execve_nosecurity(char __user *name, char __user * __user *argv,
+			   char __user * __user *envp, struct pt_regs *regs)
+{
+	long error;
+	char *filename;
+
+	filename = getname(name);
+	error = PTR_ERR(filename);
+	if (IS_ERR(filename))
+		return error;
+	error = do_execve(filename, argv, envp, regs, false);
 
 #ifdef CONFIG_X86_32
 	if (error == 0) {
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index fd5b2ea..6d3f0b6 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -231,7 +231,8 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 	NEW_AUX_ENT(AT_EUID, cred->euid);
 	NEW_AUX_ENT(AT_GID, cred->gid);
 	NEW_AUX_ENT(AT_EGID, cred->egid);
- 	NEW_AUX_ENT(AT_SECURE, security_bprm_secureexec(bprm));
+	NEW_AUX_ENT(AT_SECURE,
+		    bprm->change_security ? security_bprm_secureexec(bprm) : 0);
 	NEW_AUX_ENT(AT_RANDOM, (elf_addr_t)(unsigned long)u_rand_bytes);
 	NEW_AUX_ENT(AT_EXECFN, bprm->exec);
 	if (k_platform) {
@@ -662,7 +663,8 @@ static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 			if (elf_interpreter[elf_ppnt->p_filesz - 1] != '\0')
 				goto out_free_interp;
 
-			interpreter = open_exec(elf_interpreter);
+			interpreter = open_exec(elf_interpreter,
+						!bprm->change_security);
 			retval = PTR_ERR(interpreter);
 			if (IS_ERR(interpreter))
 				goto out_free_interp;
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 18d7729..b28b7a9 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -232,7 +232,8 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm,
 			kdebug("Using ELF interpreter %s", interpreter_name);
 
 			/* replace the program with the interpreter */
-			interpreter = open_exec(interpreter_name);
+			interpreter = open_exec(interpreter_name,
+						!bprm->change_security);
 			retval = PTR_ERR(interpreter);
 			if (IS_ERR(interpreter)) {
 				interpreter = NULL;
@@ -636,7 +637,8 @@ static int create_elf_fdpic_tables(struct linux_binprm *bprm,
 	NEW_AUX_ENT(AT_EUID,	(elf_addr_t) cred->euid);
 	NEW_AUX_ENT(AT_GID,	(elf_addr_t) cred->gid);
 	NEW_AUX_ENT(AT_EGID,	(elf_addr_t) cred->egid);
-	NEW_AUX_ENT(AT_SECURE,	security_bprm_secureexec(bprm));
+ 	NEW_AUX_ENT(AT_SECURE,
+		    bprm->change_security ? security_bprm_secureexec(bprm) : 0);
 	NEW_AUX_ENT(AT_EXECFN,	bprm->exec);
 
 #ifdef ARCH_DLINFO
diff --git a/fs/binfmt_em86.c b/fs/binfmt_em86.c
index 32fb00b..debae80 100644
--- a/fs/binfmt_em86.c
+++ b/fs/binfmt_em86.c
@@ -81,7 +81,7 @@ static int load_em86(struct linux_binprm *bprm,struct pt_regs *regs)
 	 * Note that we use open_exec() as the name is now in kernel
 	 * space, and we don't need to copy it.
 	 */
-	file = open_exec(interp);
+	file = open_exec(interp, !bprm->change_security);
 	if (IS_ERR(file))
 		return PTR_ERR(file);
 
diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index 42c6b4a..bafcee0 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -80,10 +80,12 @@ struct lib_info {
 		unsigned long build_date;		/* When this one was compiled */
 		short loaded;				/* Has this library been loaded? */
 	} lib_list[MAX_SHARED_LIBS];
+
+	unsigned int change_security : 1;
 };
 
 #ifdef CONFIG_BINFMT_SHARED_FLAT
-static int load_flat_shared_library(int id, struct lib_info *p);
+static int load_flat_shared_library(int id, struct lib_info *p, bool);
 #endif
 
 static int load_flat_binary(struct linux_binprm *, struct pt_regs * regs);
@@ -822,7 +824,7 @@ static int load_flat_shared_library(int id, struct lib_info *libs)
 
 	/* Open the file up */
 	bprm.filename = buf;
-	bprm.file = open_exec(bprm.filename);
+	bprm.file = open_exec(bprm.filename, !libs->change_security);
 	res = PTR_ERR(bprm.file);
 	if (IS_ERR(bprm.file))
 		return res;
@@ -865,6 +867,7 @@ static int load_flat_binary(struct linux_binprm * bprm, struct pt_regs * regs)
 	int i, j;
 
 	memset(&libinfo, 0, sizeof(libinfo));
+	libinfo.change_security = bprm->change_security;
 	/*
 	 * We have to add the size of our arguments to our stack size
 	 * otherwise it's too easy for users to create stack overflows
diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index c4e8353..7beb122 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -178,7 +178,7 @@ static int load_misc_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 
 	bprm->interp = iname;	/* for binfmt_script */
 
-	interp_file = open_exec (iname);
+	interp_file = open_exec (iname, !bprm->change_security);
 	retval = PTR_ERR (interp_file);
 	if (IS_ERR (interp_file))
 		goto _error;
diff --git a/fs/binfmt_script.c b/fs/binfmt_script.c
index 0834350..64b6d4d 100644
--- a/fs/binfmt_script.c
+++ b/fs/binfmt_script.c
@@ -87,7 +87,7 @@ static int load_script(struct linux_binprm *bprm,struct pt_regs *regs)
 	/*
 	 * OK, now restart the process with the interpreter's dentry.
 	 */
-	file = open_exec(interp);
+	file = open_exec(interp, !bprm->change_security);
 	if (IS_ERR(file))
 		return PTR_ERR(file);
 
diff --git a/fs/compat.c b/fs/compat.c
index 00d90c2..585a2d7 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1459,7 +1459,8 @@ out:
 int compat_do_execve(char * filename,
 	compat_uptr_t __user *argv,
 	compat_uptr_t __user *envp,
-	struct pt_regs * regs)
+	struct pt_regs * regs,
+	bool change_security)
 {
 	struct linux_binprm *bprm;
 	struct file *file;
@@ -1475,6 +1476,7 @@ int compat_do_execve(char * filename,
 	bprm = kzalloc(sizeof(*bprm), GFP_KERNEL);
 	if (!bprm)
 		goto out_files;
+	bprm->change_security = change_security;
 
 	retval = prepare_bprm_creds(bprm);
 	if (retval)
@@ -1486,7 +1488,7 @@ int compat_do_execve(char * filename,
 	clear_in_exec = retval;
 	current->in_execve = 1;
 
-	file = open_exec(filename);
+	file = open_exec(filename, !change_security);
 	retval = PTR_ERR(file);
 	if (IS_ERR(file))
 		goto out_unmark;
diff --git a/fs/exec.c b/fs/exec.c
index cce6bbd..4067b65 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -346,6 +346,12 @@ int bprm_mm_init(struct linux_binprm *bprm)
 	if (err)
 		goto err;
 
+	/* If bprm->change_security is set, we'll override this later.  If not,
+	   then just keep the current settings.  (Regenerating it from the
+	   file flags or from (uid == euid) could have strange side effects.)
+	*/
+	set_dumpable(bprm->mm, current->mm ? get_dumpable(current->mm) : 1);
+
 	return 0;
 
 err:
@@ -660,14 +666,18 @@ EXPORT_SYMBOL(setup_arg_pages);
 
 #endif /* CONFIG_MMU */
 
-struct file *open_exec(const char *name)
+struct file *open_exec(const char *name, bool require_read_access)
 {
 	struct file *file;
 	int err;
+	int acc_mode = MAY_EXEC | MAY_OPEN;
+
+	if (require_read_access)
+		acc_mode |= MAY_READ;
 
 	file = do_filp_open(AT_FDCWD, name,
 				O_LARGEFILE | O_RDONLY | FMODE_EXEC, 0,
-				MAY_EXEC | MAY_OPEN);
+				acc_mode);
 	if (IS_ERR(file))
 		goto out;
 
@@ -1000,10 +1010,13 @@ void setup_new_exec(struct linux_binprm * bprm)
 	/* This is the point of no return */
 	current->sas_ss_sp = current->sas_ss_size = 0;
 
-	if (current_euid() == current_uid() && current_egid() == current_gid())
-		set_dumpable(current->mm, 1);
-	else
-		set_dumpable(current->mm, suid_dumpable);
+	if (bprm->change_security) {
+		if (current_euid() == current_uid() &&
+		    current_egid() == current_gid())
+			set_dumpable(current->mm, 1);
+		else
+			set_dumpable(current->mm, suid_dumpable);
+	}
 
 	name = bprm->filename;
 
@@ -1025,20 +1038,23 @@ void setup_new_exec(struct linux_binprm * bprm)
 	current->mm->task_size = TASK_SIZE;
 
 	/* install the new credentials */
-	if (bprm->cred->uid != current_euid() ||
-	    bprm->cred->gid != current_egid()) {
-		current->pdeath_signal = 0;
-	} else if (file_permission(bprm->file, MAY_READ) ||
-		   bprm->interp_flags & BINPRM_FLAGS_ENFORCE_NONDUMP) {
-		set_dumpable(current->mm, suid_dumpable);
+	if (bprm->change_security) {
+		if (bprm->cred->uid != current_euid() ||
+		    bprm->cred->gid != current_egid()) {
+			current->pdeath_signal = 0;
+		} else if (file_permission(bprm->file, MAY_READ) ||
+			   bprm->interp_flags & BINPRM_FLAGS_ENFORCE_NONDUMP) {
+			set_dumpable(current->mm, suid_dumpable);
+		}
+
+		/*
+		 * Flush performance counters when crossing a
+		 * security domain:
+		 */
+		if (!get_dumpable(current->mm))
+			perf_event_exit_task(current);
 	}
 
-	/*
-	 * Flush performance counters when crossing a
-	 * security domain:
-	 */
-	if (!get_dumpable(current->mm))
-		perf_event_exit_task(current);
 
 	/* An exec changes our domain. We are no longer part of the thread
 	   group */
@@ -1058,6 +1074,9 @@ EXPORT_SYMBOL(setup_new_exec);
  */
 int prepare_bprm_creds(struct linux_binprm *bprm)
 {
+	if (!bprm->change_security)
+		return 0;
+
 	if (mutex_lock_interruptible(&current->cred_guard_mutex))
 		return -ERESTARTNOINTR;
 
@@ -1084,6 +1103,9 @@ void free_bprm(struct linux_binprm *bprm)
  */
 void install_exec_creds(struct linux_binprm *bprm)
 {
+	if (!bprm->change_security)
+		return;
+
 	security_bprm_committing_creds(bprm);
 
 	commit_creds(bprm->cred);
@@ -1109,6 +1131,9 @@ int check_unsafe_exec(struct linux_binprm *bprm)
 	unsigned n_fs;
 	int res = 0;
 
+	if (!bprm->change_security)
+		return 0;
+
 	bprm->unsafe = tracehook_unsafe_exec(p);
 
 	n_fs = 1;
@@ -1150,35 +1175,37 @@ int prepare_binprm(struct linux_binprm *bprm)
 	if (bprm->file->f_op == NULL)
 		return -EACCES;
 
-	/* clear any previous set[ug]id data from a previous binary */
-	bprm->cred->euid = current_euid();
-	bprm->cred->egid = current_egid();
+	if (bprm->change_security) {
+		/* clear any previous set[ug]id data from a previous binary */
+		bprm->cred->euid = current_euid();
+		bprm->cred->egid = current_egid();
 
-	if (!(bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)) {
-		/* Set-uid? */
-		if (mode & S_ISUID) {
-			bprm->per_clear |= PER_CLEAR_ON_SETID;
-			bprm->cred->euid = inode->i_uid;
-		}
+		if (!(bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)) {
+			/* Set-uid? */
+			if (mode & S_ISUID) {
+				bprm->per_clear |= PER_CLEAR_ON_SETID;
+				bprm->cred->euid = inode->i_uid;
+			}
 
-		/* Set-gid? */
-		/*
-		 * If setgid is set but no group execute bit then this
-		 * is a candidate for mandatory locking, not a setgid
-		 * executable.
-		 */
-		if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP)) {
-			bprm->per_clear |= PER_CLEAR_ON_SETID;
-			bprm->cred->egid = inode->i_gid;
+			/* Set-gid? */
+			/*
+			 * If setgid is set but no group execute bit then this
+			 * is a candidate for mandatory locking, not a setgid
+			 * executable.
+			 */
+			if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP)) {
+				bprm->per_clear |= PER_CLEAR_ON_SETID;
+				bprm->cred->egid = inode->i_gid;
+			}
 		}
+
+		/* fill in binprm security blob */
+		retval = security_bprm_set_creds(bprm);
+		if (retval)
+			return retval;
+		bprm->cred_prepared = 1;
 	}
 
-	/* fill in binprm security blob */
-	retval = security_bprm_set_creds(bprm);
-	if (retval)
-		return retval;
-	bprm->cred_prepared = 1;
-
 	memset(bprm->buf, 0, BINPRM_BUF_SIZE);
 	return kernel_read(bprm->file, 0, bprm->buf, BINPRM_BUF_SIZE);
 }
@@ -1314,7 +1341,8 @@ EXPORT_SYMBOL(search_binary_handler);
 int do_execve(char * filename,
 	char __user *__user *argv,
 	char __user *__user *envp,
-	struct pt_regs * regs)
+	struct pt_regs * regs,
+        bool change_security)
 {
 	struct linux_binprm *bprm;
 	struct file *file;
@@ -1330,6 +1358,7 @@ int do_execve(char * filename,
 	bprm = kzalloc(sizeof(*bprm), GFP_KERNEL);
 	if (!bprm)
 		goto out_files;
+	bprm->change_security = change_security;
 
 	retval = prepare_bprm_creds(bprm);
 	if (retval)
@@ -1338,10 +1367,11 @@ int do_execve(char * filename,
 	retval = check_unsafe_exec(bprm);
 	if (retval < 0)
 		goto out_free;
+
 	clear_in_exec = retval;
 	current->in_execve = 1;
 
-	file = open_exec(filename);
+	file = open_exec(filename, !change_security);
 	retval = PTR_ERR(file);
 	if (IS_ERR(file))
 		goto out_unmark;
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 89c6249..019de0b 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -36,6 +36,9 @@ struct linux_binprm{
 	struct mm_struct *mm;
 	unsigned long p; /* current top of mem */
 	unsigned int
+		change_security:1,  /* true if this call to exec will
+				       affect the security state of the
+				       process. */
 		cred_prepared:1,/* true if creds already prepared (multiple
 				 * preps happen for interpreters) */
 		cap_effective:1;/* true if has elevated effective capabilities,
diff --git a/include/linux/compat.h b/include/linux/compat.h
index ef68119..45ccc3e 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -243,7 +243,7 @@ asmlinkage ssize_t compat_sys_pwritev(unsigned long fd,
 		unsigned long vlen, u32 pos_low, u32 pos_high);
 
 int compat_do_execve(char * filename, compat_uptr_t __user *argv,
-	        compat_uptr_t __user *envp, struct pt_regs * regs);
+		compat_uptr_t __user *envp, struct pt_regs * regs, bool);
 
 asmlinkage long compat_sys_select(int n, compat_ulong_t __user *inp,
 		compat_ulong_t __user *outp, compat_ulong_t __user *exp,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index ebb1cd5..b2094cc 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2128,7 +2128,7 @@ extern struct file *do_filp_open(int dfd, const char *pathname,
 extern int may_open(struct path *, int, int);
 
 extern int kernel_read(struct file *, loff_t, char *, unsigned long);
-extern struct file * open_exec(const char *);
+extern struct file * open_exec(const char *, bool);
  
 /* fs/dcache.c -- generic fs support functions */
 extern int is_subdir(struct dentry *, struct dentry *);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 78efe7c..2d03069 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2175,7 +2175,7 @@ extern void daemonize(const char *, ...);
 extern int allow_signal(int);
 extern int disallow_signal(int);
 
-extern int do_execve(char *, char __user * __user *, char __user * __user *, struct pt_regs *);
+extern int do_execve(char *, char __user * __user *, char __user * __user *, struct pt_regs *, bool);
 extern long do_fork(unsigned long, unsigned long, struct pt_regs *, unsigned long, int __user *, int __user *);
 struct task_struct *fork_idle(int);
 
-- 
1.6.6.1

