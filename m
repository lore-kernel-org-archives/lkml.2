Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901Ab2CHWWI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 17:22:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22467 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758805Ab2CHWWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 17:22:03 -0500
X-Authority-Analysis: v=2.0 cv=Xp94yC59 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=TvPriwHZAZQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=oGMlB6cnAAAA:8 a=meVymXHHAAAA:8 a=VWnXU4kBQmB5lzw8e10A:9 a=M6zHii8pmiJdXllgSEsA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=CY6gl2JlH4YA:10 a=jeBq3FmKZ4MA:10 a=ESO1Ph9M-fK01yxY2uEA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120308222201.519221504@goodmis.org>
User-Agent: quilt/0.50-1
Date: Thu, 08 Mar 2012 17:17:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>
Subject: [PATCH 2/7] x86/jump-label: Do not bother updating nops if they are correct
References: <20120308221730.807074710@goodmis.org>
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
index 2889b3d..11cc4da 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -53,7 +53,25 @@ void arch_jump_label_transform(struct jump_entry *entry,
 __init_or_module void arch_jump_label_transform_static(struct jump_entry *=
entry,
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
+		const unsigned char default_nop[] =3D { STATIC_KEY_INIT_NOP };
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

iQIcBAABAgAGBQJPWTEJAAoJEIy3vGnGbaoASkAQAKFpbzFUOS7Cqty8cMe+JYbY
McZIOEhXSyhtpsA0Lobhgdc8UXIVnBxUjufULT/mTnWn9jKy8E0po5SmSO/BrLks
bV+XEnrpFRKGCvPTRlZ+dZswVUaTEp3d8DbIrsOnXZoWPYd5JpE5qCgeXEFX3bWJ
YzpWsy3CrQ6elehCwgncbrb2bgfUsauXAPvtlnK24+fnly3j5MLhynY2MpbHJqrn
GFIEfc4nYhWzRROFIM8dNxFdQlUx2RpY93x65WadNUKRyT4rKjnWjGDKmOiP7+kI
gQSa3Mi7qNwRtBAz+BfohLx66zLD488Zwjzi+pPFVLPotfj3MwnF7l5/ynhxRZJz
gn8Mldo8LMbXJAITOsDfi+R6YTC+M7dVcfWVZGUpjoWMxV7nRD3HsNJ+wobRBb4m
W3sfz/YB98bK9gBzKAqehMZamvYkw0SYJvrFB8+eUMOyHXrsoSiKkfSfqCrLsPst
tHaOnIHme3fH0S0jv7/UWhkoFwylzDR5FSOg7UcM4Ofwl7jSolVG/DA5u5DH2ZL7
pn5C9iJupcmPqG5Jhr0Tt9XdiDGzckHTZFiMhowp9VkPF6QhIZTT01tD+5/Q02bY
OSwAiaJI5WT7HeQtoWCKWFo9erj8/7rHVDLKv1G7HCFsUayWVNOs5nM/JzuiEYf+
fpHKvj9o3umABYhkT9VF
=1m77
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
