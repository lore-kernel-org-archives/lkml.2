Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab2INDET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 23:04:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22149 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223Ab2INDCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 23:02:34 -0400
X-Authority-Analysis: v=2.0 cv=C49rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=fTBKKdJEv-AA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=ZT-4DTZUx_YA:10 a=3nbZYyFuAAAA:8 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=pGLkceISAAAA:8 a=oGMlB6cnAAAA:8 a=GXSV7lqpVXBndYGrzy0A:9 a=QEXdDO2ut3YA:10 a=EvKJbDF4Ut8A:10 a=dGJ0OcVc7YAA:10 a=MSl-tDqOz04A:10 a=Zh68SRI7RUMA:10 a=CY6gl2JlH4YA:10 a=jeBq3FmKZ4MA:10 a=50yFv78JJ52fkCF8:21 a=uBIO9-YE8A-uEY6H:21 a=FkqNDYiwTG3_uuoYHAQA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20120914030233.080884371@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 13 Sep 2012 23:00:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH 6/6 v2] kprobes/x86: Fix to support jprobes on ftrace-based kprobe
References: <20120914030012.315074731@goodmis.org>
Content-Disposition: inline; filename=0006-kprobes-x86-Fix-to-support-jprobes-on-ftrace-based-k.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Fix kprobes/x86 to support jprobes on ftrace-based kprobes.
Because of -mfentry support of ftrace, ftrace is now put
on the beginning of function where jprobes are put.

Originally ftrace-based kprobes doesn't support jprobe
because it will change regs->ip and ftrace doesn't support
changing IP and ftrace itself doesn't conflict jprobe.
However, ftrace -mfentry support moves mcount call on the
top of functions where jprobes are put. This means that
jprobe always conflicts with ftrace-based kprobe and fails.

This patch allows ftrace-based kprobes to support jprobes
by allowing to modify regs->ip and kprobes breakpoint
handler also allows to skip singlestepping because there
is a ftrace call (not an original instruction).

Link: http://lkml.kernel.org/r/20120905143125.10329.90836.stgit@localhost.l=
ocaldomain

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/kprobes.c |   42 +++++++++++++++++++++++++++++-------------
 kernel/kprobes.c          |    3 ---
 2 files changed, 29 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index f49f60c..b7c2a85 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -541,6 +541,8 @@ reenter_kprobe(struct kprobe *p, struct pt_regs *regs, =
struct kprobe_ctlblk *kcb
 	return 1;
 }
=20
+static void __kprobes skip_singlestep(struct kprobe *p, struct pt_regs *re=
gs,
+				      struct kprobe_ctlblk *kcb);
 /*
  * Interrupts are disabled on entry as trap3 is an interrupt gate and they
  * remain disabled throughout this function.
@@ -599,6 +601,12 @@ static int __kprobes kprobe_handler(struct pt_regs *re=
gs)
 	} else if (kprobe_running()) {
 		p =3D __this_cpu_read(current_kprobe);
 		if (p->break_handler && p->break_handler(p, regs)) {
+#ifdef KPROBES_CAN_USE_FTRACE
+			if (kprobe_ftrace(p)) {
+				skip_singlestep(p, regs, kcb);
+				return 1;
+			}
+#endif
 			setup_singlestep(p, regs, kcb, 0);
 			return 1;
 		}
@@ -1053,6 +1061,21 @@ int __kprobes longjmp_break_handler(struct kprobe *p=
, struct pt_regs *regs)
 }
=20
 #ifdef KPROBES_CAN_USE_FTRACE
+static void __kprobes skip_singlestep(struct kprobe *p, struct pt_regs *re=
gs,
+				      struct kprobe_ctlblk *kcb)
+{
+	/*
+	 * Emulate singlestep (and also recover regs->ip)
+	 * as if there is a 5byte nop
+	 */
+	regs->ip =3D (unsigned long)p->addr + MCOUNT_INSN_SIZE;
+	if (unlikely(p->post_handler)) {
+		kcb->kprobe_status =3D KPROBE_HIT_SSDONE;
+		p->post_handler(p, regs, 0);
+	}
+	__this_cpu_write(current_kprobe, NULL);
+}
+
 /* Ftrace callback handler for kprobes */
 void __kprobes kprobe_ftrace_handler(unsigned long ip, unsigned long paren=
t_ip,
 				     struct ftrace_ops *ops, struct pt_regs *regs)
@@ -1077,19 +1100,12 @@ void __kprobes kprobe_ftrace_handler(unsigned long =
ip, unsigned long parent_ip,
=20
 		__this_cpu_write(current_kprobe, p);
 		kcb->kprobe_status =3D KPROBE_HIT_ACTIVE;
-		if (p->pre_handler)
-			p->pre_handler(p, regs);
-
-		if (unlikely(p->post_handler)) {
-			/*
-			 * Emulate singlestep (and also recover regs->ip)
-			 * as if there is a 5byte nop
-			 */
-			regs->ip =3D ip + MCOUNT_INSN_SIZE;
-			kcb->kprobe_status =3D KPROBE_HIT_SSDONE;
-			p->post_handler(p, regs, 0);
-		}
-		__this_cpu_write(current_kprobe, NULL);
+		if (!p->pre_handler || !p->pre_handler(p, regs))
+			skip_singlestep(p, regs, kcb);
+		/*
+		 * If pre_handler returns !0, it sets regs->ip and
+		 * resets current kprobe.
+		 */
 	}
 end:
 	local_irq_restore(flags);
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 35b4315..098f396 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1418,9 +1418,6 @@ static __kprobes int check_kprobe_address_safe(struct=
 kprobe *p,
 		/* Given address is not on the instruction boundary */
 		if ((unsigned long)p->addr !=3D ftrace_addr)
 			return -EILSEQ;
-		/* break_handler (jprobe) can not work with ftrace */
-		if (p->break_handler)
-			return -EINVAL;
 		p->flags |=3D KPROBE_FLAG_FTRACE;
 #else	/* !KPROBES_CAN_USE_FTRACE */
 		return -EINVAL;
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQUp5JAAoJEOdOSU1xswtMoy4IAIW3lN+K7DSQWXbLBY9bVBJd
EOPwbQlwH3I+i+owkXsQ2rzcQOmm19HfBtkHCJ4HBgU+wLIFcbRpPQRSc1RLLNAJ
W+6kEI9krnG5nYD5zr9AQrrtdMJQnPdt91IX6ndBMF/CLzkhMSRgD/zHD0qrt7cE
GaYtzY9lXLMxcBN3IS5K8yaf0Dn9MMdv23x8br+MBHd+ro2ijIsGDhh1Y2kvT86S
w2C906xkyUnVlE66tW9bIH66G8pG9YpkrHU9nTP4vHNbTF1PKCsjtgRMwMIlGESF
ZKC9OeMlKxHgNsILQLTmfirU6mNWG/wzAXUZTiS6MSBP0677Vz5c0BFP9XVy3yU=
=Abjv
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
