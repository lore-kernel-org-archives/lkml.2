Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab2AOVgR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 16:36:17 -0500
Received: from cc-smtpout1.netcologne.de ([89.1.8.211]:46009 "EHLO
	cc-smtpout1.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab2AOVgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 16:36:16 -0500
X-Greylist: delayed 361 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Jan 2012 16:36:15 EST
Date: Sun, 15 Jan 2012 22:36:10 +0100
From: Kurt Garloff <kurt@garloff.de>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: stable@vger.kernel.org, Len Brown <lenb@kernel.org>
Subject: [PATCH 2/3]: x86-64: Handle SRAT v1 and v2 consistently
Message-ID: <20120115213610.GV12380@tpkurt2.garloff.de>
Mail-Followup-To: Kurt Garloff <kurt@garloff.de>,
	linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
	stable@vger.kernel.org, Len Brown <lenb@kernel.org>
References: <20120115213005.GT12380@tpkurt2.garloff.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pqZtgxSH0iQu6R78"
Content-Disposition: inline
In-Reply-To: <20120115213005.GT12380@tpkurt2.garloff.de>
X-Operating-System: Linux 2.6.32.46-0.3-default x86_64
X-PGP-Info: on http://www.garloff.de/kurt/mykeys.pgp
X-PGP-Key: 1024D/1C98774E
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pqZtgxSH0iQu6R78
Content-Type: multipart/mixed; boundary="5Y5y2FX8vnqwSxRu"
Content-Disposition: inline


--5Y5y2FX8vnqwSxRu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

x86-64 was rather inconsistent prior to this patch; it used 8 bits=20
for the pxm field in cpu_affinity, but 32 bits in mem_affinity.
This patch makes it consistent: Either use 8 bits consistently (SRAT
rev 1 or lower) or 32 bits (SRAT rev 2 or higher).

This is patch 2/3.
--=20
Kurt Garloff <kurt@garloff.de>  [Koeln/Greven]


--5Y5y2FX8vnqwSxRu
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="acpi_srat-pxm-rev-x86-64.patch"
Content-Transfer-Encoding: quoted-printable

=46rom: Kurt Garloff <kurt@garloff.de>
Subject: Use SRAT table rev to use 8bit or 32bit PXM fields (x86/x86-64)
References: bnc#503038

In SRAT v1, we had 8bit proximity domain (PXM) fields; SRAT v2 provides
32bits for these. The new fields were reserved before.
According to the ACPI spec, the OS must disregrard reserved fields.

x86/x86-64 was rather inconsistent prior to this patch; it used 8 bits=20
for the pxm field in cpu_affinity, but 32 bits in mem_affinity.
This patch makes it consistent: Either use 8 bits consistently (SRAT
rev 1 or lower) or 32 bits (SRAT rev 2 or higher).

This is patch 2/3.

Signed-off-by: Kurt Garloff <kurt@garloff.de>

---
 arch/x86/mm/srat.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6.git/arch/x86/mm/srat.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.git.orig/arch/x86/mm/srat.c
+++ linux-2.6.git/arch/x86/mm/srat.c
@@ -108,8 +108,10 @@ acpi_numa_processor_affinity_init(struct
 	}
 	if ((pa->flags & ACPI_SRAT_CPU_ENABLED) =3D=3D 0)
 		return;
 	pxm =3D pa->proximity_domain_lo;
+	if (acpi_srat_revision >=3D 2)
+		pxm |=3D *((unsigned int*)pa->proximity_domain_hi) << 8;
 	node =3D setup_node(pxm);
 	if (node < 0) {
 		printk(KERN_ERR "SRAT: Too many proximity domains %x\n", pxm);
 		bad_srat();
@@ -159,8 +161,10 @@ acpi_numa_memory_affinity_init(struct ac
 		return;
 	start =3D ma->base_address;
 	end =3D start + ma->length;
 	pxm =3D ma->proximity_domain;
+	if (acpi_srat_revision <=3D 1)
+		pxm &=3D 0xff;
 	node =3D setup_node(pxm);
 	if (node < 0) {
 		printk(KERN_ERR "SRAT: Too many proximity domains.\n");
 		bad_srat();

--5Y5y2FX8vnqwSxRu--

--pqZtgxSH0iQu6R78
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iD8DBQFPE0bKxmLh6hyYd04RAkoNAKCSRp7gcofek5wDDsV4iZqDO9UX7wCeMUuE
AkFNf1MZRZ1IlbQlEK16++A=
=g/EG
-----END PGP SIGNATURE-----

--pqZtgxSH0iQu6R78--
