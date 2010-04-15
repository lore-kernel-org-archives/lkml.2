Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab0DOFoi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 01:44:38 -0400
Received: from smtp-out.google.com ([216.239.44.51]:33831 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419Ab0DOFoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 01:44:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=FUqEZvax9TJV3fGSgRN1JO+QEOum8XwxUNsmnPZNhIygfi1LBMm6OnYYNrxFHM/vH
	m3CfZlZfTKIUfp4c1aXNw==
From: Divyesh Shah <dpshah@google.com>
Subject: [PATCH 1/4] block: Re-introduce rq->__nr_sectors to maintain the
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, nauman@google.com, rickyb@google.com
Date: Wed, 14 Apr 2010 22:44:31 -0700
Message-ID: <20100415054348.15836.88264.stgit@austin.mtv.corp.google.com>
In-Reply-To: <20100415054057.15836.17897.stgit@austin.mtv.corp.google.com>
References: <20100415054057.15836.17897.stgit@austin.mtv.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

original size of the request right through completion where it will be useful
for the disk performance histograms.

Signed-off-by: Divyesh Shah <dpshah@google.com>
---

 block/blk-core.c       |    4 ++++
 block/blk-merge.c      |    1 +
 include/linux/blkdev.h |    7 +++++++
 3 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index e9a5ae2..f18e7b7 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1159,6 +1159,7 @@ static int __make_request(struct request_queue *q, struct bio *bio)
 	struct request *req;
 	int el_ret;
 	unsigned int bytes = bio->bi_size;
+	const unsigned int nr_sectors = bio_sectors(bio);
 	const unsigned short prio = bio_prio(bio);
 	const bool sync = bio_rw_flagged(bio, BIO_RW_SYNCIO);
 	const bool unplug = bio_rw_flagged(bio, BIO_RW_UNPLUG);
@@ -1198,6 +1199,7 @@ static int __make_request(struct request_queue *q, struct bio *bio)
 		req->biotail->bi_next = bio;
 		req->biotail = bio;
 		req->__data_len += bytes;
+		req->__nr_sectors += nr_sectors;
 		req->ioprio = ioprio_best(req->ioprio, prio);
 		if (!blk_rq_cpu_valid(req))
 			req->cpu = bio->bi_comp_cpu;
@@ -1232,6 +1234,7 @@ static int __make_request(struct request_queue *q, struct bio *bio)
 		req->buffer = bio_data(bio);
 		req->__sector = bio->bi_sector;
 		req->__data_len += bytes;
+		req->__nr_sectors += nr_sectors;
 		req->ioprio = ioprio_best(req->ioprio, prio);
 		if (!blk_rq_cpu_valid(req))
 			req->cpu = bio->bi_comp_cpu;
@@ -2350,6 +2353,7 @@ void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 	}
 	rq->__data_len = bio->bi_size;
 	rq->bio = rq->biotail = bio;
+	rq->__nr_sectors = bio_sectors(bio);
 
 	if (bio->bi_bdev)
 		rq->rq_disk = bio->bi_bdev->bd_disk;
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 5e7dc99..ee0bb50 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -411,6 +411,7 @@ static int attempt_merge(struct request_queue *q, struct request *req,
 	req->biotail = next->biotail;
 
 	req->__data_len += blk_rq_bytes(next);
+	req->__nr_sectors += blk_rq_size(next);
 
 	elv_merge_requests(q, req, next);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d483c49..4cc2cdf 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -170,6 +170,7 @@ struct request {
 	/* the following two fields are internal, NEVER access directly */
 	unsigned int __data_len;	/* total data len */
 	sector_t __sector;		/* sector cursor */
+	sector_t __nr_sectors;		/* Total number of sectors */
 
 	struct bio *bio;
 	struct bio *biotail;
@@ -844,6 +845,7 @@ static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
 
 /*
  * blk_rq_pos()			: the current sector
+ * blk_rq_size()		: the size of the request in sectors
  * blk_rq_bytes()		: bytes left in the entire request
  * blk_rq_cur_bytes()		: bytes left in the current segment
  * blk_rq_err_bytes()		: bytes left till the next error boundary
@@ -855,6 +857,11 @@ static inline sector_t blk_rq_pos(const struct request *rq)
 	return rq->__sector;
 }
 
+static inline sector_t blk_rq_size(const struct request *rq)
+{
+	return rq->__nr_sectors;
+}
+
 static inline unsigned int blk_rq_bytes(const struct request *rq)
 {
 	return rq->__data_len;

