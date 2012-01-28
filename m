Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab2A1QRQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 11:17:16 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64943 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab2A1QQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 11:16:30 -0500
X-Authority-Analysis: v=2.0 cv=MaXuSuDf c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=NIZu7Io4kigA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=oGMlB6cnAAAA:8 a=meVymXHHAAAA:8 a=nTqW6CzA5JgN1M89fUwA:9 a=-TvMK2KeZr-h3PyoLNUA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=CY6gl2JlH4YA:10 a=jeBq3FmKZ4MA:10 a=OkxHKZ0r-gJgZ73YemIA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120128161627.211742344@goodmis.org>
User-Agent: quilt/0.50-1
Date: Sat, 28 Jan 2012 11:09:28 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 3/5 v2] x86/jump-label: Add safety checks to jump label conversions
References: <20120128160925.275163704@goodmis.org>
Content-Disposition: inline; filename=0003-x86-jump-label-Add-safety-checks-to-jump-label-conve.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

As with all modifying of kernel text, we need to be very paranoid.

When converting the jump label locations to and from nops to jumps
a check has been added to make sure what we are replacing is what we
expect, otherwise we bug.

Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jason Baron <jbaron@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/jump_label.c |   32 ++++++++++++++++++++++++++++----
 1 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index cd42721..12a8812 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -26,16 +26,40 @@ union jump_code_union {
=20
 static void __jump_label_transform(struct jump_entry *entry,
 				   enum jump_label_type type,
-				   void *(*poker)(void *, const void *, size_t))
+				   void *(*poker)(void *, const void *, size_t),
+				   int init)
 {
 	union jump_code_union code;
+	const unsigned char *ideal_nop =3D ideal_nops[NOP_ATOMIC5];
=20
 	if (type =3D=3D JUMP_LABEL_ENABLE) {
+		/*
+		 * We are enabling this jump label. If it is not a nop
+		 * then something must have gone wrong.
+		 */
+		BUG_ON(memcmp((void *)entry->code, ideal_nop, 5) !=3D 0);
+
 		code.jump =3D 0xe9;
 		code.offset =3D entry->target -
 				(entry->code + JUMP_LABEL_NOP_SIZE);
-	} else
+	} else {
+		/*
+		 * We are disabling this jump label. If it is not what
+		 * we think it is, then something must have gone wrong.
+		 * If this is the first initialization call, then we
+		 * are converting the default nop to the ideal nop.
+		 */
+		if (init) {
+			const unsigned char default_nop[] =3D { JUMP_LABEL_INIT_NOP };
+			BUG_ON(memcmp((void *)entry->code, default_nop, 5) !=3D 0);
+		} else {
+			code.jump =3D 0xe9;
+			code.offset =3D entry->target -
+				(entry->code + JUMP_LABEL_NOP_SIZE);
+			BUG_ON(memcmp((void *)entry->code, &code, 5) !=3D 0);
+		}
 		memcpy(&code, ideal_nops[NOP_ATOMIC5], JUMP_LABEL_NOP_SIZE);
+	}
=20
 	(*poker)((void *)entry->code, &code, JUMP_LABEL_NOP_SIZE);
 }
@@ -45,7 +69,7 @@ void arch_jump_label_transform(struct jump_entry *entry,
 {
 	get_online_cpus();
 	mutex_lock(&text_mutex);
-	__jump_label_transform(entry, type, text_poke_smp);
+	__jump_label_transform(entry, type, text_poke_smp, 0);
 	mutex_unlock(&text_mutex);
 	put_online_cpus();
 }
@@ -71,7 +95,7 @@ void arch_jump_label_transform_static(struct jump_entry *=
entry,
 			update =3D 1;
 	}
 	if (update)
-		__jump_label_transform(entry, type, text_poke_early);
+		__jump_label_transform(entry, type, text_poke_early, 1);
 }
=20
 #endif
--=20
1.7.8.3



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPJB9bAAoJEIy3vGnGbaoAP5IQAOAFoYKhde/BBgDOUfXyuzqq
l5owOsxl9hlCh0ltElnyhZxqBgYT1Mk4l/LwROCIzdLbYZg+ISBIdKjDHjfxNUyz
r9CkkzGw6JJNsf3IuI7+wdO5NEAM3STz1AfZ6CqdI9v1i69jycLelqcJva/dwIQd
iCKQ5efiQduMfhAtbCkcJEAldH1PKnGCjVPjQc03tkAymYMkBq6lr9YWLgMT/4rd
qP3Yd2UpQ4jm4dNt5B68ecCHu2zCld3uxexjMBB5qfbdcDx/5PklYztGyc7pudEj
B+IRMXWAaztnqCTMbQE7CSqoz1/diGrMWSw78gZlUIQeAtC0VxHmRmFE2q7D30hR
xfus0CU3rvrdR2pSUQg6H4XGEpueP3dIpl8DKyxE4Vpiqmp0lWfJpRy1iQbsBe62
nI6IfaG/1L2nokfIzPH0z9p4QamKGXitexQek8jgMcAW+AKFvcEB1H8NX4Apdgpe
/SccbiFYtiGhSCNpBI/kx5nGbEzz5xSDGJk7zKLR9xM8EnAqfhgoi+ZjOEZmgc2n
+ouU35cr+pnha9LTEb85im+y9zwvmTnm/0md7KS80S2A7DBRcHonNm7u19oXN/RK
mQcTp52E+JpWHDFFuajzbMNPldxGiZWocOqrUg7V0AvzCO74GicXh5cdRuEjGo3B
1yl5TwwC81299kMVpBo7
=VpDe
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
