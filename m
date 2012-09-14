Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab2INDDg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 23:03:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29837 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454Ab2INDCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 23:02:35 -0400
X-Authority-Analysis: v=2.0 cv=VPlfbqzX c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=mAZSS0CqBOAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=3d-f-Oou5mwA:10 a=3nbZYyFuAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=oGMlB6cnAAAA:8 a=Qq8FTLfLWGNYfXvcnDEA:9 a=QEXdDO2ut3YA:10 a=EvKJbDF4Ut8A:10 a=MSl-tDqOz04A:10 a=Zh68SRI7RUMA:10 a=CY6gl2JlH4YA:10 a=jeBq3FmKZ4MA:10 a=5Q2DmOMaCtWOoRoQ8tsA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20120914030232.685276785@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 13 Sep 2012 23:00:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH 4/6 v2] kprobes/x86: Fix kprobes to collectly handle IP on ftrace
References: <20120914030012.315074731@goodmis.org>
Content-Disposition: inline; filename=0004-kprobes-x86-Fix-kprobes-to-collectly-handle-IP-on-ft.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Current kprobe_ftrace_handler expects regs->ip =3D=3D ip, but it is
incorrect (originally on x86-64). Actually, ftrace handler sets
regs->ip =3D ip + MCOUNT_INSN_SIZE.
kprobe_ftrace_handler must take care for that.

Link: http://lkml.kernel.org/r/20120905143112.10329.72069.stgit@localhost.l=
ocaldomain

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/kprobes.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 47ae102..f49f60c 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -1072,7 +1072,8 @@ void __kprobes kprobe_ftrace_handler(unsigned long ip=
, unsigned long parent_ip,
 	if (kprobe_running()) {
 		kprobes_inc_nmissed_count(p);
 	} else {
-		regs->ip +=3D sizeof(kprobe_opcode_t);
+		/* Kprobe handler expects regs->ip =3D ip + 1 as breakpoint hit */
+		regs->ip =3D ip + sizeof(kprobe_opcode_t);
=20
 		__this_cpu_write(current_kprobe, p);
 		kcb->kprobe_status =3D KPROBE_HIT_ACTIVE;
@@ -1080,13 +1081,15 @@ void __kprobes kprobe_ftrace_handler(unsigned long =
ip, unsigned long parent_ip,
 			p->pre_handler(p, regs);
=20
 		if (unlikely(p->post_handler)) {
-			/* Emulate singlestep as if there is a 5byte nop */
+			/*
+			 * Emulate singlestep (and also recover regs->ip)
+			 * as if there is a 5byte nop
+			 */
 			regs->ip =3D ip + MCOUNT_INSN_SIZE;
 			kcb->kprobe_status =3D KPROBE_HIT_SSDONE;
 			p->post_handler(p, regs, 0);
 		}
 		__this_cpu_write(current_kprobe, NULL);
-		regs->ip =3D ip;	/* Recover for next callback */
 	}
 end:
 	local_irq_restore(flags);
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQUp5IAAoJEOdOSU1xswtMcZgH+wShqFoS217zWkTcDY9DW2/5
jQWM5AOM0/CpM/iUFBWneyuOhxe8d5Z0yEYtKqe2hKNQKzqkaKSuwYA1TpW5uanp
gGJo9oZKbU+StaIG34asWRUgAUGQWuUu2Q77OLBnE6hGtTl6f+Siyhe8pkejltFg
cw697e3q95yzCKXzG7Wb4p9ndhZkqkR0Hn6/G8GPFmim9WoFcj5CZq1Mk5BtKXbV
BCnObtLip2wB6dl2qa2tp1hH7XiE1XxkU5WJVOwqVM3LAsqYLWt1A97wlTaq9Q5m
PiFBrvpHH530m3p5DCvh5kUtOLrX1X8vdlsp9bZY27+FoejvRBRb3VXvwSAfKW4=
=lo3I
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
