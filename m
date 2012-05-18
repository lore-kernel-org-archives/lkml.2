Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760502Ab2ERFYG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 01:24:06 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49116 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759216Ab2ERFYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 01:24:04 -0400
Date: Fri, 18 May 2012 15:23:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Sierra <asierra@xes-inc.com>, Guenter Roeck <linux@roeck-us.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: linux-next: manual merge of the watchdog tree with the mfd tree
Message-Id: <20120518152348.1e5070cdc16cfdf00682546d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__18_May_2012_15_23_48_+1000_ibWUWgqPc_IelAZj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__18_May_2012_15_23_48_+1000_ibWUWgqPc_IelAZj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Wim,

Today's linux-next merge of the watchdog tree got a conflict in
drivers/watchdog/iTCO_wdt.c between commit 887c8ec7219f ("watchdog:
Convert iTCO_wdt driver to mfd model") from the  tree and commit
c3614aa19d3e ("watchdog: iTCO_wdt.c: fix printk format warnings") from
the watchdog tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/watchdog/iTCO_wdt.c
index 741528b,2aab56f..0000000
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@@ -572,33 -837,32 +572,33 @@@ static int __devinit iTCO_wdt_probe(str
  	iTCO_wdt_set_NO_REBOOT_bit();
 =20
  	/* The TCO logic uses the TCO_EN bit in the SMI_EN register */
 -	if (!request_region(SMI_EN, 4, "iTCO_wdt")) {
 -		pr_err("I/O address 0x%04lx already in use, device disabled\n",
 +	if (!request_region(iTCO_wdt_private.smi_res->start,
 +			resource_size(iTCO_wdt_private.smi_res), dev->name)) {
 +		pr_err("I/O address 0x%04llx already in use, device disabled\n",
- 		       SMI_EN);
+ 		       (u64)SMI_EN);
 -		ret =3D -EIO;
 -		goto out_unmap;
 +		ret =3D -EBUSY;
 +		goto unmap_gcs;
  	}
  	if (turn_SMI_watchdog_clear_off >=3D iTCO_wdt_private.iTCO_version) {
 -		/* Bit 13: TCO_EN -> 0 =3D Disables TCO logic generating an SMI# */
 +		/*
 +		 * Bit 13: TCO_EN -> 0
 +		 * Disables TCO logic generating an SMI#
 +		 */
  		val32 =3D inl(SMI_EN);
  		val32 &=3D 0xffffdfff;	/* Turn off SMI clearing watchdog */
  		outl(val32, SMI_EN);
  	}
 =20
 -	/* The TCO I/O registers reside in a 32-byte range pointed to
 -	   by the TCOBASE value */
 -	if (!request_region(TCOBASE, 0x20, "iTCO_wdt")) {
 -		pr_err("I/O address 0x%04lx already in use, device disabled\n",
 +	if (!request_region(iTCO_wdt_private.tco_res->start,
 +			resource_size(iTCO_wdt_private.tco_res), dev->name)) {
 +		pr_err("I/O address 0x%04llx already in use, device disabled\n",
- 		       TCOBASE);
+ 		       (u64)TCOBASE);
 -		ret =3D -EIO;
 -		goto unreg_smi_en;
 +		ret =3D -EBUSY;
 +		goto unreg_smi;
  	}
 =20
 -	pr_info("Found a %s TCO device (Version=3D%d, TCOBASE=3D0x%04lx)\n",
 -		iTCO_chipset_info[ent->driver_data].name,
 -		iTCO_chipset_info[ent->driver_data].iTCO_version,
 -		(u64)TCOBASE);
 +	pr_info("Found a %s TCO device (Version=3D%d, TCOBASE=3D0x%04llx)\n",
- 		ich_info->name, ich_info->iTCO_version, TCOBASE);
++		ich_info->name, ich_info->iTCO_version, (u64)TCOBASE);
 =20
  	/* Clear out the (probably old) status */
  	outw(0x0008, TCO1_STS);	/* Clear the Time Out Status bit */

--Signature=_Fri__18_May_2012_15_23_48_+1000_ibWUWgqPc_IelAZj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPtdzkAAoJEECxmPOUX5FENycP/jD1fniOMgitCgWIkja7618u
M3MzOkgd+1X7dWZkUUaWQmfaPruIFSKr3OWxVGp9GZEVHwmBZXGBHdz78YOF2DaC
GTNYoqcOg0bu/wLOGZkuolhnLARhvK9ox2LHRroWGcfZNlWNambipXFtaexqv3Ce
YrTCo/5J+q2f91KU9ItAENv9fbg6ND0P3ENCldZzoL12EbxsT1KAhCd5FeWHKvgz
ZXAynI0SUdH5fNIEEHvpJA14wGoFvW8DAqGuIUseV/KmdPmLrQcHWM2UL3DtPnmo
YXZbx/lpb73GfVQ7vAugEZkkCty7eECXtos3n2vB1Boo4btY5IyvEIQ9np26JEaB
bD2gVsrZLU28f5dmxbJaPMfooIDpsrqzEryPDsBFzCxI+IfmqbE81rjia1YiRZ+d
2R3F8eGJ8yH3GlG8tY845YuU07icdpwPzvQOm+udbondGBUHhvWxm7nL7hvqd3vS
YUn5ZJGJFNvqc/NA+RI0OZ5IwTuJYmrDoWwCev4x+NJkc7CFdlJPxtL3l/CZxgb3
VF+o9LR0tIaGchbIUnUAFMaYK5Lvk68O8vbeekoCa1bHUTd6y8ghnTnv3Ekn9tZf
PoFV1iKZaDlRvXj0TYPB2Oi/7LrDaaoxT3JsK4cPY8GGndS7FPMYRtdAgt1mkFKv
K8dPD5nT41DwTRiz2f2D
=xcM1
-----END PGP SIGNATURE-----

--Signature=_Fri__18_May_2012_15_23_48_+1000_ibWUWgqPc_IelAZj--
