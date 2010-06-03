Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952Ab0FCRfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 13:35:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756551Ab0FCRfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 13:35:03 -0400
Date: Thu, 3 Jun 2010 13:34:52 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>
Subject: [PATCH v4] block: avoid unconditionally freeing previously allocated
 request_queue
Message-ID: <20100603173452.GC6730@redhat.com>
References: <1274744795-9825-1-git-send-email-snitzer@redhat.com>
 <1274744795-9825-3-git-send-email-snitzer@redhat.com>
 <4BFBB21A.3030105@ct.jp.nec.com>
 <20100525124912.GA7447@redhat.com>
 <20100525163455.GA10155@redhat.com>
 <20100526045219.GB24702@redhat.com>
 <20100603165809.GA6730@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100603165809.GA6730@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

block: avoid unconditionally freeing previously allocated request_queue

On blk_init_allocated_queue_node failure, only free the request_queue if
it is wasn't previously allocated outside the block layer
(e.g. blk_init_queue_node was blk_init_allocated_queue_node caller).

This addresses an interface bug introduced by the following commit:
01effb0 block: allow initialization of previously allocated
request_queue

Otherwise the request_queue may be free'd out from underneath a caller
that is managing the request_queue directly (e.g. caller uses
blk_alloc_queue + blk_init_allocated_queue_node).

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-core.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

v4: eliminate potential for NULL pointer in call to blk_cleanup_queue
v3: leverage fact that blk_cleanup_queue will properly free all memory
   associated with a request_queue (e.g.: q->rq_pool and q->elevator)

diff --git a/block/blk-core.c b/block/blk-core.c
index 3bc5579..826d070 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -570,9 +570,17 @@ EXPORT_SYMBOL(blk_init_queue);
 struct request_queue *
 blk_init_queue_node(request_fn_proc *rfn, spinlock_t *lock, int node_id)
 {
-	struct request_queue *q = blk_alloc_queue_node(GFP_KERNEL, node_id);
+	struct request_queue *uninit_q, *q;
 
-	return blk_init_allocated_queue_node(q, rfn, lock, node_id);
+	uninit_q = blk_alloc_queue_node(GFP_KERNEL, node_id);
+	if (!uninit_q)
+		return NULL;
+
+	q = blk_init_allocated_queue_node(uninit_q, rfn, lock, node_id);
+	if (!q)
+		blk_cleanup_queue(uninit_q);
+
+	return q;
 }
 EXPORT_SYMBOL(blk_init_queue_node);
 
@@ -592,10 +600,8 @@ blk_init_allocated_queue_node(struct request_queue *q, request_fn_proc *rfn,
 		return NULL;
 
 	q->node = node_id;
-	if (blk_init_free_list(q)) {
-		kmem_cache_free(blk_requestq_cachep, q);
+	if (blk_init_free_list(q))
 		return NULL;
-	}
 
 	q->request_fn		= rfn;
 	q->prep_rq_fn		= NULL;
@@ -618,7 +624,6 @@ blk_init_allocated_queue_node(struct request_queue *q, request_fn_proc *rfn,
 		return q;
 	}
 
-	blk_put_queue(q);
 	return NULL;
 }
 EXPORT_SYMBOL(blk_init_allocated_queue_node);
