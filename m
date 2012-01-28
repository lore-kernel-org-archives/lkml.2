Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab2A1QRV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 11:17:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64943 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913Ab2A1QQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 11:16:29 -0500
X-Authority-Analysis: v=2.0 cv=MaXuSuDf c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=HvQodIuWcEkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=oGMlB6cnAAAA:8 a=meVymXHHAAAA:8 a=VWnXU4kBQmB5lzw8e10A:9 a=M6zHii8pmiJdXllgSEsA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=CY6gl2JlH4YA:10 a=jeBq3FmKZ4MA:10 a=njfJ2e0Jh8yaWINSjmMA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120128161626.898021193@goodmis.org>
User-Agent: quilt/0.50-1
Date: Sat, 28 Jan 2012 11:09:27 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/5 v2] x86/jump-label: Do not bother updating nops if they are correct
References: <20120128160925.275163704@goodmis.org>
Content-Disposition: inline; filename=0002-x86-jump-label-Do-not-bother-updating-nops-if-they-a.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Steven Rostedt <srostedt@redhat.com>

On boot up, the jump label init function scans all the jump label locations
and converts them to the best nop for the machine. If the nop is already
the ideal nop, do not bother with changing it.

Cc: Jason Baron <jbaron@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/jump_label.c |   20 +++++++++++++++++++-
 1 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index ea9d5f2f..cd42721 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -53,7 +53,25 @@ void arch_jump_label_transform(struct jump_entry *entry,
 void arch_jump_label_transform_static(struct jump_entry *entry,
 				      enum jump_label_type type)
 {
-	__jump_label_transform(entry, type, text_poke_early);
+	static int once;
+	static int update;
+
+	/*
+	 * This function is called at boot up and when modules are
+	 * first loaded. Check if the default nop, the one that is
+	 * inserted at compile time, is the ideal nop. If it is, then
+	 * we do not need to update the nop, and we can leave it as is.
+	 * If it is not, then we need to update the nop to the ideal nop.
+	 */
+	if (!once) {
+		const unsigned char default_nop[] =3D { JUMP_LABEL_INIT_NOP };
+		const unsigned char *ideal_nop =3D ideal_nops[NOP_ATOMIC5];
+		once++;
+		if (memcmp(ideal_nop, default_nop, 5) !=3D 0)
+			update =3D 1;
+	}
+	if (update)
+		__jump_label_transform(entry, type, text_poke_early);
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

iQIcBAABAgAGBQJPJB9aAAoJEIy3vGnGbaoAAjIQANzxKQwxkNp+sgMBkGuHzz0P
LAAY6bRQz/iZo/o4T926yXdTdlWQuOM2tJ7H0HWKLI4mrcmzW+tM+6Y66krQsCwy
CiZuZsKE1lkTHzhf/6OBCQDTp9q+0O5FCt2J7UteXDoQeydMxbgDSgaOXmuJ2qn1
vrSWCKcDyR8y7U48q2QOeVU9B/zRSkgj/iVpGEl7osKVWTcSvLwzL8yY9bC6ZGC7
uCcRDhRfaQ6WYV0zDcmluWLHBQ9OHCidn/PjL22nfkzhu91JgeFxPAboUGYzjPWM
jh1tuRcORovsvUP4+2tP1EwuSArhnpfHCfU3vL9s5HlZmEOrz/PogK7/T0yzbJ70
NerCYd7AJLGWoM99xQB2zeIB/YC8yStr9eHqb5QWnwXa1Z1WxokZPQ7MGfYLBX41
KMkcQsbLFLb5Tqj0vWqs/RIj9x6MFrPCJVvYuhUx2jKqR/xKStgBujyVlUUldbZh
E6ZbcDb4pX0ra/5gUZ+kgJI9I6sY6nRa+Aok/aJGkPwVf1ZD79GDgR82UJlNExD+
WqhpYoqBEUMu4FpEf1LbDPuOJAW1FwrRhU1HUqUmeFtbm63jLWeO9LtyoMAaD8Wk
2KAugb+4UirHBTGceZpWmvo++1XghdK9wXuFckydy9qsxmPrkHC9ouz4YGTjRcFg
0pbVVnXfO8WbyLPSMRfl
=h9xl
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
