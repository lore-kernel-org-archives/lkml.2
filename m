Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403Ab1BQRsC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 12:48:02 -0500
Received: from RedStar.dorchain.net ([212.88.133.153]:59675 "EHLO
	Redstar.dorchain.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357Ab1BQRr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 12:47:58 -0500
X-Greylist: delayed 328 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Feb 2011 12:47:58 EST
X-DKIM: OpenDKIM Filter v2.1.3 Redstar.dorchain.net p1HHg22q011842
Date: Thu, 17 Feb 2011 18:42:01 +0100
From: Joerg Dorchain <joerg@dorchain.net>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-pci maillist <linux-pci@atrey.karlin.mff.cuni.cz>
Subject: Re: [Patch] enable AHCI mode on certain ich chipsets
Message-ID: <20110217174201.GS5778@Redstar.dorchain.net>
References: <20110216090548.GQ5778@Redstar.dorchain.net>
 <4D5C2974.4070608@garzik.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6AmSH+YAqnsWd9jO"
Content-Disposition: inline
In-Reply-To: <4D5C2974.4070608@garzik.org>
X-message-flag: Please send messages in plain text only.  Thanks!
X-Bindford: 6200 (more Power!)
X-Ray: beware
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6AmSH+YAqnsWd9jO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 16, 2011 at 02:45:56PM -0500, Jeff Garzik wrote:
> >this patch allows to force ICH7/8/9 into AHCI mode.  This is needed
> >because some BIOSes do not make AHCI-mode operation available to the
> >user.
> >As the Intel documentation states that the OS should not carry
> >out the operation - the user must force this on the kernel
> >commandline using quirk_ich_force_ahci
> >
> >As this quirk gets called whilst the PCI subsystem is
> >walking the PCI bus, we declare this quirk against the LPC
> >(device 00:1f.0), so that we can frob 00:1f.2 before the PCI
> >code has scanned it.
> >Note: the pci id might change due to this (e.g. from 27c4 to 27c5)
> >
> >For working suspend/resume, the next patch is required, too.
> >
> >Bye,
> >
> >Joerg
> >
> >
> >Signed-Off-By: joerg Dorchain<joerg@dorchain.net>
> >
> >--- linux/drivers/pci/quirks.c.orig	2011-02-04 18:29:03.000000000 +0100
> >+++ linux/drivers/pci/quirks.c	2011-02-12 07:07:57.000000000 +0100
> >@@ -2684,6 +2684,74 @@
> >  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_HINT, 0x0020, quirk_hotplug_bri=
dge);
> >
> >  /*
> >+ * Force ICH7/8/9 into AHCI mode.  This is needed because some
> >+ * BIOSes do not make AHCI-mode operation available to the user.
> >+ * As the Intel documentation states that the OS should not carry
> >+ * out the operation - the user must force this on the kernel
> >+ * commandline using quirk_ich_force_ahci
> >+ *
> >+ * As this quirk gets called whilst the PCI subsystem is
> >+ * walking the PCI bus, we declare this quirk against the LPC
> >+ * (device 00:1f.0), so that we can frob 00:1f.2 before the PCI
> >+ * code has scanned it.
> >+ * Note: the pci id might change due to this (e.g. from 27c4 to 27c5)
> >+ *
> >+ */
> >+
> >+static bool ich_force_ahci_mode; /* defaults to false */
> >+
> >+static int __init ich789_force_ahci_mode_setup(char *str)
> >+{
> >+	ich_force_ahci_mode =3D true;
> >+	return 0;
> >+}
> >+early_param("quirk_ich_force_ahci", ich789_force_ahci_mode_setup);
> >+
> >+static void ich789_force_ahci_mode(struct pci_dev *pdev)
> >+{
> >+	u8 amrval;
> >+	u8 sclkgc;
> >+	const int ich89_address_map_reg =3D 0x90;
> >+	const int ich89_sata_clock_gen_config_reg =3D 0x9c;
> >+
> >+	if (!ich_force_ahci_mode)
> >+		return;
> >+
> >+	/* ICH8 datasheet section 12.1.33 */
> >+	if (!pci_bus_read_config_byte(pdev->bus, PCI_DEVFN(PCI_SLOT(pdev->devf=
n), 2),
> >+		ich89_address_map_reg,&amrval)) {
> >+
> >+		if (amrval&  (BIT(6) | BIT(7))) {
> >+			dev_printk(KERN_DEBUG,&pdev->dev,
> >+				"ICH7/8/9 SATA controller not in IDE mode.  Not modifying.\n");
> >+			return;
> >+		}
> >+		if (amrval&  (BIT(0) | BIT(1)))
> >+			dev_printk(KERN_DEBUG,&pdev->dev,
> >+				"ICH7/8/9 in SATA/PATA combined mode.  Untested.\n");
> >+		/* AHCI mode */
> >+		amrval |=3D BIT(6);
> >+		amrval&=3D ~BIT(7);
> >+		pci_bus_read_config_byte(pdev->bus, PCI_DEVFN(PCI_SLOT(pdev->devfn), =
2),
> >+			ich89_sata_clock_gen_config_reg,&sclkgc);
> >+		dev_printk(KERN_DEBUG,&pdev->dev, "sclkgc is %#0x\n", sclkgc);
> >+		pci_bus_write_config_byte(pdev->bus, PCI_DEVFN(PCI_SLOT(pdev->devfn),=
 2),
> >+			ich89_address_map_reg, amrval);
> >+		dev_printk(KERN_DEBUG,&pdev->dev, "Forced ICH7/8/9 mode PIIX->AHCI\n"=
);
>=20
> How is the assignment of the AHCI BAR handled?  Does this happen
> automatically because it's an early fixup?

For me, it does:
        Region 0: I/O ports at b400 [size=3D8]
        Region 1: I/O ports at b080 [size=3D4]
        Region 2: I/O ports at b000 [size=3D8]
        Region 3: I/O ports at ac80 [size=3D4]
        Region 4: I/O ports at ac00 [size=3D16]
        Region 5: Memory at fe837800 (32-bit, non-prefetchable) [size=3D1K]

>=20
> That is traditionally the stumbling block...

This quirk relies on the fact the the device on 00:1f.0 is
scanned earlier than the device at 00:1f.2, so when the scan
reaches 00:1f.2, the device there is just ok for the ahci driver.

Bye,

Joerg

--6AmSH+YAqnsWd9jO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iHcEARECADcFAk1dXekwFIAAAAAAFQAScGthLWFkZHJlc3NAZ251cGcub3Jnam9l
cmdAZG9yY2hhaW4ubmV0AAoJEI2OPuD3c7zgfu8An3t5qo9ZPzaTJecNX75x12+T
CQXsAJ4ktbsaTXoRnYQScRRT3kxdVjq15g==
=vo8E
-----END PGP SIGNATURE-----

--6AmSH+YAqnsWd9jO--
