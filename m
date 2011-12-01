Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab1LADXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 22:23:16 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.122]:62870 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436Ab1LADXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 22:23:13 -0500
X-Authority-Analysis: v=2.0 cv=Vf11zSV9 c=1 sm=0 a=QETZmXXmyubuBiJjAgCHWw==:17 a=y8ZX_BOJfaUA:10 a=yzaWUNkOEcUA:10 a=ZPSk82zQDygA:10 a=ayC55rCoAAAA:8 a=xe8BsctaAAAA:8 a=AbxTyE0TmTrGuVoW2CUA:9 a=UAVRJdkkkM0A:10 a=uEinVJx6c-RdOK8u:21 a=MvY04VzlSnFPKTW7:21 a=QETZmXXmyubuBiJjAgCHWw==:117
X-Cloudmark-Score: 0
X-Originating-IP: 97.103.252.48
Message-ID: <4ED6F320.5060709@cfl.rr.com>
Date: Wed, 30 Nov 2011 22:23:12 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Add partition resize function to BLKPG ioctl
References: <cover.1322709471.git.psusi@cfl.rr.com>
In-Reply-To: <cover.1322709471.git.psusi@cfl.rr.com>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Add a new operation code ( BLKPG_RES_PARTITION ) to the
BLKPG ioctl that allows altering the size of an existing
partition, even if it is currently in use.

Signed-off-by: Phillip Susi <psusi@cfl.rr.com>
- ---
 block/ioctl.c         |   51 +++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/blkpg.h |    1 +
 2 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index ca939fc..f97e6a4 100644
- --- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -36,8 +36,8 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
 		case BLKPG_ADD_PARTITION:
 			start = p.start >> 9;
 			length = p.length >> 9;
- -			/* check for fit in a hd_struct */ 
- -			if (sizeof(sector_t) == sizeof(long) && 
+			/* check for fit in a hd_struct */
+			if (sizeof(sector_t) == sizeof(long) &&
 			    sizeof(long long) > sizeof(long)) {
 				long pstart = start, plength = length;
 				if (pstart != start || plength != length
@@ -92,6 +92,53 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
 			bdput(bdevp);
 
 			return 0;
+		case BLKPG_RES_PARTITION:
+			start = p.start >> 9;
+			length = p.length >> 9;
+			/* check for fit in a hd_struct */
+			if (sizeof(sector_t) == sizeof(long) &&
+			    sizeof(long long) > sizeof(long)) {
+				long pstart = start, plength = length;
+				if (pstart != start || plength != length
+				    || pstart < 0 || plength < 0)
+					return -EINVAL;
+			}
+
+			mutex_lock(&bdev->bd_mutex);
+
+			/* overlap? */
+			disk_part_iter_init(&piter, disk,
+					    DISK_PITER_INCL_EMPTY);
+			while ((part = disk_part_iter_next(&piter))) {
+				if (part->partno != partno && !(start + length <= part->start_sect ||
+				      start >= part->start_sect + part->nr_sects)) {
+					disk_part_iter_exit(&piter);
+					mutex_unlock(&bdev->bd_mutex);
+					return -EBUSY;
+				}
+			}
+			disk_part_iter_exit(&piter);
+			part = disk_get_part(disk, partno);
+			if (!part)
+			{
+				mutex_unlock(&bdev->bd_mutex);
+				return -ENXIO;
+			}
+			if (start != part->start_sect)
+			{
+				mutex_unlock(&bdev->bd_mutex);
+				disk_put_part(part);
+				return -EINVAL;
+			}
+			part->nr_sects = length;
+			bdevp = bdget(part_devt(part));
+			mutex_lock(&bdevp->bd_mutex);
+			i_size_write(bdevp->bd_inode, p.length);
+			mutex_unlock(&bdevp->bd_mutex);
+			bdput(bdevp);
+			disk_put_part(part);
+			mutex_unlock(&bdev->bd_mutex);
+			return 0;
 		default:
 			return -EINVAL;
 	}
diff --git a/include/linux/blkpg.h b/include/linux/blkpg.h
index faf8a45..103da38 100644
- --- a/include/linux/blkpg.h
+++ b/include/linux/blkpg.h
@@ -40,6 +40,7 @@ struct blkpg_ioctl_arg {
 /* The subfunctions (for the op field) */
 #define BLKPG_ADD_PARTITION	1
 #define BLKPG_DEL_PARTITION	2
+#define BLKPG_RES_PARTITION	3
 
 /* Sizes of name fields. Unused at present. */
 #define BLKPG_DEVNAMELTH	64
- -- 
1.7.5.4

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk7W8yAACgkQJ4UciIs+XuKpiwCfd8YC2241ScOcruAoGvBnTyVZ
p6UAoI5JT/UX4gkilpjmTKbuBLzeCTv4
=K/d3
-----END PGP SIGNATURE-----
