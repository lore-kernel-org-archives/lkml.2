Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab2HOPEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 11:04:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:23415 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064Ab2HOPES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 11:04:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,773,1336374000"; 
   d="asc'?scan'208";a="208815731"
Message-ID: <1345043331.3393.151.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 3/4] UBI: use the whole MTD device size to get
 bad_peb_limit
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Genoud <richard.genoud@gmail.com>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Wed, 15 Aug 2012 18:08:51 +0300
In-Reply-To: <1341937423-16516-4-git-send-email-richard.genoud@gmail.com>
References: <1341937423-16516-1-git-send-email-richard.genoud@gmail.com>
	 <1341937423-16516-4-git-send-email-richard.genoud@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-cV0IXn8Tq7/1j6+HeM2t"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-cV0IXn8Tq7/1j6+HeM2t
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-07-10 at 18:23 +0200, Richard Genoud wrote:
> +			/* we are using here the whole MTD device size and not
> +			 * the MTD partition size because the maximum number of
> +			 * bad blocks is a percentage of the whole device and
> +			 * the bad blocks are not fairly disposed on a flash
> +			 * device
> +			 */

Would you please use proper kernel-style comments instead, to be
consistent with the rest of the UBI code? I've amended this one, but
wanted to note for future.

I've re-based your patch against the latest UBI. I've also tried to
improve the Kconfig help message as well. Below is the patch I ended up
with.



=46rom cb14c6c5455443cbe960a36e77b3fcd0e5bc7152 Mon Sep 17 00:00:00 2001
From: Richard Genoud <richard.genoud@gmail.com>
Date: Tue, 10 Jul 2012 18:23:41 +0200
Subject: [PATCH 2/2] UBI: use the whole MTD device size to get bad_peb_limi=
t

On NAND flash devices, UBI reserves some physical erase blocks (PEB) for
bad block handling. Today, the number of reserved PEB can only be set as a
percentage of the total number of PEB in each MTD partition. For example, f=
or a
NAND flash with 128KiB PEB, 2 MTD partition of 20MiB (mtd0) and 100MiB (mtd=
1)
and 2% reserved PEB:
 - the UBI device on mtd0 will have 2 PEB reserved
 - the UBI device on mtd1 will have 16 PEB reserved

The problem with this behaviour is that NAND flash manufacturers give a
minimum number of valid block (NVB) during the endurance life of the
device, e.g.:

Parameter             Symbol    Min    Max    Unit      Notes
--------------------------------------------------------------
Valid block number     NVB     1004    1024   Blocks     1
Note:
1. Invalid blocks are block that contain one or more bad bits beyond
ECC. The device may contain bad blocks upon shipment. Additional bad
blocks may develop over time; however, the total number of available
blocks will not drop below NVB during the endurance life of the device.

=46rom this number we can deduce the maximum number of bad PEB that a device =
will
contain during its endurance life: a 128MiB NAND flash (1024 PEB) will not =
have
less than 20 bad blocks during the flash endurance life.

But the manufacturer doesn't tell where those bad block will appear. He doe=
sn't
say either if they will be equally disposed on the whole device (and I'm pr=
etty
sure they won't). So, according to the datasheets, we should reserve the
maximum number of bad PEB for each UBI device (worst case scenario: 20 bad
blocks appears on the smallest MTD partition).

So this patch make UBI use the whole MTD device size to calculate the maxim=
um
bad expected eraseblocks.

The Kconfig option is in per1024 blocks, thus it can have a default value o=
f 20
which is *very* common for NAND devices.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 drivers/mtd/ubi/Kconfig |   27 +++++++++++++++++++++------
 drivers/mtd/ubi/build.c |   21 ++++++++++++++++++---
 2 files changed, 39 insertions(+), 9 deletions(-)

diff --git a/drivers/mtd/ubi/Kconfig b/drivers/mtd/ubi/Kconfig
index b2f4f0f..98bda6c 100644
--- a/drivers/mtd/ubi/Kconfig
+++ b/drivers/mtd/ubi/Kconfig
@@ -28,14 +28,29 @@ config MTD_UBI_WL_THRESHOLD
 	  to 128 or 256, although it does not have to be power of 2).
=20
 config MTD_UBI_BEB_LIMIT
-	int "Percentage of maximum expected bad eraseblocks"
-	default 2
-	range 0 25
+	int "Maximum expected bad eraseblock count per 1024 eraseblocks"
+	default 20
+	range 2 256
 	help
 	  This option specifies the maximum bad physical eraseblocks UBI
-	  expects on the UBI device (percents of total number of physical
-	  eraseblocks on this MTD partition). If the underlying flash does not
-	  admit of bad eraseblocks (e.g. NOR flash), this value is ignored.
+	  expects on the MTD device (per 1024 eraseblocks). If the underlying
+	  flash does not admit of bad eraseblocks (e.g. NOR flash), this value
+	  is ignored.
+
+	  NAND datasheets often specify the minimum and maximum NVM (Number of
+	  Valid Blocks) for the flashes' endurance lifetime. The maximum
+	  expected bad eraseblocks per 1024 eraseblocks then can be calculated
+	  as "1024 * (1 - MinNVB / MaxNVB)", which gives 20 for most NANDs
+	  (MaxNVB is basically the total count of eraseblocks on the chip).
+
+	  To put it differently, if this value is 20, UBI will try to reserve
+	  about 1.9% of physical eraseblocks for bad blocks handling. And that
+	  will be 1.9% of eraseblocks on the entire NAND chip, not just the MTD
+	  partition UBI attaches. This means that if you have, say,  if a NAND
+	  flash chip admits maximum 40 bad eraseblocks, and it is split on two
+	  MTD partitions of the same size, UBI will reserve 40 eraseblocks when
+	  attaching a partition.
+
 	  Leave the default value if unsure.
=20
 config MTD_UBI_GLUEBI
diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 7b6b5f9..9fd8d86 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -36,6 +36,7 @@
 #include <linux/namei.h>
 #include <linux/stat.h>
 #include <linux/miscdevice.h>
+#include <linux/mtd/partitions.h>
 #include <linux/log2.h>
 #include <linux/kthread.h>
 #include <linux/kernel.h>
@@ -610,11 +611,25 @@ static int io_init(struct ubi_device *ubi)
 	if (mtd_can_have_bb(ubi->mtd)) {
 		ubi->bad_allowed =3D 1;
 		if (CONFIG_MTD_UBI_BEB_LIMIT > 0) {
-			int percent =3D CONFIG_MTD_UBI_BEB_LIMIT;
-			int limit =3D mult_frac(ubi->peb_count, percent, 100);
+			int per1024 =3D CONFIG_MTD_UBI_BEB_LIMIT;
+			int limit, device_pebs;
+			uint64_t device_size;
+
+			/*
+			 * Here we are using size of the entire flash chip and
+			 * not just the MTD partition size because the maximum
+			 * number of bad eraseblocks is a percentage of the
+			 * whole device and bad eraseblocks are not fairly
+			 * distributed over the flash chip. So the worst case
+			 * is that all the bad eraseblocks of the chip are in
+			 * the MTD partition we are attaching (ubi->mtd).
+			 */
+			device_size =3D mtd_get_device_size(ubi->mtd);
+			device_pebs =3D mtd_div_by_eb(device_size, ubi->mtd);
+			limit =3D mult_frac(device_pebs, per1024, 1024);
=20
 			/* Round it up */
-			if (mult_frac(limit, 100, percent) < ubi->peb_count)
+			if (mult_frac(limit, 1024, per1024) < ubi->peb_count)
 				limit +=3D 1;
 			ubi->bad_peb_limit =3D limit;
 		}
--=20
1.7.10.4

--=20
Best Regards,
Artem Bityutskiy

--=-cV0IXn8Tq7/1j6+HeM2t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQK7uDAAoJECmIfjd9wqK0ik4QAKWloDWbFBvb37HHjRYUlezV
pW7zWA6L6+jst4EHB7hFOqxGMzrxFLV8n08t3m7kw72+lvSoCL/Wnu62869ghNIg
FUeZAFh0wGZlDxOmAiqxD9N5m51A6WMs7P4/5AyuaqU4CZzuGHIZv/zuT9XAU0k7
679xscPaCv9smHaMO32ftLuYy7N8sweIJq3hSd/VPSOPd7Q1HgSsOnbiiFDJM+Kx
qz/kmz9xmREkX3QvDnzKktP8IgkNulaf707UvPLBRdAktA4IuWo6RO7ZI0L6MATN
RWn9kjxjoRO4EGfQKB4BbQfEdTTHEyF6W5jqgdMD/yiN73gbD+psp+iGyQL96LCt
h0IwqlzesASUikC69DXGYPPJISL6whAvkx1BhDiLywimc9mk/6r9oGllAtx9gYvR
YMpMF0LL0iWHY1UHAeX8aAQ+Ra6uhdH4IcIyJRI821zGpbsrUsIzlq8/+57nPH4e
SWXHWpWyUMYBiBBe32loABZc344PAkvtTWd064X6zAJk47WplhLYrCzID0zK1irC
Dka4huJ3EU23xal74VQKM11QChPB8S2jiHpiL57G0a3lqvQjbW8HiiVEHbPVw8tF
8opC+4xyM6qHHCKbn9Kb1j+wkrsTJ3u+mYeCihRxj44Hod+zjRgZiCCYKZ0MuORu
9FkiSyuEdKVebjdozA8g
=lOS6
-----END PGP SIGNATURE-----

--=-cV0IXn8Tq7/1j6+HeM2t--

