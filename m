Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab1LVDUP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 22:20:15 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:51590 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468Ab1LVDT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 22:19:57 -0500
X-Authority-Analysis: v=2.0 cv=SqgSGYy0 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=D-BQp-kph3UA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=Z4Rwk6OoAAAA:8 a=JfrnYn6hAAAA:8 a=QyXUC8HyAAAA:8 a=1XWaLZrsAAAA:8 a=pGLkceISAAAA:8 a=7d_E57ReAAAA:8 a=meVymXHHAAAA:8 a=Cptyo3eXLKIAm20J6WMA:9 a=T9OKp7xno0g6nnxLbVIA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=jbrJJM5MRmoA:10 a=3Rfx1nUSh_UA:10 a=Zh68SRI7RUMA:10 a=UTB_XpHje0EA:10 a=MSl-tDqOz04A:10 a=D6-X0JM3zdQA:10 a=jeBq3FmKZ4MA:10 a=0lG8U-ic6zNqz5Yq:21 a=w_VY6Y8DAxVXfO3Z:21 a=csd4aKSQPMI5L0qoYCAA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111222031952.609832586@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 21 Dec 2011 22:14:02 -0500
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
Subject: [PATCH 5/6 v3] x86: Allow NMIs to hit breakpoints in i386
References: <20111222031357.120841629@goodmis.org>
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
 arch/x86/kernel/nmi.c |  101 +++++++++++++++++++++++++++++++++++++++++++++=
---
 1 files changed, 94 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index de8d4b3..47acaf3 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -405,11 +405,84 @@ static notrace __kprobes void default_do_nmi(struct p=
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
+#define nmi_nesting_preprocess(regs)					\
+	do {								\
+		if (__get_cpu_var(nmi_state) !=3D NMI_NOT_RUNNING) {	\
+			__get_cpu_var(nmi_state) =3D NMI_LATCHED;		\
+			return;						\
+		}							\
+	nmi_restart:							\
+		__get_cpu_var(nmi_state) =3D NMI_EXECUTING;		\
+	} while (0)
+
+#define nmi_nesting_postprocess()					\
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
+static inline void nmi_nesting_preprocess(struct pt_regs *regs)
+{
 	/*
 	 * If we interrupted a breakpoint, it is possible that
 	 * the nmi handler will have breakpoints too. We need to
@@ -418,8 +491,22 @@ do_nmi(struct pt_regs *regs, long error_code)
 	 */
 	if (unlikely(is_debug_stack(regs->sp))) {
 		debug_stack_set_zero();
-		update_debug_stack =3D 1;
+		__get_cpu_var(update_debug_stack) =3D 1;
 	}
+}
+
+static inline void nmi_nesting_postprocess(void)
+{
+	if (unlikely(__get_cpu_var(update_debug_stack)))
+		debug_stack_reset();
+}
+#endif
+
+dotraplinkage notrace __kprobes void
+do_nmi(struct pt_regs *regs, long error_code)
+{
+	nmi_nesting_preprocess(regs);
+
 	nmi_enter();
=20
 	inc_irq_stat(__nmi_count);
@@ -429,8 +516,8 @@ do_nmi(struct pt_regs *regs, long error_code)
=20
 	nmi_exit();
=20
-	if (unlikely(update_debug_stack))
-		debug_stack_reset();
+	/* On i386, may loop back to preprocess */
+	nmi_nesting_postprocess();
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

iQIcBAABAgAGBQJO8qHYAAoJEIy3vGnGbaoA6zAQALYHyjF8xnh16ixwaboQ+Cea
K5+INTwaAtoYavvC5LAH6GdcDm5HlFplWGuwuXxRuHSI4wvflU/mkf9W0M2EI/Ox
eh6XBC+xxUClGSTIhpzWfBZKb3M24eKRrAHTbcGb98yJUuTUbPMN1OTagAfjiHEh
XA09nfg+NMII8nUzba+QLSbV1TfQ0Qo5QeSpmal3dOa64PBPJuNlw5VEFeT0Lyii
Bx7zOpPFEq+JFkZyGiFgNLdFFpMw8taRUk2L1YenxZyeqjoQED8B3I+I1URdGyrY
ZimYbbiwp+BmN995//wS088zEmVJRUf6Dy7IUbOGs5D6L2zILhb10b/v3DYl2TRH
RowHMQFFISmwGBNB6szJODAzWkqgaxfdlWV2lFuz90WxgC07c76oVE7kxB/DQzPb
NISIJ9NWvRqoQ9sSIwB0NOZaWDBa870RK2UKdHOYmfEOQJG1arJbBgF1+4pKvJni
mDj9Gsz2ncSb/zTVHK+xX6hqQUnrpcC7Lwn65f8ojHAxtCSICxpCuqH6VlMp3jKo
exxrCIFmaQtGIlaQi/cbNGiyIzqwVE6Vfeo1S2Mvt2bNkc/jm4QqUD8QLIg7kOyq
kjZz3IRX5VN3ko9Am2Vg/OUhcm+H1LSPv0kXeArrw+FwNU6pE9oacvFbrwPpaYbB
/BGHf/41DVQbnDX7A2F+
=YPdB
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
