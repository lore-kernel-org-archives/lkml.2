Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813Ab0HQWyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 18:54:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230Ab0HQWyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 18:54:31 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Make do_execve() take a const filename pointer
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: ralf@linux-mips.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Date: Tue, 17 Aug 2010 23:52:56 +0100
Message-ID: <20100817225256.4775.6641.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make do_execve() take a const filename pointer so that kernel_execve() compiles
correctly on ARM:

arch/arm/kernel/sys_arm.c:88: warning: passing argument 1 of 'do_execve' discards qualifiers from pointer target type

This also requires the argv and envp arguments to be consted twice, once for
the pointer array and once for the strings the array points to.  This is
because do_execve() passes a pointer to the filename (now const) to
copy_strings_kernel().  A simpler alternative would be to cast the filename
pointer in do_execve() when it's passed to copy_strings_kernel().

do_execve() may not change any of the strings it is passed as part of the argv
or envp lists as they are some of them in .rodata, so marking these strings as
const should be fine.

Further kernel_execve() and sys_execve() need to be changed to match.

This has been test built on x86_64, frv, arm and mips.

Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Ralf Baechle <ralf@linux-mips.org>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
---

 arch/alpha/kernel/process.c             |    5 +++--
 arch/arm/kernel/sys_arm.c               |   14 +++++++++-----
 arch/avr32/kernel/process.c             |    5 +++--
 arch/avr32/kernel/sys_avr32.c           |    4 +++-
 arch/blackfin/kernel/process.c          |    4 +++-
 arch/cris/arch-v10/kernel/process.c     |    4 +++-
 arch/cris/arch-v32/kernel/process.c     |    6 ++++--
 arch/frv/kernel/process.c               |    5 +++--
 arch/h8300/kernel/process.c             |    5 ++++-
 arch/h8300/kernel/sys_h8300.c           |    4 +++-
 arch/ia64/kernel/process.c              |    4 +++-
 arch/m32r/kernel/process.c              |    4 ++--
 arch/m32r/kernel/sys_m32r.c             |    4 +++-
 arch/m68k/kernel/process.c              |    4 +++-
 arch/m68k/kernel/sys_m68k.c             |    4 +++-
 arch/m68knommu/kernel/process.c         |    4 +++-
 arch/m68knommu/kernel/sys_m68k.c        |    4 +++-
 arch/microblaze/kernel/sys_microblaze.c |   10 +++++++---
 arch/mips/kernel/syscall.c              |   10 +++++++---
 arch/mn10300/kernel/process.c           |    4 ++--
 arch/parisc/hpux/fs.c                   |    6 ++++--
 arch/parisc/kernel/process.c            |   15 ++++++++++-----
 arch/powerpc/kernel/process.c           |    5 +++--
 arch/s390/kernel/process.c              |    5 +++--
 arch/score/kernel/sys_score.c           |   10 +++++++---
 arch/sh/kernel/process_32.c             |    7 ++++---
 arch/sh/kernel/process_64.c             |    4 ++--
 arch/sh/kernel/sys_sh32.c               |    4 +++-
 arch/sh/kernel/sys_sh64.c               |    4 +++-
 arch/sparc/kernel/process_32.c          |    6 ++++--
 arch/sparc/kernel/process_64.c          |    4 ++--
 arch/sparc/kernel/sys_sparc_32.c        |    4 +++-
 arch/sparc/kernel/sys_sparc_64.c        |    4 +++-
 arch/tile/kernel/process.c              |    5 +++--
 arch/um/kernel/exec.c                   |    5 +++--
 arch/um/kernel/syscall.c                |    4 +++-
 arch/x86/include/asm/syscalls.h         |    5 +++--
 arch/x86/kernel/process.c               |    5 +++--
 arch/x86/kernel/sys_i386_32.c           |    4 +++-
 arch/xtensa/kernel/process.c            |    5 +++--
 fs/binfmt_misc.c                        |    2 +-
 fs/binfmt_script.c                      |    3 ++-
 fs/exec.c                               |   21 +++++++++++----------
 include/linux/binfmts.h                 |    7 ++++---
 include/linux/sched.h                   |    4 +++-
 include/linux/syscalls.h                |    2 +-
 init/do_mounts_initrd.c                 |    7 ++++---
 init/main.c                             |    6 +++---
 kernel/kmod.c                           |    4 +++-
 security/commoncap.c                    |    2 +-
 50 files changed, 179 insertions(+), 98 deletions(-)

diff --git a/arch/alpha/kernel/process.c b/arch/alpha/kernel/process.c
index 88e608a..842dba3 100644
--- a/arch/alpha/kernel/process.c
+++ b/arch/alpha/kernel/process.c
@@ -387,8 +387,9 @@ EXPORT_SYMBOL(dump_elf_task_fp);
  * sys_execve() executes a new program.
  */
 asmlinkage int
-do_sys_execve(const char __user *ufilename, char __user * __user *argv,
-	      char __user * __user *envp, struct pt_regs *regs)
+do_sys_execve(const char __user *ufilename,
+	      const char __user *const __user *argv,
+	      const char __user *const __user *envp, struct pt_regs *regs)
 {
 	int error;
 	char *filename;
diff --git a/arch/arm/kernel/sys_arm.c b/arch/arm/kernel/sys_arm.c
index 5b7c541..62e7c61 100644
--- a/arch/arm/kernel/sys_arm.c
+++ b/arch/arm/kernel/sys_arm.c
@@ -62,8 +62,9 @@ asmlinkage int sys_vfork(struct pt_regs *regs)
 /* sys_execve() executes a new program.
  * This is called indirectly via a small wrapper
  */
-asmlinkage int sys_execve(const char __user *filenamei, char __user * __user *argv,
-			  char __user * __user *envp, struct pt_regs *regs)
+asmlinkage int sys_execve(const char __user *filenamei,
+			  const char __user *const __user *argv,
+			  const char __user *const __user *envp, struct pt_regs *regs)
 {
 	int error;
 	char * filename;
@@ -78,14 +79,17 @@ out:
 	return error;
 }
 
-int kernel_execve(const char *filename, char *const argv[], char *const envp[])
+int kernel_execve(const char *filename,
+		  const char *const argv[],
+		  const char *const envp[])
 {
 	struct pt_regs regs;
 	int ret;
 
 	memset(&regs, 0, sizeof(struct pt_regs));
-	ret = do_execve(filename, (char __user * __user *)argv,
-			(char __user * __user *)envp, &regs);
+	ret = do_execve(filename,
+			(const char __user *const __user *)argv,
+			(const char __user *const __user *)envp, &regs);
 	if (ret < 0)
 		goto out;
 
diff --git a/arch/avr32/kernel/process.c b/arch/avr32/kernel/process.c
index e5daddf..9c46aaa 100644
--- a/arch/avr32/kernel/process.c
+++ b/arch/avr32/kernel/process.c
@@ -384,8 +384,9 @@ asmlinkage int sys_vfork(struct pt_regs *regs)
 }
 
 asmlinkage int sys_execve(const char __user *ufilename,
-			  char __user *__user *uargv,
-			  char __user *__user *uenvp, struct pt_regs *regs)
+			  const char __user *const __user *uargv,
+			  const char __user *const __user *uenvp,
+			  struct pt_regs *regs)
 {
 	int error;
 	char *filename;
diff --git a/arch/avr32/kernel/sys_avr32.c b/arch/avr32/kernel/sys_avr32.c
index 459349b..62635a0 100644
--- a/arch/avr32/kernel/sys_avr32.c
+++ b/arch/avr32/kernel/sys_avr32.c
@@ -7,7 +7,9 @@
  */
 #include <linux/unistd.h>
 
-int kernel_execve(const char *file, char **argv, char **envp)
+int kernel_execve(const char *file,
+		  const char *const *argv,
+		  const char *const *envp)
 {
 	register long scno asm("r8") = __NR_execve;
 	register long sc1 asm("r12") = (long)file;
diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
index a566f61..01f98cb 100644
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -209,7 +209,9 @@ copy_thread(unsigned long clone_flags,
 /*
  * sys_execve() executes a new program.
  */
-asmlinkage int sys_execve(const char __user *name, char __user * __user *argv, char __user * __user *envp)
+asmlinkage int sys_execve(const char __user *name,
+			  const char __user *const __user *argv,
+			  const char __user *const __user *envp)
 {
 	int error;
 	char *filename;
diff --git a/arch/cris/arch-v10/kernel/process.c b/arch/cris/arch-v10/kernel/process.c
index 93f0f64..9a57db6 100644
--- a/arch/cris/arch-v10/kernel/process.c
+++ b/arch/cris/arch-v10/kernel/process.c
@@ -204,7 +204,9 @@ asmlinkage int sys_vfork(long r10, long r11, long r12, long r13, long mof, long
 /*
  * sys_execve() executes a new program.
  */
-asmlinkage int sys_execve(const char *fname, char **argv, char **envp,
+asmlinkage int sys_execve(const char *fname,
+			  const char *const *argv,
+			  const char *const *envp,
 			  long r13, long mof, long srp, 
 			  struct pt_regs *regs)
 {
diff --git a/arch/cris/arch-v32/kernel/process.c b/arch/cris/arch-v32/kernel/process.c
index 2661a95..562f847 100644
--- a/arch/cris/arch-v32/kernel/process.c
+++ b/arch/cris/arch-v32/kernel/process.c
@@ -218,8 +218,10 @@ sys_vfork(long r10, long r11, long r12, long r13, long mof, long srp,
 
 /* sys_execve() executes a new program. */
 asmlinkage int
-sys_execve(const char *fname, char **argv, char **envp, long r13, long mof, long srp,
-	struct pt_regs *regs)
+sys_execve(const char *fname,
+	   const char *const *argv,
+	   const char *const *envp, long r13, long mof, long srp,
+	   struct pt_regs *regs)
 {
 	int error;
 	char *filename;
diff --git a/arch/frv/kernel/process.c b/arch/frv/kernel/process.c
index 428931c..2b63b01 100644
--- a/arch/frv/kernel/process.c
+++ b/arch/frv/kernel/process.c
@@ -250,8 +250,9 @@ int copy_thread(unsigned long clone_flags,
 /*
  * sys_execve() executes a new program.
  */
-asmlinkage int sys_execve(const char __user *name, char __user * __user *argv,
-			  char __user * __user *envp)
+asmlinkage int sys_execve(const char __user *name,
+			  const char __user *const __user *argv,
+			  const char __user *const __user *envp)
 {
 	int error;
 	char * filename;
diff --git a/arch/h8300/kernel/process.c b/arch/h8300/kernel/process.c
index 8b7b78d..9747813 100644
--- a/arch/h8300/kernel/process.c
+++ b/arch/h8300/kernel/process.c
@@ -212,7 +212,10 @@ int copy_thread(unsigned long clone_flags,
 /*
  * sys_execve() executes a new program.
  */
-asmlinkage int sys_execve(const char *name, char **argv, char **envp,int dummy,...)
+asmlinkage int sys_execve(const char *name,
+			  const char *const *argv,
+			  const char *const *envp,
+			  int dummy, ...)
 {
 	int error;
 	char * filename;
diff --git a/arch/h8300/kernel/sys_h8300.c b/arch/h8300/kernel/sys_h8300.c
index f9b3f44..dc1ac02 100644
--- a/arch/h8300/kernel/sys_h8300.c
+++ b/arch/h8300/kernel/sys_h8300.c
@@ -51,7 +51,9 @@ asmlinkage void syscall_print(void *dummy,...)
  * Do a system call from kernel instead of calling sys_execve so we
  * end up with proper pt_regs.
  */
-int kernel_execve(const char *filename, char *const argv[], char *const envp[])
+int kernel_execve(const char *filename,
+		  const char *const argv[],
+		  const char *const envp[])
 {
 	register long res __asm__("er0");
 	register char *const *_c __asm__("er3") = envp;
diff --git a/arch/ia64/kernel/process.c b/arch/ia64/kernel/process.c
index a879c03..16f1c7b 100644
--- a/arch/ia64/kernel/process.c
+++ b/arch/ia64/kernel/process.c
@@ -633,7 +633,9 @@ dump_fpu (struct pt_regs *pt, elf_fpregset_t dst)
 }
 
 long
-sys_execve (const char __user *filename, char __user * __user *argv, char __user * __user *envp,
+sys_execve (const char __user *filename,
+	    const char __user *const __user *argv,
+	    const char __user *const __user *envp,
 	    struct pt_regs *regs)
 {
 	char *fname;
diff --git a/arch/m32r/kernel/process.c b/arch/m32r/kernel/process.c
index 8665a4d..422bea9 100644
--- a/arch/m32r/kernel/process.c
+++ b/arch/m32r/kernel/process.c
@@ -289,8 +289,8 @@ asmlinkage int sys_vfork(unsigned long r0, unsigned long r1, unsigned long r2,
  * sys_execve() executes a new program.
  */
 asmlinkage int sys_execve(const char __user *ufilename,
-			  char __user * __user *uargv,
-			  char __user * __user *uenvp,
+			  const char __user *const __user *uargv,
+			  const char __user *const __user *uenvp,
 			  unsigned long r3, unsigned long r4, unsigned long r5,
 			  unsigned long r6, struct pt_regs regs)
 {
diff --git a/arch/m32r/kernel/sys_m32r.c b/arch/m32r/kernel/sys_m32r.c
index 0a00f46..d841fb6 100644
--- a/arch/m32r/kernel/sys_m32r.c
+++ b/arch/m32r/kernel/sys_m32r.c
@@ -93,7 +93,9 @@ asmlinkage int sys_cachectl(char *addr, int nbytes, int op)
  * Do a system call from kernel instead of calling sys_execve so we
  * end up with proper pt_regs.
  */
-int kernel_execve(const char *filename, char *const argv[], char *const envp[])
+int kernel_execve(const char *filename,
+		  const char *const argv[],
+		  const char *const envp[])
 {
 	register long __scno __asm__ ("r7") = __NR_execve;
 	register long __arg3 __asm__ ("r2") = (long)(envp);
diff --git a/arch/m68k/kernel/process.c b/arch/m68k/kernel/process.c
index 221d0b7..18732ab 100644
--- a/arch/m68k/kernel/process.c
+++ b/arch/m68k/kernel/process.c
@@ -315,7 +315,9 @@ EXPORT_SYMBOL(dump_fpu);
 /*
  * sys_execve() executes a new program.
  */
-asmlinkage int sys_execve(const char __user *name, char __user * __user *argv, char __user * __user *envp)
+asmlinkage int sys_execve(const char __user *name,
+			  const char __user *const __user *argv,
+			  const char __user *const __user *envp)
 {
 	int error;
 	char * filename;
diff --git a/arch/m68k/kernel/sys_m68k.c b/arch/m68k/kernel/sys_m68k.c
index 7789669..2f431ec 100644
--- a/arch/m68k/kernel/sys_m68k.c
+++ b/arch/m68k/kernel/sys_m68k.c
@@ -459,7 +459,9 @@ asmlinkage int sys_getpagesize(void)
  * Do a system call from kernel instead of calling sys_execve so we
  * end up with proper pt_regs.
  */
-int kernel_execve(const char *filename, char *const argv[], char *const envp[])
+int kernel_execve(const char *filename,
+		  const char *const argv[],
+		  const char *const envp[])
 {
 	register long __res asm ("%d0") = __NR_execve;
 	register long __a asm ("%d1") = (long)(filename);
diff --git a/arch/m68knommu/kernel/process.c b/arch/m68knommu/kernel/process.c
index 6350f68..4d090d3 100644
--- a/arch/m68knommu/kernel/process.c
+++ b/arch/m68knommu/kernel/process.c
@@ -350,7 +350,9 @@ void dump(struct pt_regs *fp)
 /*
  * sys_execve() executes a new program.
  */
-asmlinkage int sys_execve(const char *name, char **argv, char **envp)
+asmlinkage int sys_execve(const char *name,
+			  const char *const *argv,
+			  const char *const *envp)
 {
 	int error;
 	char * filename;
diff --git a/arch/m68knommu/kernel/sys_m68k.c b/arch/m68knommu/kernel/sys_m68k.c
index d65e9c4..68488ae 100644
--- a/arch/m68knommu/kernel/sys_m68k.c
+++ b/arch/m68knommu/kernel/sys_m68k.c
@@ -44,7 +44,9 @@ asmlinkage int sys_getpagesize(void)
  * Do a system call from kernel instead of calling sys_execve so we
  * end up with proper pt_regs.
  */
-int kernel_execve(const char *filename, char *const argv[], char *const envp[])
+int kernel_execve(const char *filename,
+		  const char *const argv[],
+		  const char *const envp[])
 {
 	register long __res asm ("%d0") = __NR_execve;
 	register long __a asm ("%d1") = (long)(filename);
diff --git a/arch/microblaze/kernel/sys_microblaze.c b/arch/microblaze/kernel/sys_microblaze.c
index 6abab6e..2250fe9 100644
--- a/arch/microblaze/kernel/sys_microblaze.c
+++ b/arch/microblaze/kernel/sys_microblaze.c
@@ -47,8 +47,10 @@ asmlinkage long microblaze_clone(int flags, unsigned long stack, struct pt_regs
 	return do_fork(flags, stack, regs, 0, NULL, NULL);
 }
 
-asmlinkage long microblaze_execve(const char __user *filenamei, char __user *__user *argv,
-			char __user *__user *envp, struct pt_regs *regs)
+asmlinkage long microblaze_execve(const char __user *filenamei,
+				  const char __user *const __user *argv,
+				  const char __user *const __user *envp,
+				  struct pt_regs *regs)
 {
 	int error;
 	char *filename;
@@ -77,7 +79,9 @@ asmlinkage long sys_mmap(unsigned long addr, unsigned long len,
  * Do a system call from kernel instead of calling sys_execve so we
  * end up with proper pt_regs.
  */
-int kernel_execve(const char *filename, char *const argv[], char *const envp[])
+int kernel_execve(const char *filename,
+		  const char *const argv[],
+		  const char *const envp[])
 {
 	register const char *__a __asm__("r5") = filename;
 	register const void *__b __asm__("r6") = argv;
diff --git a/arch/mips/kernel/syscall.c b/arch/mips/kernel/syscall.c
index bddce0b..1dc6edf 100644
--- a/arch/mips/kernel/syscall.c
+++ b/arch/mips/kernel/syscall.c
@@ -258,8 +258,10 @@ asmlinkage int sys_execve(nabi_no_regargs struct pt_regs regs)
 	error = PTR_ERR(filename);
 	if (IS_ERR(filename))
 		goto out;
-	error = do_execve(filename, (char __user *__user *) (long)regs.regs[5],
-	                  (char __user *__user *) (long)regs.regs[6], &regs);
+	error = do_execve(filename,
+			  (const char __user *const __user *) (long)regs.regs[5],
+	                  (const char __user *const __user *) (long)regs.regs[6],
+			  &regs);
 	putname(filename);
 
 out:
@@ -436,7 +438,9 @@ asmlinkage void bad_stack(void)
  * Do a system call from kernel instead of calling sys_execve so we
  * end up with proper pt_regs.
  */
-int kernel_execve(const char *filename, char *const argv[], char *const envp[])
+int kernel_execve(const char *filename,
+		  const char *const argv[],
+		  const char *const envp[])
 {
 	register unsigned long __a0 asm("$4") = (unsigned long) filename;
 	register unsigned long __a1 asm("$5") = (unsigned long) argv;
diff --git a/arch/mn10300/kernel/process.c b/arch/mn10300/kernel/process.c
index 762eb32..f48373e 100644
--- a/arch/mn10300/kernel/process.c
+++ b/arch/mn10300/kernel/process.c
@@ -269,8 +269,8 @@ asmlinkage long sys_vfork(void)
 }
 
 asmlinkage long sys_execve(const char __user *name,
-			   char __user * __user *argv,
-			   char __user * __user *envp)
+			   const char __user *const __user *argv,
+			   const char __user *const __user *envp)
 {
 	char *filename;
 	int error;
diff --git a/arch/parisc/hpux/fs.c b/arch/parisc/hpux/fs.c
index 1444875..0dc8543 100644
--- a/arch/parisc/hpux/fs.c
+++ b/arch/parisc/hpux/fs.c
@@ -41,8 +41,10 @@ int hpux_execve(struct pt_regs *regs)
 	if (IS_ERR(filename))
 		goto out;
 
-	error = do_execve(filename, (char __user * __user *) regs->gr[25],
-		(char __user * __user *) regs->gr[24], regs);
+	error = do_execve(filename,
+			  (const char __user *const __user *) regs->gr[25],
+			  (const char __user *const __user *) regs->gr[24],
+			  regs);
 
 	putname(filename);
 
diff --git a/arch/parisc/kernel/process.c b/arch/parisc/kernel/process.c
index 76332da..4b4b918 100644
--- a/arch/parisc/kernel/process.c
+++ b/arch/parisc/kernel/process.c
@@ -348,17 +348,22 @@ asmlinkage int sys_execve(struct pt_regs *regs)
 	error = PTR_ERR(filename);
 	if (IS_ERR(filename))
 		goto out;
-	error = do_execve(filename, (char __user * __user *) regs->gr[25],
-		(char __user * __user *) regs->gr[24], regs);
+	error = do_execve(filename,
+			  (const char __user *const __user *) regs->gr[25],
+			  (const char __user *const __user *) regs->gr[24],
+			  regs);
 	putname(filename);
 out:
 
 	return error;
 }
 
-extern int __execve(const char *filename, char *const argv[],
-		char *const envp[], struct task_struct *task);
-int kernel_execve(const char *filename, char *const argv[], char *const envp[])
+extern int __execve(const char *filename,
+		    const char *const argv[],
+		    const char *const envp[], struct task_struct *task);
+int kernel_execve(const char *filename,
+		  const char *const argv[],
+		  const char *const envp[])
 {
 	return __execve(filename, argv, envp, current);
 }
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index feacfb7..91356ff 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -1034,8 +1034,9 @@ int sys_execve(unsigned long a0, unsigned long a1, unsigned long a2,
 	flush_fp_to_thread(current);
 	flush_altivec_to_thread(current);
 	flush_spe_to_thread(current);
-	error = do_execve(filename, (char __user * __user *) a1,
-			  (char __user * __user *) a2, regs);
+	error = do_execve(filename,
+			  (const char __user *const __user *) a1,
+			  (const char __user *const __user *) a2, regs);
 	putname(filename);
 out:
 	return error;
diff --git a/arch/s390/kernel/process.c b/arch/s390/kernel/process.c
index 7eafaf2..d3a2d1c 100644
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -267,8 +267,9 @@ asmlinkage void execve_tail(void)
 /*
  * sys_execve() executes a new program.
  */
-SYSCALL_DEFINE3(execve, const char __user *, name, char __user * __user *, argv,
-		char __user * __user *, envp)
+SYSCALL_DEFINE3(execve, const char __user *, name,
+		const char __user *const __user *, argv,
+		const char __user *const __user *, envp)
 {
 	struct pt_regs *regs = task_pt_regs(current);
 	char *filename;
diff --git a/arch/score/kernel/sys_score.c b/arch/score/kernel/sys_score.c
index 651096f..e478bf9 100644
--- a/arch/score/kernel/sys_score.c
+++ b/arch/score/kernel/sys_score.c
@@ -99,8 +99,10 @@ score_execve(struct pt_regs *regs)
 	if (IS_ERR(filename))
 		return error;
 
-	error = do_execve(filename, (char __user *__user*)regs->regs[5],
-			  (char __user *__user *) regs->regs[6], regs);
+	error = do_execve(filename,
+			  (const char __user *const __user *)regs->regs[5],
+			  (const char __user *const __user *)regs->regs[6],
+			  regs);
 
 	putname(filename);
 	return error;
@@ -110,7 +112,9 @@ score_execve(struct pt_regs *regs)
  * Do a system call from kernel instead of calling sys_execve so we
  * end up with proper pt_regs.
  */
-int kernel_execve(const char *filename, char *const argv[], char *const envp[])
+int kernel_execve(const char *filename,
+		  const char *const argv[],
+		  const char *const envp[])
 {
 	register unsigned long __r4 asm("r4") = (unsigned long) filename;
 	register unsigned long __r5 asm("r5") = (unsigned long) argv;
diff --git a/arch/sh/kernel/process_32.c b/arch/sh/kernel/process_32.c
index 0529819..762a139 100644
--- a/arch/sh/kernel/process_32.c
+++ b/arch/sh/kernel/process_32.c
@@ -296,9 +296,10 @@ asmlinkage int sys_vfork(unsigned long r4, unsigned long r5,
 /*
  * sys_execve() executes a new program.
  */
-asmlinkage int sys_execve(char __user *ufilename, char __user * __user *uargv,
-			  char __user * __user *uenvp, unsigned long r7,
-			  struct pt_regs __regs)
+asmlinkage int sys_execve(const char __user *ufilename,
+			  const char __user *const __user *uargv,
+			  const char __user *const __user *uenvp,
+			  unsigned long r7, struct pt_regs __regs)
 {
 	struct pt_regs *regs = RELOC_HIDE(&__regs, 0);
 	int error;
diff --git a/arch/sh/kernel/process_64.c b/arch/sh/kernel/process_64.c
index 68d128d..210c1ca 100644
--- a/arch/sh/kernel/process_64.c
+++ b/arch/sh/kernel/process_64.c
@@ -497,8 +497,8 @@ asmlinkage int sys_execve(const char *ufilename, char **uargv,
 		goto out;
 
 	error = do_execve(filename,
-			  (char __user * __user *)uargv,
-			  (char __user * __user *)uenvp,
+			  (const char __user *const __user *)uargv,
+			  (const char __user *const __user *)uenvp,
 			  pregs);
 	putname(filename);
 out:
diff --git a/arch/sh/kernel/sys_sh32.c b/arch/sh/kernel/sys_sh32.c
index eb68bfd..f56b6fe5 100644
--- a/arch/sh/kernel/sys_sh32.c
+++ b/arch/sh/kernel/sys_sh32.c
@@ -71,7 +71,9 @@ asmlinkage int sys_fadvise64_64_wrapper(int fd, u32 offset0, u32 offset1,
  * Do a system call from kernel instead of calling sys_execve so we
  * end up with proper pt_regs.
  */
-int kernel_execve(const char *filename, char *const argv[], char *const envp[])
+int kernel_execve(const char *filename,
+		  const char *const argv[],
+		  const char *const envp[])
 {
 	register long __sc0 __asm__ ("r3") = __NR_execve;
 	register long __sc4 __asm__ ("r4") = (long) filename;
diff --git a/arch/sh/kernel/sys_sh64.c b/arch/sh/kernel/sys_sh64.c
index 2872357..c5a38c4 100644
--- a/arch/sh/kernel/sys_sh64.c
+++ b/arch/sh/kernel/sys_sh64.c
@@ -33,7 +33,9 @@
  * Do a system call from kernel instead of calling sys_execve so we
  * end up with proper pt_regs.
  */
-int kernel_execve(const char *filename, char *const argv[], char *const envp[])
+int kernel_execve(const char *filename,
+		  const char *const argv[],
+		  const char *const envp[])
 {
 	register unsigned long __sc0 __asm__ ("r9") = ((0x13 << 16) | __NR_execve);
 	register unsigned long __sc2 __asm__ ("r2") = (unsigned long) filename;
diff --git a/arch/sparc/kernel/process_32.c b/arch/sparc/kernel/process_32.c
index 40e29fc..1752929 100644
--- a/arch/sparc/kernel/process_32.c
+++ b/arch/sparc/kernel/process_32.c
@@ -633,8 +633,10 @@ asmlinkage int sparc_execve(struct pt_regs *regs)
 	if(IS_ERR(filename))
 		goto out;
 	error = do_execve(filename,
-			  (char __user * __user *)regs->u_regs[base + UREG_I1],
-			  (char __user * __user *)regs->u_regs[base + UREG_I2],
+			  (const char __user *const  __user *)
+			  regs->u_regs[base + UREG_I1],
+			  (const char __user *const  __user *)
+			  regs->u_regs[base + UREG_I2],
 			  regs);
 	putname(filename);
 out:
diff --git a/arch/sparc/kernel/process_64.c b/arch/sparc/kernel/process_64.c
index dbe81a3..485f547 100644
--- a/arch/sparc/kernel/process_64.c
+++ b/arch/sparc/kernel/process_64.c
@@ -739,9 +739,9 @@ asmlinkage int sparc_execve(struct pt_regs *regs)
 	if (IS_ERR(filename))
 		goto out;
 	error = do_execve(filename,
-			  (char __user * __user *)
+			  (const char __user *const __user *)
 			  regs->u_regs[base + UREG_I1],
-			  (char __user * __user *)
+			  (const char __user *const __user *)
 			  regs->u_regs[base + UREG_I2], regs);
 	putname(filename);
 	if (!error) {
diff --git a/arch/sparc/kernel/sys_sparc_32.c b/arch/sparc/kernel/sys_sparc_32.c
index ee995b7..5079413 100644
--- a/arch/sparc/kernel/sys_sparc_32.c
+++ b/arch/sparc/kernel/sys_sparc_32.c
@@ -282,7 +282,9 @@ out:
  * Do a system call from kernel instead of calling sys_execve so we
  * end up with proper pt_regs.
  */
-int kernel_execve(const char *filename, char *const argv[], char *const envp[])
+int kernel_execve(const char *filename,
+		  const char *const argv[],
+		  const char *const envp[])
 {
 	long __res;
 	register long __g1 __asm__ ("g1") = __NR_execve;
diff --git a/arch/sparc/kernel/sys_sparc_64.c b/arch/sparc/kernel/sys_sparc_64.c
index 3d435c4..f836f4e 100644
--- a/arch/sparc/kernel/sys_sparc_64.c
+++ b/arch/sparc/kernel/sys_sparc_64.c
@@ -758,7 +758,9 @@ SYSCALL_DEFINE5(rt_sigaction, int, sig, const struct sigaction __user *, act,
  * Do a system call from kernel instead of calling sys_execve so we
  * end up with proper pt_regs.
  */
-int kernel_execve(const char *filename, char *const argv[], char *const envp[])
+int kernel_execve(const char *filename,
+		  const char *const argv[],
+		  const char *const envp[])
 {
 	long __res;
 	register long __g1 __asm__ ("g1") = __NR_execve;
diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index ed590ad..985cc28 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -543,8 +543,9 @@ long _sys_vfork(struct pt_regs *regs)
 /*
  * sys_execve() executes a new program.
  */
-long _sys_execve(char __user *path, char __user *__user *argv,
-		 char __user *__user *envp, struct pt_regs *regs)
+long _sys_execve(const char __user *path,
+		 const char __user *const __user *argv,
+		 const char __user *const __user *envp, struct pt_regs *regs)
 {
 	long error;
 	char *filename;
diff --git a/arch/um/kernel/exec.c b/arch/um/kernel/exec.c
index 59b20d9..cd145ed 100644
--- a/arch/um/kernel/exec.c
+++ b/arch/um/kernel/exec.c
@@ -44,8 +44,9 @@ void start_thread(struct pt_regs *regs, unsigned long eip, unsigned long esp)
 	PT_REGS_SP(regs) = esp;
 }
 
-static long execve1(const char *file, char __user * __user *argv,
-		    char __user *__user *env)
+static long execve1(const char *file,
+		    const char __user *const __user *argv,
+		    const char __user *const __user *env)
 {
 	long error;
 
diff --git a/arch/um/kernel/syscall.c b/arch/um/kernel/syscall.c
index 7427c0b..5ddb246 100644
--- a/arch/um/kernel/syscall.c
+++ b/arch/um/kernel/syscall.c
@@ -51,7 +51,9 @@ long old_mmap(unsigned long addr, unsigned long len,
 	return err;
 }
 
-int kernel_execve(const char *filename, char *const argv[], char *const envp[])
+int kernel_execve(const char *filename,
+		  const char *const argv[],
+		  const char *const envp[])
 {
 	mm_segment_t fs;
 	int ret;
diff --git a/arch/x86/include/asm/syscalls.h b/arch/x86/include/asm/syscalls.h
index feb2ff9..f1d8b44 100644
--- a/arch/x86/include/asm/syscalls.h
+++ b/arch/x86/include/asm/syscalls.h
@@ -23,8 +23,9 @@ long sys_iopl(unsigned int, struct pt_regs *);
 /* kernel/process.c */
 int sys_fork(struct pt_regs *);
 int sys_vfork(struct pt_regs *);
-long sys_execve(const char __user *, char __user * __user *,
-		char __user * __user *, struct pt_regs *);
+long sys_execve(const char __user *,
+		const char __user *const __user *,
+		const char __user *const __user *, struct pt_regs *);
 long sys_clone(unsigned long, unsigned long, void __user *,
 	       void __user *, struct pt_regs *);
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 64ecaf0..57d1868 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -301,8 +301,9 @@ EXPORT_SYMBOL(kernel_thread);
 /*
  * sys_execve() executes a new program.
  */
-long sys_execve(const char __user *name, char __user * __user *argv,
-		char __user * __user *envp, struct pt_regs *regs)
+long sys_execve(const char __user *name,
+		const char __user *const __user *argv,
+		const char __user *const __user *envp, struct pt_regs *regs)
 {
 	long error;
 	char *filename;
diff --git a/arch/x86/kernel/sys_i386_32.c b/arch/x86/kernel/sys_i386_32.c
index 196552b..d5e0662 100644
--- a/arch/x86/kernel/sys_i386_32.c
+++ b/arch/x86/kernel/sys_i386_32.c
@@ -28,7 +28,9 @@
  * Do a system call from kernel instead of calling sys_execve so we
  * end up with proper pt_regs.
  */
-int kernel_execve(const char *filename, char *const argv[], char *const envp[])
+int kernel_execve(const char *filename,
+		  const char *const argv[],
+		  const char *const envp[])
 {
 	long __res;
 	asm volatile ("push %%ebx ; movl %2,%%ebx ; int $0x80 ; pop %%ebx"
diff --git a/arch/xtensa/kernel/process.c b/arch/xtensa/kernel/process.c
index 7c2f38f..e3558b9 100644
--- a/arch/xtensa/kernel/process.c
+++ b/arch/xtensa/kernel/process.c
@@ -318,8 +318,9 @@ long xtensa_clone(unsigned long clone_flags, unsigned long newsp,
  */
 
 asmlinkage
-long xtensa_execve(const char __user *name, char __user * __user *argv,
-                   char __user * __user *envp,
+long xtensa_execve(const char __user *name,
+		   const char __user *const __user *argv,
+                   const char __user *const __user *envp,
                    long a3, long a4, long a5,
                    struct pt_regs *regs)
 {
diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 9e60fd2..a7528b9 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -108,7 +108,7 @@ static int load_misc_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	Node *fmt;
 	struct file * interp_file = NULL;
 	char iname[BINPRM_BUF_SIZE];
-	char *iname_addr = iname;
+	const char *iname_addr = iname;
 	int retval;
 	int fd_binary = -1;
 
diff --git a/fs/binfmt_script.c b/fs/binfmt_script.c
index aca9d55..396a988 100644
--- a/fs/binfmt_script.c
+++ b/fs/binfmt_script.c
@@ -16,7 +16,8 @@
 
 static int load_script(struct linux_binprm *bprm,struct pt_regs *regs)
 {
-	char *cp, *i_name, *i_arg;
+	const char *i_arg, *i_name;
+	char *cp;
 	struct file *file;
 	char interp[BINPRM_BUF_SIZE];
 	int retval;
diff --git a/fs/exec.c b/fs/exec.c
index 7761837..05c7d6b 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -361,13 +361,13 @@ err:
 /*
  * count() counts the number of strings in array ARGV.
  */
-static int count(char __user * __user * argv, int max)
+static int count(const char __user * const __user * argv, int max)
 {
 	int i = 0;
 
 	if (argv != NULL) {
 		for (;;) {
-			char __user * p;
+			const char __user * p;
 
 			if (get_user(p, argv))
 				return -EFAULT;
@@ -387,7 +387,7 @@ static int count(char __user * __user * argv, int max)
  * processes's memory to the new process's stack.  The call to get_user_pages()
  * ensures the destination page is created and not swapped out.
  */
-static int copy_strings(int argc, char __user * __user * argv,
+static int copy_strings(int argc, const char __user *const __user *argv,
 			struct linux_binprm *bprm)
 {
 	struct page *kmapped_page = NULL;
@@ -396,7 +396,7 @@ static int copy_strings(int argc, char __user * __user * argv,
 	int ret;
 
 	while (argc-- > 0) {
-		char __user *str;
+		const char __user *str;
 		int len;
 		unsigned long pos;
 
@@ -470,12 +470,13 @@ out:
 /*
  * Like copy_strings, but get argv and its values from kernel memory.
  */
-int copy_strings_kernel(int argc,char ** argv, struct linux_binprm *bprm)
+int copy_strings_kernel(int argc, const char *const *argv,
+			struct linux_binprm *bprm)
 {
 	int r;
 	mm_segment_t oldfs = get_fs();
 	set_fs(KERNEL_DS);
-	r = copy_strings(argc, (char __user * __user *)argv, bprm);
+	r = copy_strings(argc, (const char __user *const  __user *)argv, bprm);
 	set_fs(oldfs);
 	return r;
 }
@@ -997,7 +998,7 @@ EXPORT_SYMBOL(flush_old_exec);
 void setup_new_exec(struct linux_binprm * bprm)
 {
 	int i, ch;
-	char * name;
+	const char *name;
 	char tcomm[sizeof(current->comm)];
 
 	arch_pick_mmap_layout(current->mm);
@@ -1316,9 +1317,9 @@ EXPORT_SYMBOL(search_binary_handler);
 /*
  * sys_execve() executes a new program.
  */
-int do_execve(char * filename,
-	char __user *__user *argv,
-	char __user *__user *envp,
+int do_execve(const char * filename,
+	const char __user *const __user *argv,
+	const char __user *const __user *envp,
 	struct pt_regs * regs)
 {
 	struct linux_binprm *bprm;
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index c809e28..a065612 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -50,8 +50,8 @@ struct linux_binprm{
 	int unsafe;		/* how unsafe this exec is (mask of LSM_UNSAFE_*) */
 	unsigned int per_clear;	/* bits to clear in current->personality */
 	int argc, envc;
-	char * filename;	/* Name of binary as seen by procps */
-	char * interp;		/* Name of the binary really executed. Most
+	const char * filename;	/* Name of binary as seen by procps */
+	const char * interp;	/* Name of the binary really executed. Most
 				   of the time same as filename, but could be
 				   different for binfmt_{misc,script} */
 	unsigned interp_flags;
@@ -126,7 +126,8 @@ extern int setup_arg_pages(struct linux_binprm * bprm,
 			   unsigned long stack_top,
 			   int executable_stack);
 extern int bprm_mm_init(struct linux_binprm *bprm);
-extern int copy_strings_kernel(int argc,char ** argv,struct linux_binprm *bprm);
+extern int copy_strings_kernel(int argc, const char *const *argv,
+			       struct linux_binprm *bprm);
 extern int prepare_bprm_creds(struct linux_binprm *bprm);
 extern void install_exec_creds(struct linux_binprm *bprm);
 extern void do_coredump(long signr, int exit_code, struct pt_regs *regs);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index ce160d6..1e2a6db 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2109,7 +2109,9 @@ extern void daemonize(const char *, ...);
 extern int allow_signal(int);
 extern int disallow_signal(int);
 
-extern int do_execve(char *, char __user * __user *, char __user * __user *, struct pt_regs *);
+extern int do_execve(const char *,
+		     const char __user * const __user *,
+		     const char __user * const __user *, struct pt_regs *);
 extern long do_fork(unsigned long, unsigned long, struct pt_regs *, unsigned long, int __user *, int __user *);
 struct task_struct *fork_idle(int);
 
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 6e5d197..e6319d1 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -820,7 +820,7 @@ asmlinkage long sys_fanotify_mark(int fanotify_fd, unsigned int flags,
 				  u64 mask, int fd,
 				  const char  __user *pathname);
 
-int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
+int kernel_execve(const char *filename, const char *const argv[], const char *const envp[]);
 
 
 asmlinkage long sys_perf_event_open(
diff --git a/init/do_mounts_initrd.c b/init/do_mounts_initrd.c
index 2b10853..3098a38 100644
--- a/init/do_mounts_initrd.c
+++ b/init/do_mounts_initrd.c
@@ -24,10 +24,11 @@ static int __init no_initrd(char *str)
 
 __setup("noinitrd", no_initrd);
 
-static int __init do_linuxrc(void * shell)
+static int __init do_linuxrc(void *_shell)
 {
-	static char *argv[] = { "linuxrc", NULL, };
-	extern char * envp_init[];
+	static const char *argv[] = { "linuxrc", NULL, };
+	extern const char *envp_init[];
+	const char *shell = _shell;
 
 	sys_close(old_fd);sys_close(root_fd);
 	sys_setsid();
diff --git a/init/main.c b/init/main.c
index 22d61cb..94ab488 100644
--- a/init/main.c
+++ b/init/main.c
@@ -197,8 +197,8 @@ static int __init set_reset_devices(char *str)
 
 __setup("reset_devices", set_reset_devices);
 
-static char * argv_init[MAX_INIT_ARGS+2] = { "init", NULL, };
-char * envp_init[MAX_INIT_ENVS+2] = { "HOME=/", "TERM=linux", NULL, };
+static const char * argv_init[MAX_INIT_ARGS+2] = { "init", NULL, };
+const char * envp_init[MAX_INIT_ENVS+2] = { "HOME=/", "TERM=linux", NULL, };
 static const char *panic_later, *panic_param;
 
 extern const struct obs_kernel_param __setup_start[], __setup_end[];
@@ -809,7 +809,7 @@ static void __init do_pre_smp_initcalls(void)
 		do_one_initcall(*fn);
 }
 
-static void run_init_process(char *init_filename)
+static void run_init_process(const char *init_filename)
 {
 	argv_init[0] = init_filename;
 	kernel_execve(init_filename, argv_init, envp_init);
diff --git a/kernel/kmod.c b/kernel/kmod.c
index 6e9b196..9cd0591 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -153,7 +153,9 @@ static int ____call_usermodehelper(void *data)
 			goto fail;
 	}
 
-	retval = kernel_execve(sub_info->path, sub_info->argv, sub_info->envp);
+	retval = kernel_execve(sub_info->path,
+			       (const char *const *)sub_info->argv,
+			       (const char *const *)sub_info->envp);
 
 	/* Exec failed? */
 fail:
diff --git a/security/commoncap.c b/security/commoncap.c
index 4e01599..9d172e6 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -40,7 +40,7 @@
  *
  * Warn if that happens, once per boot.
  */
-static void warn_setuid_and_fcaps_mixed(char *fname)
+static void warn_setuid_and_fcaps_mixed(const char *fname)
 {
 	static int warned;
 	if (!warned) {

