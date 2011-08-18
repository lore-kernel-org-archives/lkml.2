Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab1HRTAv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:00:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49921 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab1HRTAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:00:50 -0400
Date: Thu, 18 Aug 2011 20:00:49 +0100
To: richard@nod.at
Subject: Subject: [PATCH 11/91] um: series of __get_user() is costly in
 sigframe handling
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7ph-0007V3-7A@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It's not x86, where __get_user() is a single dereference; here it's
a single ptrace(2) call in host, which obviously costs a lot more.
IOW, it's cheaper to do copy_{to,from}_user() once than bother with
fields one by one...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/sys-i386/signal.c   |   48 ++++++++---------
 arch/um/sys-x86_64/signal.c |  118 +++++++++++++++++++++----------------------
 2 files changed, 80 insertions(+), 86 deletions(-)

diff --git a/arch/um/sys-i386/signal.c b/arch/um/sys-i386/signal.c
index b87195b..bcbfb0d 100644
--- a/arch/um/sys-i386/signal.c
+++ b/arch/um/sys-i386/signal.c
@@ -10,28 +10,6 @@
 #include "frame_kern.h"
 #include "skas.h"
 
-static void copy_sc(struct uml_pt_regs *regs, void *from)
-{
-	struct sigcontext *sc = from;
-
-	REGS_GS(regs->gp) = sc->gs;
-	REGS_FS(regs->gp) = sc->fs;
-	REGS_ES(regs->gp) = sc->es;
-	REGS_DS(regs->gp) = sc->ds;
-	REGS_EDI(regs->gp) = sc->di;
-	REGS_ESI(regs->gp) = sc->si;
-	REGS_EBP(regs->gp) = sc->bp;
-	REGS_SP(regs->gp) = sc->sp;
-	REGS_EBX(regs->gp) = sc->bx;
-	REGS_EDX(regs->gp) = sc->dx;
-	REGS_ECX(regs->gp) = sc->cx;
-	REGS_EAX(regs->gp) = sc->ax;
-	REGS_IP(regs->gp) = sc->ip;
-	REGS_CS(regs->gp) = sc->cs;
-	REGS_EFLAGS(regs->gp) = sc->flags;
-	REGS_SS(regs->gp) = sc->ss;
-}
-
 /*
  * FPU tag word conversions.
  */
@@ -175,7 +153,27 @@ static int copy_sc_from_user(struct pt_regs *regs,
 		return err;
 
 	pid = userspace_pid[current_thread_info()->cpu];
-	copy_sc(&regs->regs, &sc);
+
+#define GETREG(regno, regname) regs->regs.gp[HOST_##regno] = sc.regname
+
+	GETREG(GS, gs);
+	GETREG(FS, fs);
+	GETREG(ES, es);
+	GETREG(DS, ds);
+	GETREG(EDI, di);
+	GETREG(ESI, si);
+	GETREG(EBP, bp);
+	GETREG(SP, sp);
+	GETREG(EBX, bx);
+	GETREG(EDX, dx);
+	GETREG(ECX, cx);
+	GETREG(EAX, ax);
+	GETREG(IP, ip);
+	GETREG(CS, cs);
+	GETREG(EFLAGS, flags);
+	GETREG(SS, ss);
+
+#undef GETREG
 	if (have_fpx_regs) {
 		struct user_fxsr_struct fpx;
 
@@ -196,8 +194,7 @@ static int copy_sc_from_user(struct pt_regs *regs,
 			       -err);
 			return 1;
 		}
-	}
-	else {
+	} else {
 		struct user_i387_struct fp;
 
 		err = copy_from_user(&fp, sc.fpstate,
@@ -224,6 +221,7 @@ static int copy_sc_to_user(struct sigcontext __user *to,
 	struct sigcontext sc;
 	struct faultinfo * fi = &current->thread.arch.faultinfo;
 	int err, pid;
+	memset(&sc, 0, sizeof(struct sigcontext));
 
 	sc.gs = REGS_GS(regs->regs.gp);
 	sc.fs = REGS_FS(regs->regs.gp);
diff --git a/arch/um/sys-x86_64/signal.c b/arch/um/sys-x86_64/signal.c
index 61ad980..255b2ca 100644
--- a/arch/um/sys-x86_64/signal.c
+++ b/arch/um/sys-x86_64/signal.c
@@ -16,41 +16,39 @@
 static int copy_sc_from_user(struct pt_regs *regs,
 			     struct sigcontext __user *from)
 {
+	struct sigcontext sc;
 	struct user_i387_struct fp;
 	void __user *buf;
-	int err = 0;
+	int err;
 
-#define GETREG(regs, regno, sc, regname)				\
-	__get_user((regs)->regs.gp[(regno) / sizeof(unsigned long)],	\
-		   &(sc)->regname)
-
-	err |= GETREG(regs, R8, from, r8);
-	err |= GETREG(regs, R9, from, r9);
-	err |= GETREG(regs, R10, from, r10);
-	err |= GETREG(regs, R11, from, r11);
-	err |= GETREG(regs, R12, from, r12);
-	err |= GETREG(regs, R13, from, r13);
-	err |= GETREG(regs, R14, from, r14);
-	err |= GETREG(regs, R15, from, r15);
-	err |= GETREG(regs, RDI, from, di);
-	err |= GETREG(regs, RSI, from, si);
-	err |= GETREG(regs, RBP, from, bp);
-	err |= GETREG(regs, RBX, from, bx);
-	err |= GETREG(regs, RDX, from, dx);
-	err |= GETREG(regs, RAX, from, ax);
-	err |= GETREG(regs, RCX, from, cx);
-	err |= GETREG(regs, RSP, from, sp);
-	err |= GETREG(regs, RIP, from, ip);
-	err |= GETREG(regs, EFLAGS, from, flags);
-	err |= GETREG(regs, CS, from, cs);
+	err = copy_from_user(&sc, from, sizeof(sc));
 	if (err)
-		return 1;
-
+		return err;
+
+#define GETREG(regno, regname) regs->regs.gp[HOST_##regno] = sc.regname
+
+	GETREG(R8, r8);
+	GETREG(R9, r9);
+	GETREG(R10, r10);
+	GETREG(R11, r11);
+	GETREG(R12, r12);
+	GETREG(R13, r13);
+	GETREG(R14, r14);
+	GETREG(R15, r15);
+	GETREG(RDI, di);
+	GETREG(RSI, si);
+	GETREG(RBP, bp);
+	GETREG(RBX, bx);
+	GETREG(RDX, dx);
+	GETREG(RAX, ax);
+	GETREG(RCX, cx);
+	GETREG(SP, sp);
+	GETREG(IP, ip);
+	GETREG(EFLAGS, flags);
+	GETREG(CS, cs);
 #undef GETREG
 
-	err = __get_user(buf, &from->fpstate);
-	if (err)
-		return 1;
+	buf = sc.fpstate;
 
 	err = copy_from_user(&fp, buf, sizeof(struct user_i387_struct));
 	if (err)
@@ -73,48 +71,46 @@ static int copy_sc_to_user(struct sigcontext __user *to,
 			   unsigned long mask, unsigned long sp)
 {
 	struct faultinfo * fi = &current->thread.arch.faultinfo;
+	struct sigcontext sc;
 	struct user_i387_struct fp;
 	int err = 0;
+	memset(&sc, 0, sizeof(struct sigcontext));
 
-	err |= __put_user(0, &to->gs);
-	err |= __put_user(0, &to->fs);
-
-#define PUTREG(regs, regno, sc, regname)				\
-	__put_user((regs)->regs.gp[(regno) / sizeof(unsigned long)],	\
-		   &(sc)->regname)
+#define PUTREG(regno, regname) sc.regname = regs->regs.gp[HOST_##regno]
 
-	err |= PUTREG(regs, RDI, to, di);
-	err |= PUTREG(regs, RSI, to, si);
-	err |= PUTREG(regs, RBP, to, bp);
+	PUTREG(RDI, di);
+	PUTREG(RSI, si);
+	PUTREG(RBP, bp);
 	/*
 	 * Must use original RSP, which is passed in, rather than what's in
-	 * the pt_regs, because that's already been updated to point at the
 	 * signal frame.
 	 */
-	err |= __put_user(sp, &to->sp);
-	err |= PUTREG(regs, RBX, to, bx);
-	err |= PUTREG(regs, RDX, to, dx);
-	err |= PUTREG(regs, RCX, to, cx);
-	err |= PUTREG(regs, RAX, to, ax);
-	err |= PUTREG(regs, R8, to, r8);
-	err |= PUTREG(regs, R9, to, r9);
-	err |= PUTREG(regs, R10, to, r10);
-	err |= PUTREG(regs, R11, to, r11);
-	err |= PUTREG(regs, R12, to, r12);
-	err |= PUTREG(regs, R13, to, r13);
-	err |= PUTREG(regs, R14, to, r14);
-	err |= PUTREG(regs, R15, to, r15);
-	err |= PUTREG(regs, CS, to, cs); /* XXX x86_64 doesn't do this */
-
-	err |= __put_user(fi->cr2, &to->cr2);
-	err |= __put_user(fi->error_code, &to->err);
-	err |= __put_user(fi->trap_no, &to->trapno);
-
-	err |= PUTREG(regs, RIP, to, ip);
-	err |= PUTREG(regs, EFLAGS, to, flags);
+	sc.sp = sp;
+	PUTREG(RBX, bx);
+	PUTREG(RDX, dx);
+	PUTREG(RCX, cx);
+	PUTREG(RAX, ax);
+	PUTREG(R8, r8);
+	PUTREG(R9, r9);
+	PUTREG(R10, r10);
+	PUTREG(R11, r11);
+	PUTREG(R12, r12);
+	PUTREG(R13, r13);
+	PUTREG(R14, r14);
+	PUTREG(R15, r15);
+	PUTREG(CS, cs); /* XXX x86_64 doesn't do this */
+
+	sc.cr2 = fi->cr2;
+	sc.err = fi->error_code;
+	sc.trapno = fi->trap_no;
+
+	PUTREG(IP, ip);
+	PUTREG(EFLAGS, flags);
 #undef PUTREG
 
-	err |= __put_user(mask, &to->oldmask);
+	sc.oldmask = mask;
+
+	err = copy_to_user(to, &sc, sizeof(struct sigcontext));
 	if (err)
 		return 1;
 
-- 
1.7.2.5


