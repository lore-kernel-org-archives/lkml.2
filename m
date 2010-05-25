Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758953Ab0EYQzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 12:55:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754277Ab0EYQzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 12:55:36 -0400
Date: Tue, 25 May 2010 12:34:55 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>,
       Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] block: avoid unconditionally freeing previously allocated
 request_queue
Message-ID: <20100525163455.GA10155@redhat.com>
References: <1274744795-9825-1-git-send-email-snitzer@redhat.com>
 <1274744795-9825-3-git-send-email-snitzer@redhat.com>
 <4BFBB21A.3030105@ct.jp.nec.com>
 <20100525124912.GA7447@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100525124912.GA7447@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25 2010 at  8:49am -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Tue, May 25 2010 at  7:18am -0400,
> Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
> 
> > > +/*
> > > + * Fully initialize a request-based queue (->elevator, ->request_fn, etc).
> > > + */
> > > +static int dm_init_request_based_queue(struct mapped_device *md)
> > > +{
> > > +	struct request_queue *q = NULL;
> > > +
> > > +	/* Avoid re-initializing the queue if already fully initialized */
> > > +	if (!md->queue->elevator) {
> > > +		/* Fully initialize the queue */
> > > +		q = blk_init_allocated_queue(md->queue, dm_request_fn, NULL);
> > > +		if (!q)
> > > +			return 0;
> > 
> > When blk_init_allocated_queue() fails, the block-layer seems not to
> > guarantee that the queue is still available.
> 
> Ouch, yes this portion of blk_init_allocated_queue_node() is certainly
> problematic:
> 
>         if (blk_init_free_list(q)) {
>                 kmem_cache_free(blk_requestq_cachep, q);
>                 return NULL;
>         }
> 
> Cc'ing Jens as I think it would be advantageous for us to push the above
> kmem_cache_free() into the callers where it really makes sense, e.g.:
> blk_init_queue_node().
> 
> So on blk_init_allocated_queue_node() failure blk_init_queue_node() will
> take care to cleanup the queue that it assumes it is managing
> completely.
> 
> My patch (linux-2.6-block.git's commit: 01effb0) that split out
> blk_init_allocated_queue_node() from blk_init_queue_node() opened up
> this issue.  I'm fairly confident we'll get it fixed by the time 2.6.35
> ships.

Jens,

How about something like the following?


block: avoid unconditionally freeing previously allocated request_queue

On blk_init_allocated_queue_node failure, only free request_queue if
it is wasn't previously allocated outside the block layer
(e.g. blk_init_queue_node was blk_init_allocated_queue_node caller).

This addresses a regression introduced by the following commit:
01effb0 block: allow initialization of previously allocated request_queue

Otherwise the request_queue may be free'd out from underneath a caller
that is managing the request_queue directly (e.g. caller uses
blk_alloc_queue + blk_init_allocated_queue_node).

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-core.c |   31 ++++++++++++++++++++++++++-----
 1 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 3bc5579..c0179b7 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -528,6 +528,24 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 }
 EXPORT_SYMBOL(blk_alloc_queue_node);
 
+static void blk_free_partial_queue(struct request_queue *q)
+{
+	/* Free q if blk_init_queue failed early enough. */
+	int free_request_queue = 0;
+	struct request_list *rl;
+
+	if (!q)
+		return;
+
+	/* Was blk_init_free_list the cause for failure? */
+	rl = &q->rq;
+	if (!rl->rq_pool)
+		free_request_queue = 1;
+
+	if (free_request_queue)
+		kmem_cache_free(blk_requestq_cachep, q);
+}
+
 /**
  * blk_init_queue  - prepare a request queue for use with a block device
  * @rfn:  The function to be called to process requests that have been
@@ -570,9 +588,14 @@ EXPORT_SYMBOL(blk_init_queue);
 struct request_queue *
 blk_init_queue_node(request_fn_proc *rfn, spinlock_t *lock, int node_id)
 {
-	struct request_queue *q = blk_alloc_queue_node(GFP_KERNEL, node_id);
+	struct request_queue *uninit_q, *q;
+
+	uninit_q = blk_alloc_queue_node(GFP_KERNEL, node_id);
+	q = blk_init_allocated_queue_node(uninit_q, rfn, lock, node_id);
+	if (!q)
+		blk_free_partial_queue(uninit_q);
 
-	return blk_init_allocated_queue_node(q, rfn, lock, node_id);
+	return q;
 }
 EXPORT_SYMBOL(blk_init_queue_node);
 
@@ -592,10 +615,8 @@ blk_init_allocated_queue_node(struct request_queue *q, request_fn_proc *rfn,
 		return NULL;
 
 	q->node = node_id;
-	if (blk_init_free_list(q)) {
-		kmem_cache_free(blk_requestq_cachep, q);
+	if (blk_init_free_list(q))
 		return NULL;
-	}
 
 	q->request_fn		= rfn;
 	q->prep_rq_fn		= NULL;
