Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab2FSBPt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 21:15:49 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47539 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab2FSBPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 21:15:47 -0400
Date: Tue, 19 Jun 2012 11:15:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: linux-next: manual merge of the pci tree with Linus' tree
Message-Id: <20120619111535.da6def8f1171361ed31adf84@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta8 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__19_Jun_2012_11_15_35_+1000_omEXEKGb6gCNxIgw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__19_Jun_2012_11_15_35_+1000_omEXEKGb6gCNxIgw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Bjorn,

Today's linux-next merge of the pci tree got a conflict in
drivers/pci/quirks.c between commit c2fb8a3fa255 ("USB: add
NO_D3_DURING_SLEEP flag and revert 151b61284776be2") from Linus' tree and
commit fbebb9fd2258 ("PCI: add infrastructure for devices with broken
INTx masking") from the pci tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/pci/quirks.c
index 9478f72,a2d9d33..0000000
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@@ -2930,31 -2930,19 +2930,45 @@@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_I
  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x010a, disable_igfx_irq);
 =20
  /*
 + * The Intel 6 Series/C200 Series chipset's EHCI controllers on many
 + * ASUS motherboards will cause memory corruption or a system crash
 + * if they are in D3 while the system is put into S3 sleep.
 + */
 +static void __devinit asus_ehci_no_d3(struct pci_dev *dev)
 +{
 +	const char *sys_info;
 +	static const char good_Asus_board[] =3D "P8Z68-V";
 +
 +	if (dev->dev_flags & PCI_DEV_FLAGS_NO_D3_DURING_SLEEP)
 +		return;
 +	if (dev->subsystem_vendor !=3D PCI_VENDOR_ID_ASUSTEK)
 +		return;
 +	sys_info =3D dmi_get_system_info(DMI_BOARD_NAME);
 +	if (sys_info && memcmp(sys_info, good_Asus_board,
 +			sizeof(good_Asus_board) - 1) =3D=3D 0)
 +		return;
 +
 +	dev_info(&dev->dev, "broken D3 during system sleep on ASUS\n");
 +	dev->dev_flags |=3D PCI_DEV_FLAGS_NO_D3_DURING_SLEEP;
 +	device_set_wakeup_capable(&dev->dev, false);
 +}
 +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x1c26, asus_ehci_no_d3);
 +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x1c2d, asus_ehci_no_d3);
 +
++/*
+  * Some devices may pass our check in pci_intx_mask_supported if
+  * PCI_COMMAND_INTX_DISABLE works though they actually do not properly
+  * support this feature.
+  */
+ static void __devinit quirk_broken_intx_masking(struct pci_dev *dev)
+ {
+ 	dev->broken_intx_masking =3D 1;
+ }
+ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_CHELSIO, 0x0030,
+ 			 quirk_broken_intx_masking);
+ DECLARE_PCI_FIXUP_HEADER(0x1814, 0x0601, /* Ralink RT2800 802.11n PCI */
+ 			 quirk_broken_intx_masking);
+=20
  static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
  			  struct pci_fixup *end)
  {

--Signature=_Tue__19_Jun_2012_11_15_35_+1000_omEXEKGb6gCNxIgw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP39K3AAoJEECxmPOUX5FEnLMP/RlwiOu/Yth7qSVaxA+ERjrZ
coL/UDJsFElcK5pmvraMnUBK4Z6RLAs4ogtzUBh5OYxEXpzfWyMnpDZOPq8SZMsN
bGIyZ8FuaE+4aIYxI61qzWJE64AIesBZyinw5k3PgbZsoMvjGIBmz08Irjk2tW0D
4ZWi0pnFul+x4WdWDlxDn0GT3OEg/hCbIOagMbSVJPq6WYrx7hcpeYVAA2x91Bgr
iRRgpEo2DfKZ+AhXQFZS1NihB34EA10hqLIhkuF6rU5pdLFVbm4N5EAJptyRSGAc
whaeIveWtlboSAZ/XVYU6Pr9Hb8R+nZF4VTmXUCPdhietNJsryez8y7Nx+4nv6Ly
TZVPmvQMr03PJj7LKqzR2nEuPFXKo8VdNELtdTw9Hcl/IWUVqrjonjGPcfgcb6Q7
hfnv6d+ywsSDZWxsBYAcfWlb0GDzVmdOCB2jz9Iowqk/7PKobbTN4nAqcqaVSfPT
OVHIRCHR/EjU6opjphkXkTKH1R5kXiD82kz18R5e1sLoUKLp6EzVMLFe88zXuo4h
R0vobeAAnBwxVSiZ7YMZ8W9RD+kQ6HBPjMbjBSzE6wPt7H9QioZifzdoiXVNIUio
NEyqfXGqvJ9hk31cHwZ4AXb7RcNAjbJA+XDylJ1NCNSLU/kJd1bP+9v11tsi1e4G
QOXBHekQdN+PPFQcIUwj
=4BEd
-----END PGP SIGNATURE-----

--Signature=_Tue__19_Jun_2012_11_15_35_+1000_omEXEKGb6gCNxIgw--
