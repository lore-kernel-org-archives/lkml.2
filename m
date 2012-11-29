Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945910Ab2K2EGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 23:06:46 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:41885 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422637Ab2K2EGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 23:06:45 -0500
Date: Thu, 29 Nov 2012 15:06:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bill Pemberton <wfp5p@virginia.edu>, Ian Abbott <abbotti@mev.co.uk>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: linux-next: manual merge of the driver-core tree with the pci tree
Message-Id: <20121129150641.a049c1048c4085d339e5f591@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__29_Nov_2012_15_06_41_+1100_ZvSfybZyLG4JVIzA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Nov_2012_15_06_41_+1100_ZvSfybZyLG4JVIzA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
drivers/pci/quirks.c between commit 21c5fd97380b ("PCI: Add workaround
for PLX PCI 9050 BAR alignment erratum") from the pci tree and commit
15856ad50bf5 ("PCI: Remove __dev* markings") from the driver-core tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/pci/quirks.c
index 0c59f7a,22ad3ee..0000000
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@@ -1790,46 -1790,7 +1790,46 @@@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_
  			 PCI_DEVICE_ID_TOSHIBA_TC86C001_IDE,
  			 quirk_tc86c001_ide);
 =20
 +/*
 + * PLX PCI 9050 PCI Target bridge controller has an errata that prevents =
the
 + * local configuration registers accessible via BAR0 (memory) or BAR1 (i/=
o)
 + * being read correctly if bit 7 of the base address is set.
 + * The BAR0 or BAR1 region may be disabled (size 0) or enabled (size 128).
 + * Re-allocate the regions to a 256-byte boundary if necessary.
 + */
- static void __devinit quirk_plx_pci9050(struct pci_dev *dev)
++static void quirk_plx_pci9050(struct pci_dev *dev)
 +{
 +	unsigned int bar;
 +
 +	/* Fixed in revision 2 (PCI 9052). */
 +	if (dev->revision >=3D 2)
 +		return;
 +	for (bar =3D 0; bar <=3D 1; bar++)
 +		if (pci_resource_len(dev, bar) =3D=3D 0x80 &&
 +		    (pci_resource_start(dev, bar) & 0x80)) {
 +			struct resource *r =3D &dev->resource[bar];
 +			dev_info(&dev->dev,
 +				 "Re-allocating PLX PCI 9050 BAR %u to length 256 to avoid bit 7 bug\=
n",
 +				 bar);
 +			r->start =3D 0;
 +			r->end =3D 0xff;
 +		}
 +}
 +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050,
 +			 quirk_plx_pci9050);
 +/*
 + * The following Meilhaus (vendor ID 0x1402) device IDs (amongst others)
 + * may be using the PLX PCI 9050: 0x0630, 0x0940, 0x0950, 0x0960, 0x100b,
 + * 0x1400, 0x140a, 0x140b, 0x14e0, 0x14ea, 0x14eb, 0x1604, 0x1608, 0x160c,
 + * 0x168f, 0x2000, 0x2600, 0x3000, 0x810a, 0x810b.
 + *
 + * Currently, device IDs 0x2000 and 0x2600 are used by the Comedi "me_daq"
 + * driver.
 + */
 +DECLARE_PCI_FIXUP_HEADER(0x1402, 0x2000, quirk_plx_pci9050);
 +DECLARE_PCI_FIXUP_HEADER(0x1402, 0x2600, quirk_plx_pci9050);
 +
- static void __devinit quirk_netmos(struct pci_dev *dev)
+ static void quirk_netmos(struct pci_dev *dev)
  {
  	unsigned int num_parallel =3D (dev->subsystem_device & 0xf0) >> 4;
  	unsigned int num_serial =3D dev->subsystem_device & 0xf;

--Signature=_Thu__29_Nov_2012_15_06_41_+1100_ZvSfybZyLG4JVIzA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQtt9RAAoJEECxmPOUX5FEXb0P/0mQDZzofAO3BNlptckEhUlU
23N9ACLmgMjwfR8/BPgd1gEH7v0xCQtKkXyUWRAuRE3GTqh4XOYdDSF+PxDJySSg
5BsMKvSm6059aOWcYIDDCIqld2b9a51PxSR5hJs2l5JseSspcNvFUw5BGpwcNSvT
Nmc/GmPKMfV4bxpVLsyMJeXUE6Il60QKye2W6JXnJxBm0K48SFjz+TVlhTOFICxw
yEvCribMMHRCiNLq9yLKnoGWUlXU0vEYyGy9GbbaA6JcoGu7dlIq89JvGvsnYE7q
0t2y0BSsnB5vA91ZXibB//xOx+Ps6jDZTWQHMwAAPoCiCWEcFawe0PdOB73E++ih
TL2mWDMrnTV/0FNh5BLx/5CiVVqyQfPjMdrUGj2KJlawciz/CztRylosJNlvzF2S
tB3w6nVtvDAVSMWfun8tGqNx+3pbKYiLtqQV0IpUchzdCoEQyk2iZtgccJu+PJU+
qHSgJFiu0UbvPQwIfmDgcWgOLAsDEG5pnN6nG95FIMRElmLI+WGGAqVo0ARikc49
Ux7Me2yUAg6x8+iisSGDx16Ab3RvityVIu/VVjxJzHG4AYHf0wNXXl3JzoNyHwSj
IdKBaBKBU4MFmAdZlugPWkmeiFEy9SjGY9oor0oDeDhKRVX+qhVhS5692/mC/wXG
x8czp6i+InwQIEGEtfgy
=4Ogb
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Nov_2012_15_06_41_+1100_ZvSfybZyLG4JVIzA--
