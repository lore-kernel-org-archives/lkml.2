Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933654Ab1C3VMD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:12:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:25196 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965351Ab1C3VKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:10:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621239561"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: neilb@suse.de, ak@linux.intel.com, stable@kernel.org,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [267/275] md: Fix - again - partition detection when array becomes active
Message-Id: <20110330210834.BDD063E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:08:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: NeilBrown <neilb@suse.de>

[ upstream commit f0b4f7e2f29af678bd9af43422c537dcb6008603 ]

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: stable@kernel.org

---
 drivers/md/md.c |   22 +++++++++++++++++++++-
 drivers/md/md.h |    2 ++
 2 files changed, 23 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/md/md.c
===================================================================
--- linux-2.6.35.y.orig/drivers/md/md.c	2011-03-29 23:03:01.000000000 -0700
+++ linux-2.6.35.y/drivers/md/md.c	2011-03-29 23:45:22.648240160 -0700
@@ -4550,6 +4550,7 @@
 
 	set_capacity(mddev->gendisk, mddev->array_sectors);
 	revalidate_disk(mddev->gendisk);
+	mddev->changed = 1;
 	kobject_uevent(&disk_to_dev(mddev->gendisk)->kobj, KOBJ_CHANGE);
 out:
 	return err;
@@ -4638,6 +4639,7 @@
 	mddev->sync_speed_min = mddev->sync_speed_max = 0;
 	mddev->recovery = 0;
 	mddev->in_sync = 0;
+	mddev->changed = 0;
 	mddev->degraded = 0;
 	mddev->barriers_work = 0;
 	mddev->safemode = 0;
@@ -4744,6 +4746,7 @@
 
 		set_capacity(disk, 0);
 		revalidate = 1;
+		mddev->changed = 1;
 
 		if (mddev->ro)
 			mddev->ro = 0;
@@ -5930,7 +5933,7 @@
 	atomic_inc(&mddev->openers);
 	mutex_unlock(&mddev->open_mutex);
 
-	check_disk_size_change(mddev->gendisk, bdev);
+	check_disk_change(bdev);
  out:
 	return err;
 }
@@ -5945,6 +5948,21 @@
 
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
@@ -5955,6 +5973,8 @@
 	.compat_ioctl	= md_compat_ioctl,
 #endif
 	.getgeo		= md_getgeo,
+	.media_changed  = md_media_changed,
+	.revalidate_disk= md_revalidate,
 };
 
 static int md_thread(void * arg)
Index: linux-2.6.35.y/drivers/md/md.h
===================================================================
--- linux-2.6.35.y.orig/drivers/md/md.h	2011-01-13 09:47:51.000000000 -0800
+++ linux-2.6.35.y/drivers/md/md.h	2011-03-29 23:44:32.646519581 -0700
@@ -250,6 +250,8 @@
 	atomic_t			active;		/* general refcount */
 	atomic_t			openers;	/* number of active opens */
 
+	int				changed;	/* True if we might need to
+							 * reread partition info */
 	int				degraded;	/* whether md should consider
 							 * adding a spare
 							 */
