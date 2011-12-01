Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab1LADXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 22:23:46 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.121]:64525 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436Ab1LADXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 22:23:45 -0500
X-Authority-Analysis: v=2.0 cv=BK0xXSsG c=1 sm=0 a=QETZmXXmyubuBiJjAgCHWw==:17 a=y8ZX_BOJfaUA:10 a=YU8HmM6wsVwA:10 a=ZPSk82zQDygA:10 a=ayC55rCoAAAA:8 a=xe8BsctaAAAA:8 a=Mz574nbezjJi_xtMRHsA:9 a=UAVRJdkkkM0A:10 a=l_uIMmhx26zkyTVK:21 a=Zqov490u-r5Nc_tb:21 a=QETZmXXmyubuBiJjAgCHWw==:117
X-Cloudmark-Score: 0
X-Originating-IP: 97.103.252.48
Message-ID: <4ED6F340.9050000@cfl.rr.com>
Date: Wed, 30 Nov 2011 22:23:44 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Add BLKPG_GET_PARTITION operation
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

Add a new operation to the BLKPG ioctl to read the partition.
This allows user space to find the current start and length
of a partition without having to open the partition and use
the long depreciated HDIO_GETGEO ioctl.

Signed-off-by: Phillip Susi <psusi@cfl.rr.com>
- ---
 block/ioctl.c         |   15 +++++++++++++++
 include/linux/blkpg.h |    1 +
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index f97e6a4..3e92f0f 100644
- --- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -139,6 +139,21 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
 			disk_put_part(part);
 			mutex_unlock(&bdev->bd_mutex);
 			return 0;
+		case BLKPG_GET_PARTITION:
+			mutex_lock(&bdev->bd_mutex);
+			part = disk_get_part(disk, partno);
+			if (!part)
+			{
+				mutex_unlock(&bdev->bd_mutex);
+				return -ENXIO;
+			}
+			p.start = part->start_sect << 9;
+			p.length = part->nr_sects << 9;
+			disk_put_part(part);
+			mutex_unlock(&bdev->bd_mutex);
+			if (copy_to_user(a.data, &p, sizeof(struct blkpg_partition)))
+				return -EFAULT;
+			return 0;
 		default:
 			return -EINVAL;
 	}
diff --git a/include/linux/blkpg.h b/include/linux/blkpg.h
index 103da38..26b1aef 100644
- --- a/include/linux/blkpg.h
+++ b/include/linux/blkpg.h
@@ -41,6 +41,7 @@ struct blkpg_ioctl_arg {
 #define BLKPG_ADD_PARTITION	1
 #define BLKPG_DEL_PARTITION	2
 #define BLKPG_RES_PARTITION	3
+#define BLKPG_GET_PARTITION	4
 
 /* Sizes of name fields. Unused at present. */
 #define BLKPG_DEVNAMELTH	64
- -- 
1.7.5.4

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk7W80AACgkQJ4UciIs+XuJHtQCgjsMlhoVgn2ZDOv2nJ2pJNM3j
0psAoIDeUgJKw+eCAeleFNAGuuHy+HBO
=mBqW
-----END PGP SIGNATURE-----
