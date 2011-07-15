Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab1GOTMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 15:12:55 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.121]:50163 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab1GOTMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 15:12:53 -0400
Authentication-Results: cdptpa-omtalb.mail.rr.com smtp.user=psusi@cfl.rr.com; auth=pass (PLAIN)
X-Authority-Analysis: v=1.1 cv=8mDY8c80ZOa76EOwICuS+E2YRQjxDgO9xqUnRMONc7w= c=1 sm=0 a=aAvtD6xXQTUA:10 a=p8NdAnTFcCEA:10 a=pg4Dpxby4z7sZisWVyJ9NA==:17 a=9-Jv4ekX_Sh413Ua8wQA:9 a=wPNLvfGTeEIA:10 a=DfNHnWVPAAAA:8 a=danhDmx_AAAA:8 a=imx6bq5wevw5aM2f5rEA:9 a=X2OimeIR18glAeU5rKoA:7 a=lBRciGGoxdUA:10 a=pg4Dpxby4z7sZisWVyJ9NA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.242.190.170
Message-ID: <4E209132.7000704@cfl.rr.com>
Date: Fri, 15 Jul 2011 15:12:50 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To: Ayan George <ayan@ayan.net>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: loop device auto release patch
References: <4E1F3BE0.8040506@ayan.net>
In-Reply-To: <4E1F3BE0.8040506@ayan.net>
Content-Type: multipart/mixed;
 boundary="------------080706050103020705080803"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080706050103020705080803
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 7/14/2011 2:56 PM, Ayan George wrote:
>
> Hi Philip,
>
> This is the patch I'd like to submit for the loop device. I'm in the
> process of testing it now. I'm pretty confident it will work.

Looks good to me.  Forwarding to Andrew Morton.  Andrew, please 
disregard my previous patch as I think this one is better.


--------------080706050103020705080803
Content-Type: text/x-patch;
 name="0001-Always-invalidate-cleared-loop-block-devices.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Always-invalidate-cleared-loop-block-devices.patch"

>From c783ba6a26eff42d3cb0061e4fcb8ee8a16b3e67 Mon Sep 17 00:00:00 2001
From: Ayan George <ayan.george@canonical.com>
Date: Thu, 14 Jul 2011 14:16:58 -0400
Subject: [PATCH] Always invalidate cleared loop block devices

The API for loop_clr_fd() is confusing -- the second argument (bdev)
isn't necessesary as struct loop_device contains a pointer to the block
device it is assocated with.

There is a cases where loop_clr_fd() is called with NULL for bdev
which prevents the block device from ever being invalidated with
invalidate_bdev() and prevents a uevent from being emitted.

This patch removes the bdev argument from loop_clr_fd(), unconditionally
invalidates lo->lo_device when cleared, and unconditionally emits a
uevent for removed loops.

Launchpad bug for reference:

BugLink: https://bugs.launchpad.net/bugs/548546

Signed-off-by: Ayan George <ayan.george@canonical.com>
---
 drivers/block/loop.c |   24 ++++++++++++++----------
 1 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 76c8da7..a40e12b 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -987,11 +987,13 @@ loop_init_xfer(struct loop_device *lo, struct loop_func_table *xfer,
 	return err;
 }
 
-static int loop_clr_fd(struct loop_device *lo, struct block_device *bdev)
+static int loop_clr_fd(struct loop_device *lo)
 {
 	struct file *filp = lo->lo_backing_file;
 	gfp_t gfp = lo->old_gfp_mask;
 
+	struct block_device *bdev = lo->lo_device;
+
 	if (lo->lo_state != Lo_bound)
 		return -ENXIO;
 
@@ -1022,15 +1024,17 @@ static int loop_clr_fd(struct loop_device *lo, struct block_device *bdev)
 	memset(lo->lo_encrypt_key, 0, LO_KEY_SIZE);
 	memset(lo->lo_crypt_name, 0, LO_NAME_SIZE);
 	memset(lo->lo_file_name, 0, LO_NAME_SIZE);
-	if (bdev)
-		invalidate_bdev(bdev);
+
+	invalidate_bdev(bdev);
+
 	set_capacity(lo->lo_disk, 0);
 	loop_sysfs_exit(lo);
-	if (bdev) {
-		bd_set_size(bdev, 0);
-		/* let user-space know about this change */
-		kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, KOBJ_CHANGE);
-	}
+
+	bd_set_size(bdev, 0);
+
+	/* let user-space know about this change */
+	kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, KOBJ_CHANGE);
+
 	mapping_set_gfp_mask(filp->f_mapping, gfp);
 	lo->lo_state = Lo_unbound;
 	/* This is safe: open() is still holding a reference. */
@@ -1298,7 +1302,7 @@ static int lo_ioctl(struct block_device *bdev, fmode_t mode,
 		break;
 	case LOOP_CLR_FD:
 		/* loop_clr_fd would have unlocked lo_ctl_mutex on success */
-		err = loop_clr_fd(lo, bdev);
+		err = loop_clr_fd(lo);
 		if (!err)
 			goto out_unlocked;
 		break;
@@ -1509,7 +1513,7 @@ static int lo_release(struct gendisk *disk, fmode_t mode)
 		 * In autoclear mode, stop the loop thread
 		 * and remove configuration after last close.
 		 */
-		err = loop_clr_fd(lo, NULL);
+		err = loop_clr_fd(lo);
 		if (!err)
 			goto out_unlocked;
 	} else {
-- 
1.7.4.1


--------------080706050103020705080803--
