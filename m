Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab2A0UV2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 15:21:28 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47745 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542Ab2A0UUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 15:20:34 -0500
X-Authority-Analysis: v=2.0 cv=fNy7LOme c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=8FJhGbST3WsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=oGMlB6cnAAAA:8 a=meVymXHHAAAA:8 a=nTqW6CzA5JgN1M89fUwA:9 a=-TvMK2KeZr-h3PyoLNUA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=CY6gl2JlH4YA:10 a=jeBq3FmKZ4MA:10 a=xHBOSaZc_I5vfqVi2gAA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120127202031.535429354@goodmis.org>
User-Agent: quilt/0.50-1
Date: Fri, 27 Jan 2012 15:14:45 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 3/5] x86/jump-label: Add safety checks to jump label conversions
References: <20120127201442.080360013@goodmis.org>
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
index 0f4c6ba..44f2528 100644
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
+			unsigned char default_nop[] =3D { JUMP_LABEL_INIT_NOP };
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

iQIcBAABAgAGBQJPIwcPAAoJEIy3vGnGbaoAJGsP/A2tA1h0swn+w9KHfiNNkfAY
L7lMsekLt8Z5Glv4rHG32PHLlcjVe+/xFZ9yTDHMixG9DtcpiDILWUv2Dc+ZZ9D3
JNtVNc4Flsfj2OB4uYZjVBz+odQ+K/1xF6ujGDxu9xvC/5vcIzAYkbh7qQyHwWqJ
1uhXWOymlfAklNa02Qo6J80jQarT0eAeKKTNRMp22Xr63/ZQEaJTJtpZBLbZ0QlB
aLj28pIM2Y7DdE9wUf2uX8wOHmRNoqH/wkZvUek0+V8M24Dm121T2yu3kGrioXXL
12ZsjMGGQDth4i9719PVvhhoffRIuESInfbPodWfZd3GPVIuqxLbZjCNO5QYRvUX
bwL31w6VTHk7E287HohO+/0wO0wEoQo90ItAIF5zst87swr1gbojX1ld6YYhihQX
oskU1vNGw+FzJvekF91Dpjg6SLUJKotWWnlurx0ciGDyyJZzSafmTEjOd5M67gLd
KxjqP0fI748GYFfBsZDi2G3UWF0KkYX5/LNuiOoOkWq7sPAw0ZhHwEYeCk3vqyo/
AherNmwHCz/GPJTYFwFAVs9ZTPqQ4/stJHchU21jV06ZhqVWuOoVKsGsElITJl28
a0Pjc5HJyojkhAL30chh0LsW/3RUT9HXAms5mUYNN0uR6qdK2qgkRQCmprGTMP+r
KHXHjum8+Y7sdX2XlR28
=8D4U
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
