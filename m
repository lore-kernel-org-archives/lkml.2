Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab1HFDBh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 23:01:37 -0400
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:52719 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752293Ab1HFDBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 23:01:35 -0400
X-AuditID: 12074424-b7b0fae000000a08-5a-4e3caeab03b0
From: Andy Lutomirski <luto@MIT.EDU>
To: "H. Peter Anvin\"" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        lueckintel@yahoo.com, kimwooyoung@gmail.com,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [RFC] x86-64: Allow emulated vsyscalls from user addresses
Date: Fri,  5 Aug 2011 23:01:21 -0400
Message-Id: <a6e46d590f1dc5dc1e9b4dd05f7f9491bb9cacd7.1312599488.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <4E3C8B8A.3080007@zytor.com>
References: <4E3C8B8A.3080007@zytor.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsUixG6nort6nY2fwc+zphZ9V46yWxy59p3d
	YtpGcYtXf8otLu+aw2ax4nwnq8W/plssFo/63rJb/NjwmNWB02P+zo+MHjtn3WX3WLznJZPH
	plWdbB4nZvxm8fi8Sc5j1qzDTB4nWr6wBnBEcdmkpOZklqUW6dslcGWceN/IVtCpWzG/P6aB
	cZZKFyMnh4SAicTChf3MELaYxIV769m6GLk4hAT2MUrM2nkaylnPKHFh03lGCOcpk0THi39s
	IC1sAioSHUsfMIHYIgJqEgt+PmQGKWIW6GWS+NT6ASwhLOAscWbqDfYuRg4OFgFVid3nPUHC
	vAJBEhu/v2GCWC0nceTyczCbU0BTYu3HVYwgtpCAhsSpO1OYJjDyLWBkWMUom5JbpZubmJlT
	nJqsW5ycmJeXWqRrrpebWaKXmlK6iREcrC4qOxibDykdYhTgYFTi4bWQt/ETYk0sK67MPcQo
	ycGkJMr7ZxVQiC8pP6UyI7E4I76oNCe1+BCjBAezkghvji5QjjclsbIqtSgfJiXNwaIkzlvq
	/d9XSCA9sSQ1OzW1ILUIJivDwaEkwcsDjEohwaLU9NSKtMycEoQ0EwcnyHAeoOGPVoMMLy5I
	zC3OTIfIn2JUlBLnFQdpFgBJZJTmwfXCkskrRnGgV4R5L64FquIBJiK47ldAg5mABv9/bwEy
	uCQRISXVwJgQkxMzR9OQKfBUg0HKtx9blnPvcDzyWeB6xPT90daMf8qyHi3gWvmIwzF3/49w
	sS2H1ATnm9zvfvyU9YqepOL3716NzewHBa9wF6l/3fO7YKXk7CMTogz35b2KXbfH1c5L6c/r
	T+X6pivXTzP/qb9SyW6JhtqPlOcFl5kuPtvt/2Py+8tPbE4rsRRnJBpqMRcVJwIAwBgCwAED
	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few dynamic recompilation tools are too clever for their own good.
They trace control flow through the vsyscall page and recompile that
code somewhere else.  Then they expect it to work.  DynamoRIO
(http://dynamorio.org/) and Pin (http://www.pintool.org/) are
affected.  They crash when tracing programs that use vsyscalls.
Valgrind is smart enough not to cause problems.  It crashes on the
getcpu vsyscall, but that has nothing to do with emulation.

This patch makes each of the three vsyscall entries use a different
vector so that they can work when relocated.  It assumes that the
code that relocates them is okay with the int instruction acting
like ret.  DynamoRIO at least appears to work.

We print an obnoxious (rate-limited) message to the log when this
happens.  Hopefully it will inspire the JIT tools to learn not to
trace into kernel address space.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---

This uses vectors 0x40, 0x41, and 0x42 for now.  They are REX
prefixes in 64-bit code, and jumping to the second byte of one
of these instructions will turn into 'rex.? int3', which will
trap.

 arch/x86/kernel/vsyscall_64.c     |   75 ++++++++++--------------------------
 arch/x86/kernel/vsyscall_emu_64.S |    6 +-
 2 files changed, 24 insertions(+), 57 deletions(-)

diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index f785f5b..a33ad02 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -105,22 +105,8 @@ static void warn_bad_vsyscall(const char *level, struct pt_regs *regs,
 	       regs->sp, regs->ax, regs->si, regs->di);
 }
 
-static int addr_to_vsyscall_nr(unsigned long addr)
-{
-	int nr;
-
-	if ((addr & ~0xC00UL) != VSYSCALL_START)
-		return -EINVAL;
-
-	nr = (addr & 0xC00UL) >> 10;
-	if (nr >= 3)
-		return -EINVAL;
-
-	return nr;
-}
-
-void emulate_vsyscall(struct pt_regs *regs, int nr,
-		      long (*vsys)(struct pt_regs *))
+static void emulate_vsyscall(struct pt_regs *regs, int nr,
+			     long (*vsys)(struct pt_regs *))
 {
 	struct task_struct *tsk;
 	unsigned long caller;
@@ -128,6 +114,8 @@ void emulate_vsyscall(struct pt_regs *regs, int nr,
 
 	local_irq_enable();
 
+	trace_emulate_vsyscall(nr);
+
 	if (!user_64bit_mode(regs)) {
 		/*
 		 * If we trapped from kernel mode, we might as well OOPS now
@@ -138,50 +126,29 @@ void emulate_vsyscall(struct pt_regs *regs, int nr,
 
 		/* Compat mode and non-compat 32-bit CS should both segfault. */
 		warn_bad_vsyscall(KERN_WARNING, regs,
-				  "illegal int 0xcc from 32-bit mode");
+				  "illegal emulated vsyscall from 32-bit mode");
 		goto sigsegv;
 	}
 
-	/*
-	 * x86-ism here: regs->ip points to the instruction after the int 0xcc,
-	 * and int 0xcc is two bytes long.
-	 */
-	vsyscall_nr = addr_to_vsyscall_nr(regs->ip - 2);
-
-	trace_emulate_vsyscall(vsyscall_nr);
-
-	if (vsyscall_nr < 0) {
-		warn_bad_vsyscall(KERN_WARNING, regs,
-				  "illegal int 0xcc (exploit attempt?)");
-		goto sigsegv;
-	}
+	tsk = current;
+	if (seccomp_mode(&tsk->seccomp))
+		do_exit(SIGKILL);
 
 	if (get_user(caller, (unsigned long __user *)regs->sp) != 0) {
 		warn_bad_vsyscall(KERN_WARNING, regs, "int 0xcc with bad stack (exploit attempt?)");
 		goto sigsegv;
 	}
 
-	tsk = current;
-	if (seccomp_mode(&tsk->seccomp))
-		do_exit(SIGKILL);
+	/*
+	 * x86-ism here: regs->ip points to the instruction after the int 0xcc,
+	 * and int 0xcc is two bytes long.
+	 */
+	if (((regs->ip - 2) & ~0xfff) != VSYSCALL_START)
+		warn_bad_vsyscall(KERN_WARNING, regs,
+				  "emulated vsyscall from bogus address -- "
+				  "fix your code");
 
-	switch (vsyscall_nr) {
-	case 0:
-		ret = sys_gettimeofday(
-			(struct timeval __user *)regs->di,
-			(struct timezone __user *)regs->si);
-		break;
-
-	case 1:
-		ret = sys_time((time_t __user *)regs->di);
-		break;
-
-	case 2:
-		ret = sys_getcpu((unsigned __user *)regs->di,
-				 (unsigned __user *)regs->si,
-				 0);
-		break;
-	}
+	ret = vsys(regs);
 
 	if (ret == -EFAULT) {
 		/*
@@ -223,9 +190,9 @@ static long vsys_gettimeofday(struct pt_regs *regs)
 		(struct timezone __user *)regs->si);
 }
 
-void dotraplinkage emulate_vsyscall0(struct pt_regs *regs, long error_code)
+void dotraplinkage do_emulate_vsyscall0(struct pt_regs *regs, long error_code)
 {
-	emulate_vsyscall(regs, vsys_gettimeofday);
+	emulate_vsyscall(regs, 0, vsys_gettimeofday);
 }
 
 static long vsys_time(struct pt_regs *regs)
@@ -233,7 +200,7 @@ static long vsys_time(struct pt_regs *regs)
 	return sys_time((time_t __user *)regs->di);
 }
 
-void dotraplinkage emulate_vsyscall1(struct pt_regs *regs, long error_code)
+void dotraplinkage do_emulate_vsyscall1(struct pt_regs *regs, long error_code)
 {
 	emulate_vsyscall(regs, 1, vsys_time);
 }
@@ -245,7 +212,7 @@ static long vsys_getcpu(struct pt_regs *regs)
 			  0);
 }
 
-void dotraplinkage emulate_vsyscall2(struct pt_regs *regs, long error_code)
+void dotraplinkage do_emulate_vsyscall2(struct pt_regs *regs, long error_code)
 {
 	emulate_vsyscall(regs, 2, vsys_getcpu);
 }
diff --git a/arch/x86/kernel/vsyscall_emu_64.S b/arch/x86/kernel/vsyscall_emu_64.S
index ffa845e..a4f02a3 100644
--- a/arch/x86/kernel/vsyscall_emu_64.S
+++ b/arch/x86/kernel/vsyscall_emu_64.S
@@ -13,15 +13,15 @@
 
 .section .vsyscall_0, "a"
 ENTRY(vsyscall_0)
-	int $VSYSCALL_EMU_VECTOR
+	int $VSYSCALL0_EMU_VECTOR
 END(vsyscall_0)
 
 .section .vsyscall_1, "a"
 ENTRY(vsyscall_1)
-	int $VSYSCALL_EMU_VECTOR
+	int $VSYSCALL1_EMU_VECTOR
 END(vsyscall_1)
 
 .section .vsyscall_2, "a"
 ENTRY(vsyscall_2)
-	int $VSYSCALL_EMU_VECTOR
+	int $VSYSCALL2_EMU_VECTOR
 END(vsyscall_2)
-- 
1.7.6

