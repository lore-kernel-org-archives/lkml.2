Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab1LCBtt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 20:49:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53812 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275Ab1LCBrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 20:47:49 -0500
X-Authority-Analysis: v=2.0 cv=bdLpoZzB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=Kz5hGUpqRHAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=zd2uoN0lAAAA:8 a=yKafnHZ5yalax2nsnYMA:9 a=xYFKbO9I-7DiXM_RbAMA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=wu_e27o_rKQA:10 a=Cu7jb0sJNv6X0sPmiusA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111203014745.894197548@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 02 Dec 2011 20:46:45 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Avi Kivity <avi@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 04/10] KVM: Sanitize cpuid
References: <20111203014641.165123482@goodmis.org>
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

iQIcBAABAgAGBQJO2X/CAAoJEIy3vGnGbaoA7ZAQAOvBU6tjWmq8F+Zw08LC8Wvi
ZcxAyKpzO20aPnjUZGsyS4UgnKJp9YDTq79xxHzNtkS9p8NVbY7kcae7u+g1tfSZ
7l7l/DGN2BVjW/RQzX49hCnpiuQoHqYlK8d1Clty/U0sqrqF3vVyCzzJU8aiPUsX
rf0BFcojL+vwTLTuq3ThlXUaxL/6nTpZexetHttqYFxyG3YoASk0y5wE1PhfqGU/
H3jZK0NszUpnFq3Zbq5N2vkpYCLXIxFGM8FNOXq5LRLHMSEYwWmQF0C95xyP4dQB
qGP0TFuX7k52czWf+t02A9OC94gyin649DYOYKWn5xNMrplC7gn2CgR/klgTa+Fa
LdqR+h8orDMa1XedKIu/Girt9+bPuce8+87CO7vDtQbdYsM6m8l/4FZY0fZ5pMM8
9/Xy9vs5iyQSMm1sjjmk1ly6Bg2AyS2NBD4JdjfuZ10/49PHo7caGKb4JafohrK3
3mASNd4Ygtl13d1P+A4TEnVqMkqKngMFYY/r7FN9lCWp2O+fLfdXVgqOOH4sBlqW
MJQCwY+JCvvuswTzik/2fqzTLiD/H1MRgfPKImtbaIVV+WbRpoTLl2B8lX41qryu
wb3UtpUvyYqndkjZK2X+v+P3oBAu/how7jXLEJ2BjoK8oUnpMgYXztCjLFKJc4Km
J3BrnXC4SHY0ryTP+K1R
=+28J
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
