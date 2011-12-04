Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab1LDTCt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 14:02:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:42201 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350Ab1LDTAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 14:00:16 -0500
X-Authority-Analysis: v=2.0 cv=bdLpoZzB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=ZtGVN2OOP-4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=zd2uoN0lAAAA:8 a=20KFwNOVAAAA:8 a=aOgMwHPKE6SdTuoaAKAA:9 a=QEXdDO2ut3YA:10 a=wu_e27o_rKQA:10 a=jEp0ucaQiEUA:10 a=jAM28HPp8GYOk3RgS_MA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111204190013.224839960@goodmis.org>
User-Agent: quilt/0.48-1
Date: Sun, 04 Dec 2011 13:54:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Andre Przywara <andre.przywara@amd.com>, Avi Kivity <avi@redhat.com>
Subject: [PATCH 05/11] KVM: fix XSAVE bit scanning (now properly)
References: <20111204185444.411298317@goodmis.org>
Content-Disposition: inline; filename=0005-KVM-fix-XSAVE-bit-scanning-now-properly.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Andre Przywara <andre.przywara@amd.com>

commit 123108f1c1aafd51d6a5c79cc04d7999dd88a930 tried to fix KVMs
XSAVE valid feature scanning, but it was wrong. It was not considering
the sparse nature of this bitfield, instead reading values from
uninitialized members of the entries array.
This patch now separates subleaf indicies from KVM's array indicies
and fills the entry before querying it's value.
This fixes AVX support in KVM guests.

Signed-off-by: Andre Przywara <andre.przywara@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f168c61..3567c76 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2419,16 +2419,17 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *e=
ntry, u32 function,
 		break;
 	}
 	case 0xd: {
-		int i;
+		int idx, i;
=20
 		entry->flags |=3D KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
-		for (i =3D 1; *nent < maxnent && i < 64; ++i) {
-			if (entry[i].eax =3D=3D 0 || !supported_xcr0_bit(i))
+		for (idx =3D 1, i =3D 1; *nent < maxnent && idx < 64; ++idx) {
+			do_cpuid_1_ent(&entry[i], function, idx);
+			if (entry[i].eax =3D=3D 0 || !supported_xcr0_bit(idx))
 				continue;
-			do_cpuid_1_ent(&entry[i], function, i);
 			entry[i].flags |=3D
 			       KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
 			++*nent;
+			++i;
 		}
 		break;
 	}
--=20
1.7.7.1



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO28M9AAoJEIy3vGnGbaoAL4IQAOE0tTLA8qURfIa5LK+TnLvH
l68D///Hvktne8LuBMN8M9iaPe8Ft0NVnlmOCZ3P1MOhsKDhKv+eAxDEoNaGRvMD
DHcIkKGfxdjAfKggrlMYsd3Lm1jdGVpQgDezQt650EuNvvXZ9dl4r8B5L5SZRV0l
vnhk3EYNy/bgFOCFwalSQV2zPicFNphHgzDpc/7t5oyBJ8R7NrFBwa07oMFUpEuY
JbGQKgZ/cu0ZzWaHJwMsOvIVPN+ewY2KRWfuG4i3QVZaQZLeHnYJ1zTF6NkRNRa0
h+hSWvUvJjFJVwP5QzszqQKlMe6oPWqyOB7ZL9KjdFdHvf/f+VqU8iqc2H+aM/rU
5fyDsDYjDlOMK7SvbxlMZ7Wp/XHxs+Bx4rybpg1yDBgK076SJwj+6YR6NPqR3wps
skexHhi0UyB0PHoaLJXKkNiJpW28lUxP7d+N6N1y4Tz3PzQpK5JehvHc/AaAYCSq
H5Hgc+kNbKkjqKhnL4itB+3nip90acaszzOUm3iHYqiGCsNrzue5XJXNCO7oKTGY
gaKBtALtRvts3SFcHere4IRhoeKFKK4+xfV0omLfXEE4jlxT35vousBITXtZziMw
dR4Bc0pQPwAtefqSh7OO4g9yii5g6zS451+bEUCBPmsOpb681rI3k8V6k2wHft83
Gpuv4vmFnaJLi0D7gWmH
=iFcL
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
