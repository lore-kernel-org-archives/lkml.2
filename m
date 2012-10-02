Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508Ab2JBA1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 20:27:19 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60923 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab2JBAR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 20:17:26 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: eparis@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com
Subject: [PATCH v7 14/49] vfs: define getname_info struct and have getname() return it
Date: Mon,  1 Oct 2012 20:16:23 -0400
Message-Id: <1349137018-21948-15-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
References: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

getname() is intended to copy pathname strings from userspace into a
kernel buffer. The result is just a string in kernel space. It would
however be quite helpful to be able to attach some ancillary info to
the string.

For instance, we could attach some audit-related info to reduce the
amount of audit-related processing needed. When auditing is enabled,
we could also call getname() on the string more than once and not
need to recopy it from userspace.

This patchset converts the getname()/putname() interfaces to return
a struct instead of a string. For now, the struct just tracks the
string in kernel space and the original userland pointer for it.

Later, we'll add other information to the struct as it becomes
convenient.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 arch/alpha/kernel/osf_sys.c             |  16 ++---
 arch/avr32/kernel/process.c             |   4 +-
 arch/blackfin/kernel/process.c          |   4 +-
 arch/cris/arch-v10/kernel/process.c     |   4 +-
 arch/cris/arch-v32/kernel/process.c     |   4 +-
 arch/h8300/kernel/process.c             |   4 +-
 arch/hexagon/kernel/syscall.c           |   4 +-
 arch/ia64/kernel/process.c              |   4 +-
 arch/m32r/kernel/process.c              |   4 +-
 arch/microblaze/kernel/sys_microblaze.c |   4 +-
 arch/mips/kernel/linux32.c              |   4 +-
 arch/mips/kernel/syscall.c              |   4 +-
 arch/openrisc/kernel/process.c          |   4 +-
 arch/parisc/hpux/fs.c                   |   4 +-
 arch/parisc/kernel/process.c            |   4 +-
 arch/parisc/kernel/sys_parisc32.c       |   4 +-
 arch/score/kernel/sys_score.c           |   4 +-
 arch/sh/kernel/process_32.c             |   4 +-
 arch/sh/kernel/process_64.c             |   4 +-
 arch/tile/kernel/process.c              |   8 +--
 arch/unicore32/kernel/sys.c             |   4 +-
 arch/xtensa/kernel/process.c            |   4 +-
 fs/compat.c                             |  12 ++--
 fs/exec.c                               |  13 ++--
 fs/filesystems.c                        |   4 +-
 fs/namei.c                              | 113 +++++++++++++++++++-------------
 fs/namespace.c                          |   4 +-
 fs/open.c                               |   4 +-
 fs/quota/quota.c                        |   4 +-
 include/linux/audit.h                   |   8 ++-
 include/linux/fs.h                      |  14 +++-
 ipc/mqueue.c                            |  13 ++--
 kernel/acct.c                           |   4 +-
 kernel/auditsc.c                        |  86 +++++++++++++-----------
 mm/swapfile.c                           |  11 ++--
 35 files changed, 218 insertions(+), 176 deletions(-)

diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index bc1acdd..b3f41e8 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -452,7 +452,7 @@ osf_ufs_mount(char *dirname, struct ufs_args __user *args, int flags)
 {
 	int retval;
 	struct cdfs_args tmp;
-	char *devname;
+	struct getname_info *devname;
 
 	retval = -EFAULT;
 	if (copy_from_user(&tmp, args, sizeof(tmp)))
@@ -461,7 +461,7 @@ osf_ufs_mount(char *dirname, struct ufs_args __user *args, int flags)
 	retval = PTR_ERR(devname);
 	if (IS_ERR(devname))
 		goto out;
-	retval = do_mount(devname, dirname, "ext2", flags, NULL);
+	retval = do_mount(devname->name, dirname, "ext2", flags, NULL);
 	putname(devname);
  out:
 	return retval;
@@ -472,7 +472,7 @@ osf_cdfs_mount(char *dirname, struct cdfs_args __user *args, int flags)
 {
 	int retval;
 	struct cdfs_args tmp;
-	char *devname;
+	struct getname_info *devname;
 
 	retval = -EFAULT;
 	if (copy_from_user(&tmp, args, sizeof(tmp)))
@@ -481,7 +481,7 @@ osf_cdfs_mount(char *dirname, struct cdfs_args __user *args, int flags)
 	retval = PTR_ERR(devname);
 	if (IS_ERR(devname))
 		goto out;
-	retval = do_mount(devname, dirname, "iso9660", flags, NULL);
+	retval = do_mount(devname->name, dirname, "iso9660", flags, NULL);
 	putname(devname);
  out:
 	return retval;
@@ -502,7 +502,7 @@ SYSCALL_DEFINE4(osf_mount, unsigned long, typenr, const char __user *, path,
 		int, flag, void __user *, data)
 {
 	int retval;
-	char *name;
+	struct getname_info *name;
 
 	name = getname(path);
 	retval = PTR_ERR(name);
@@ -510,13 +510,13 @@ SYSCALL_DEFINE4(osf_mount, unsigned long, typenr, const char __user *, path,
 		goto out;
 	switch (typenr) {
 	case 1:
-		retval = osf_ufs_mount(name, data, flag);
+		retval = osf_ufs_mount(name->name, data, flag);
 		break;
 	case 6:
-		retval = osf_cdfs_mount(name, data, flag);
+		retval = osf_cdfs_mount(name->name, data, flag);
 		break;
 	case 9:
-		retval = osf_procfs_mount(name, data, flag);
+		retval = osf_procfs_mount(name->name, data, flag);
 		break;
 	default:
 		retval = -EINVAL;
diff --git a/arch/avr32/kernel/process.c b/arch/avr32/kernel/process.c
index 92c5af9..c2034e8 100644
--- a/arch/avr32/kernel/process.c
+++ b/arch/avr32/kernel/process.c
@@ -388,14 +388,14 @@ asmlinkage int sys_execve(const char __user *ufilename,
 			  struct pt_regs *regs)
 {
 	int error;
-	char *filename;
+	struct getname_info *filename;
 
 	filename = getname(ufilename);
 	error = PTR_ERR(filename);
 	if (IS_ERR(filename))
 		goto out;
 
-	error = do_execve(filename, uargv, uenvp, regs);
+	error = do_execve(filename->name, uargv, uenvp, regs);
 	putname(filename);
 
 out:
diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
index 62bcea7..bc5c162 100644
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -213,14 +213,14 @@ asmlinkage int sys_execve(const char __user *name,
 			  const char __user *const __user *envp)
 {
 	int error;
-	char *filename;
+	struct getname_info *filename;
 	struct pt_regs *regs = (struct pt_regs *)((&name) + 6);
 
 	filename = getname(name);
 	error = PTR_ERR(filename);
 	if (IS_ERR(filename))
 		return error;
-	error = do_execve(filename, argv, envp, regs);
+	error = do_execve(filename->name, argv, envp, regs);
 	putname(filename);
 	return error;
 }
diff --git a/arch/cris/arch-v10/kernel/process.c b/arch/cris/arch-v10/kernel/process.c
index bee8df4..92b57e7 100644
--- a/arch/cris/arch-v10/kernel/process.c
+++ b/arch/cris/arch-v10/kernel/process.c
@@ -212,14 +212,14 @@ asmlinkage int sys_execve(const char *fname,
 			  struct pt_regs *regs)
 {
 	int error;
-	char *filename;
+	struct getname_info *filename;
 
 	filename = getname(fname);
 	error = PTR_ERR(filename);
 
 	if (IS_ERR(filename))
 	        goto out;
-	error = do_execve(filename, argv, envp, regs);
+	error = do_execve(filename->name, argv, envp, regs);
 	putname(filename);
  out:
 	return error;
diff --git a/arch/cris/arch-v32/kernel/process.c b/arch/cris/arch-v32/kernel/process.c
index 0570e8c..a80be6f 100644
--- a/arch/cris/arch-v32/kernel/process.c
+++ b/arch/cris/arch-v32/kernel/process.c
@@ -224,7 +224,7 @@ sys_execve(const char *fname,
 	   struct pt_regs *regs)
 {
 	int error;
-	char *filename;
+	struct getname_info *filename;
 
 	filename = getname(fname);
 	error = PTR_ERR(filename);
@@ -232,7 +232,7 @@ sys_execve(const char *fname,
 	if (IS_ERR(filename))
 	        goto out;
 
-	error = do_execve(filename, argv, envp, regs);
+	error = do_execve(filename->name, argv, envp, regs);
 	putname(filename);
  out:
 	return error;
diff --git a/arch/h8300/kernel/process.c b/arch/h8300/kernel/process.c
index 0e9c315..67d357d 100644
--- a/arch/h8300/kernel/process.c
+++ b/arch/h8300/kernel/process.c
@@ -214,14 +214,14 @@ asmlinkage int sys_execve(const char *name,
 			  int dummy, ...)
 {
 	int error;
-	char * filename;
+	struct getname_info *filename;
 	struct pt_regs *regs = (struct pt_regs *) ((unsigned char *)&dummy-4);
 
 	filename = getname(name);
 	error = PTR_ERR(filename);
 	if (IS_ERR(filename))
 		return error;
-	error = do_execve(filename, argv, envp, regs);
+	error = do_execve(filename->name, argv, envp, regs);
 	putname(filename);
 	return error;
 }
diff --git a/arch/hexagon/kernel/syscall.c b/arch/hexagon/kernel/syscall.c
index 553cd60..f67b4d5 100644
--- a/arch/hexagon/kernel/syscall.c
+++ b/arch/hexagon/kernel/syscall.c
@@ -40,7 +40,7 @@ asmlinkage int sys_execve(char __user *ufilename,
 			  const char __user *const __user *envp)
 {
 	struct pt_regs *pregs = current_thread_info()->regs;
-	char *filename;
+	struct getname_info *filename;
 	int retval;
 
 	filename = getname(ufilename);
@@ -48,7 +48,7 @@ asmlinkage int sys_execve(char __user *ufilename,
 	if (IS_ERR(filename))
 		return retval;
 
-	retval = do_execve(filename, argv, envp, pregs);
+	retval = do_execve(filename->name, argv, envp, pregs);
 	putname(filename);
 
 	return retval;
diff --git a/arch/ia64/kernel/process.c b/arch/ia64/kernel/process.c
index dd6fc14..d2cf668 100644
--- a/arch/ia64/kernel/process.c
+++ b/arch/ia64/kernel/process.c
@@ -611,14 +611,14 @@ sys_execve (const char __user *filename,
 	    const char __user *const __user *envp,
 	    struct pt_regs *regs)
 {
-	char *fname;
+	struct getname_info *fname;
 	int error;
 
 	fname = getname(filename);
 	error = PTR_ERR(fname);
 	if (IS_ERR(fname))
 		goto out;
-	error = do_execve(fname, argv, envp, regs);
+	error = do_execve(fname->name, argv, envp, regs);
 	putname(fname);
 out:
 	return error;
diff --git a/arch/m32r/kernel/process.c b/arch/m32r/kernel/process.c
index 3a4a32b..e1ea185 100644
--- a/arch/m32r/kernel/process.c
+++ b/arch/m32r/kernel/process.c
@@ -293,14 +293,14 @@ asmlinkage int sys_execve(const char __user *ufilename,
 			  unsigned long r6, struct pt_regs regs)
 {
 	int error;
-	char *filename;
+	struct getname_info *filename;
 
 	filename = getname(ufilename);
 	error = PTR_ERR(filename);
 	if (IS_ERR(filename))
 		goto out;
 
-	error = do_execve(filename, uargv, uenvp, &regs);
+	error = do_execve(filename->name, uargv, uenvp, &regs);
 	putname(filename);
 out:
 	return error;
diff --git a/arch/microblaze/kernel/sys_microblaze.c b/arch/microblaze/kernel/sys_microblaze.c
index e5b154f..f273d16 100644
--- a/arch/microblaze/kernel/sys_microblaze.c
+++ b/arch/microblaze/kernel/sys_microblaze.c
@@ -54,13 +54,13 @@ asmlinkage long microblaze_execve(const char __user *filenamei,
 				  struct pt_regs *regs)
 {
 	int error;
-	char *filename;
+	struct getname_info *filename;
 
 	filename = getname(filenamei);
 	error = PTR_ERR(filename);
 	if (IS_ERR(filename))
 		goto out;
-	error = do_execve(filename, argv, envp, regs);
+	error = do_execve(filename->name, argv, envp, regs);
 	putname(filename);
 out:
 	return error;
diff --git a/arch/mips/kernel/linux32.c b/arch/mips/kernel/linux32.c
index 922a554..62ff5a9 100644
--- a/arch/mips/kernel/linux32.c
+++ b/arch/mips/kernel/linux32.c
@@ -83,13 +83,13 @@ out:
 asmlinkage int sys32_execve(nabi_no_regargs struct pt_regs regs)
 {
 	int error;
-	char * filename;
+	struct getname_info *filename;
 
 	filename = getname(compat_ptr(regs.regs[4]));
 	error = PTR_ERR(filename);
 	if (IS_ERR(filename))
 		goto out;
-	error = compat_do_execve(filename, compat_ptr(regs.regs[5]),
+	error = compat_do_execve(filename->name, compat_ptr(regs.regs[5]),
 				 compat_ptr(regs.regs[6]), &regs);
 	putname(filename);
 
diff --git a/arch/mips/kernel/syscall.c b/arch/mips/kernel/syscall.c
index b08220c..679c417 100644
--- a/arch/mips/kernel/syscall.c
+++ b/arch/mips/kernel/syscall.c
@@ -133,13 +133,13 @@ _sys_clone(nabi_no_regargs struct pt_regs regs)
 asmlinkage int sys_execve(nabi_no_regargs struct pt_regs regs)
 {
 	int error;
-	char * filename;
+	struct getname_info *filename;
 
 	filename = getname((const char __user *) (long)regs.regs[4]);
 	error = PTR_ERR(filename);
 	if (IS_ERR(filename))
 		goto out;
-	error = do_execve(filename,
+	error = do_execve(filename->name,
 			  (const char __user *const __user *) (long)regs.regs[5],
 	                  (const char __user *const __user *) (long)regs.regs[6],
 			  &regs);
diff --git a/arch/openrisc/kernel/process.c b/arch/openrisc/kernel/process.c
index 55210f3..9edec79 100644
--- a/arch/openrisc/kernel/process.c
+++ b/arch/openrisc/kernel/process.c
@@ -271,7 +271,7 @@ asmlinkage long _sys_execve(const char __user *name,
 			    struct pt_regs *regs)
 {
 	int error;
-	char *filename;
+	struct getname_info *filename;
 
 	filename = getname(name);
 	error = PTR_ERR(filename);
@@ -279,7 +279,7 @@ asmlinkage long _sys_execve(const char __user *name,
 	if (IS_ERR(filename))
 		goto out;
 
-	error = do_execve(filename, argv, envp, regs);
+	error = do_execve(filename->name, argv, envp, regs);
 	putname(filename);
 
 out:
diff --git a/arch/parisc/hpux/fs.c b/arch/parisc/hpux/fs.c
index c71eb6c..a40d81f 100644
--- a/arch/parisc/hpux/fs.c
+++ b/arch/parisc/hpux/fs.c
@@ -34,14 +34,14 @@
 int hpux_execve(struct pt_regs *regs)
 {
 	int error;
-	char *filename;
+	struct getname_info *filename;
 
 	filename = getname((const char __user *) regs->gr[26]);
 	error = PTR_ERR(filename);
 	if (IS_ERR(filename))
 		goto out;
 
-	error = do_execve(filename,
+	error = do_execve(filename->name,
 			  (const char __user *const __user *) regs->gr[25],
 			  (const char __user *const __user *) regs->gr[24],
 			  regs);
diff --git a/arch/parisc/kernel/process.c b/arch/parisc/kernel/process.c
index 2c05a92..f8d32be 100644
--- a/arch/parisc/kernel/process.c
+++ b/arch/parisc/kernel/process.c
@@ -339,13 +339,13 @@ unsigned long thread_saved_pc(struct task_struct *t)
 asmlinkage int sys_execve(struct pt_regs *regs)
 {
 	int error;
-	char *filename;
+	struct getname_info *filename;
 
 	filename = getname((const char __user *) regs->gr[26]);
 	error = PTR_ERR(filename);
 	if (IS_ERR(filename))
 		goto out;
-	error = do_execve(filename,
+	error = do_execve(filename->name,
 			  (const char __user *const __user *) regs->gr[25],
 			  (const char __user *const __user *) regs->gr[24],
 			  regs);
diff --git a/arch/parisc/kernel/sys_parisc32.c b/arch/parisc/kernel/sys_parisc32.c
index dc9a624..7e17607 100644
--- a/arch/parisc/kernel/sys_parisc32.c
+++ b/arch/parisc/kernel/sys_parisc32.c
@@ -60,14 +60,14 @@
 asmlinkage int sys32_execve(struct pt_regs *regs)
 {
 	int error;
-	char *filename;
+	struct getname_info *filename;
 
 	DBG(("sys32_execve(%p) r26 = 0x%lx\n", regs, regs->gr[26]));
 	filename = getname((const char __user *) regs->gr[26]);
 	error = PTR_ERR(filename);
 	if (IS_ERR(filename))
 		goto out;
-	error = compat_do_execve(filename, compat_ptr(regs->gr[25]),
+	error = compat_do_execve(filename->name, compat_ptr(regs->gr[25]),
 				 compat_ptr(regs->gr[24]), regs);
 	putname(filename);
 out:
diff --git a/arch/score/kernel/sys_score.c b/arch/score/kernel/sys_score.c
index e478bf9..9ee9ac9 100644
--- a/arch/score/kernel/sys_score.c
+++ b/arch/score/kernel/sys_score.c
@@ -92,14 +92,14 @@ asmlinkage long
 score_execve(struct pt_regs *regs)
 {
 	int error;
-	char *filename;
+	struct getname_info *filename;
 
 	filename = getname((char __user*)regs->regs[4]);
 	error = PTR_ERR(filename);
 	if (IS_ERR(filename))
 		return error;
 
-	error = do_execve(filename,
+	error = do_execve(filename->name,
 			  (const char __user *const __user *)regs->regs[5],
 			  (const char __user *const __user *)regs->regs[6],
 			  regs);
diff --git a/arch/sh/kernel/process_32.c b/arch/sh/kernel/process_32.c
index 59521e8..93d4879 100644
--- a/arch/sh/kernel/process_32.c
+++ b/arch/sh/kernel/process_32.c
@@ -298,14 +298,14 @@ asmlinkage int sys_execve(const char __user *ufilename,
 {
 	struct pt_regs *regs = RELOC_HIDE(&__regs, 0);
 	int error;
-	char *filename;
+	struct getname_info *filename;
 
 	filename = getname(ufilename);
 	error = PTR_ERR(filename);
 	if (IS_ERR(filename))
 		goto out;
 
-	error = do_execve(filename, uargv, uenvp, regs);
+	error = do_execve(filename->name, uargv, uenvp, regs);
 	putname(filename);
 out:
 	return error;
diff --git a/arch/sh/kernel/process_64.c b/arch/sh/kernel/process_64.c
index 602545b..bad7c30 100644
--- a/arch/sh/kernel/process_64.c
+++ b/arch/sh/kernel/process_64.c
@@ -491,14 +491,14 @@ asmlinkage int sys_execve(const char *ufilename, char **uargv,
 			  struct pt_regs *pregs)
 {
 	int error;
-	char *filename;
+	struct getname_info *filename;
 
 	filename = getname((char __user *)ufilename);
 	error = PTR_ERR(filename);
 	if (IS_ERR(filename))
 		goto out;
 
-	error = do_execve(filename,
+	error = do_execve(filename->name,
 			  (const char __user *const __user *)uargv,
 			  (const char __user *const __user *)uenvp,
 			  pregs);
diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index 6be7991..04b0e62 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -594,13 +594,13 @@ SYSCALL_DEFINE4(execve, const char __user *, path,
 		struct pt_regs *, regs)
 {
 	long error;
-	char *filename;
+	struct getname_info *filename;
 
 	filename = getname(path);
 	error = PTR_ERR(filename);
 	if (IS_ERR(filename))
 		goto out;
-	error = do_execve(filename, argv, envp, regs);
+	error = do_execve(filename->name, argv, envp, regs);
 	putname(filename);
 	if (error == 0)
 		single_step_execve();
@@ -615,13 +615,13 @@ long compat_sys_execve(const char __user *path,
 		       struct pt_regs *regs)
 {
 	long error;
-	char *filename;
+	struct getname_info *filename;
 
 	filename = getname(path);
 	error = PTR_ERR(filename);
 	if (IS_ERR(filename))
 		goto out;
-	error = compat_do_execve(filename, argv, envp, regs);
+	error = compat_do_execve(filename->name, argv, envp, regs);
 	putname(filename);
 	if (error == 0)
 		single_step_execve();
diff --git a/arch/unicore32/kernel/sys.c b/arch/unicore32/kernel/sys.c
index 5fd9af7..7a0c372 100644
--- a/arch/unicore32/kernel/sys.c
+++ b/arch/unicore32/kernel/sys.c
@@ -51,13 +51,13 @@ asmlinkage long __sys_execve(const char __user *filename,
 			  struct pt_regs *regs)
 {
 	int error;
-	char *fn;
+	struct getname_info *fn;
 
 	fn = getname(filename);
 	error = PTR_ERR(fn);
 	if (IS_ERR(fn))
 		goto out;
-	error = do_execve(fn, argv, envp, regs);
+	error = do_execve(fn->name, argv, envp, regs);
 	putname(fn);
 out:
 	return error;
diff --git a/arch/xtensa/kernel/process.c b/arch/xtensa/kernel/process.c
index 2c8d6a3..03d723d 100644
--- a/arch/xtensa/kernel/process.c
+++ b/arch/xtensa/kernel/process.c
@@ -325,13 +325,13 @@ long xtensa_execve(const char __user *name,
                    struct pt_regs *regs)
 {
 	long error;
-	char * filename;
+	struct getname_info *filename;
 
 	filename = getname(name);
 	error = PTR_ERR(filename);
 	if (IS_ERR(filename))
 		goto out;
-	error = do_execve(filename, argv, envp, regs);
+	error = do_execve(filename->name, argv, envp, regs);
 	putname(filename);
 out:
 	return error;
diff --git a/fs/compat.c b/fs/compat.c
index 1bdb350..224f726 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -776,16 +776,16 @@ asmlinkage long compat_sys_mount(const char __user * dev_name,
 	char *kernel_type;
 	unsigned long data_page;
 	char *kernel_dev;
-	char *dir_page;
+	struct getname_info *dir;
 	int retval;
 
 	retval = copy_mount_string(type, &kernel_type);
 	if (retval < 0)
 		goto out;
 
-	dir_page = getname(dir_name);
-	retval = PTR_ERR(dir_page);
-	if (IS_ERR(dir_page))
+	dir = getname(dir_name);
+	retval = PTR_ERR(dir);
+	if (IS_ERR(dir))
 		goto out1;
 
 	retval = copy_mount_string(dev_name, &kernel_dev);
@@ -807,7 +807,7 @@ asmlinkage long compat_sys_mount(const char __user * dev_name,
 		}
 	}
 
-	retval = do_mount(kernel_dev, dir_page, kernel_type,
+	retval = do_mount(kernel_dev, dir->name, kernel_type,
 			flags, (void*)data_page);
 
  out4:
@@ -815,7 +815,7 @@ asmlinkage long compat_sys_mount(const char __user * dev_name,
  out3:
 	kfree(kernel_dev);
  out2:
-	putname(dir_page);
+	putname(dir);
  out1:
 	kfree(kernel_type);
  out:
diff --git a/fs/exec.c b/fs/exec.c
index 50a1270..222e282 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -115,7 +115,7 @@ static inline void put_binfmt(struct linux_binfmt * fmt)
 SYSCALL_DEFINE1(uselib, const char __user *, library)
 {
 	struct file *file;
-	char *tmp = getname(library);
+	struct getname_info *tmp = getname(library);
 	int error = PTR_ERR(tmp);
 	static const struct open_flags uselib_flags = {
 		.open_flag = O_LARGEFILE | O_RDONLY | __FMODE_EXEC,
@@ -126,7 +126,7 @@ SYSCALL_DEFINE1(uselib, const char __user *, library)
 	if (IS_ERR(tmp))
 		goto out;
 
-	file = do_filp_open(AT_FDCWD, tmp, &uselib_flags, LOOKUP_FOLLOW);
+	file = do_filp_open(AT_FDCWD, tmp->name, &uselib_flags, LOOKUP_FOLLOW);
 	putname(tmp);
 	error = PTR_ERR(file);
 	if (IS_ERR(file))
@@ -2325,10 +2325,10 @@ SYSCALL_DEFINE3(execve,
 		const char __user *const __user *, argv,
 		const char __user *const __user *, envp)
 {
-	const char *path = getname(filename);
+	struct getname_info *path = getname(filename);
 	int error = PTR_ERR(path);
 	if (!IS_ERR(path)) {
-		error = do_execve(path, argv, envp, current_pt_regs());
+		error = do_execve(path->name, argv, envp, current_pt_regs());
 		putname(path);
 	}
 	return error;
@@ -2338,10 +2338,11 @@ asmlinkage long compat_sys_execve(const char __user * filename,
 	const compat_uptr_t __user * argv,
 	const compat_uptr_t __user * envp)
 {
-	const char *path = getname(filename);
+	struct getname_info *path = getname(filename);
 	int error = PTR_ERR(path);
 	if (!IS_ERR(path)) {
-		error = compat_do_execve(path, argv, envp, current_pt_regs());
+		error = compat_do_execve(path->name, argv, envp,
+							current_pt_regs());
 		putname(path);
 	}
 	return error;
diff --git a/fs/filesystems.c b/fs/filesystems.c
index 96f2428..9f4d31a 100644
--- a/fs/filesystems.c
+++ b/fs/filesystems.c
@@ -124,7 +124,7 @@ EXPORT_SYMBOL(unregister_filesystem);
 static int fs_index(const char __user * __name)
 {
 	struct file_system_type * tmp;
-	char * name;
+	struct getname_info *name;
 	int err, index;
 
 	name = getname(__name);
@@ -135,7 +135,7 @@ static int fs_index(const char __user * __name)
 	err = -EINVAL;
 	read_lock(&file_systems_lock);
 	for (tmp=file_systems, index=0 ; tmp ; tmp=tmp->next, index++) {
-		if (strcmp(tmp->name,name) == 0) {
+		if (strcmp(tmp->name, name->name) == 0) {
 			err = index;
 			break;
 		}
diff --git a/fs/namei.c b/fs/namei.c
index 64f7350..60db390 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -117,18 +117,37 @@
  * POSIX.1 2.4: an empty pathname is invalid (ENOENT).
  * PATH_MAX includes the nul terminator --RR.
  */
-static char *getname_flags(const char __user *filename, int flags, int *empty)
+void final_putname(struct getname_info *ginfo)
 {
-	char *result = __getname(), *err;
+	__putname(ginfo->name);
+	kfree(ginfo);
+}
+
+static struct getname_info *
+getname_flags(const char __user *filename, int flags, int *empty)
+{
+	struct getname_info *result, *err;
+	char *kname;
 	int len;
 
+	/* FIXME: create dedicated slabcache? */
+	result = kzalloc(sizeof(*result), GFP_KERNEL);
 	if (unlikely(!result))
 		return ERR_PTR(-ENOMEM);
 
-	len = strncpy_from_user(result, filename, PATH_MAX);
-	err = ERR_PTR(len);
-	if (unlikely(len < 0))
+	kname = __getname();
+	if (unlikely(!kname)) {
+		err = ERR_PTR(-ENOMEM);
+		goto error_free_ginfo;
+	}
+
+	result->name = kname;
+	result->uptr = filename;
+	len = strncpy_from_user(kname, filename, PATH_MAX);
+	if (unlikely(len < 0)) {
+		err = ERR_PTR(len);
 		goto error;
+	}
 
 	/* The empty path is special. */
 	if (unlikely(!len)) {
@@ -146,25 +165,28 @@ static char *getname_flags(const char __user *filename, int flags, int *empty)
 	}
 
 error:
-	__putname(result);
+	__putname(kname);
+error_free_ginfo:
+	kfree(result);
 	return err;
 }
 
-char *getname(const char __user * filename)
+struct getname_info *
+getname(const char __user * filename)
 {
 	return getname_flags(filename, 0, NULL);
 }
+EXPORT_SYMBOL(getname);
 
-#ifdef CONFIG_AUDITSYSCALL
-void putname(const char *name)
+void putname(struct getname_info *ginfo)
 {
+#ifdef CONFIG_AUDITSYSCALL
 	if (unlikely(!audit_dummy_context()))
-		audit_putname(name);
-	else
-		__putname(name);
+		return audit_putname(ginfo);
+#endif
+	final_putname(ginfo);
 }
 EXPORT_SYMBOL(putname);
-#endif
 
 static int check_acl(struct inode *inode, int mask)
 {
@@ -2098,13 +2120,13 @@ int user_path_at_empty(int dfd, const char __user *name, unsigned flags,
 		 struct path *path, int *empty)
 {
 	struct nameidata nd;
-	char *tmp = getname_flags(name, flags, empty);
+	struct getname_info *tmp = getname_flags(name, flags, empty);
 	int err = PTR_ERR(tmp);
 	if (!IS_ERR(tmp)) {
 
 		BUG_ON(flags & LOOKUP_PARENT);
 
-		err = do_path_lookup(dfd, tmp, flags, &nd);
+		err = do_path_lookup(dfd, tmp->name, flags, &nd);
 		putname(tmp);
 		if (!err)
 			*path = nd.path;
@@ -2118,22 +2140,22 @@ int user_path_at(int dfd, const char __user *name, unsigned flags,
 	return user_path_at_empty(dfd, name, flags, path, NULL);
 }
 
-static int user_path_parent(int dfd, const char __user *path,
-			struct nameidata *nd, char **name)
+static struct getname_info *
+user_path_parent(int dfd, const char __user *path, struct nameidata *nd)
 {
-	char *s = getname(path);
+	struct getname_info *s = getname(path);
 	int error;
 
 	if (IS_ERR(s))
-		return PTR_ERR(s);
+		return s;
 
-	error = do_path_lookup(dfd, s, LOOKUP_PARENT, nd);
-	if (error)
+	error = do_path_lookup(dfd, s->name, LOOKUP_PARENT, nd);
+	if (error) {
 		putname(s);
-	else
-		*name = s;
+		return ERR_PTR(error);
+	}
 
-	return error;
+	return s;
 }
 
 /*
@@ -3044,11 +3066,11 @@ EXPORT_SYMBOL(done_path_create);
 
 struct dentry *user_path_create(int dfd, const char __user *pathname, struct path *path, int is_dir)
 {
-	char *tmp = getname(pathname);
+	struct getname_info *tmp = getname(pathname);
 	struct dentry *res;
 	if (IS_ERR(tmp))
 		return ERR_CAST(tmp);
-	res = kern_path_create(dfd, tmp, path, is_dir);
+	res = kern_path_create(dfd, tmp->name, path, is_dir);
 	putname(tmp);
 	return res;
 }
@@ -3253,13 +3275,13 @@ out:
 static long do_rmdir(int dfd, const char __user *pathname)
 {
 	int error = 0;
-	char * name;
+	struct getname_info *name;
 	struct dentry *dentry;
 	struct nameidata nd;
 
-	error = user_path_parent(dfd, pathname, &nd, &name);
-	if (error)
-		return error;
+	name = user_path_parent(dfd, pathname, &nd);
+	if (IS_ERR(name))
+		return PTR_ERR(name);
 
 	switch(nd.last_type) {
 	case LAST_DOTDOT:
@@ -3348,14 +3370,14 @@ int vfs_unlink(struct inode *dir, struct dentry *dentry)
 static long do_unlinkat(int dfd, const char __user *pathname)
 {
 	int error;
-	char *name;
+	struct getname_info *name;
 	struct dentry *dentry;
 	struct nameidata nd;
 	struct inode *inode = NULL;
 
-	error = user_path_parent(dfd, pathname, &nd, &name);
-	if (error)
-		return error;
+	name = user_path_parent(dfd, pathname, &nd);
+	if (IS_ERR(name))
+		return PTR_ERR(name);
 
 	error = -EISDIR;
 	if (nd.last_type != LAST_NORM)
@@ -3439,7 +3461,7 @@ SYSCALL_DEFINE3(symlinkat, const char __user *, oldname,
 		int, newdfd, const char __user *, newname)
 {
 	int error;
-	char *from;
+	struct getname_info *from;
 	struct dentry *dentry;
 	struct path path;
 
@@ -3452,9 +3474,9 @@ SYSCALL_DEFINE3(symlinkat, const char __user *, oldname,
 	if (IS_ERR(dentry))
 		goto out_putname;
 
-	error = security_path_symlink(&path, dentry, from);
+	error = security_path_symlink(&path, dentry, from->name);
 	if (!error)
-		error = vfs_symlink(path.dentry->d_inode, dentry, from);
+		error = vfs_symlink(path.dentry->d_inode, dentry, from->name);
 	done_path_create(&path, dentry);
 out_putname:
 	putname(from);
@@ -3734,17 +3756,21 @@ SYSCALL_DEFINE4(renameat, int, olddfd, const char __user *, oldname,
 	struct dentry *old_dentry, *new_dentry;
 	struct dentry *trap;
 	struct nameidata oldnd, newnd;
-	char *from;
-	char *to;
+	struct getname_info *from;
+	struct getname_info *to;
 	int error;
 
-	error = user_path_parent(olddfd, oldname, &oldnd, &from);
-	if (error)
+	from = user_path_parent(olddfd, oldname, &oldnd);
+	if (IS_ERR(from)) {
+		error = PTR_ERR(from);
 		goto exit;
+	}
 
-	error = user_path_parent(newdfd, newname, &newnd, &to);
-	if (error)
+	to = user_path_parent(newdfd, newname, &newnd);
+	if (IS_ERR(to)) {
+		error = PTR_ERR(to);
 		goto exit1;
+	}
 
 	error = -EXDEV;
 	if (oldnd.path.mnt != newnd.path.mnt)
@@ -3968,7 +3994,6 @@ EXPORT_SYMBOL(follow_down_one);
 EXPORT_SYMBOL(follow_down);
 EXPORT_SYMBOL(follow_up);
 EXPORT_SYMBOL(get_write_access); /* binfmt_aout */
-EXPORT_SYMBOL(getname);
 EXPORT_SYMBOL(lock_rename);
 EXPORT_SYMBOL(lookup_one_len);
 EXPORT_SYMBOL(page_follow_link_light);
diff --git a/fs/namespace.c b/fs/namespace.c
index 8e52b1c..7dfe6ac 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2402,7 +2402,7 @@ SYSCALL_DEFINE5(mount, char __user *, dev_name, char __user *, dir_name,
 {
 	int ret;
 	char *kernel_type;
-	char *kernel_dir;
+	struct getname_info *kernel_dir;
 	char *kernel_dev;
 	unsigned long data_page;
 
@@ -2424,7 +2424,7 @@ SYSCALL_DEFINE5(mount, char __user *, dev_name, char __user *, dir_name,
 	if (ret < 0)
 		goto out_data;
 
-	ret = do_mount(kernel_dev, kernel_dir, kernel_type, flags,
+	ret = do_mount(kernel_dev, kernel_dir->name, kernel_type, flags,
 		(void *) data_page);
 
 	free_page(data_page);
diff --git a/fs/open.c b/fs/open.c
index ec06921..3796d0c 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -945,13 +945,13 @@ long do_sys_open(int dfd, const char __user *filename, int flags, umode_t mode)
 {
 	struct open_flags op;
 	int lookup = build_open_flags(flags, mode, &op);
-	char *tmp = getname(filename);
+	struct getname_info *tmp = getname(filename);
 	int fd = PTR_ERR(tmp);
 
 	if (!IS_ERR(tmp)) {
 		fd = get_unused_fd_flags(flags);
 		if (fd >= 0) {
-			struct file *f = do_filp_open(dfd, tmp, &op, lookup);
+			struct file *f = do_filp_open(dfd, tmp->name, &op, lookup);
 			if (IS_ERR(f)) {
 				put_unused_fd(fd);
 				fd = PTR_ERR(f);
diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 6f15578..1cf3f2a 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -315,11 +315,11 @@ static struct super_block *quotactl_block(const char __user *special, int cmd)
 #ifdef CONFIG_BLOCK
 	struct block_device *bdev;
 	struct super_block *sb;
-	char *tmp = getname(special);
+	struct getname_info *tmp = getname(special);
 
 	if (IS_ERR(tmp))
 		return ERR_CAST(tmp);
-	bdev = lookup_bdev(tmp);
+	bdev = lookup_bdev(tmp->name);
 	putname(tmp);
 	if (IS_ERR(bdev))
 		return ERR_CAST(bdev);
diff --git a/include/linux/audit.h b/include/linux/audit.h
index 0f7284a..d361921 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -459,6 +459,8 @@ extern int audit_classify_arch(int arch);
 #define AUDIT_TYPE_CHILD_CREATE 4	/* a child being created */
 
 #ifdef CONFIG_AUDITSYSCALL
+struct getname_info;
+
 /* These are defined in auditsc.c */
 				/* Public API */
 extern int  audit_alloc(struct task_struct *task);
@@ -467,8 +469,8 @@ extern void __audit_syscall_entry(int arch,
 				  int major, unsigned long a0, unsigned long a1,
 				  unsigned long a2, unsigned long a3);
 extern void __audit_syscall_exit(int ret_success, long ret_value);
-extern void __audit_getname(const char *name);
-extern void audit_putname(const char *name);
+extern void __audit_getname(struct getname_info *ginfo);
+extern void audit_putname(struct getname_info *ginfo);
 extern void __audit_inode(const char *name, const struct dentry *dentry,
 				unsigned int parent);
 extern void __audit_inode_child(const struct inode *parent,
@@ -503,7 +505,7 @@ static inline void audit_syscall_exit(void *pt_regs)
 		__audit_syscall_exit(success, return_code);
 	}
 }
-static inline void audit_getname(const char *name)
+static inline void audit_getname(struct getname_info *name)
 {
 	if (unlikely(!audit_dummy_context()))
 		__audit_getname(name);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b6ce6fc..1b0d0fb 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2189,6 +2189,10 @@ static inline int break_lease(struct inode *inode, unsigned int mode)
 #endif /* CONFIG_FILE_LOCKING */
 
 /* fs/open.c */
+struct getname_info {
+	const char *name;		/* pointer to actual string */
+	const __user char *uptr;	/* original userland pointer */
+};
 
 extern int do_truncate(struct dentry *, loff_t start, unsigned int time_attrs,
 		       struct file *filp);
@@ -2201,7 +2205,9 @@ extern struct file *file_open_root(struct dentry *, struct vfsmount *,
 				   const char *, int);
 extern struct file * dentry_open(const struct path *, int, const struct cred *);
 extern int filp_close(struct file *, fl_owner_t id);
-extern char * getname(const char __user *);
+
+extern struct getname_info *getname(const char __user *);
+
 enum {
 	FILE_CREATED = 1,
 	FILE_OPENED = 2
@@ -2221,12 +2227,14 @@ extern void __init vfs_caches_init(unsigned long);
 
 extern struct kmem_cache *names_cachep;
 
+extern void final_putname(struct getname_info *ginfo);
+
 #define __getname()		kmem_cache_alloc(names_cachep, GFP_KERNEL)
 #define __putname(name)		kmem_cache_free(names_cachep, (void *)(name))
 #ifndef CONFIG_AUDITSYSCALL
-#define putname(name)   __putname(name)
+#define putname(name)		final_putname(name)
 #else
-extern void putname(const char *name);
+extern void putname(struct getname_info *ginfo);
 #endif
 
 #ifdef CONFIG_BLOCK
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 69cb5fe..2071a27 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -773,7 +773,7 @@ SYSCALL_DEFINE4(mq_open, const char __user *, u_name, int, oflag, umode_t, mode,
 {
 	struct path path;
 	struct file *filp;
-	char *name;
+	struct getname_info *name;
 	struct mq_attr attr;
 	int fd, error;
 	struct ipc_namespace *ipc_ns = current->nsproxy->ipc_ns;
@@ -796,7 +796,7 @@ SYSCALL_DEFINE4(mq_open, const char __user *, u_name, int, oflag, umode_t, mode,
 	ro = mnt_want_write(mnt);	/* we'll drop it in any case */
 	error = 0;
 	mutex_lock(&root->d_inode->i_mutex);
-	path.dentry = lookup_one_len(name, root, strlen(name));
+	path.dentry = lookup_one_len(name->name, root, strlen(name->name));
 	if (IS_ERR(path.dentry)) {
 		error = PTR_ERR(path.dentry);
 		goto out_putfd;
@@ -805,7 +805,7 @@ SYSCALL_DEFINE4(mq_open, const char __user *, u_name, int, oflag, umode_t, mode,
 
 	if (oflag & O_CREAT) {
 		if (path.dentry->d_inode) {	/* entry already exists */
-			audit_inode(name, path.dentry, 0);
+			audit_inode(name->name, path.dentry, 0);
 			if (oflag & O_EXCL) {
 				error = -EEXIST;
 				goto out;
@@ -825,7 +825,7 @@ SYSCALL_DEFINE4(mq_open, const char __user *, u_name, int, oflag, umode_t, mode,
 			error = -ENOENT;
 			goto out;
 		}
-		audit_inode(name, path.dentry, 0);
+		audit_inode(name->name, path.dentry, 0);
 		filp = do_open(&path, oflag);
 	}
 
@@ -850,7 +850,7 @@ out_putname:
 SYSCALL_DEFINE1(mq_unlink, const char __user *, u_name)
 {
 	int err;
-	char *name;
+	struct getname_info *name;
 	struct dentry *dentry;
 	struct inode *inode = NULL;
 	struct ipc_namespace *ipc_ns = current->nsproxy->ipc_ns;
@@ -864,7 +864,8 @@ SYSCALL_DEFINE1(mq_unlink, const char __user *, u_name)
 	if (err)
 		goto out_name;
 	mutex_lock_nested(&mnt->mnt_root->d_inode->i_mutex, I_MUTEX_PARENT);
-	dentry = lookup_one_len(name, mnt->mnt_root, strlen(name));
+	dentry = lookup_one_len(name->name, mnt->mnt_root,
+				strlen(name->name));
 	if (IS_ERR(dentry)) {
 		err = PTR_ERR(dentry);
 		goto out_unlock;
diff --git a/kernel/acct.c b/kernel/acct.c
index e97d159..3943608 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -260,10 +260,10 @@ SYSCALL_DEFINE1(acct, const char __user *, name)
 		return -EPERM;
 
 	if (name) {
-		char *tmp = getname(name);
+		struct getname_info *tmp = getname(name);
 		if (IS_ERR(tmp))
 			return (PTR_ERR(tmp));
-		error = acct_on(tmp);
+		error = acct_on(tmp->name);
 		putname(tmp);
 	} else {
 		struct bsd_acct_struct *acct;
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 2f20b97..0ba346b 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -103,28 +103,29 @@ struct audit_cap_data {
  * we don't let putname() free it (instead we free all of the saved
  * pointers at syscall exit time).
  *
- * Further, in fs/namei.c:path_lookup() we store the inode and device. */
+ * Further, in fs/namei.c:path_lookup() we store the inode and device.
+ */
 struct audit_names {
-	struct list_head list;		/* audit_context->names_list */
-	const char	*name;
-	unsigned long	ino;
-	dev_t		dev;
-	umode_t		mode;
-	uid_t		uid;
-	gid_t		gid;
-	dev_t		rdev;
-	u32		osid;
-	struct audit_cap_data fcap;
-	unsigned int	fcap_ver;
-	int		name_len;	/* number of name's characters to log */
-	unsigned char	type;		/* record type */
-	bool		name_put;	/* call __putname() for this name */
+	struct list_head	list;		/* audit_context->names_list */
+	struct getname_info	*ginfo;
+	unsigned long		ino;
+	dev_t			dev;
+	umode_t			mode;
+	uid_t			uid;
+	gid_t			gid;
+	dev_t			rdev;
+	u32			osid;
+	struct audit_cap_data 	fcap;
+	unsigned int		fcap_ver;
+	int			name_len;	/* nr of characters to log */
+	unsigned char		type;		/* record type */
+	bool			name_put;	/* call final_putname() */
 	/*
 	 * This was an allocated audit_names and not from the array of
 	 * names allocated in the task audit context.  Thus this name
 	 * should be freed on syscall exit
 	 */
-	bool		should_free;
+	bool			should_free;
 };
 
 struct audit_aux_data {
@@ -1004,7 +1005,7 @@ static inline void audit_free_names(struct audit_context *context)
 		       context->ino_count);
 		list_for_each_entry(n, &context->names_list, list) {
 			printk(KERN_ERR "names[%d] = %p = %s\n", i,
-			       n->name, n->name ?: "(null)");
+			       n->ginfo, n->ginfo->name ?: "(null)");
 		}
 		dump_stack();
 		return;
@@ -1017,8 +1018,8 @@ static inline void audit_free_names(struct audit_context *context)
 
 	list_for_each_entry_safe(n, next, &context->names_list, list) {
 		list_del(&n->list);
-		if (n->name && n->name_put)
-			__putname(n->name);
+		if (n->ginfo && n->name_put)
+			__putname(n->ginfo);
 		if (n->should_free)
 			kfree(n);
 	}
@@ -1529,12 +1530,12 @@ static void audit_log_name(struct audit_context *context, struct audit_names *n,
 
 	audit_log_format(ab, "item=%d", record_num);
 
-	if (n->name) {
+	if (n->ginfo) {
 		switch (n->name_len) {
 		case AUDIT_NAME_FULL:
 			/* log the full path */
 			audit_log_format(ab, " name=");
-			audit_log_untrustedstring(ab, n->name);
+			audit_log_untrustedstring(ab, n->ginfo->name);
 			break;
 		case 0:
 			/* name was specified as a relative path and the
@@ -1544,7 +1545,7 @@ static void audit_log_name(struct audit_context *context, struct audit_names *n,
 		default:
 			/* log the name's directory component */
 			audit_log_format(ab, " name=");
-			audit_log_n_untrustedstring(ab, n->name,
+			audit_log_n_untrustedstring(ab, n->ginfo->name,
 						    n->name_len);
 		}
 	} else
@@ -2040,7 +2041,7 @@ static struct audit_names *audit_alloc_name(struct audit_context *context,
  * Add a name to the list of audit names for this context.
  * Called from fs/namei.c:getname().
  */
-void __audit_getname(const char *name)
+void __audit_getname(struct getname_info *ginfo)
 {
 	struct audit_context *context = current->audit_context;
 	struct audit_names *n;
@@ -2048,17 +2049,22 @@ void __audit_getname(const char *name)
 	if (!context->in_syscall) {
 #if AUDIT_DEBUG == 2
 		printk(KERN_ERR "%s:%d(:%d): ignoring getname(%p)\n",
-		       __FILE__, __LINE__, context->serial, name);
+		       __FILE__, __LINE__, context->serial, ginfo);
 		dump_stack();
 #endif
 		return;
 	}
 
+#if AUDIT_DEBUG
+	/* The getname_info _must_ have a populated ->name */
+	BUG_ON(!ginfo->name);
+#endif
+
 	n = audit_alloc_name(context, AUDIT_TYPE_UNKNOWN);
 	if (!n)
 		return;
 
-	n->name = name;
+	n->ginfo = ginfo;
 	n->name_len = AUDIT_NAME_FULL;
 	n->name_put = true;
 
@@ -2073,7 +2079,7 @@ void __audit_getname(const char *name)
  * then we delay the putname until syscall exit.
  * Called from include/linux/fs.h:putname().
  */
-void audit_putname(const char *name)
+void audit_putname(struct getname_info *ginfo)
 {
 	struct audit_context *context = current->audit_context;
 
@@ -2081,17 +2087,17 @@ void audit_putname(const char *name)
 	if (!context->in_syscall) {
 #if AUDIT_DEBUG == 2
 		printk(KERN_ERR "%s:%d(:%d): __putname(%p)\n",
-		       __FILE__, __LINE__, context->serial, name);
+		       __FILE__, __LINE__, context->serial, ginfo);
 		if (context->name_count) {
 			struct audit_names *n;
 			int i;
 
 			list_for_each_entry(n, &context->names_list, list)
 				printk(KERN_ERR "name[%d] = %p = %s\n", i,
-				       n->name, n->name ?: "(null)");
+				       n->ginfo, n->ginfo->name ?: "(null)");
 			}
 #endif
-		__putname(name);
+		__putname(ginfo);
 	}
 #if AUDIT_DEBUG
 	else {
@@ -2102,8 +2108,8 @@ void audit_putname(const char *name)
 			       " put_count=%d\n",
 			       __FILE__, __LINE__,
 			       context->serial, context->major,
-			       context->in_syscall, name, context->name_count,
-			       context->put_count);
+			       context->in_syscall, ginfo->name,
+			       context->name_count, context->put_count);
 			dump_stack();
 		}
 	}
@@ -2166,7 +2172,7 @@ void __audit_inode(const char *name, const struct dentry *dentry,
 
 	list_for_each_entry_reverse(n, &context->names_list, list) {
 		/* does the name pointer match? */
-		if (n->name != name)
+		if (!n->ginfo || n->ginfo->name != name)
 			continue;
 
 		/* match the correct record type */
@@ -2189,7 +2195,7 @@ out_alloc:
 		return;
 out:
 	if (parent) {
-		n->name_len = n->name ? parent_len(n->name) : AUDIT_NAME_FULL;
+		n->name_len = n->ginfo ? parent_len(n->ginfo->name) : AUDIT_NAME_FULL;
 		n->type = AUDIT_TYPE_PARENT;
 	} else {
 		n->name_len = AUDIT_NAME_FULL;
@@ -2230,11 +2236,11 @@ void __audit_inode_child(const struct inode *parent,
 
 	/* look for a parent entry first */
 	list_for_each_entry(n, &context->names_list, list) {
-		if (!n->name || n->type != AUDIT_TYPE_PARENT)
+		if (!n->ginfo || n->type != AUDIT_TYPE_PARENT)
 			continue;
 
 		if (n->ino == parent->i_ino &&
-		    !audit_compare_dname_path(dname, n->name, n->name_len)) {
+		    !audit_compare_dname_path(dname, n->ginfo->name, n->name_len)) {
 			found_parent = n;
 			break;
 		}
@@ -2243,15 +2249,15 @@ void __audit_inode_child(const struct inode *parent,
 	/* is there a matching child entry? */
 	list_for_each_entry(n, &context->names_list, list) {
 		/* can only match entries that have a name */
-		if (!n->name || n->type != type)
+		if (!n->ginfo || n->type != type)
 			continue;
 
 		/* if we found a parent, make sure this one is a child of it */
-		if (found_parent && (n->name != found_parent->name))
+		if (found_parent && (n->ginfo != found_parent->ginfo))
 			continue;
 
-		if (!strcmp(dname, n->name) ||
-		    !audit_compare_dname_path(dname, n->name,
+		if (!strcmp(dname, n->ginfo->name) ||
+		    !audit_compare_dname_path(dname, n->ginfo->name,
 						found_parent ?
 						found_parent->name_len :
 						AUDIT_NAME_FULL)) {
@@ -2277,7 +2283,7 @@ void __audit_inode_child(const struct inode *parent,
 		 * directory. All names for this context are relinquished in
 		 * audit_free_names() */
 		if (found_parent) {
-			found_child->name = found_parent->name;
+			found_child->ginfo = found_parent->ginfo;
 			found_child->name_len = AUDIT_NAME_FULL;
 			/* don't call __putname() */
 			found_child->name_put = false;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 14e254c..8dbf46d 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1483,7 +1483,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	struct file *swap_file, *victim;
 	struct address_space *mapping;
 	struct inode *inode;
-	char *pathname;
+	struct getname_info *pathname;
 	int oom_score_adj;
 	int i, type, prev;
 	int err;
@@ -1498,8 +1498,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	if (IS_ERR(pathname))
 		goto out;
 
-	victim = filp_open(pathname, O_RDWR|O_LARGEFILE, 0);
-	putname(pathname);
+	victim = filp_open(pathname->name, O_RDWR|O_LARGEFILE, 0);
 	err = PTR_ERR(victim);
 	if (IS_ERR(victim))
 		goto out;
@@ -1936,7 +1935,7 @@ static int setup_swap_map_and_extents(struct swap_info_struct *p,
 SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 {
 	struct swap_info_struct *p;
-	char *name;
+	struct getname_info *name;
 	struct file *swap_file = NULL;
 	struct address_space *mapping;
 	int i;
@@ -1967,7 +1966,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		name = NULL;
 		goto bad_swap;
 	}
-	swap_file = filp_open(name, O_RDWR|O_LARGEFILE, 0);
+	swap_file = filp_open(name->name, O_RDWR|O_LARGEFILE, 0);
 	if (IS_ERR(swap_file)) {
 		error = PTR_ERR(swap_file);
 		swap_file = NULL;
@@ -2053,7 +2052,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 
 	printk(KERN_INFO "Adding %uk swap on %s.  "
 			"Priority:%d extents:%d across:%lluk %s%s%s\n",
-		p->pages<<(PAGE_SHIFT-10), name, p->prio,
+		p->pages<<(PAGE_SHIFT-10), name->name, p->prio,
 		nr_extents, (unsigned long long)span<<(PAGE_SHIFT-10),
 		(p->flags & SWP_SOLIDSTATE) ? "SS" : "",
 		(p->flags & SWP_DISCARDABLE) ? "D" : "",
-- 
1.7.11.4

