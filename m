Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab1DKH11 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 03:27:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079Ab1DKH1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 03:27:25 -0400
Message-ID: <4DA2AD59.8070302@redhat.com>
Date: Mon, 11 Apr 2011 08:27:21 +0100
From: Niels de Vos <ndevos@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-serial@vger.kernel.org, Julia Lawall <julia@diku.dk>
Subject: [PATCH v2] parport_pc.c: correctly release the requested region for
 the IT887x
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE38997D45DE098544D7E7D98"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE38997D45DE098544D7E7D98
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Replace release_resource() by release_region() and also fix the
inconsistency in the size of the requested/released region.

The size of the resource should be 32, not 0x8 like it was corrected in
commit e7c310c36e5fdf1b83a459e5db167bfbd86137db already.

CC: linux-serial@vger.kernel.org
Reported-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Niels de Vos <ndevos@redhat.com>

---
This is a followup/improvement on https://lkml.org/lkml/2011/4/11/37
that was posted by Julia earlier. I've updated the subject to reflect
the corrections made.

There is currently no maintainer for the drivers/parport/ tree. As the
IT887x also (can) provide a serial port, I'm adding linux-serial@ to the
list of CCs.

 drivers/parport/parport_pc.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
index 8d62fb7..be8b5ac 100644
--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -2550,7 +2550,6 @@ static int __devinit sio_ite_8872_probe(struct pci_=
dev *pdev, int autoirq,
 					 const struct parport_pc_via_data *via)
 {
 	short inta_addr[6] =3D { 0x2A0, 0x2C0, 0x220, 0x240, 0x1E0 };
-	struct resource *base_res;
 	u32 ite8872set;
 	u32 ite8872_lpt, ite8872_lpthi;
 	u8 ite8872_irq, type;
@@ -2561,8 +2560,7 @@ static int __devinit sio_ite_8872_probe(struct pci_=
dev *pdev, int autoirq,
=20
 	/* make sure which one chip */
 	for (i =3D 0; i < 5; i++) {
-		base_res =3D request_region(inta_addr[i], 32, "it887x");
-		if (base_res) {
+		if (request_region(inta_addr[i], 32, "it887x")) {
 			int test;
 			pci_write_config_dword(pdev, 0x60,
 						0xe5000000 | inta_addr[i]);
@@ -2571,7 +2569,7 @@ static int __devinit sio_ite_8872_probe(struct pci_=
dev *pdev, int autoirq,
 			test =3D inb(inta_addr[i]);
 			if (test !=3D 0xff)
 				break;
-			release_region(inta_addr[i], 0x8);
+			release_region(inta_addr[i], 32);
 		}
 	}
 	if (i >=3D 5) {
@@ -2635,7 +2633,7 @@ static int __devinit sio_ite_8872_probe(struct pci_=
dev *pdev, int autoirq,
 	/*
 	 * Release the resource so that parport_pc_probe_port can get it.
 	 */
-	release_resource(base_res);
+	release_region(inta_addr[i], 32);
 	if (parport_pc_probe_port(ite8872_lpt, ite8872_lpthi,
 				   irq, PARPORT_DMA_NONE, &pdev->dev, 0)) {
 		printk(KERN_INFO
--=20
1.7.4



--------------enigE38997D45DE098544D7E7D98
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2irVkACgkQ3GGILUD6RHttzwCdFNPIs9CcI22ypaK4TA0bOOtn
c3oAoMEMLfNSwYcPiUVAw4vLLiDC/++R
=8flc
-----END PGP SIGNATURE-----

--------------enigE38997D45DE098544D7E7D98--
