Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030202Ab1LPXHX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 18:07:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53603 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760972Ab1LPXGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 18:06:18 -0500
X-Authority-Analysis: v=2.0 cv=Z6Nu7QtA c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=LVG8-y8ILH4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=ayC55rCoAAAA:8 a=7d_E57ReAAAA:8 a=Z4Rwk6OoAAAA:8 a=JfrnYn6hAAAA:8 a=QyXUC8HyAAAA:8 a=1XWaLZrsAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=bjtyyEyAhk0x-LzI2ooA:9 a=YePrbjL4OOkhEfs5NS8A:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=D6-X0JM3zdQA:10 a=jbrJJM5MRmoA:10 a=3Rfx1nUSh_UA:10 a=Zh68SRI7RUMA:10 a=UTB_XpHje0EA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=Nk7NuooMRfPFSJTBXc8A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111216230617.544240425@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 16 Dec 2011 17:59:12 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andi Kleen <andi@firstfloor.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Paul Turner <pjt@google.com>
Subject: [PATCH 6/6] x86: Add counter when debug stack is used with interrupts enabled
References: <20111216225906.481643317@goodmis.org>
Content-Disposition: inline; filename=0006-x86-Add-counter-when-debug-stack-is-used-with-interr.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

Mathieu Desnoyers pointed out a case that can cause issues with
NMIs running on the debug stack:

  int3 -> interrupt -> NMI -> int3

Because the interrupt changes the stack, the NMI will not see that
it preempted the debug stack. Looking deeper at this case,
interrupts only happen when the int3 is from userspace or in
an a location in the exception table (fixup).

  userspace -> int3 -> interurpt -> NMI -> int3

All other int3s that happen in the kernel should be processed
without ever enabling interrupts, as the do_trap() call will
panic the kernel if it is called to process any other location
within the kernel.

Adding a counter around the sections that enable interrupts while
using the debug stack allows the NMI to also check that case.
If the NMI sees that it either interrupted a task using the debug
stack or the debug counter is non-zero, then it will have to
change the IDT table to make the int3 not change stacks (which will
corrupt the stack if it does).

Link: http://lkml.kernel.org/r/1323976535.23971.112.camel@gandalf.stny.rr.c=
om

Reported-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul Turner <pjt@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/processor.h |    4 ++++
 arch/x86/kernel/cpu/common.c     |   16 ++++++++++++++--
 arch/x86/kernel/traps.c          |   14 ++++++++++++++
 3 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/proces=
sor.h
index d748d1f..2fef5ba 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -402,6 +402,8 @@ DECLARE_PER_CPU(char *, irq_stack_ptr);
 DECLARE_PER_CPU(unsigned int, irq_count);
 extern unsigned long kernel_eflags;
 extern asmlinkage void ignore_sysret(void);
+void inc_debug_stack_usage(void);
+void dec_debug_stack_usage(void);
 int is_debug_stack(unsigned long addr);
 void zero_debug_stack(void);
 void reset_debug_stack(void);
@@ -420,6 +422,8 @@ struct stack_canary {
 DECLARE_PER_CPU_ALIGNED(struct stack_canary, stack_canary);
 #endif
 static inline int is_debug_stack(unsigned long addr) { return 0; }
+static inline void inc_debug_stack_usage(void) { }
+static inline void dec_debug_stack_usage(void) { }
 static inline void zero_debug_stack(void) { }
 static inline void reset_debug_stack(void) { }
 #endif	/* X86_64 */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 98faeff..f1ec612 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1093,11 +1093,23 @@ unsigned long kernel_eflags;
 DEFINE_PER_CPU(struct orig_ist, orig_ist);
=20
 static DEFINE_PER_CPU(unsigned long, debug_stack_addr);
+static DEFINE_PER_CPU(int, debug_stack_usage);
+
+void inc_debug_stack_usage(void)
+{
+	__get_cpu_var(debug_stack_usage)++;
+}
+
+void dec_debug_stack_usage(void)
+{
+	__get_cpu_var(debug_stack_usage)--;
+}
=20
 int is_debug_stack(unsigned long addr)
 {
-	return addr <=3D __get_cpu_var(debug_stack_addr) &&
-		addr > (__get_cpu_var(debug_stack_addr) - DEBUG_STKSZ);
+	return __get_cpu_var(debug_stack_usage) ||
+		(addr <=3D __get_cpu_var(debug_stack_addr) &&
+		 addr > (__get_cpu_var(debug_stack_addr) - DEBUG_STKSZ));
 }
=20
 void zero_debug_stack(void)
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index a93c5ca..d2510e7 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -316,9 +316,15 @@ dotraplinkage void __kprobes do_int3(struct pt_regs *r=
egs, long error_code)
 		return;
 #endif
=20
+	/*
+	 * Let others (NMI) know that the debug stack is in use
+	 * as we may switch to the interrupt stack.
+	 */
+	inc_debug_stack_usage();
 	preempt_conditional_sti(regs);
 	do_trap(3, SIGTRAP, "int3", regs, error_code, NULL);
 	preempt_conditional_cli(regs);
+	dec_debug_stack_usage();
 }
=20
 #ifdef CONFIG_X86_64
@@ -411,6 +417,12 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *=
regs, long error_code)
 							SIGTRAP) =3D=3D NOTIFY_STOP)
 		return;
=20
+	/*
+	 * Let others (NMI) know that the debug stack is in use
+	 * as we may switch to the interrupt stack.
+	 */
+	inc_debug_stack_usage();
+
 	/* It's safe to allow irq's after DR6 has been saved */
 	preempt_conditional_sti(regs);
=20
@@ -418,6 +430,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *r=
egs, long error_code)
 		handle_vm86_trap((struct kernel_vm86_regs *) regs,
 				error_code, 1);
 		preempt_conditional_cli(regs);
+		dec_debug_stack_usage();
 		return;
 	}
=20
@@ -437,6 +450,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *r=
egs, long error_code)
 	if (tsk->thread.debugreg6 & (DR_STEP | DR_TRAP_BITS) || user_icebp)
 		send_sigtrap(tsk, regs, error_code, si_code);
 	preempt_conditional_cli(regs);
+	dec_debug_stack_usage();
=20
 	return;
 }
--=20
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO687pAAoJEIy3vGnGbaoA3ysQAKcYdQJanWXP3+zAgea5xf4L
Oa/EXeeCVz6T5mqaZE46Dnk4BL++EK8eMWPLgQvVt74Rusj2R5aN2Atqg/uaQ3UR
Z1TvXBRokSQWXH6ek19iM5hIomQfs/T/U2CArBIkRTGrNBhcVy8/nNs/eRraGnQG
OkuKpKsrb7XLrT0GuujiEa0sULkbUumjn606xfRWejxTO9Fzd34h/WzvIv5kuY07
2dqryVnHEBzkk363s2WPDtfKuWQiIp3GRHSTDSBQWb56XDXSeAkC/i4KAu8NttOy
b6XGhxPYSEqT9ZNESC/xM13EvPUGE78AcdHygJE7Fcm5jIPhnfKssYktdMM+gC7G
epYp/rDI5WYXK8f1j7FK/b2I46HY/d9gEnCIzveiTgq9MLF+OIGQExC/40ZWcYNe
v9LDqsUxWJNEK1AgLLRiq0fy0i6VReV9DB+3qdYFKtorvpK0yAVPcf1qmn0L5vpF
ni1dYlGZJvvb9gcDSqEXFpE2OJ+NR/98tVdXagf1q6dk341DacNsuF3UplUAPa6H
p+LyiTE+cqHKcTl3VAT3o6G7OLDDtKYUBLpSaP6/5zuSpti6CLS5UHBUSmoIYRHc
+/wz43fSDNQKCtjzun2R+ISPzTKkwa0vE9qipHWKwc+c/swOnNuLMYai5fLmlWF/
NBM0r472b8XNFQB413Nl
=+iGX
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
