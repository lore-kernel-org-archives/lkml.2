Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760368Ab1CEBAO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:00:14 -0500
Received: from kroah.org ([198.145.64.141]:50220 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760348Ab1CEBAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:00:11 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:37 2011
Message-Id: <20110305005637.029391792@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:55:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        NeilBrown <neilb@suse.de>
Subject: [25/73] md: Fix - again - partition detection when array becomes active
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: NeilBrown <neilb@suse.de>

commit f0b4f7e2f29af678bd9af43422c537dcb6008603 upstream.

Revert
    b821eaa572fd737faaf6928ba046e571526c36c6
and
    f3b99be19ded511a1bf05a148276239d9f13eefa

When I wrote the first of these I had a wrong idea about the
lifetime of 'struct block_device'.  It can disappear at any time that
the block device is not open if it falls out of the inode cache.

So relying on the 'size' recorded with it to detect when the
device size has changed and so we need to revalidate, is wrong.

Rather, we really do need the 'changed' attribute stored directly in
the mddev and set/tested as appropriate.

Without this patch, a sequence of:
   mknod / open / close / unlink

(which can cause a block_device to be created and then destroyed)
will result in a rescan of the partition table and consequence removal
and addition of partitions.
Several of these in a row can get udev racing to create and unlink and
other code can get confused.

With the patch, the rescan is only performed when needed and so there
are no races.

This is suitable for any stable kernel from 2.6.35.

Reported-by: "Wojcik, Krzysztof" <krzysztof.wojcik@intel.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/md.c |   22 +++++++++++++++++++++-
 drivers/md/md.h |    2 ++
 2 files changed, 23 insertions(+), 1 deletion(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4614,6 +4614,7 @@ static int do_md_run(mddev_t *mddev)
 	}
 	set_capacity(mddev->gendisk, mddev->array_sectors);
 	revalidate_disk(mddev->gendisk);
+	mddev->changed = 1;
 	kobject_uevent(&disk_to_dev(mddev->gendisk)->kobj, KOBJ_CHANGE);
 out:
 	return err;
@@ -4702,6 +4703,7 @@ static void md_clean(mddev_t *mddev)
 	mddev->sync_speed_min = mddev->sync_speed_max = 0;
 	mddev->recovery = 0;
 	mddev->in_sync = 0;
+	mddev->changed = 0;
 	mddev->degraded = 0;
 	mddev->safemode = 0;
 	mddev->bitmap_info.offset = 0;
@@ -4811,6 +4813,7 @@ static int do_md_stop(mddev_t * mddev, i
 
 		set_capacity(disk, 0);
 		mutex_unlock(&mddev->open_mutex);
+		mddev->changed = 1;
 		revalidate_disk(disk);
 
 		if (mddev->ro)
@@ -5994,7 +5997,7 @@ static int md_open(struct block_device *
 	atomic_inc(&mddev->openers);
 	mutex_unlock(&mddev->open_mutex);
 
-	check_disk_size_change(mddev->gendisk, bdev);
+	check_disk_change(bdev);
  out:
 	return err;
 }
@@ -6009,6 +6012,21 @@ static int md_release(struct gendisk *di
 
 	return 0;
 }
+
+static int md_media_changed(struct gendisk *disk)
+{
+	mddev_t *mddev = disk->private_data;
+
+	return mddev->changed;
+}
+
+static int md_revalidate(struct gendisk *disk)
+{
+	mddev_t *mddev = disk->private_data;
+
+	mddev->changed = 0;
+	return 0;
+}
 static const struct block_device_operations md_fops =
 {
 	.owner		= THIS_MODULE,
@@ -6019,6 +6037,8 @@ static const struct block_device_operati
 	.compat_ioctl	= md_compat_ioctl,
 #endif
 	.getgeo		= md_getgeo,
+	.media_changed  = md_media_changed,
+	.revalidate_disk= md_revalidate,
 };
 
 static int md_thread(void * arg)
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -270,6 +270,8 @@ struct mddev_s
 	atomic_t			active;		/* general refcount */
 	atomic_t			openers;	/* number of active opens */
 
+	int				changed;	/* True if we might need to
+							 * reread partition info */
 	int				degraded;	/* whether md should consider
 							 * adding a spare
 							 */


