Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab1LVDUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 22:20:20 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37183 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717Ab1LVDT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 22:19:56 -0500
X-Authority-Analysis: v=2.0 cv=Pb19d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=jshO0eaZUDIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=ayC55rCoAAAA:8 a=7d_E57ReAAAA:8 a=Z4Rwk6OoAAAA:8 a=JfrnYn6hAAAA:8 a=QyXUC8HyAAAA:8 a=1XWaLZrsAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=JFrj-8ub1IdNfYPJg5EA:9 a=i8K03HYRVufQw0ERsoYA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=D6-X0JM3zdQA:10 a=jbrJJM5MRmoA:10 a=3Rfx1nUSh_UA:10 a=Zh68SRI7RUMA:10 a=UTB_XpHje0EA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=1-OUzYbhqPPHvMrkYEgA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111222031953.275570916@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 21 Dec 2011 22:14:03 -0500
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
Subject: [PATCH 6/6 v3] x86: Add counter when debug stack is used with interrupts enabled
References: <20111222031357.120841629@goodmis.org>
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

Note, I had to move the debug_usage functions out of processor.h
and into debugreg.h because of the static inlined functions to
inc and dec the debug_usage counter. __get_cpu_var() requires
smp.h which includes processor.h, and would fail to build.

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
 arch/x86/include/asm/debugreg.h  |   22 ++++++++++++++++++++++
 arch/x86/include/asm/processor.h |    6 ------
 arch/x86/kernel/cpu/common.c     |    6 ++++--
 arch/x86/kernel/traps.c          |   14 ++++++++++++++
 4 files changed, 40 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/debugreg.h b/arch/x86/include/asm/debugre=
g.h
index 078ad0c..b903d5e 100644
--- a/arch/x86/include/asm/debugreg.h
+++ b/arch/x86/include/asm/debugreg.h
@@ -101,6 +101,28 @@ extern void aout_dump_debugregs(struct user *dump);
=20
 extern void hw_breakpoint_restore(void);
=20
+#ifdef CONFIG_X86_64
+DECLARE_PER_CPU(int, debug_stack_usage);
+static inline void debug_stack_usage_inc(void)
+{
+	__get_cpu_var(debug_stack_usage)++;
+}
+static inline void debug_stack_usage_dec(void)
+{
+	__get_cpu_var(debug_stack_usage)--;
+}
+int is_debug_stack(unsigned long addr);
+void debug_stack_set_zero(void);
+void debug_stack_reset(void);
+#else /* !X86_64 */
+static inline int is_debug_stack(unsigned long addr) { return 0; }
+static inline void debug_stack_set_zero(void) { }
+static inline void debug_stack_reset(void) { }
+static inline void debug_stack_usage_inc(void) { }
+static inline void debug_stack_usage_dec(void) { }
+#endif /* X86_64 */
+
+
 #endif	/* __KERNEL__ */
=20
 #endif /* _ASM_X86_DEBUGREG_H */
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/proces=
sor.h
index 4b39d6d..b650435 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -402,9 +402,6 @@ DECLARE_PER_CPU(char *, irq_stack_ptr);
 DECLARE_PER_CPU(unsigned int, irq_count);
 extern unsigned long kernel_eflags;
 extern asmlinkage void ignore_sysret(void);
-int is_debug_stack(unsigned long addr);
-void debug_stack_set_zero(void);
-void debug_stack_reset(void);
 #else	/* X86_64 */
 #ifdef CONFIG_CC_STACKPROTECTOR
 /*
@@ -419,9 +416,6 @@ struct stack_canary {
 };
 DECLARE_PER_CPU_ALIGNED(struct stack_canary, stack_canary);
 #endif
-static inline int is_debug_stack(unsigned long addr) { return 0; }
-static inline void debug_stack_set_zero(void) { }
-static inline void debug_stack_reset(void) { }
 #endif	/* X86_64 */
=20
 extern unsigned int xstate_size;
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index caa4045..266e464 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1093,11 +1093,13 @@ unsigned long kernel_eflags;
 DEFINE_PER_CPU(struct orig_ist, orig_ist);
=20
 static DEFINE_PER_CPU(unsigned long, debug_stack_addr);
+DEFINE_PER_CPU(int, debug_stack_usage);
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
 void debug_stack_set_zero(void)
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index a93c5ca..0072b38 100644
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
+	debug_stack_usage_inc();
 	preempt_conditional_sti(regs);
 	do_trap(3, SIGTRAP, "int3", regs, error_code, NULL);
 	preempt_conditional_cli(regs);
+	debug_stack_usage_dec();
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
+	debug_stack_usage_inc();
+
 	/* It's safe to allow irq's after DR6 has been saved */
 	preempt_conditional_sti(regs);
=20
@@ -418,6 +430,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *r=
egs, long error_code)
 		handle_vm86_trap((struct kernel_vm86_regs *) regs,
 				error_code, 1);
 		preempt_conditional_cli(regs);
+		debug_stack_usage_dec();
 		return;
 	}
=20
@@ -437,6 +450,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *r=
egs, long error_code)
 	if (tsk->thread.debugreg6 & (DR_STEP | DR_TRAP_BITS) || user_icebp)
 		send_sigtrap(tsk, regs, error_code, si_code);
 	preempt_conditional_cli(regs);
+	debug_stack_usage_dec();
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

iQIcBAABAgAGBQJO8qHZAAoJEIy3vGnGbaoAICcQAKUuDJQs843XpJAm2ofbj1Nl
HAgp5Um6Cuxsf4gnVvevu/OyM0SGFY1TPWHPeUoVgZROI+YvR7CQkLD87Sd3dIiH
mIDCUr3A55DtQ7gGUREhlALZ47mQ0izviLSmPl3ZLBZkpFHhAIqUAyTPFN3rM8zT
aNGdB5YH0Slcb1zBn919tLhpppEGMkEfKTuUOi9hdcWINlUQUeBMcuKQPgvuEN0f
ZiQJPaup3DdD12n+mYraMh/dRKToVKR+T0Pmrmg2CbhaDEjgLxZj8NPLsZKTT2N3
sG0VFQXSZ96NGDmmeqtyeCuh638UyI/UsxDNbqorFPzSSuOSXvLweDjUsBi36Uwa
nUglc7nYDraZTSiQdy7fqQplU6YrCJ3sSYFtw9nkf9/jJlXw9wLMordRQSolVy+/
VK6F3v6XMYBmPRYW+fByHn6b0E7cmavBMFZaXjhgaU2mZ3U8+J2vlLc9WWpvH20K
P27JQgVuKi8gUwnszl3avmxpK6cZz49Em9lcidpd7HGvus5/BsMAnnUuyGp/OQrZ
GMI6fGy+oPp8Wb60nBfWgtWyPqUJwfLqgC+BGskNDX28xG/o85XjOGIRT0eOgqhi
VWPwkMw8utQUaV/SZN5uYeIi6zWmcX9yD9sXe2wvmTEWWyPQprUghbhmGly6DY1C
gdqeNgKjuKZfgpGgSN6a
=97DC
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
