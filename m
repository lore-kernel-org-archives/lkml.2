Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567Ab2AOVlo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 16:41:44 -0500
Received: from cc-smtpout3.netcologne.de ([89.1.8.213]:40009 "EHLO
	cc-smtpout3.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab2AOVlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 16:41:42 -0500
Date: Sun, 15 Jan 2012 22:34:07 +0100
From: Kurt Garloff <kurt@garloff.de>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: stable@vger.kernel.org, lenb@kernel.org
Subject: [PATCH 1/3]: Store SRAT revision
Message-ID: <20120115213407.GU12380@tpkurt2.garloff.de>
Mail-Followup-To: Kurt Garloff <kurt@garloff.de>,
	linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
	stable@vger.kernel.org, lenb@kernel.org
References: <20120115213005.GT12380@tpkurt2.garloff.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="07KgZKBWke2i7lgQ"
Content-Disposition: inline
In-Reply-To: <20120115213005.GT12380@tpkurt2.garloff.de>
X-Operating-System: Linux 2.6.32.46-0.3-default x86_64
X-PGP-Info: on http://www.garloff.de/kurt/mykeys.pgp
X-PGP-Key: 1024D/1C98774E
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--07KgZKBWke2i7lgQ
Content-Type: multipart/mixed; boundary="0tC/8VcTcTa+VwnR"
Content-Disposition: inline


--0tC/8VcTcTa+VwnR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

This patch stores the SRAT table revision for later consumption
by arch specific __init functions.


This is patch 1/3.
--=20
Kurt Garloff <kurt@garloff.de>  [Koeln/Greven]


--0tC/8VcTcTa+VwnR
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="acpi_srat-pxm-rev-store.patch"
Content-Transfer-Encoding: quoted-printable

=46rom: Kurt Garloff <kurt@garloff.de>
Subject: Store SRAT table revision
References: bnc#503038

In SRAT v1, we had 8bit proximity domain (PXM) fields; SRAT v2 provides
32bits for these. The new fields were reserved before.
According to the ACPI spec, the OS must disregrard reserved fields.
In order to know whether or not, we must know what version the SRAT
table has.

This patch stores the SRAT table revision for later consumption
by arch specific __init functions.

This is patch 1/3.

Signed-off-by: Kurt Garloff <kurt@garloff.de>

---
 drivers/acpi/numa.c      |    3 +++
 include/acpi/acpi_numa.h |    1 +
 2 files changed, 4 insertions(+)

Index: linux-2.6.git/drivers/acpi/numa.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.git.orig/drivers/acpi/numa.c
+++ linux-2.6.git/drivers/acpi/numa.c
@@ -44,8 +44,10 @@ static int pxm_to_node_map[MAX_PXM_DOMAI
 			=3D { [0 ... MAX_PXM_DOMAINS - 1] =3D NUMA_NO_NODE };
 static int node_to_pxm_map[MAX_NUMNODES]
 			=3D { [0 ... MAX_NUMNODES - 1] =3D PXM_INVAL };
=20
+unsigned char acpi_srat_revision __initdata;
+
 int pxm_to_node(int pxm)
 {
 	if (pxm < 0)
 		return NUMA_NO_NODE;
@@ -254,11 +256,15 @@ acpi_parse_memory_affinity(struct acpi_s
 }
=20
 static int __init acpi_parse_srat(struct acpi_table_header *table)
 {
+	struct acpi_table_srat *srat;
 	if (!table)
 		return -EINVAL;
=20
+  	srat =3D (struct acpi_table_srat *)table;
+	acpi_srat_revision =3D srat->header.revision;
+
 	/* Real work done in acpi_table_parse_srat below. */
=20
 	return 0;
 }
Index: linux-2.6.git/include/acpi/acpi_numa.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.git.orig/include/acpi/acpi_numa.h
+++ linux-2.6.git/include/acpi/acpi_numa.h
@@ -14,7 +14,8 @@
 extern int pxm_to_node(int);
 extern int node_to_pxm(int);
 extern void __acpi_map_pxm_to_node(int, int);
 extern int acpi_map_pxm_to_node(int);
+extern unsigned char acpi_srat_revision;
=20
 #endif				/* CONFIG_ACPI_NUMA */
 #endif				/* __ACP_NUMA_H */

--0tC/8VcTcTa+VwnR--

--07KgZKBWke2i7lgQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iD8DBQFPE0ZPxmLh6hyYd04RAq1kAKC6Hih/CLo/C39gE1Cgr54JlrmiPQCg0xEK
XkmeTp4fCvlwo9e/sZnGLx0=
=KMrF
-----END PGP SIGNATURE-----

--07KgZKBWke2i7lgQ--
