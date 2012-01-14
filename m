Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab2ANOxo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 09:53:44 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62928 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886Ab2ANOxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 09:53:42 -0500
Message-ID: <1326552921.19039.75.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] [MTD] Only call mtd->sync() method in mtdblock_release
 if opened for write.
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org
Date: Sat, 14 Jan 2012 16:55:21 +0200
In-Reply-To: <1326198418-8996-1-git-send-email-alexander.stein@systec-electronic.com>
References: <1326198418-8996-1-git-send-email-alexander.stein@systec-electronic.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-7ncJJ15SlBNDCpcFzHkn"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-7ncJJ15SlBNDCpcFzHkn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-01-10 at 13:26 +0100, Alexander Stein wrote:
> Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>

Added commit message, amended the patch, and pushed to l2-mtd.git,
thanks!


=46rom 961aa500ce7592a4ac917b7b56a15d1998722acf Mon Sep 17 00:00:00 2001
From: Alexander Stein <alexander.stein@systec-electronic.com>
Date: Tue, 10 Jan 2012 13:26:58 +0100
Subject: [PATCH] mtd: mtdblock: call mtd_sync() only if opened for write

Because it is useless to call it if the device is opened in R/O mode, and a=
lso
harmful: on CFI NOR flash it may block for long time waiting for erase
operations to complete is another partition with a R/W file-system on this
chip.

Artem Bityutskiy: write commit message, amend the patch to match the latest
tree (we use mtd_sync(), not mtd->sync() nowadays).

Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 drivers/mtd/mtd_blkdevs.c    |    1 +
 drivers/mtd/mtdblock.c       |    8 ++++++--
 include/linux/mtd/blktrans.h |    1 +
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 424ca5f..f1f0671 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -233,6 +233,7 @@ static int blktrans_open(struct block_device *bdev, fmo=
de_t mode)
 	ret =3D __get_mtd_device(dev->mtd);
 	if (ret)
 		goto error_release;
+	dev->file_mode =3D mode;
=20
 unlock:
 	dev->open++;
diff --git a/drivers/mtd/mtdblock.c b/drivers/mtd/mtdblock.c
index af65912..6c6d807 100644
--- a/drivers/mtd/mtdblock.c
+++ b/drivers/mtd/mtdblock.c
@@ -321,8 +321,12 @@ static int mtdblock_release(struct mtd_blktrans_dev *m=
bd)
 	mutex_unlock(&mtdblk->cache_mutex);
=20
 	if (!--mtdblk->count) {
-		/* It was the last usage. Free the cache */
-		mtd_sync(mbd->mtd);
+		/*
+		 * It was the last usage. Free the cache, but only sync if
+		 * opened for writing.
+		 */
+		if (mbd->file_mode & FMODE_WRITE)
+			mtd_sync(mbd->mtd);
 		vfree(mtdblk->cache_data);
 	}
=20
diff --git a/include/linux/mtd/blktrans.h b/include/linux/mtd/blktrans.h
index 1bbd9f2..ed270bd 100644
--- a/include/linux/mtd/blktrans.h
+++ b/include/linux/mtd/blktrans.h
@@ -47,6 +47,7 @@ struct mtd_blktrans_dev {
 	struct request_queue *rq;
 	spinlock_t queue_lock;
 	void *priv;
+	fmode_t file_mode;
 };
=20
 struct mtd_blktrans_ops {
--=20
1.7.7.5


--=20
Best Regards,
Artem Bityutskiy

--=-7ncJJ15SlBNDCpcFzHkn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPEZdZAAoJECmIfjd9wqK0HKAQAKFNBOcE8zxfrw0h50azrCgl
DZtK1MrfMDzb7dpLADbX+a3k3qqwv9A4dDucD/JE0J4BvXgdmdotx8VTmPoMHyR7
2diB4U6PN6IFlVpxdhbI8TAYXXA047/xtKGFaDTX4AEil+HxTTceH0zhSzMRE9o6
QXB6f1qsc0CA4ESTUaHjXRzLW7za7ygTafhtDTpuQooNyiDHWmSSWbu6FE6cymXL
AetdUD18UIWsrsmeasjilm4NlzyfQF5IMM2h6aNTJiN1xdFP6224ooUoeGHou/co
JU5l5eE9APb5DFAT9S5LG9u0Vc7ZkOkELXqlgGwshksIdMcK4wf1HkPe4XcnWVIt
9DPRyfNtEQiZy1+H2+EGiECJa6eWUEXUCySd8tA9tViNJWvnOPhntw2k1O7cQZ5E
mVBvpjwJHVS1aLb20dY4ZX50SeoTrgKE7ce7gJ/tPXwERJ1lAvVmo5H3AG/XgfJY
02G1lePQi513vNPwKynUyvdGsgiPl0n99PH/dhQUldnvbg/mctmdUHWMjsf2zM3W
6VFeJNn9kLN2AGMqRcipcPzCBCLH+xyMi/bnsOmi1/D83Q2s0XYiIfsbq1NY2VA7
rF8x25XTjrFAaa/HYqSDrfhmSpPz5xOOSRtrot77sy62dH7hLnGs9ZkxkGzH9qPv
6otRBmUTHoyt0Ar5MnjK
=kOcV
-----END PGP SIGNATURE-----

--=-7ncJJ15SlBNDCpcFzHkn--

