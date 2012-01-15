Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab2AOViK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 16:38:10 -0500
Received: from cc-smtpout2.netcologne.de ([89.1.8.212]:47011 "EHLO
	cc-smtpout2.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab2AOViG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 16:38:06 -0500
Date: Sun, 15 Jan 2012 22:37:59 +0100
From: Kurt Garloff <kurt@garloff.de>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: stable@vger.kernel.org, lenb@kernel.org
Subject: [PATCH 3/3]: Consider SRAT rev on ia64
Message-ID: <20120115213759.GW12380@tpkurt2.garloff.de>
Mail-Followup-To: Kurt Garloff <kurt@garloff.de>,
	linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
	stable@vger.kernel.org, lenb@kernel.org
References: <20120115213005.GT12380@tpkurt2.garloff.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ca0e2zgpnh8/XhnM"
Content-Disposition: inline
In-Reply-To: <20120115213005.GT12380@tpkurt2.garloff.de>
X-Operating-System: Linux 2.6.32.46-0.3-default x86_64
X-PGP-Info: on http://www.garloff.de/kurt/mykeys.pgp
X-PGP-Key: 1024D/1C98774E
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ca0e2zgpnh8/XhnM
Content-Type: multipart/mixed; boundary="KzTpGdFWKkiGyjCs"
Content-Disposition: inline


--KzTpGdFWKkiGyjCs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

ia64 did handle the PXM fields almost consistently, but depending on=20
sgi's sn2 platform. This patch leaves the sn2 logic in, but does also
use 16/32 bits for PXM if the SRAT has rev 2 or higher.

This is patch 3/3.
--=20
Kurt Garloff <kurt@garloff.de>  [Koeln/Greven]


--KzTpGdFWKkiGyjCs
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="acpi_srat-pxm-rev-ia64.patch"
Content-Transfer-Encoding: quoted-printable

=46rom: Kurt Garloff <kurt@garloff.de>
Subject: Use SRAT table rev to use 8bit or 16/32bit PXM fields (ia64)
References: bnc#503038

In SRAT v1, we had 8bit proximity domain (PXM) fields; SRAT v2 provides
32bits for these. The new fields were reserved before.
According to the ACPI spec, the OS must disregrard reserved fields.

ia64 did handle the PXM fields almost consistently, but depending on=20
sgi's sn2 platform. This patch leaves the sn2 logic in, but does also
use 16/32 bits for PXM if the SRAT has rev 2 or higher.

The patch also adds __init to the two pxm accessor functions, as they
access __initdata now and are called from an __init function only anyway.

Note that the code only uses 16 bits for the PXM field in the processor
proximity field; the patch does not address this as 16 bits are more than
enough.

This is patch 3/3.

Signed-off-by: Kurt Garloff <kurt@garloff.de>

---
 arch/ia64/kernel/acpi.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: linux-2.6.git/arch/ia64/kernel/acpi.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.git.orig/arch/ia64/kernel/acpi.c
+++ linux-2.6.git/arch/ia64/kernel/acpi.c
@@ -428,24 +428,26 @@ static u32 __devinitdata pxm_flag[PXM_FL
 #define pxm_bit_test(bit)	(test_bit(bit,(void *)pxm_flag))
 static struct acpi_table_slit __initdata *slit_table;
 cpumask_t early_cpu_possible_map =3D CPU_MASK_NONE;
=20
-static int get_processor_proximity_domain(struct acpi_srat_cpu_affinity *p=
a)
+static int __init
+get_processor_proximity_domain(struct acpi_srat_cpu_affinity *pa)
 {
 	int pxm;
=20
 	pxm =3D pa->proximity_domain_lo;
-	if (ia64_platform_is("sn2"))
+	if (ia64_platform_is("sn2") || acpi_srat_revision >=3D 2)
 		pxm +=3D pa->proximity_domain_hi[0] << 8;
 	return pxm;
 }
=20
-static int get_memory_proximity_domain(struct acpi_srat_mem_affinity *ma)
+static int __init
+get_memory_proximity_domain(struct acpi_srat_mem_affinity *ma)
 {
 	int pxm;
=20
 	pxm =3D ma->proximity_domain;
-	if (!ia64_platform_is("sn2"))
+	if (!ia64_platform_is("sn2") && acpi_srat_revision <=3D 1)
 		pxm &=3D 0xff;
=20
 	return pxm;
 }

--KzTpGdFWKkiGyjCs--

--Ca0e2zgpnh8/XhnM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iD8DBQFPE0c3xmLh6hyYd04RAmL4AJwIa4CFlg1Ewh9PzxiHQOJlBsg37gCfTTi3
uVyDUqTDGC4yoqZdvWy6jF0=
=KtDT
-----END PGP SIGNATURE-----

--Ca0e2zgpnh8/XhnM--
