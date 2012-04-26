Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab2DZCiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 22:38:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10757 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab2DZChL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 22:37:11 -0400
X-Authority-Analysis: v=2.0 cv=MNHiabll c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=MKhmbQqpU8YA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=3nbZYyFuAAAA:8 a=meVymXHHAAAA:8 a=sJhoW3mGIMxpGeSBRGIA:9 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=w0Z8DbZOQiBoDkZM:21 a=2PTJiWK5wDtiKLcn:21 a=6IFf4U8bVk5jMhbsQwkA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120426023708.577576476@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 25 Apr 2012 22:29:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 6/6][RFC] kprobes: Allow probe on ftrace reserved text (but move it)
References: <20120426022922.683707508@goodmis.org>
Content-Disposition: inline; filename=0006-kprobes-Allow-probe-on-ftrace-reserved-text-but-move.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

If a probe is placed on a ftrace nop (or ftrace_caller), simply move the
probe to the next instruction instead of rejecting it. This will allow
kprobes not to be affected by ftrace using the -mfentry gcc option which
will put the ftrace nop at the beginning of the function. As a very common
case for kprobes is to add a probe to the very beginning of a function
we need a way to handle the case when ftrace takes the first instruction.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/kprobes.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index c62b854..560d80e 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1319,10 +1319,20 @@ int __kprobes register_kprobe(struct kprobe *p)
 	struct kprobe *old_p;
 	struct module *probed_mod;
 	kprobe_opcode_t *addr;
+	unsigned long ftrace_addr;
=20
 	addr =3D kprobe_addr(p);
 	if (IS_ERR(addr))
 		return PTR_ERR(addr);
+
+	/*
+	 * If the address is located on a ftrace nop, set the
+	 * breakpoint to the following instruction.
+	 */
+	ftrace_addr =3D ftrace_location((unsigned long)addr);
+	if (unlikely(ftrace_addr))
+		addr =3D (kprobe_opcode_t *)(ftrace_addr + MCOUNT_INSN_SIZE);
+
 	p->addr =3D addr;
=20
 	ret =3D check_kprobe_rereg(p);
@@ -1333,7 +1343,6 @@ int __kprobes register_kprobe(struct kprobe *p)
 	preempt_disable();
 	if (!kernel_text_address((unsigned long) p->addr) ||
 	    in_kprobes_functions((unsigned long) p->addr) ||
-	    ftrace_text_reserved(p->addr, p->addr) ||
 	    jump_label_text_reserved(p->addr, p->addr)) {
 		ret =3D -EINVAL;
 		goto cannot_probe;
--=20
1.7.9.5



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPmLTUAAoJEIy3vGnGbaoAYCsQAMATtkO0JZSUF/tteHf+9qXU
MkVoOFuBl9GJuoRAi+2iWfTjy6H8njhvrsAtSq8I0pUsSSdyVL8bYNMn31VhgUqs
FbFONNuR2qNIbSUtTZHd3DYlYdXFyJnzysb4IPPhnzD8FTV4mjr5r+Ou/UnGbXGb
NJ3cHAyLe/DWIxR27c83QgNNs1rtkDpYSx8YOlgNOWgKXg6x5Mw9ggs5lyN/seR+
ODCUVJPp0tsVeLi44S6boK8jUXv6CprTGvivo7nZEUb0TXCUrqIDankZos1a7Jy9
jf6zYkIIHfFYNvLWKAiGzEzd/FDUIC0Ri0rfKmLfKKRtbhZE9Ae3wgUr34qnevw8
P6w2CIgf2nIjqlIjfXod4gsTCpBArrRDA4r/ar4mg/EDivZfle+rLAQHbDPEeiPp
bRqwqgNxKG9HMxUwRxHFbhsbT+32tx1qCqn1GBYmu+dJMrOYQTmE7nFuJJe5c6Aj
IemO/LNkyoo+UqSWoHtuDKxdsoxlhZ2/0+FCrGBgXXqNh01O6SZqjuCGfGVtO2WJ
VcMvHHTCCJKUYn0WUSQ5BJgkg7BlxutobACzkEUEkIyOoEg1OKuYvBiwOvCOMpqY
PSYm7QNUQRUexAcg8T1V7TA1CistDsKlgJVmTP9t1VsiOT5ZpYjAG+gLfss0r9+7
uRv6bCEv2X/s77tyu2Lh
=kgXr
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
