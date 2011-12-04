Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab1LDTDV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 14:03:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50476 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278Ab1LDTAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 14:00:14 -0500
X-Authority-Analysis: v=2.0 cv=QqvcLCOd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=13_xHbeR9GcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=zd2uoN0lAAAA:8 a=yKafnHZ5yalax2nsnYMA:9 a=xYFKbO9I-7DiXM_RbAMA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=wu_e27o_rKQA:10 a=VvZBSq-jr2ZIbkx33rIA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111204190011.156778105@goodmis.org>
User-Agent: quilt/0.48-1
Date: Sun, 04 Dec 2011 13:54:48 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Avi Kivity <avi@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 04/11] KVM: Sanitize cpuid
References: <20111204185444.411298317@goodmis.org>
Content-Disposition: inline; filename=0004-KVM-Sanitize-cpuid.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Avi Kivity <avi@redhat.com>

Instead of blacklisting known-unsupported cpuid leaves, whitelist known-
supported leaves.  This is more conservative and prevents us from reporting
features we don't support.  Also whitelist a few more leaves while at it.

Signed-off-by: Avi Kivity <avi@redhat.com>
Acked-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/x86.c |   37 +++++++++++++++++++++++++++++++++++--
 1 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 545c61b..f168c61 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2283,6 +2283,13 @@ static void do_cpuid_1_ent(struct kvm_cpuid_entry2 *=
entry, u32 function,
 	entry->flags =3D 0;
 }
=20
+static bool supported_xcr0_bit(unsigned bit)
+{
+	u64 mask =3D ((u64)1 << bit);
+
+	return mask & (XSTATE_FP | XSTATE_SSE | XSTATE_YMM) & host_xcr0;
+}
+
 #define F(x) bit(X86_FEATURE_##x)
=20
 static void do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
@@ -2393,6 +2400,8 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *ent=
ry, u32 function,
 		}
 		break;
 	}
+	case 9:
+		break;
 	case 0xb: {
 		int i, level_type;
=20
@@ -2414,7 +2423,7 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *ent=
ry, u32 function,
=20
 		entry->flags |=3D KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
 		for (i =3D 1; *nent < maxnent && i < 64; ++i) {
-			if (entry[i].eax =3D=3D 0)
+			if (entry[i].eax =3D=3D 0 || !supported_xcr0_bit(i))
 				continue;
 			do_cpuid_1_ent(&entry[i], function, i);
 			entry[i].flags |=3D
@@ -2451,6 +2460,24 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *en=
try, u32 function,
 		entry->ecx &=3D kvm_supported_word6_x86_features;
 		cpuid_mask(&entry->ecx, 6);
 		break;
+	case 0x80000008: {
+		unsigned g_phys_as =3D (entry->eax >> 16) & 0xff;
+		unsigned virt_as =3D max((entry->eax >> 8) & 0xff, 48U);
+		unsigned phys_as =3D entry->eax & 0xff;
+
+		if (!g_phys_as)
+			g_phys_as =3D phys_as;
+		entry->eax =3D g_phys_as | (virt_as << 8);
+		entry->ebx =3D entry->edx =3D 0;
+		break;
+	}
+	case 0x80000019:
+		entry->ecx =3D entry->edx =3D 0;
+		break;
+	case 0x8000001a:
+		break;
+	case 0x8000001d:
+		break;
 	/*Add support for Centaur's CPUID instruction*/
 	case 0xC0000000:
 		/*Just support up to 0xC0000004 now*/
@@ -2460,10 +2487,16 @@ static void do_cpuid_ent(struct kvm_cpuid_entry2 *e=
ntry, u32 function,
 		entry->edx &=3D kvm_supported_word5_x86_features;
 		cpuid_mask(&entry->edx, 5);
 		break;
+	case 3: /* Processor serial number */
+	case 5: /* MONITOR/MWAIT */
+	case 6: /* Thermal management */
+	case 0xA: /* Architectural Performance Monitoring */
+	case 0x80000007: /* Advanced power management */
 	case 0xC0000002:
 	case 0xC0000003:
 	case 0xC0000004:
-		/*Now nothing to do, reserved for the future*/
+	default:
+		entry->eax =3D entry->ebx =3D entry->ecx =3D entry->edx =3D 0;
 		break;
 	}
=20
--=20
1.7.7.1



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO28M7AAoJEIy3vGnGbaoAIA0QAIrB/Oxxxx6D9GyEzUN5avQU
kO9QhGPfBMsq4dS56E3IN9Hrzqv8E5fPK1/wyYOAU3XAls3AfXdljh2v2ar/jFmK
0u1icwpplJIrFQ7SJDY18byriEimF6WxNS2l2VxdCOmNLN+59QJClGFv3Rc0BewE
vR5PZbg8vsEDY5kQQT7QhUy7xHAd3DwZcA1SMRZ+OcY3AzxtnY0d3crX3eNp1iDH
FR39AcJIDSBoC6jAcUNmT6qYymsMbzXkIx53RlA6i+YfN/3pKJiwlHGlITolFSJL
OcJ4uZ0ETG4AWIT4ZpXzWigGTyKKEh51XUcMkMBbuqrQxlEQSg6hUVGNEn8+LEIC
Tw+70tgh39Zi1TDPf1hHQmSBm6Sl8EZhvGaf7PvDbXwzYRkP2PJtK7h1hf7lkz7c
igwHqW5+glvB/dz9dfLvvlNO2WcE4GJYn8wGVuNXXRpkvJdkJWpKD6cBKNa7Gvzj
RraL3pBwIQkdhfYtNfa/CRG7w78pTInJMASzcDfZK/wUQb2hjOXXAh7ZFwETa9yH
uhwk2CzUTffTgzwhsbfmHoKSk24QcIIR+fQxK6exz3uHnwsFEsMPtFvSTCFaIT91
36bA7FhwvYSPm844jPn9k18nbWDiYGbRmJpPoHzoaK69nABvGu0W0FIGQqh0YRFp
TH9rs8uWrQe+UOTVdI3L
=vukS
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
