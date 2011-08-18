Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab1HRTMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:12:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48409 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041Ab1HRTMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:12:30 -0400
Date: Thu, 18 Aug 2011 20:12:29 +0100
To: richard@nod.at
Subject: Subject: [PATCH 81/91] um: clean arch_ptrace() up a bit
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu80z-00084j-Vg@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1) take subarch-specific stuff to subarch_ptrace()
2) PTRACE_{PEEK,POKE}{TEXT,DATA} is handled by ptrace_request() just fine...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/include/asm/ptrace-generic.h |    4 ----
 arch/um/kernel/ptrace.c              |   28 ----------------------------
 arch/x86/um/asm/ptrace_32.h          |    5 -----
 arch/x86/um/ptrace_32.c              |   18 ++++++++++++------
 arch/x86/um/ptrace_64.c              |   22 +++++++++++++++++++---
 5 files changed, 31 insertions(+), 46 deletions(-)

diff --git a/arch/um/include/asm/ptrace-generic.h b/arch/um/include/asm/ptrace-generic.h
index 97c35f8..f605d3c 100644
--- a/arch/um/include/asm/ptrace-generic.h
+++ b/arch/um/include/asm/ptrace-generic.h
@@ -35,10 +35,6 @@ extern long subarch_ptrace(struct task_struct *child, long request,
 	unsigned long addr, unsigned long data);
 extern unsigned long getreg(struct task_struct *child, int regno);
 extern int putreg(struct task_struct *child, int regno, unsigned long value);
-extern int get_fpregs(struct user_i387_struct __user *buf,
-		      struct task_struct *child);
-extern int set_fpregs(struct user_i387_struct __user *buf,
-		      struct task_struct *child);
 
 extern int arch_copy_tls(struct task_struct *new);
 extern void clear_flushed_tls(struct task_struct *task);
diff --git a/arch/um/kernel/ptrace.c b/arch/um/kernel/ptrace.c
index 701b672..c9da32b 100644
--- a/arch/um/kernel/ptrace.c
+++ b/arch/um/kernel/ptrace.c
@@ -50,23 +50,11 @@ long arch_ptrace(struct task_struct *child, long request,
 	void __user *vp = p;
 
 	switch (request) {
-	/* read word at location addr. */
-	case PTRACE_PEEKTEXT:
-	case PTRACE_PEEKDATA:
-		ret = generic_ptrace_peekdata(child, addr, data);
-		break;
-
 	/* read the word at location addr in the USER area. */
 	case PTRACE_PEEKUSR:
 		ret = peek_user(child, addr, data);
 		break;
 
-	/* write the word at location addr. */
-	case PTRACE_POKETEXT:
-	case PTRACE_POKEDATA:
-		ret = generic_ptrace_pokedata(child, addr, data);
-		break;
-
 	/* write the word at location addr in the USER area */
 	case PTRACE_POKEUSR:
 		ret = poke_user(child, addr, data);
@@ -107,16 +95,6 @@ long arch_ptrace(struct task_struct *child, long request,
 		break;
 	}
 #endif
-#ifdef PTRACE_GETFPREGS
-	case PTRACE_GETFPREGS: /* Get the child FPU state. */
-		ret = get_fpregs(vp, child);
-		break;
-#endif
-#ifdef PTRACE_SETFPREGS
-	case PTRACE_SETFPREGS: /* Set the child FPU state. */
-		ret = set_fpregs(vp, child);
-		break;
-#endif
 	case PTRACE_GET_THREAD_AREA:
 		ret = ptrace_get_thread_area(child, addr, vp);
 		break;
@@ -154,12 +132,6 @@ long arch_ptrace(struct task_struct *child, long request,
 		break;
 	}
 #endif
-#ifdef PTRACE_ARCH_PRCTL
-	case PTRACE_ARCH_PRCTL:
-		/* XXX Calls ptrace on the host - needs some SMP thinking */
-		ret = arch_prctl(child, data, (void __user *) addr);
-		break;
-#endif
 	default:
 		ret = ptrace_request(child, request, addr, data);
 		if (ret == -EIO)
diff --git a/arch/x86/um/asm/ptrace_32.h b/arch/x86/um/asm/ptrace_32.h
index 0273e4d..5d2a591 100644
--- a/arch/x86/um/asm/ptrace_32.h
+++ b/arch/x86/um/asm/ptrace_32.h
@@ -42,11 +42,6 @@
  */
 struct user_desc;
 
-extern int get_fpxregs(struct user_fxsr_struct __user *buf,
-		       struct task_struct *child);
-extern int set_fpxregs(struct user_fxsr_struct __user *buf,
-		       struct task_struct *tsk);
-
 extern int ptrace_get_thread_area(struct task_struct *child, int idx,
                                   struct user_desc __user *user_desc);
 
diff --git a/arch/x86/um/ptrace_32.c b/arch/x86/um/ptrace_32.c
index 3caaab9..3b949da 100644
--- a/arch/x86/um/ptrace_32.c
+++ b/arch/x86/um/ptrace_32.c
@@ -190,7 +190,7 @@ int peek_user(struct task_struct *child, long addr, long data)
 	return put_user(tmp, (unsigned long __user *) data);
 }
 
-int get_fpregs(struct user_i387_struct __user *buf, struct task_struct *child)
+static int get_fpregs(struct user_i387_struct __user *buf, struct task_struct *child)
 {
 	int err, n, cpu = ((struct thread_info *) child->stack)->cpu;
 	struct user_i387_struct fpregs;
@@ -206,7 +206,7 @@ int get_fpregs(struct user_i387_struct __user *buf, struct task_struct *child)
 	return n;
 }
 
-int set_fpregs(struct user_i387_struct __user *buf, struct task_struct *child)
+static int set_fpregs(struct user_i387_struct __user *buf, struct task_struct *child)
 {
 	int n, cpu = ((struct thread_info *) child->stack)->cpu;
 	struct user_i387_struct fpregs;
@@ -219,7 +219,7 @@ int set_fpregs(struct user_i387_struct __user *buf, struct task_struct *child)
 				    (unsigned long *) &fpregs);
 }
 
-int get_fpxregs(struct user_fxsr_struct __user *buf, struct task_struct *child)
+static int get_fpxregs(struct user_fxsr_struct __user *buf, struct task_struct *child)
 {
 	int err, n, cpu = ((struct thread_info *) child->stack)->cpu;
 	struct user_fxsr_struct fpregs;
@@ -235,7 +235,7 @@ int get_fpxregs(struct user_fxsr_struct __user *buf, struct task_struct *child)
 	return n;
 }
 
-int set_fpxregs(struct user_fxsr_struct __user *buf, struct task_struct *child)
+static int set_fpxregs(struct user_fxsr_struct __user *buf, struct task_struct *child)
 {
 	int n, cpu = ((struct thread_info *) child->stack)->cpu;
 	struct user_fxsr_struct fpregs;
@@ -253,15 +253,21 @@ long subarch_ptrace(struct task_struct *child, long request,
 {
 	int ret = -EIO;
 	void __user *datap = (void __user *) data;
-
 	switch (request) {
+	case PTRACE_GETFPREGS: /* Get the child FPU state. */
+		ret = get_fpregs(datap, child);
+		break;
+	case PTRACE_SETFPREGS: /* Set the child FPU state. */
+		ret = set_fpregs(datap, child);
+		break;
 	case PTRACE_GETFPXREGS: /* Get the child FPU state. */
 		ret = get_fpxregs(datap, child);
 		break;
 	case PTRACE_SETFPXREGS: /* Set the child FPU state. */
 		ret = set_fpxregs(datap, child);
 		break;
+	default:
+		ret = -EIO;
 	}
-
 	return ret;
 }
diff --git a/arch/x86/um/ptrace_64.c b/arch/x86/um/ptrace_64.c
index 71cd19d..3b52bf0 100644
--- a/arch/x86/um/ptrace_64.c
+++ b/arch/x86/um/ptrace_64.c
@@ -218,7 +218,7 @@ int is_syscall(unsigned long addr)
 	return instr == 0x050f;
 }
 
-int get_fpregs(struct user_i387_struct __user *buf, struct task_struct *child)
+static int get_fpregs(struct user_i387_struct __user *buf, struct task_struct *child)
 {
 	int err, n, cpu = ((struct thread_info *) child->stack)->cpu;
 	long fpregs[HOST_FP_SIZE];
@@ -235,7 +235,7 @@ int get_fpregs(struct user_i387_struct __user *buf, struct task_struct *child)
 	return n;
 }
 
-int set_fpregs(struct user_i387_struct __user *buf, struct task_struct *child)
+static int set_fpregs(struct user_i387_struct __user *buf, struct task_struct *child)
 {
 	int n, cpu = ((struct thread_info *) child->stack)->cpu;
 	long fpregs[HOST_FP_SIZE];
@@ -251,5 +251,21 @@ int set_fpregs(struct user_i387_struct __user *buf, struct task_struct *child)
 long subarch_ptrace(struct task_struct *child, long request,
 		    unsigned long addr, unsigned long data)
 {
-	return -EIO;
+	int ret = -EIO;
+	void __user *datap = (void __user *) data;
+
+	switch (request) {
+	case PTRACE_GETFPREGS: /* Get the child FPU state. */
+		ret = get_fpregs(datap, child);
+		break;
+	case PTRACE_SETFPREGS: /* Set the child FPU state. */
+		ret = set_fpregs(datap, child);
+		break;
+	case PTRACE_ARCH_PRCTL:
+		/* XXX Calls ptrace on the host - needs some SMP thinking */
+		ret = arch_prctl(child, data, (void __user *) addr);
+		break;
+	}
+
+	return ret;
 }
-- 
1.7.2.5


