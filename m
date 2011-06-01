Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161789Ab1FAIOJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:14:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:43678 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908Ab1FAIOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:14:03 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:03:53 2011
Message-Id: <20110601080352.700724063@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:00:23 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        NeilBrown <neilb@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [087/146] md: Fix race when creating a new md device.
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: NeilBrown <neilb@suse.de>

commit b0140891a8cea36469f58d23859e599b1122bd37 upstream.

There is a race when creating an md device by opening /dev/mdXX.

If two processes do this at much the same time they will follow the
call path
  __blkdev_get -> get_gendisk -> kobj_lookup

The first will call
  -> md_probe -> md_alloc -> add_disk -> blk_register_region

and the race happens when the second gets to kobj_lookup after
add_disk has called blk_register_region but before it returns to
md_alloc.

In the case the second will not call md_probe (as the probe is already
done) but will get a handle on the gendisk, return to __blkdev_get
which will then call md_open (via the ->open) pointer.

As mddev->gendisk hasn't been set yet, md_open will think something is
wrong an return with ERESTARTSYS.

This can loop endlessly while the first thread makes no progress
through add_disk.  Nothing is blocking it, but due to scheduler
behaviour it doesn't get a turn.
So this is essentially a live-lock.

We fix this by simply moving the assignment to mddev->gendisk before
the call the add_disk() so md_open doesn't get confused.
Also move blk_queue_flush earlier because add_disk should be as late
as possible.

To make sure that md_open doesn't complete until md_alloc has done all
that is needed, we take mddev->open_mutex during the last part of
md_alloc.  md_open will wait for this.

This can cause a lock-up on boot so Cc:ing for stable.
For 2.6.36 and earlier a different patch will be needed as the
'blk_queue_flush' call isn't there.

Signed-off-by: NeilBrown <neilb@suse.de>
Reported-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
Tested-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/md.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4335,13 +4335,19 @@ static int md_alloc(dev_t dev, char *nam
 	disk->fops = &md_fops;
 	disk->private_data = mddev;
 	disk->queue = mddev->queue;
+	blk_queue_flush(mddev->queue, REQ_FLUSH | REQ_FUA);
 	/* Allow extended partitions.  This makes the
 	 * 'mdp' device redundant, but we can't really
 	 * remove it now.
 	 */
 	disk->flags |= GENHD_FL_EXT_DEVT;
-	add_disk(disk);
 	mddev->gendisk = disk;
+	/* As soon as we call add_disk(), another thread could get
+	 * through to md_open, so make sure it doesn't get too far
+	 */
+	mutex_lock(&mddev->open_mutex);
+	add_disk(disk);
+
 	error = kobject_init_and_add(&mddev->kobj, &md_ktype,
 				     &disk_to_dev(disk)->kobj, "%s", "md");
 	if (error) {
@@ -4355,8 +4361,7 @@ static int md_alloc(dev_t dev, char *nam
 	if (mddev->kobj.sd &&
 	    sysfs_create_group(&mddev->kobj, &md_bitmap_group))
 		printk(KERN_DEBUG "pointless warning\n");
-
-	blk_queue_flush(mddev->queue, REQ_FLUSH | REQ_FUA);
+	mutex_unlock(&mddev->open_mutex);
  abort:
 	mutex_unlock(&disks_mutex);
 	if (!error && mddev->kobj.sd) {


