Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932937Ab0HXW65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 18:58:57 -0400
Received: from kroah.org ([198.145.64.141]:40422 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932924Ab0HXW6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:58:51 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:42:15 2010
Message-Id: <20100824224215.509611680@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:42:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mikulas Patocka <mpatocka@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>
Subject: [40/91] dm snapshot: test chunk size against both origin and snapshot
In-Reply-To: <20100824224617.GA5440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit c24110450650f17f7d3ba4fbe01f01ac5a115456 upstream.

Validate chunk size against both origin and snapshot sector size

Don't allow chunk size smaller than either origin or snapshot logical
sector size. Reading or writing data not aligned to sector size is not
allowed and causes immediate errors.

This requires us to open the origin before initialising the
exception store and to export dm_snap_origin.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-exception-store.c |    4 +++-
 drivers/md/dm-exception-store.h |    3 ++-
 drivers/md/dm-snap.c            |   36 +++++++++++++++++++++---------------
 3 files changed, 26 insertions(+), 17 deletions(-)

--- a/drivers/md/dm-exception-store.c
+++ b/drivers/md/dm-exception-store.c
@@ -173,7 +173,9 @@ int dm_exception_store_set_chunk_size(st
 
 	/* Validate the chunk size against the device block size */
 	if (chunk_size %
-	    (bdev_logical_block_size(dm_snap_cow(store->snap)->bdev) >> 9)) {
+	    (bdev_logical_block_size(dm_snap_cow(store->snap)->bdev) >> 9) ||
+	    chunk_size %
+	    (bdev_logical_block_size(dm_snap_origin(store->snap)->bdev) >> 9)) {
 		*error = "Chunk size is not a multiple of device blocksize";
 		return -EINVAL;
 	}
--- a/drivers/md/dm-exception-store.h
+++ b/drivers/md/dm-exception-store.h
@@ -126,8 +126,9 @@ struct dm_exception_store {
 };
 
 /*
- * Obtain the cow device used by a given snapshot.
+ * Obtain the origin or cow device used by a given snapshot.
  */
+struct dm_dev *dm_snap_origin(struct dm_snapshot *snap);
 struct dm_dev *dm_snap_cow(struct dm_snapshot *snap);
 
 /*
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -148,6 +148,12 @@ struct dm_snapshot {
 #define RUNNING_MERGE          0
 #define SHUTDOWN_MERGE         1
 
+struct dm_dev *dm_snap_origin(struct dm_snapshot *s)
+{
+	return s->origin;
+}
+EXPORT_SYMBOL(dm_snap_origin);
+
 struct dm_dev *dm_snap_cow(struct dm_snapshot *s)
 {
 	return s->cow;
@@ -1065,10 +1071,6 @@ static int snapshot_ctr(struct dm_target
 		origin_mode = FMODE_WRITE;
 	}
 
-	origin_path = argv[0];
-	argv++;
-	argc--;
-
 	s = kmalloc(sizeof(*s), GFP_KERNEL);
 	if (!s) {
 		ti->error = "Cannot allocate snapshot context private "
@@ -1077,6 +1079,16 @@ static int snapshot_ctr(struct dm_target
 		goto bad;
 	}
 
+	origin_path = argv[0];
+	argv++;
+	argc--;
+
+	r = dm_get_device(ti, origin_path, origin_mode, &s->origin);
+	if (r) {
+		ti->error = "Cannot get origin device";
+		goto bad_origin;
+	}
+
 	cow_path = argv[0];
 	argv++;
 	argc--;
@@ -1097,12 +1109,6 @@ static int snapshot_ctr(struct dm_target
 	argv += args_used;
 	argc -= args_used;
 
-	r = dm_get_device(ti, origin_path, origin_mode, &s->origin);
-	if (r) {
-		ti->error = "Cannot get origin device";
-		goto bad_origin;
-	}
-
 	s->ti = ti;
 	s->valid = 1;
 	s->active = 0;
@@ -1212,15 +1218,15 @@ bad_kcopyd:
 	dm_exception_table_exit(&s->complete, exception_cache);
 
 bad_hash_tables:
-	dm_put_device(ti, s->origin);
-
-bad_origin:
 	dm_exception_store_destroy(s->store);
 
 bad_store:
 	dm_put_device(ti, s->cow);
 
 bad_cow:
+	dm_put_device(ti, s->origin);
+
+bad_origin:
 	kfree(s);
 
 bad:
@@ -1314,12 +1320,12 @@ static void snapshot_dtr(struct dm_targe
 
 	mempool_destroy(s->pending_pool);
 
-	dm_put_device(ti, s->origin);
-
 	dm_exception_store_destroy(s->store);
 
 	dm_put_device(ti, s->cow);
 
+	dm_put_device(ti, s->origin);
+
 	kfree(s);
 }
 


