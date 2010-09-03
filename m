Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757807Ab0ICKlF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 06:41:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:35624 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756865Ab0ICKbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 06:31:07 -0400
From: Tejun Heo <tj@kernel.org>
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, hch@lst.de, konishi.ryusuke@lab.ntt.co.jp,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com,
        hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com,
        snitzer@redhat.com, k-ueda@ct.jp.nec.com, mpatocka@redhat.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 15/41] block: make sure FSEQ_DATA request has the same rq_disk as the original
Date: Fri,  3 Sep 2010 12:29:30 +0200
Message-Id: <1283509796-1510-16-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283509796-1510-1-git-send-email-tj@kernel.org>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 03 Sep 2010 10:30:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rq->rq_disk and bio->bi_bdev->bd_disk may differ if a request has
passed through remapping drivers.  FSEQ_DATA request incorrectly
followed bio->bi_bdev->bd_disk ending up being issued w/ mismatching
rq_disk.  Make it follow orig_rq->rq_disk.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Tested-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
---
 block/blk-flush.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index cb4c844..7d1fc98 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -111,6 +111,13 @@ static struct request *queue_next_fseq(struct request_queue *q)
 		break;
 	case QUEUE_FSEQ_DATA:
 		init_request_from_bio(rq, orig_rq->bio);
+		/*
+		 * orig_rq->rq_disk may be different from
+		 * bio->bi_bdev->bd_disk if orig_rq got here through
+		 * remapping drivers.  Make sure rq->rq_disk points
+		 * to the same one as orig_rq.
+		 */
+		rq->rq_disk = orig_rq->rq_disk;
 		rq->cmd_flags &= ~(REQ_FLUSH | REQ_FUA);
 		rq->cmd_flags |= orig_rq->cmd_flags & (REQ_FLUSH | REQ_FUA);
 		rq->end_io = flush_data_end_io;
-- 
1.7.1

