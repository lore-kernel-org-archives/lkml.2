Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268Ab1HIO2X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 10:28:23 -0400
Received: from DMZ-MAILSEC-SCANNER-5.MIT.EDU ([18.7.68.34]:62219 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752018Ab1HIO2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 10:28:20 -0400
X-AuditID: 12074422-b7ba7ae000000a14-b9-4e4143f566b8
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: Andy Lutomirski <luto@MIT.EDU>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, lueckintel@yahoo.com,
        kimwooyoung@gmail.com, Ingo Molnar <mingo@elte.hu>,
        Borislav Petkov <bp@alien8.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 1/4] x86-64: Allow emulated vsyscalls from user addresses
Date: Tue,  9 Aug 2011 10:27:47 -0400
Message-Id: <135b827ce7b4e6059f11de631ea4a455e2b433be.1312899174.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1312899174.git.luto@mit.edu>
References: <cover.1312899174.git.luto@mit.edu>
In-Reply-To: <cover.1312899174.git.luto@mit.edu>
References: <cover.1312899174.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJKsWRmVeSWpSXmKPExsUixCmqrfvV2dHPYOFDBYu+K0fZLY5c+85u
	8XnDPzaLaRvFLV79Kbe4vGsOm8WK852sFlsuNbNa/Gu6xWLxqO8tu8WPDY9ZHbg9vrf2sXjc
	avvD7DF/50dGj52z7rJ7LN7zkslj06pONo8TM36zeHzeJOcxa9ZhJo8TLV9YA7iiuGxSUnMy
	y1KL9O0SuDLuXN7BVnAqoeLN/J2MDYyN/l2MHBwSAiYS11ezdjFyApliEhfurWcDsYUE9jFK
	3N+S1MXIBWSvZ5R4vG82O4TzlEni0JTVjCBVbAIqEh1LHzCBDBIREJJYercOpIYZpKZ5zm5m
	kBphAU+JVzN2M4HYLAKqEgdXvgbr5RUIkvj+r48RYrOcxJHLz8FqOAUMJH58vssEcYW+xPoT
	F3GKT2AUWMDIsIpRNiW3Sjc3MTOnODVZtzg5MS8vtUjXVC83s0QvNaV0EyMoBthdlHYw/jyo
	dIhRgINRiYeXk9/BT4g1say4MvcQoyQHk5IorxkwgoT4kvJTKjMSizPii0pzUosPMUpwMCuJ
	8KZrAOV4UxIrq1KL8mFS0hwsSuK8XDuBJgmkJ5akZqemFqQWwWRlODiUJHj9QIYKFqWmp1ak
	ZeaUIKSZODhBhvMADa9yAhleXJCYW5yZDpE/xagoJc4bBdIsAJLIKM2D64WlqFeM4kCvCPPq
	g1TxANMbXPcroMFMQIPr7ziADC5JREhJNTDahZnyqsVE5fNvTwtwcUz6wM191tuIZ+mDFq2P
	vhe4A9h59bfa/brpZjvt/NkXto2r5aUux/yM+/xUjSnSdnVJ3PKjEnEVP4xKLPl+vbOZK+7z
	wzw7ppmxN85gi73QtYo7Uc83JBUHyOmqvc/5mMhhfM152p2XelHq9z39/UIbp3v/Xmk0XYml
	OCPRUIu5qDgRAMDwUPosAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few dynamic recompilation tools are too clever for their own good.
They trace control flow through the vsyscall page and recompile that
code somewhere else.  Then they expect it to work.  DynamoRIO
(http://dynamorio.org/) and supposedly Pin (http://www.pintool.org/) are
affected.  They crash when tracing programs that use vsyscalls.
Valgrind is smart enough not to cause problems.  It crashes on the
getcpu vsyscall, but that has nothing to do with emulation.

This patch makes each of the three vsyscall entries use a different
vector so that they can work when relocated.  It assumes that the code
that relocates them is okay with the int instruction acting like ret.
DynamoRIO at least appears to work.  Pin is untestable because it can't
handle Linux version 3.0+.

We print an obnoxious (rate-limited) message to the log when this
happens.  Hopefully it will inspire the JIT tools to learn not to
trace into kernel address space.

Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Andy Lutomirski <luto@mit.edu>
---

Suresh: can you comment on whether interrupt vectors 0x40-0x42
are good choices?

 arch/x86/include/asm/irq_vectors.h |   11 ++--
 arch/x86/include/asm/traps.h       |    8 ++-
 arch/x86/kernel/entry_64.S         |    4 +-
 arch/x86/kernel/traps.c            |   14 +++-
 arch/x86/kernel/vsyscall_64.c      |  128 ++++++++++++++++++-----------------
 arch/x86/kernel/vsyscall_emu_64.S  |    6 +-
 6 files changed, 95 insertions(+), 76 deletions(-)

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
index 93a0d46..36259be 100644
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
@@ -90,7 +88,7 @@ void update_vsyscall(struct timespec *wall_time, struct timespec *wtm,
 	write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);
 }
 
-static void warn_bad_vsyscall(const char *level, struct pt_regs *regs,
+static void warn_bad_vsyscall(const char *level, struct pt_regs *regs, int nr,
 			      const char *message)
 {
 	static DEFINE_RATELIMIT_STATE(rs, DEFAULT_RATELIMIT_INTERVAL, DEFAULT_RATELIMIT_BURST);
@@ -101,35 +99,23 @@ static void warn_bad_vsyscall(const char *level, struct pt_regs *regs,
 
 	tsk = current;
 
-	printk("%s%s[%d] %s ip:%lx cs:%lx sp:%lx ax:%lx si:%lx di:%lx\n",
+	printk("%s%s[%d] %s nr: %d ip:%lx cs:%lx sp:%lx ax:%lx si:%lx di:%lx\n",
 	       level, tsk->comm, task_pid_nr(tsk),
-	       message, regs->ip - 2, regs->cs,
+	       message, nr, regs->ip - 2, regs->cs,
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
@@ -139,51 +125,30 @@ void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
 		BUG_ON(!user_mode(regs));
 
 		/* Compat mode and non-compat 32-bit CS should both segfault. */
-		warn_bad_vsyscall(KERN_WARNING, regs,
-				  "illegal int 0xcc from 32-bit mode");
+		warn_bad_vsyscall(KERN_WARNING, regs, nr,
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
-		warn_bad_vsyscall(KERN_WARNING, regs, "int 0xcc with bad stack (exploit attempt?)");
+		warn_bad_vsyscall(KERN_WARNING, regs, nr,
+				  "emulated vsyscall with bad stack (exploit attempt?)");
 		goto sigsegv;
 	}
 
-	tsk = current;
-	if (seccomp_mode(&tsk->seccomp))
-		do_exit(SIGKILL);
+	/*
+	 * x86-ism here: regs->ip points to the instruction after the int,
+	 * and the int instruction is two bytes long.
+	 */
+	if (((regs->ip - 2) & ~0xfff) != VSYSCALL_START)
+		warn_bad_vsyscall(KERN_WARNING, regs, nr,
+				  "emulated vsyscall from bogus address -- fix your code");
 
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
@@ -193,7 +158,7 @@ void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
 		 * To make writing reliable exploits using the emulated
 		 * vsyscalls harder, generate SIGSEGV here as well.
 		 */
-		warn_bad_vsyscall(KERN_INFO, regs,
+		warn_bad_vsyscall(KERN_INFO, regs, nr,
 				  "vsyscall fault (exploit attempt?)");
 		goto sigsegv;
 	}
@@ -208,11 +173,50 @@ void dotraplinkage do_emulate_vsyscall(struct pt_regs *regs, long error_code)
 	return;
 
 sigsegv:
-	regs->ip -= 2;  /* The faulting instruction should be the int 0xcc. */
+	regs->ip -= 2;  /* The faulting instruction should be the int. */
 	force_sig(SIGSEGV, current);
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

