Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab1HFDEc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 23:04:32 -0400
Received: from DMZ-MAILSEC-SCANNER-4.MIT.EDU ([18.9.25.15]:65344 "EHLO
	dmz-mailsec-scanner-4.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752293Ab1HFDEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 23:04:30 -0400
X-AuditID: 1209190f-b7b44ae000000a24-d2-4e3caea59225
From: Andy Lutomirski <luto@MIT.EDU>
To: "H. Peter Anvin\"" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        lueckintel@yahoo.com, kimwooyoung@gmail.com,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [RFC v2] x86-64: Allow emulated vsyscalls from user addresses
Date: Fri,  5 Aug 2011 23:04:22 -0400
Message-Id: <44eea096d708c5c3273e41ced354073ebd62a1d6.1312599769.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <4E3C8B8A.3080007@zytor.com>
References: <4E3C8B8A.3080007@zytor.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsUixCmqrLt0nY2fwSxWi74rR9ktjlz7zm4x
	baO4xas/5RaXd81hs1hxvpPV4l/TLRaLR31v2S1+bHjM6sDpMX/nR0aPnbPusnss3vOSyWPT
	qk42jxMzfrN4fN4k5zFr1mEmjxMtX1gDOKK4bFJSczLLUov07RK4MjZc2sFWcC2k4k3vD/YG
	xvmuXYycHBICJhK3Jvxlg7DFJC7cWw9kc3EICexjlPi/ehEThLOeUeLNvatQzlMmiWlz9rKA
	tLAJqEh0LH3ABGKLCKhJLPj5kBmkiFmgl0niU+sHsISwgJvEh/1/WUFsFgFViWX/FgDt4ODg
	FQiSeNcvBrFaTuLI5edg5ZwCmhJrP65iBLGFBDQkTt2ZwjSBkW8BI8MqRtmU3Crd3MTMnOLU
	ZN3i5MS8vNQiXRO93MwSvdSU0k2M4GCV5N/B+O2g0iFGAQ5GJR7ehzI2fkKsiWXFlbmHGCU5
	mJREef+sAgrxJeWnVGYkFmfEF5XmpBYfYpTgYFYS4c3RBcrxpiRWVqUW5cOkpDlYlMR5y73/
	+woJpCeWpGanphakFsFkZTg4lCR4eYBRKSRYlJqeWpGWmVOCkGbi4AQZzgM0/NFqkOHFBYm5
	xZnpEPlTjIpS4ryTQZoFQBIZpXlwvbBk8opRHOgVYd5akCoeYCKC634FNJgJaPD/9xYgg0sS
	EVJSDYx87S17VefXzbrvuMP447MbQYmL2V9kC/C4TBXe47rC5Wrs426jh/vMmw/6bbM/kBhr
	NzEyi985o0Sbf4JV5KGX9SbfF1YFnrYtk1rtEZiqotk06+1Rno5zZ2Zc+RtTevWuiX3dnkmV
	/y7O4d7cuzBha1VsUO7PsueCHYl+wQ4MV1x9vpmubFViKc5INNRiLipOBACn3upBAQMAAA==
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

Changes from v1: Sending the correct patch this time.

 arch/x86/include/asm/irq_vectors.h |   11 ++--
 arch/x86/include/asm/traps.h       |    8 ++-
 arch/x86/kernel/entry_64.S         |    4 +-
 arch/x86/kernel/traps.c            |   14 ++++-
 arch/x86/kernel/vsyscall_64.c      |  114 ++++++++++++++++++-----------------
 arch/x86/kernel/vsyscall_emu_64.S  |    6 +-
 6 files changed, 88 insertions(+), 69 deletions(-)

diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index f9a3209..b9c229a 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -15,10 +15,9 @@
  * IDT entries:
  *
  *  Vectors   0 ...  31 : system traps and exceptions - hardcoded events
- *  Vectors  32 ... 127 : device interrupts
- *  Vector  128         : legacy int80 syscall interface
- *  Vector  204         : legacy x86_64 vsyscall emulation
- *  Vectors 129 ... INVALIDATE_TLB_VECTOR_START-1 except 204 : device interrupts
+ *  Vectors  32 ... INVALIDATE_TLB_VECTOR_START-1 : device interrupts, except:
+ *   Vectors 64 ... 66  : legacy x86_64 vsyscall emulation
+ *   Vector  128        : legacy int80 syscall interface
  *  Vectors INVALIDATE_TLB_VECTOR_START ... 255 : special interrupts
  *
  * 64-bit x86 has per CPU IDT tables, 32-bit has one shared IDT table.
@@ -52,7 +51,9 @@
 # define SYSCALL_VECTOR			0x80
 #endif
 #ifdef CONFIG_X86_64
-# define VSYSCALL_EMU_VECTOR		0xcc
+# define VSYSCALL0_EMU_VECTOR		0x40
+# define VSYSCALL1_EMU_VECTOR		0x41
+# define VSYSCALL2_EMU_VECTOR		0x42
 #endif
 
 /*
diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 2bae0a5..4335ff7 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -40,7 +40,9 @@ asmlinkage void alignment_check(void);
 asmlinkage void machine_check(void);
 #endif /* CONFIG_X86_MCE */
 asmlinkage void simd_coprocessor_error(void);
-asmlinkage void emulate_vsyscall(void);
+asmlinkage void emulate_vsyscall0(void);
+asmlinkage void emulate_vsyscall1(void);
+asmlinkage void emulate_vsyscall2(void);
 
 dotraplinkage void do_divide_error(struct pt_regs *, long);
 dotraplinkage void do_debug(struct pt_regs *, long);
@@ -67,7 +69,9 @@ dotraplinkage void do_alignment_check(struct pt_regs *, long);
 dotraplinkage void do_machine_check(struct pt_regs *, long);
 #endif
 dotraplinkage void do_simd_coprocessor_error(struct pt_regs *, long);
-dotraplinkage void do_emulate_vsyscall(struct pt_regs *, long);
+dotraplinkage void do_emulate_vsyscall0(struct pt_regs *, long);
+dotraplinkage void do_emulate_vsyscall1(struct pt_regs *, long);
+dotraplinkage void do_emulate_vsyscall2(struct pt_regs *, long);
 #ifdef CONFIG_X86_32
 dotraplinkage void do_iret_error(struct pt_regs *, long);
 #endif
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index e13329d..10489e5 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1111,7 +1111,9 @@ zeroentry spurious_interrupt_bug do_spurious_interrupt_bug
 zeroentry coprocessor_error do_coprocessor_error
 errorentry alignment_check do_alignment_check
 zeroentry simd_coprocessor_error do_simd_coprocessor_error
-zeroentry emulate_vsyscall do_emulate_vsyscall
+zeroentry emulate_vsyscall0 do_emulate_vsyscall0
+zeroentry emulate_vsyscall1 do_emulate_vsyscall1
+zeroentry emulate_vsyscall2 do_emulate_vsyscall2
 
 
 	/* Reload gs selector with exception handling */
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 9682ec5..6ae5e3a 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -873,9 +873,17 @@ void __init trap_init(void)
 #endif
 
 #ifdef CONFIG_X86_64
-	BUG_ON(test_bit(VSYSCALL_EMU_VECTOR, used_vectors));
-	set_system_intr_gate(VSYSCALL_EMU_VECTOR, &emulate_vsyscall);
-	set_bit(VSYSCALL_EMU_VECTOR, used_vectors);
+	BUG_ON(test_bit(VSYSCALL0_EMU_VECTOR, used_vectors));
+	set_system_intr_gate(VSYSCALL0_EMU_VECTOR, &emulate_vsyscall0);
+	set_bit(VSYSCALL0_EMU_VECTOR, used_vectors);
+
+	BUG_ON(test_bit(VSYSCALL1_EMU_VECTOR, used_vectors));
+	set_system_intr_gate(VSYSCALL1_EMU_VECTOR, &emulate_vsyscall1);
+	set_bit(VSYSCALL1_EMU_VECTOR, used_vectors);
+
+	BUG_ON(test_bit(VSYSCALL2_EMU_VECTOR, used_vectors));
+	set_system_intr_gate(VSYSCALL2_EMU_VECTOR, &emulate_vsyscall2);
+	set_bit(VSYSCALL2_EMU_VECTOR, used_vectors);
 #endif
 
 	/*
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 93a0d46..a33ad02 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -8,11 +8,9 @@
  *  Special thanks to Ingo Molnar for his early experience with
  *  a different vsyscall implementation for Linux/IA32 and for the name.
  *
- *  vsyscall 1 is located at -10Mbyte, vsyscall 2 is located
- *  at virtual address -10Mbyte+1024bytes etc... There are at max 4
- *  vsyscalls. One vsyscall can reserve more than 1 slot to avoid
- *  jumping out of line if necessary. We cannot add more with this
- *  mechanism because older kernels won't return -ENOSYS.
+ *  There are exactly three vsyscalls.  vsyscall 0 is at -10Mbyte,
+ *  and vsyscalls 1 and 2 are 1024 and 2048 bytes past vsyscall 0.
+ *  We cannot (and do not want to) add more.
  *
  *  Note: the concept clashes with user mode linux.  UML users should
  *  use the vDSO.
@@ -107,29 +105,17 @@ static void warn_bad_vsyscall(const char *level, struct pt_regs *regs,
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
-void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
+static void emulate_vsyscall(struct pt_regs *regs, int nr,
+			     long (*vsys)(struct pt_regs *))
 {
 	struct task_struct *tsk;
 	unsigned long caller;
-	int vsyscall_nr;
 	long ret;
 
 	local_irq_enable();
 
+	trace_emulate_vsyscall(nr);
+
 	if (!user_64bit_mode(regs)) {
 		/*
 		 * If we trapped from kernel mode, we might as well OOPS now
@@ -140,50 +126,29 @@ void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
 
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
@@ -213,6 +178,45 @@ sigsegv:
 	local_irq_disable();
 }
 
+
+/*
+ * These are the actual vsyscall emulation entries.
+ */
+
+static long vsys_gettimeofday(struct pt_regs *regs)
+{
+	return  sys_gettimeofday(
+		(struct timeval __user *)regs->di,
+		(struct timezone __user *)regs->si);
+}
+
+void dotraplinkage do_emulate_vsyscall0(struct pt_regs *regs, long error_code)
+{
+	emulate_vsyscall(regs, 0, vsys_gettimeofday);
+}
+
+static long vsys_time(struct pt_regs *regs)
+{
+	return sys_time((time_t __user *)regs->di);
+}
+
+void dotraplinkage do_emulate_vsyscall1(struct pt_regs *regs, long error_code)
+{
+	emulate_vsyscall(regs, 1, vsys_time);
+}
+
+static long vsys_getcpu(struct pt_regs *regs)
+{
+	return sys_getcpu((unsigned __user *)regs->di,
+			  (unsigned __user *)regs->si,
+			  0);
+}
+
+void dotraplinkage do_emulate_vsyscall2(struct pt_regs *regs, long error_code)
+{
+	emulate_vsyscall(regs, 2, vsys_getcpu);
+}
+
 /*
  * Assume __initcall executes before all user space. Hopefully kmod
  * doesn't violate that. We'll find out if it does.
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

