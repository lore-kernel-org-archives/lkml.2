Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab1DARnt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 13:43:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28478 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393Ab1DARns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 13:43:48 -0400
Date: Fri, 1 Apr 2011 13:42:59 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: device-mapper development <dm-devel@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <jaxboe@fusionio.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <James.Bottomley@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] dm: improve block integrity support
Message-ID: <20110401174259.GA22598@redhat.com>
References: <alpine.LFD.2.00.1103290006070.2774@localhost6.localdomain6>
 <alpine.LFD.2.00.1103290040300.2774@localhost6.localdomain6>
 <20110328230319.GA12790@redhat.com>
 <4D918347.7050500@fusionio.com>
 <20110329132032.GA22921@redhat.com>
 <yq1lizyhwlr.fsf@sermon.lab.mkp.net>
 <20110329135800.GB23508@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110329135800.GB23508@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current block integrity (DIF/DIX) support in DM is verifying that
all devices' integrity profiles match during DM device resume (which
is past the point of no return).  To some degree that is unavoidable
(stacked DM devices force this late checking).  But for most DM
devices (which aren't stacking on other DM devices) the ideal time to
verify all integrity profiles match is during table load.

Introduce the notion of an "initialized" integrity profile: a profile
that was blk_integrity_register()'d with a non-NULL 'blk_integrity'
template.  Add blk_integrity_is_initialized() to allow checking if a
profile was initialized.

Update DM integrity support to:
- check all devices with _initialized_ integrity profiles match
  during table load; uninitialized profiles (e.g. for underlying DM
  device(s) of a stacked DM device) are ignored.
- disallow a table load that would result in an integrity profile that
  conflicts with a DM device's existing (in-use) integrity profile
- avoid clearing an existing integrity profile
- validate all integrity profiles match during resume; but if they
  don't all we can do is report the mismatch (during resume we're past
  the point of no return)

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/blk-integrity.c  |   12 +++++-
 drivers/md/dm-table.c  |  114 +++++++++++++++++++++++++++++++++--------------
 include/linux/blkdev.h |    2 +
 3 files changed, 93 insertions(+), 35 deletions(-)

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 54bcba6..129b9e2 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -30,6 +30,8 @@
 
 static struct kmem_cache *integrity_cachep;
 
+static const char *bi_unsupported_name = "unsupported";
+
 /**
  * blk_rq_count_integrity_sg - Count number of integrity scatterlist elements
  * @q:		request queue
@@ -358,6 +360,14 @@ static struct kobj_type integrity_ktype = {
 	.release	= blk_integrity_release,
 };
 
+bool blk_integrity_is_initialized(struct gendisk *disk)
+{
+	struct blk_integrity *bi = blk_get_integrity(disk);
+
+	return (bi && bi->name && strcmp(bi->name, bi_unsupported_name) != 0);
+}
+EXPORT_SYMBOL(blk_integrity_is_initialized);
+
 /**
  * blk_integrity_register - Register a gendisk as being integrity-capable
  * @disk:	struct gendisk pointer to make integrity-aware
@@ -407,7 +417,7 @@ int blk_integrity_register(struct gendisk *disk, struct blk_integrity *template)
 		bi->get_tag_fn = template->get_tag_fn;
 		bi->tag_size = template->tag_size;
 	} else
-		bi->name = "unsupported";
+		bi->name = bi_unsupported_name;
 
 	return 0;
 }
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 416d4e2..cb8380c 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -927,20 +927,80 @@ static int dm_table_build_index(struct dm_table *t)
 }
 
 /*
+ * Get a disk whose integrity profile reflects the table's profile.
+ * If %match_all is true, all devices' profiles must match.
+ * If %match_all is false, all devices must at least have an
+ * allocated integrity profile; but uninitialized is ok.
+ * Returns NULL if integrity support was inconsistent or unavailable.
+ */
+static struct gendisk * dm_table_get_integrity_disk(struct dm_table *t,
+						    bool match_all)
+{
+	struct list_head *devices = dm_table_get_devices(t);
+	struct dm_dev_internal *dd = NULL;
+	struct gendisk *prev_disk = NULL, *template_disk = NULL;
+
+	list_for_each_entry(dd, devices, list) {
+		template_disk = dd->dm_dev.bdev->bd_disk;
+		if (!blk_get_integrity(template_disk))
+			goto no_integrity;
+		if (!match_all && !blk_integrity_is_initialized(template_disk))
+			continue; /* skip uninitialized profiles */
+		else if (prev_disk &&
+			 blk_integrity_compare(prev_disk, template_disk) < 0)
+			goto no_integrity;
+		prev_disk = template_disk;
+	}
+
+	return template_disk;
+
+no_integrity:
+	if (prev_disk)
+		DMWARN("%s: integrity not set: %s and %s profile mismatch",
+		       dm_device_name(t->md),
+		       prev_disk->disk_name,
+		       template_disk->disk_name);
+	return NULL;
+}
+
+/*
  * Register the mapped device for blk_integrity support if
- * the underlying devices support it.
+ * the underlying devices have an integrity profile.  But all devices
+ * may not have matching profiles (checking all devices isn't reliable
+ * during table load because this table may use other DM device(s) which
+ * must be resumed before they will have an initialized integity profile).
+ * Stacked DM devices force a 2 stage integrity profile validation:
+ * 1 - during load, validate all initialized integrity profiles match
+ * 2 - during resume, validate all integrity profiles match
  */
 static int dm_table_prealloc_integrity(struct dm_table *t, struct mapped_device *md)
 {
-	struct list_head *devices = dm_table_get_devices(t);
-	struct dm_dev_internal *dd;
+	struct gendisk *template_disk = NULL;
 
-	list_for_each_entry(dd, devices, list)
-		if (bdev_get_integrity(dd->dm_dev.bdev)) {
-			t->integrity_supported = 1;
-			return blk_integrity_register(dm_disk(md), NULL);
-		}
+	template_disk = dm_table_get_integrity_disk(t, false);
+	if (!template_disk)
+		return 0;
 
+	if (!blk_integrity_is_initialized(dm_disk(md))) {
+		t->integrity_supported = 1;
+		return blk_integrity_register(dm_disk(md), NULL);
+	}
+
+	/*
+	 * If DM device already has an initalized integrity
+	 * profile the new profile should not conflict.
+	 */
+	if (blk_integrity_is_initialized(template_disk) &&
+	    blk_integrity_compare(dm_disk(md), template_disk) < 0) {
+		DMWARN("%s: conflict with existing integrity profile: "
+		       "%s profile mismatch",
+		       dm_device_name(t->md),
+		       template_disk->disk_name);
+		return 1;
+	}
+
+	/* Preserve existing initialized integrity profile */
+	t->integrity_supported = 1;
 	return 0;
 }
 
@@ -1094,41 +1154,27 @@ combine_limits:
 
 /*
  * Set the integrity profile for this device if all devices used have
- * matching profiles.
+ * matching profiles.  We're quite deep in the resume path but still
+ * don't know if all devices (particularly DM devices this device
+ * may be stacked on) have matching profiles.  Even if the profiles
+ * don't match we have no way to fail (to resume) at this point.
  */
 static void dm_table_set_integrity(struct dm_table *t)
 {
-	struct list_head *devices = dm_table_get_devices(t);
-	struct dm_dev_internal *prev = NULL, *dd = NULL;
+	struct gendisk *template_disk = NULL;
 
 	if (!blk_get_integrity(dm_disk(t->md)))
 		return;
 
-	list_for_each_entry(dd, devices, list) {
-		if (prev &&
-		    blk_integrity_compare(prev->dm_dev.bdev->bd_disk,
-					  dd->dm_dev.bdev->bd_disk) < 0) {
-			DMWARN("%s: integrity not set: %s and %s mismatch",
-			       dm_device_name(t->md),
-			       prev->dm_dev.bdev->bd_disk->disk_name,
-			       dd->dm_dev.bdev->bd_disk->disk_name);
-			goto no_integrity;
-		}
-		prev = dd;
+	template_disk = dm_table_get_integrity_disk(t, true);
+	if (!template_disk &&
+	    blk_integrity_is_initialized(dm_disk(t->md))) {
+		DMWARN("%s: device no longer has a valid integrity profile",
+		       dm_device_name(t->md));
+		return;
 	}
-
-	if (!prev || !bdev_get_integrity(prev->dm_dev.bdev))
-		goto no_integrity;
-
 	blk_integrity_register(dm_disk(t->md),
-			       bdev_get_integrity(prev->dm_dev.bdev));
-
-	return;
-
-no_integrity:
-	blk_integrity_register(dm_disk(t->md), NULL);
-
-	return;
+			       blk_get_integrity(template_disk));
 }
 
 void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 16a902f..32176cc 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1206,6 +1206,7 @@ struct blk_integrity {
 	struct kobject		kobj;
 };
 
+extern bool blk_integrity_is_initialized(struct gendisk *);
 extern int blk_integrity_register(struct gendisk *, struct blk_integrity *);
 extern void blk_integrity_unregister(struct gendisk *);
 extern int blk_integrity_compare(struct gendisk *, struct gendisk *);
@@ -1262,6 +1263,7 @@ queue_max_integrity_segments(struct request_queue *q)
 #define queue_max_integrity_segments(a)		(0)
 #define blk_integrity_merge_rq(a, b, c)		(0)
 #define blk_integrity_merge_bio(a, b, c)	(0)
+#define blk_integrity_is_initialized(a)		(0)
 
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
 
