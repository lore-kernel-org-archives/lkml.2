Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab1DFWiB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 18:38:01 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:55209
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755295Ab1DFWh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 18:37:59 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 17/22] Staging: hv: Get rid of the forward declaration for blkvsc_do_request()
Date: Wed,  6 Apr 2011 14:35:15 -0700
Message-Id: <1302125720-10808-17-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302125720-10808-1-git-send-email-kys@microsoft.com>
References: <1302125655-10741-1-git-send-email-kys@microsoft.com>
 <1302125720-10808-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the forward declaration for blkvsc_do_request() by moving the
code around.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |  370 ++++++++++++++++++++-------------------
 1 files changed, 193 insertions(+), 177 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index f7bf42f..9d4fcbd 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -118,6 +118,12 @@ static const struct hv_guid g_blk_device_type = {
 	}
 };
 
+/*
+ * There is a circular dependency involving blkvsc_request_completion()
+ * and blkvsc_do_request().
+ */
+static void blkvsc_request_completion(struct hv_storvsc_request *request);
+
 static int blk_vsc_on_device_add(struct hv_device *device,
 				void *additional_info)
 {
@@ -955,12 +961,196 @@ static int blkvsc_do_inquiry(struct block_device_context *blkdev)
 	return 0;
 }
 
+
+/*
+ * We break the request into 1 or more blkvsc_requests and submit
+ * them.  If we cant submit them all, we put them on the
+ * pending_list. The blkvsc_request() will work on the pending_list.
+ */
+static int blkvsc_do_request(struct block_device_context *blkdev,
+			     struct request *req)
+{
+	struct bio *bio = NULL;
+	struct bio_vec *bvec = NULL;
+	struct bio_vec *prev_bvec = NULL;
+	struct blkvsc_request *blkvsc_req = NULL;
+	struct blkvsc_request *tmp;
+	int databuf_idx = 0;
+	int seg_idx = 0;
+	sector_t start_sector;
+	unsigned long num_sectors = 0;
+	int ret = 0;
+	int pending = 0;
+	struct blkvsc_request_group *group = NULL;
+
+	DPRINT_DBG(BLKVSC_DRV, "blkdev %p req %p sect %lu\n", blkdev, req,
+		  (unsigned long)blk_rq_pos(req));
+
+	/* Create a group to tie req to list of blkvsc_reqs */
+	group = kmem_cache_zalloc(blkdev->request_pool, GFP_ATOMIC);
+	if (!group)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&group->blkvsc_req_list);
+	group->outstanding = group->status = 0;
+
+	start_sector = blk_rq_pos(req);
+
+	/* foreach bio in the request */
+	if (req->bio) {
+		for (bio = req->bio; bio; bio = bio->bi_next) {
+			/*
+			 * Map this bio into an existing or new storvsc request
+			 */
+			bio_for_each_segment(bvec, bio, seg_idx) {
+				DPRINT_DBG(BLKVSC_DRV, "bio_for_each_segment() "
+					   "- req %p bio %p bvec %p seg_idx %d "
+					   "databuf_idx %d\n", req, bio, bvec,
+					   seg_idx, databuf_idx);
+
+				/* Get a new storvsc request */
+				/* 1st-time */
+				if ((!blkvsc_req) ||
+				    (databuf_idx >= MAX_MULTIPAGE_BUFFER_COUNT)
+				    /* hole at the begin of page */
+				    || (bvec->bv_offset != 0) ||
+				    /* hold at the end of page */
+				    (prev_bvec &&
+				     (prev_bvec->bv_len != PAGE_SIZE))) {
+					/* submit the prev one */
+					if (blkvsc_req) {
+						blkvsc_req->sector_start =
+						start_sector;
+						sector_div(
+						blkvsc_req->sector_start,
+						(blkdev->sector_size >> 9));
+
+						blkvsc_req->sector_count =
+						num_sectors /
+						(blkdev->sector_size >> 9);
+						blkvsc_init_rw(blkvsc_req);
+					}
+
+					/*
+					 * Create new blkvsc_req to represent
+					 * the current bvec
+					 */
+					blkvsc_req =
+					kmem_cache_zalloc(
+					blkdev->request_pool, GFP_ATOMIC);
+					if (!blkvsc_req) {
+						/* free up everything */
+						list_for_each_entry_safe(
+							blkvsc_req, tmp,
+							&group->blkvsc_req_list,
+							req_entry) {
+							list_del(
+							&blkvsc_req->req_entry);
+							kmem_cache_free(
+							blkdev->request_pool,
+							blkvsc_req);
+						}
+
+						kmem_cache_free(
+						blkdev->request_pool, group);
+						return -ENOMEM;
+					}
+
+					memset(blkvsc_req, 0,
+					       sizeof(struct blkvsc_request));
+
+					blkvsc_req->dev = blkdev;
+					blkvsc_req->req = req;
+					blkvsc_req->request.
+					data_buffer.offset
+					= bvec->bv_offset;
+					blkvsc_req->request.
+					data_buffer.len = 0;
+
+					/* Add to the group */
+					blkvsc_req->group = group;
+					blkvsc_req->group->outstanding++;
+					list_add_tail(&blkvsc_req->req_entry,
+					&blkvsc_req->group->blkvsc_req_list);
+
+					start_sector += num_sectors;
+					num_sectors = 0;
+					databuf_idx = 0;
+				}
+
+				/*
+				 * Add the curr bvec/segment to the curr
+				 * blkvsc_req
+				 */
+				blkvsc_req->request.data_buffer.
+					pfn_array[databuf_idx]
+						= page_to_pfn(bvec->bv_page);
+				blkvsc_req->request.data_buffer.len
+					+= bvec->bv_len;
+
+				prev_bvec = bvec;
+
+				databuf_idx++;
+				num_sectors += bvec->bv_len >> 9;
+
+			} /* bio_for_each_segment */
+
+		} /* rq_for_each_bio */
+	}
+
+	/* Handle the last one */
+	if (blkvsc_req) {
+		DPRINT_DBG(BLKVSC_DRV, "blkdev %p req %p group %p count %d\n",
+			   blkdev, req, blkvsc_req->group,
+			   blkvsc_req->group->outstanding);
+
+		blkvsc_req->sector_start = start_sector;
+		sector_div(blkvsc_req->sector_start,
+			   (blkdev->sector_size >> 9));
+
+		blkvsc_req->sector_count = num_sectors /
+					   (blkdev->sector_size >> 9);
+
+		blkvsc_init_rw(blkvsc_req);
+	}
+
+	list_for_each_entry(blkvsc_req, &group->blkvsc_req_list, req_entry) {
+		if (pending) {
+			DPRINT_DBG(BLKVSC_DRV, "adding blkvsc_req to "
+				   "pending_list - blkvsc_req %p start_sect %lu"
+				   " sect_count %ld (%lu %ld)\n", blkvsc_req,
+				   (unsigned long)blkvsc_req->sector_start,
+				   blkvsc_req->sector_count,
+				   (unsigned long)start_sector,
+				   (unsigned long)num_sectors);
+
+			list_add_tail(&blkvsc_req->pend_entry,
+				      &blkdev->pending_list);
+		} else {
+			ret = blkvsc_submit_request(blkvsc_req,
+						    blkvsc_request_completion);
+			if (ret == -1) {
+				pending = 1;
+				list_add_tail(&blkvsc_req->pend_entry,
+					      &blkdev->pending_list);
+			}
+
+			DPRINT_DBG(BLKVSC_DRV, "submitted blkvsc_req %p "
+				   "start_sect %lu sect_count %ld (%lu %ld) "
+				   "ret %d\n", blkvsc_req,
+				   (unsigned long)blkvsc_req->sector_start,
+				   blkvsc_req->sector_count,
+				   (unsigned long)start_sector,
+				   num_sectors, ret);
+		}
+	}
+
+	return pending;
+}
+
 /* Static decl */
 static int blkvsc_probe(struct device *dev);
 static void blkvsc_request(struct request_queue *queue);
-static void blkvsc_request_completion(struct hv_storvsc_request *request);
-static int blkvsc_do_request(struct block_device_context *blkdev,
-			     struct request *req);
 static int blkvsc_do_pending_reqs(struct block_device_context *blkdev);
 
 static int blkvsc_ringbuffer_size = BLKVSC_RING_BUFFER_SIZE;
@@ -1216,180 +1406,6 @@ Cleanup:
 	return ret;
 }
 
-/*
- * We break the request into 1 or more blkvsc_requests and submit
- * them.  If we cant submit them all, we put them on the
- * pending_list. The blkvsc_request() will work on the pending_list.
- */
-static int blkvsc_do_request(struct block_device_context *blkdev,
-			     struct request *req)
-{
-	struct bio *bio = NULL;
-	struct bio_vec *bvec = NULL;
-	struct bio_vec *prev_bvec = NULL;
-	struct blkvsc_request *blkvsc_req = NULL;
-	struct blkvsc_request *tmp;
-	int databuf_idx = 0;
-	int seg_idx = 0;
-	sector_t start_sector;
-	unsigned long num_sectors = 0;
-	int ret = 0;
-	int pending = 0;
-	struct blkvsc_request_group *group = NULL;
-
-	DPRINT_DBG(BLKVSC_DRV, "blkdev %p req %p sect %lu\n", blkdev, req,
-		  (unsigned long)blk_rq_pos(req));
-
-	/* Create a group to tie req to list of blkvsc_reqs */
-	group = kmem_cache_zalloc(blkdev->request_pool, GFP_ATOMIC);
-	if (!group)
-		return -ENOMEM;
-
-	INIT_LIST_HEAD(&group->blkvsc_req_list);
-	group->outstanding = group->status = 0;
-
-	start_sector = blk_rq_pos(req);
-
-	/* foreach bio in the request */
-	if (req->bio) {
-		for (bio = req->bio; bio; bio = bio->bi_next) {
-			/*
-			 * Map this bio into an existing or new storvsc request
-			 */
-			bio_for_each_segment(bvec, bio, seg_idx) {
-				DPRINT_DBG(BLKVSC_DRV, "bio_for_each_segment() "
-					   "- req %p bio %p bvec %p seg_idx %d "
-					   "databuf_idx %d\n", req, bio, bvec,
-					   seg_idx, databuf_idx);
-
-				/* Get a new storvsc request */
-				/* 1st-time */
-				if ((!blkvsc_req) ||
-				    (databuf_idx >= MAX_MULTIPAGE_BUFFER_COUNT)
-				    /* hole at the begin of page */
-				    || (bvec->bv_offset != 0) ||
-				    /* hold at the end of page */
-				    (prev_bvec &&
-				     (prev_bvec->bv_len != PAGE_SIZE))) {
-					/* submit the prev one */
-					if (blkvsc_req) {
-						blkvsc_req->sector_start = start_sector;
-						sector_div(blkvsc_req->sector_start, (blkdev->sector_size >> 9));
-
-						blkvsc_req->sector_count = num_sectors / (blkdev->sector_size >> 9);
-						blkvsc_init_rw(blkvsc_req);
-					}
-
-					/*
-					 * Create new blkvsc_req to represent
-					 * the current bvec
-					 */
-					blkvsc_req =
-					kmem_cache_zalloc(
-					blkdev->request_pool, GFP_ATOMIC);
-					if (!blkvsc_req) {
-						/* free up everything */
-						list_for_each_entry_safe(
-							blkvsc_req, tmp,
-							&group->blkvsc_req_list,
-							req_entry) {
-							list_del(&blkvsc_req->req_entry);
-							kmem_cache_free(blkdev->request_pool, blkvsc_req);
-						}
-
-						kmem_cache_free(blkdev->request_pool, group);
-						return -ENOMEM;
-					}
-
-					memset(blkvsc_req, 0,
-					       sizeof(struct blkvsc_request));
-
-					blkvsc_req->dev = blkdev;
-					blkvsc_req->req = req;
-					blkvsc_req->request.
-					data_buffer.offset
-					= bvec->bv_offset;
-					blkvsc_req->request.
-					data_buffer.len = 0;
-
-					/* Add to the group */
-					blkvsc_req->group = group;
-					blkvsc_req->group->outstanding++;
-					list_add_tail(&blkvsc_req->req_entry,
-						&blkvsc_req->group->blkvsc_req_list);
-
-					start_sector += num_sectors;
-					num_sectors = 0;
-					databuf_idx = 0;
-				}
-
-				/* Add the curr bvec/segment to the curr blkvsc_req */
-				blkvsc_req->request.data_buffer.
-					pfn_array[databuf_idx]
-						= page_to_pfn(bvec->bv_page);
-				blkvsc_req->request.data_buffer.len
-					+= bvec->bv_len;
-
-				prev_bvec = bvec;
-
-				databuf_idx++;
-				num_sectors += bvec->bv_len >> 9;
-
-			} /* bio_for_each_segment */
-
-		} /* rq_for_each_bio */
-	}
-
-	/* Handle the last one */
-	if (blkvsc_req) {
-		DPRINT_DBG(BLKVSC_DRV, "blkdev %p req %p group %p count %d\n",
-			   blkdev, req, blkvsc_req->group,
-			   blkvsc_req->group->outstanding);
-
-		blkvsc_req->sector_start = start_sector;
-		sector_div(blkvsc_req->sector_start,
-			   (blkdev->sector_size >> 9));
-
-		blkvsc_req->sector_count = num_sectors /
-					   (blkdev->sector_size >> 9);
-
-		blkvsc_init_rw(blkvsc_req);
-	}
-
-	list_for_each_entry(blkvsc_req, &group->blkvsc_req_list, req_entry) {
-		if (pending) {
-			DPRINT_DBG(BLKVSC_DRV, "adding blkvsc_req to "
-				   "pending_list - blkvsc_req %p start_sect %lu"
-				   " sect_count %ld (%lu %ld)\n", blkvsc_req,
-				   (unsigned long)blkvsc_req->sector_start,
-				   blkvsc_req->sector_count,
-				   (unsigned long)start_sector,
-				   (unsigned long)num_sectors);
-
-			list_add_tail(&blkvsc_req->pend_entry,
-				      &blkdev->pending_list);
-		} else {
-			ret = blkvsc_submit_request(blkvsc_req,
-						    blkvsc_request_completion);
-			if (ret == -1) {
-				pending = 1;
-				list_add_tail(&blkvsc_req->pend_entry,
-					      &blkdev->pending_list);
-			}
-
-			DPRINT_DBG(BLKVSC_DRV, "submitted blkvsc_req %p "
-				   "start_sect %lu sect_count %ld (%lu %ld) "
-				   "ret %d\n", blkvsc_req,
-				   (unsigned long)blkvsc_req->sector_start,
-				   blkvsc_req->sector_count,
-				   (unsigned long)start_sector,
-				   num_sectors, ret);
-		}
-	}
-
-	return pending;
-}
-
 static void blkvsc_request_completion(struct hv_storvsc_request *request)
 {
 	struct blkvsc_request *blkvsc_req =
-- 
1.7.4.1

