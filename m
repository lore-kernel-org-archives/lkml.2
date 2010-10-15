Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab0JOUb1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 16:31:27 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:58181 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756202Ab0JOUbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 16:31:25 -0400
Subject: Re: Staging: zram: work around oops due to startup ordering snafu
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Anton Blanchard <anton@samba.org>
Cc: Nitin Gupta <ngupta@vflare.org>, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary="=-A06Atq1rmSVCpZYkfjM4"
Date: Fri, 15 Oct 2010 13:31:20 -0700
Message-ID: <1287174680.10966.6686.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-A06Atq1rmSVCpZYkfjM4
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Content-Transfer-Encoding: 7bit

After I pulled Linus's latest git, I can no longer initialize my zram
devices.  Looks like it is caused by this commit:

commit 7e24cce38a99f373450db67bf576fe73e8168d66
Author: Anton Blanchard <anton@samba.org>
Date:   Fri Oct 1 14:19:55 2010 -0700

>     I'm getting an oops when running mkfs on zram:
>     
>     NIP [d0000000030e0340] .zram_inc_stat+0x58/0x84 [zram]
>     [c00000006d58f720] [d0000000030e091c] .zram_make_request+0xa8/0x6a0 [zram]
>     [c00000006d58f840] [c00000000035795c] .generic_make_request+0x390/0x434
>     [c00000006d58f950] [c000000000357b14] .submit_bio+0x114/0x140
>     [c00000006d58fa20] [c000000000361778] .blkdev_issue_discard+0x1ac/0x250
>     [c00000006d58fb10] [c000000000361f68] .blkdev_ioctl+0x358/0x7fc
>     [c00000006d58fbd0] [c0000000001c1c1c] .block_ioctl+0x6c/0x90
>     [c00000006d58fc70] [c0000000001984c4] .do_vfs_ioctl+0x660/0x6d4
>     [c00000006d58fd70] [c0000000001985a0] .SyS_ioctl+0x68/0xb0
>     
>     Since disksize no longer starts as 0 it looks like we can call
>     zram_make_request before the device has been initialised. The patch below
>     fixes the immediate problem but this would go away if we move the
>     initialisation function elsewhere (as suggested in another thread).
>     
>     Signed-off-by: Anton Blanchard <anton@samba.org>
>     Cc: Nitin Gupta <ngupta@vflare.org>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> index c5f84ee..72f1b9c 100644
> --- a/drivers/staging/zram/zram_drv.c
> +++ b/drivers/staging/zram/zram_drv.c
> @@ -435,6 +435,12 @@ static int zram_make_request(struct request_queue *queue, struct bio *bio)
>         int ret = 0;
>         struct zram *zram = queue->queuedata;
>  
> +       if (unlikely(!zram->init_done)) {
> +               set_bit(BIO_UPTODATE, &bio->bi_flags);
> +               bio_endio(bio, 0);
> +               return 0;
> +       }
> +

The issue appears because:

1. zram_init_device() is the only code to set zram->init_done=1
2. zram_write() is the only caller of zram_init_device()
3. zram_make_request() checks for zram->init_done==0 and will never
   call zram_write() if zram->init_done==0

I'm not sure how this code ever worked.  Maybe if you pass the disk size
as a module parameter.  I suspect that Anton's patch was against a
different version anyway.

I have the feeling that we just need to do something like the attached
patch (which is just for commenting at this point).  Instead of needing
multiple file writes, if someone writes to one of the config variables,
we just reset the disk then and there.

Another option might be to move the configuration to configfs.  Don't
allow zram devices to be modified once they are created.  If you want to
change one, you remove the existing device and create a new one.  That
would remove any confusion about initialization.  If there's a device
there, it's initialized, period.

-- Dave

--=-A06Atq1rmSVCpZYkfjM4
Content-Disposition: attachment; filename="dont-depend-on-rw-for-init.patch"
Content-Type: text/x-patch; name="dont-depend-on-rw-for-init.patch"; charset="ANSI_X3.4-1968"
Content-Transfer-Encoding: 7bit



---

 linux-2.6.git-dave/drivers/staging/zram/zram_drv.c   |   29 -------------
 linux-2.6.git-dave/drivers/staging/zram/zram_sysfs.c |   41 +++----------------
 2 files changed, 9 insertions(+), 61 deletions(-)

diff -puN drivers/staging/zram/zram_drv.c~dont-depend-on-rw-for-init drivers/staging/zram/zram_drv.c
--- linux-2.6.git/drivers/staging/zram/zram_drv.c~dont-depend-on-rw-for-init	2010-10-15 10:48:14.000000000 -0700
+++ linux-2.6.git-dave/drivers/staging/zram/zram_drv.c	2010-10-15 11:10:41.000000000 -0700
@@ -207,12 +207,6 @@ static int zram_read(struct zram *zram, 
 	u32 index;
 	struct bio_vec *bvec;
 
-	if (unlikely(!zram->init_done)) {
-		set_bit(BIO_UPTODATE, &bio->bi_flags);
-		bio_endio(bio, 0);
-		return 0;
-	}
-
 	zram_stat64_inc(zram, &zram->stats.num_reads);
 	index = bio->bi_sector >> SECTORS_PER_PAGE_SHIFT;
 
@@ -285,12 +279,6 @@ static int zram_write(struct zram *zram,
 	u32 index;
 	struct bio_vec *bvec;
 
-	if (unlikely(!zram->init_done)) {
-		ret = zram_init_device(zram);
-		if (ret)
-			goto out;
-	}
-
 	zram_stat64_inc(zram, &zram->stats.num_writes);
 	index = bio->bi_sector >> SECTORS_PER_PAGE_SHIFT;
 
@@ -435,12 +423,6 @@ static int zram_make_request(struct requ
 	int ret = 0;
 	struct zram *zram = queue->queuedata;
 
-	if (unlikely(!zram->init_done)) {
-		set_bit(BIO_UPTODATE, &bio->bi_flags);
-		bio_endio(bio, 0);
-		return 0;
-	}
-
 	if (!valid_io_request(zram, bio)) {
 		zram_stat64_inc(zram, &zram->stats.invalid_io);
 		bio_io_error(bio);
@@ -465,7 +447,6 @@ void zram_reset_device(struct zram *zram
 	size_t index;
 
 	mutex_lock(&zram->init_lock);
-	zram->init_done = 0;
 
 	/* Free various per-device buffers */
 	kfree(zram->compress_workmem);
@@ -511,10 +492,7 @@ int zram_init_device(struct zram *zram)
 
 	mutex_lock(&zram->init_lock);
 
-	if (zram->init_done) {
-		mutex_unlock(&zram->init_lock);
-		return 0;
-	}
+	BUG_ON(zram->init_done);
 
 	zram_set_disksize(zram, totalram_pages << PAGE_SHIFT);
 
@@ -642,8 +620,6 @@ static int create_device(struct zram *zr
 	}
 #endif
 
-	zram->init_done = 0;
-
 out:
 	return ret;
 }
@@ -721,8 +697,7 @@ static void __exit zram_exit(void)
 		zram = &devices[i];
 
 		destroy_device(zram);
-		if (zram->init_done)
-			zram_reset_device(zram);
+		zram_reset_device(zram);
 	}
 
 	unregister_blkdev(zram_major, "zram");
diff -puN drivers/staging/zram/zram_drv.h~dont-depend-on-rw-for-init drivers/staging/zram/zram_drv.h
diff -puN drivers/staging/zram/zram_sysfs.c~dont-depend-on-rw-for-init drivers/staging/zram/zram_sysfs.c
--- linux-2.6.git/drivers/staging/zram/zram_sysfs.c~dont-depend-on-rw-for-init	2010-10-15 10:48:14.000000000 -0700
+++ linux-2.6.git-dave/drivers/staging/zram/zram_sysfs.c	2010-10-15 11:15:27.000000000 -0700
@@ -57,6 +57,7 @@ static ssize_t disksize_store(struct dev
 {
 	int ret;
 	struct zram *zram = dev_to_zram(dev);
+	struct block_device *bdev;
 
 	if (zram->init_done) {
 		pr_info("Cannot change disksize for initialized device\n");
@@ -67,8 +68,14 @@ static ssize_t disksize_store(struct dev
 	if (ret)
 		return ret;
 
+	bdev = bdget_disk(zram->disk, 0);
+	/* Do not reset an active device! */
+	if (bdev->bd_holders)
+		return -EBUSY;
+
 	zram->disksize &= PAGE_MASK;
 	set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT);
+	zram_init_device(zram);
 
 	return len;
 }
@@ -81,38 +88,6 @@ static ssize_t initstate_show(struct dev
 	return sprintf(buf, "%u\n", zram->init_done);
 }
 
-static ssize_t reset_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t len)
-{
-	int ret;
-	unsigned long do_reset;
-	struct zram *zram;
-	struct block_device *bdev;
-
-	zram = dev_to_zram(dev);
-	bdev = bdget_disk(zram->disk, 0);
-
-	/* Do not reset an active device! */
-	if (bdev->bd_holders)
-		return -EBUSY;
-
-	ret = strict_strtoul(buf, 10, &do_reset);
-	if (ret)
-		return ret;
-
-	if (!do_reset)
-		return -EINVAL;
-
-	/* Make sure all pending I/O is finished */
-	if (bdev)
-		fsync_bdev(bdev);
-
-	if (zram->init_done)
-		zram_reset_device(zram);
-
-	return len;
-}
-
 static ssize_t num_reads_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -192,7 +167,6 @@ static ssize_t mem_used_total_show(struc
 static DEVICE_ATTR(disksize, S_IRUGO | S_IWUGO,
 		disksize_show, disksize_store);
 static DEVICE_ATTR(initstate, S_IRUGO, initstate_show, NULL);
-static DEVICE_ATTR(reset, S_IWUGO, NULL, reset_store);
 static DEVICE_ATTR(num_reads, S_IRUGO, num_reads_show, NULL);
 static DEVICE_ATTR(num_writes, S_IRUGO, num_writes_show, NULL);
 static DEVICE_ATTR(invalid_io, S_IRUGO, invalid_io_show, NULL);
@@ -205,7 +179,6 @@ static DEVICE_ATTR(mem_used_total, S_IRU
 static struct attribute *zram_disk_attrs[] = {
 	&dev_attr_disksize.attr,
 	&dev_attr_initstate.attr,
-	&dev_attr_reset.attr,
 	&dev_attr_num_reads.attr,
 	&dev_attr_num_writes.attr,
 	&dev_attr_invalid_io.attr,
diff -puN drivers/staging/zram/zram_drv.c~dont-depend-on-rw-for-init~dont-depend-on-rw-for-init drivers/staging/zram/zram_drv.c~dont-depend-on-rw-for-init
diff -puN drivers/staging/zram/zram_drv.h~dont-depend-on-rw-for-init~dont-depend-on-rw-for-init drivers/staging/zram/zram_drv.h~dont-depend-on-rw-for-init
diff -puN drivers/staging/zram/zram_sysfs.c~dont-depend-on-rw-for-init~dont-depend-on-rw-for-init drivers/staging/zram/zram_sysfs.c~dont-depend-on-rw-for-init
_

--=-A06Atq1rmSVCpZYkfjM4--

