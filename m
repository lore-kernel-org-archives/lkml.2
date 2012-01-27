Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab2A0UUe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 15:20:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46619 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab2A0UUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 15:20:32 -0500
X-Authority-Analysis: v=2.0 cv=T9kOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=kD8KHFLvyJUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=oGMlB6cnAAAA:8 a=meVymXHHAAAA:8 a=VWnXU4kBQmB5lzw8e10A:9 a=M6zHii8pmiJdXllgSEsA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=CY6gl2JlH4YA:10 a=jeBq3FmKZ4MA:10 a=KAJi5KGweDojO8rZhcsA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120127202031.234193929@goodmis.org>
User-Agent: quilt/0.50-1
Date: Fri, 27 Jan 2012 15:14:44 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/5] x86/jump-label: Do not bother updating nops if they are correct
References: <20120127201442.080360013@goodmis.org>
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
index ea9d5f2f..0f4c6ba 100644
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
+		unsigned char default_nop[] =3D { JUMP_LABEL_INIT_NOP };
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

iQIcBAABAgAGBQJPIwcPAAoJEIy3vGnGbaoAb0YQAJmsGyn1sRm5S4otUK+Pu3vH
T/WfivyxXpP1uUvTJOXP7iKJT6rSXG7NYIugR1kpgQo2V/lEWPBjo4CgUofjdO6T
nBiS9aziqVLlJbusrwnwJzQMU5yNzRTnVVLitShd7sb/y/3KkdtBzd8/GcSu53Pl
fm4i7AC3Bh5DFCNL44UmVrf165l5MseSSqYLAuUW0cTLlFN0yc5IFBufilyby5zB
gZM4Moqcpl0Jz2/LT8llg92w9csdkUwj5B8UNCUKiRGk/W+XG558zlDqMsL17C4K
uVioa4R5JiR4/bh9zjDGnnZE7gKHqphgzAk8HRZb1lxeTU/Y0V6svRrmjyRpzeLf
VmLP0SMhg0i0PwD9Jh8WoVmT5Xsc9aLwV4H5uZ7aLxxNp/Kad9yv5wFVldxaH5DS
8BB1Xg45cvENschyolOjDDPrYk1dWEUre86Lq1AQbvenkQoTzR/1zK61b2H7r+fm
VJD2S/9Ws6E+H/MmM/rhBSt9fHcSFrEAZYfbRLLc8HHkF26Q8ZwlOvFTQHek3NG0
a+RV86L7nLbJgo+ElcjxZZs5Iz1GL7VWgGWphIWXfIr9As6/nSeWs0ZE9zqrmzA0
URE/5kzwXmedjS7FT4A33h84fp+IzbM84FjtLzx83pUGJvub+4apvSDf/uHOyfYO
YOYuSnekQjzvTDESS04T
=UdJV
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
