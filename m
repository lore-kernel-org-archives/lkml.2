Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760404Ab1LPXHH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 18:07:07 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46965 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760981Ab1LPXGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 18:06:24 -0500
X-Authority-Analysis: v=2.0 cv=FIuZNpUs c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=scKMFu31ESQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=Z4Rwk6OoAAAA:8 a=JfrnYn6hAAAA:8 a=QyXUC8HyAAAA:8 a=1XWaLZrsAAAA:8 a=pGLkceISAAAA:8 a=7d_E57ReAAAA:8 a=meVymXHHAAAA:8 a=r6tlpdmizkw4SpTRxM4A:9 a=pmeH6dRcdzFXV19EwPMA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jbrJJM5MRmoA:10 a=3Rfx1nUSh_UA:10 a=Zh68SRI7RUMA:10 a=UTB_XpHje0EA:10 a=MSl-tDqOz04A:10 a=D6-X0JM3zdQA:10 a=jeBq3FmKZ4MA:10 a=00VAB27iOpDD2gO3:21 a=xXETSA8P2YTXNwkd:21 a=64jVXc2MIfLKrbZ5BGsA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111216230616.771089182@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 16 Dec 2011 17:59:11 -0500
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
Subject: [PATCH 5/6] x86: Allow NMIs to hit breakpoints in i386
References: <20111216225906.481643317@goodmis.org>
Content-Disposition: inline; filename=0005-x86-Allow-NMIs-to-hit-breakpoints-in-i386.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

With i386, NMIs and breakpoints use the current stack and they
do not reset the stack pointer to a fix point that might corrupt
a previous NMI or breakpoint (as it does in x86_64). But NMIs are
still not made to be re-entrant, and need to prevent the case that
an NMI hitting a breakpoint (which does an iret), doesn't allow
another NMI to run.

The fix is to let the NMI be in 3 different states:

1) not running
2) executing
3) latched

When no NMI is executing on a given CPU, the state is "not running".
When the first NMI comes in, the state is switched to "executing".
On exit of that NMI, a cmpxchg is performed to switch the state
back to "not running" and if that fails, the NMI is restarted.

If a breakpoint is hit and does an iret, which re-enables NMIs,
and another NMI comes in before the first NMI finished, it will
detect that the state is not in the "not running" state and the
current NMI is nested. In this case, the state is switched to "latched"
to let the interrupted NMI know to restart the NMI handler, and
the nested NMI exits without doing anything.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul Turner <pjt@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/nmi.c |  100 +++++++++++++++++++++++++++++++++++++++++++++=
---
 1 files changed, 93 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index fb86773..f670295 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -404,11 +404,84 @@ static notrace __kprobes void default_do_nmi(struct p=
t_regs *regs)
 		unknown_nmi_error(reason, regs);
 }
=20
-dotraplinkage notrace __kprobes void
-do_nmi(struct pt_regs *regs, long error_code)
-{
-	int update_debug_stack =3D 0;
+/*
+ * NMIs can hit breakpoints which will cause it to lose its
+ * NMI context with the CPU when the breakpoint does an iret.
+ */
+#ifdef CONFIG_X86_32
+/*
+ * For i386, NMIs use the same stack as the kernel, and we can
+ * add a workaround to the iret problem in C. Simply have 3 states
+ * the NMI can be in.
+ *
+ *  1) not running
+ *  2) executing
+ *  3) latched
+ *
+ * When no NMI is in progress, it is in the "not running" state.
+ * When an NMI comes in, it goes into the "executing" state.
+ * Normally, if another NMI is triggered, it does not interrupt
+ * the running NMI and the HW will simply latch it so that when
+ * the first NMI finishes, it will restart the second NMI.
+ * (Note, the latch is binary, thus multiple NMIs triggering,
+ *  when one is running, are ignored. Only one NMI is restarted.)
+ *
+ * If an NMI hits a breakpoint that executes an iret, another
+ * NMI can preempt it. We do not want to allow this new NMI
+ * to run, but we want to execute it when the first one finishes.
+ * We set the state to "latched", and the first NMI will perform
+ * an cmpxchg on the state, and if it doesn't successfully
+ * reset the state to "not running" it will restart the next
+ * NMI.
+ */
+enum nmi_states {
+	NMI_NOT_RUNNING,
+	NMI_EXECUTING,
+	NMI_LATCHED,
+};
+static DEFINE_PER_CPU(enum nmi_states, nmi_state);
+
+#define nmi_preprocess(regs)						\
+	do {								\
+		if (__get_cpu_var(nmi_state) !=3D NMI_NOT_RUNNING) {	\
+			__get_cpu_var(nmi_state) =3D NMI_LATCHED;		\
+			return;						\
+		}							\
+	nmi_restart:							\
+		__get_cpu_var(nmi_state) =3D NMI_EXECUTING;		\
+	} while (0)
+
+#define nmi_postprocess()						\
+	do {								\
+		if (cmpxchg(&__get_cpu_var(nmi_state),			\
+		    NMI_EXECUTING, NMI_NOT_RUNNING) !=3D NMI_EXECUTING)	\
+			goto nmi_restart;				\
+	} while (0)
+#else /* x86_64 */
+/*
+ * In x86_64 things are a bit more difficult. This has the same problem
+ * where an NMI hitting a breakpoint that calls iret will remove the
+ * NMI context, allowing a nested NMI to enter. What makes this more
+ * difficult is that both NMIs and breakpoints have their own stack.
+ * When a new NMI or breakpoint is executed, the stack is set to a fixed
+ * point. If an NMI is nested, it will have its stack set at that same
+ * fixed address that the first NMI had, and will start corrupting the
+ * stack. This is handled in entry_64.S, but the same problem exists with
+ * the breakpoint stack.
+ *
+ * If a breakpoint is being processed, and the debug stack is being used,
+ * if an NMI comes in and also hits a breakpoint, the stack pointer
+ * will be set to the same fixed address as the breakpoint that was
+ * interrupted, causing that stack to be corrupted. To handle this case,
+ * check if the stack that was interrupted is the debug stack, and if
+ * so, change the IDT so that new breakpoints will use the current stack
+ * and not switch to the fixed address. On return of the NMI, switch back
+ * to the original IDT.
+ */
+static DEFINE_PER_CPU(int, update_debug_stack);
=20
+static inline void nmi_preprocess(struct pt_regs *regs)
+{
 	/*
 	 * If we interrupted a breakpoint, it is possible that
 	 * the nmi handler will have breakpoints too. We need to
@@ -417,8 +490,22 @@ do_nmi(struct pt_regs *regs, long error_code)
 	 */
 	if (unlikely(is_debug_stack(regs->sp))) {
 		zero_debug_stack();
-		update_debug_stack =3D 1;
+		__get_cpu_var(update_debug_stack) =3D 1;
 	}
+}
+
+static inline void nmi_postprocess(void)
+{
+	if (unlikely(__get_cpu_var(update_debug_stack)))
+		reset_debug_stack();
+}
+#endif
+
+dotraplinkage notrace __kprobes void
+do_nmi(struct pt_regs *regs, long error_code)
+{
+	nmi_preprocess(regs);
+
 	nmi_enter();
=20
 	inc_irq_stat(__nmi_count);
@@ -428,8 +515,7 @@ do_nmi(struct pt_regs *regs, long error_code)
=20
 	nmi_exit();
=20
-	if (unlikely(update_debug_stack))
-		reset_debug_stack();
+	nmi_postprocess();
 }
=20
 void stop_nmi(void)
--=20
1.7.7.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO687pAAoJEIy3vGnGbaoAQ8AQAK3StucHsYJ5TIOR+nvq5OYb
/Gay1Da5moo7aPvC2+RGe7WjRmx6RlSjChEiXjasKN7FdVV44x5E/lxFRLhgs9qd
j1iLVGfWzJHJdQK2IdEr3fr/h2MaoL9mAWrhnqSN8YUEhug2AgNu9sdO7sMizznS
I4ehQBnBDsH7K68yzuao/bvBVnIICSMp6FzgJRCKyP4GjA4veXPuYZYlmfgjY5em
Ci0tJHfDxT40+8hd4PXpsCv9IMSsfJ+p9Z4CF2NJ7I80qYrnfUWBYYGO0F+9sXVG
87ENV/kOeVnCt9Qbs2TkbaKMYXEvZkIFg24Tch/lU+PuJBO74/Gx0dL6ljWV3YPJ
0EG9ChPbIMCPYvvOulyQFmT04hTm/7TH08nZCqv/h947o+13rC30Ei2iiRJ1QKHx
dksB7ivabQwVwTycWBaj7aAi9ztiCmH8tW/HoEZf4UOzsCiiOWxoSFhESFCdHnu9
jnEDaNL7CE0oJc4R+Vxd/A3Bc5s1uZy86m8QnwR2XqALfLPD36DO4K1zGB4VVm3Z
WUDSv8pWH5+yeQwMvbP4g0K/kpNk/bFocma1u+Mc6cwAo55C2kLpUH0jicPbQQPT
wjpTwP06mEVbEypCsMOd3Lw+UWSVAf97/ld9a4xnHFVG8K3GSPTv+8nOODOmKgAt
JdDTJooyBWvWQuUtU+VX
=q2hf
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
