Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab1DOGeQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 02:34:16 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:51372 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752898Ab1DOGeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 02:34:14 -0400
X-ASG-Debug-ID: 1302849251-01de284cf814e240001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DA7E6E2.5000902@fusionio.com>
Date: Fri, 15 Apr 2011 08:34:10 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: "hch@infradead.org" <hch@infradead.org>
CC: NeilBrown <neilb@suse.de>, Mike Snitzer <snitzer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
References: <20110310005810.GA17911@redhat.com> <20110405130541.6c2b5f86@notabene.brown> <20110411145022.710c30e9@notabene.brown> <4DA2C7BE.6060804@fusionio.com> <20110411205928.13915719@notabene.brown> <4DA2E03A.2080607@fusionio.com> <20110411212635.7959de70@notabene.brown> <4DA2E7F0.9010904@fusionio.com> <20110411220505.1028816e@notabene.brown> <4DA2F00E.6010907@fusionio.com> <20110415042611.GA3116@infradead.org>
X-ASG-Orig-Subj: Re: [PATCH 05/10] block: remove per-queue plugging
In-Reply-To: <20110415042611.GA3116@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1302849251
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.60903
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-15 06:26, hch@infradead.org wrote:
> Btw, "block: move queue run on unplug to kblockd" currently moves
> the __blk_run_queue call to kblockd unconditionally currently.  But
> I'm not sure that's correct - if we do an explicit blk_finish_plug
> there's no point in forcing the context switch.

It's correct, but yes it's not optimal for the explicit unplug. Well I
think it really depends - for the single sync case, it's not ideal to
punt to kblockd. But if you have a bunch of threads doing IO, you
probably DO want to punt it to kblockd to avoid too many threads
hammering on the queue lock at the same time. Would need testing to be
sure, the below would a way to accomplish that.


diff --git a/block/blk-core.c b/block/blk-core.c
index b598fa7..995e995 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2662,16 +2662,16 @@ static int plug_rq_cmp(void *priv, struct list_head *a, struct list_head *b)
 	return !(rqa->q <= rqb->q);
 }
 
-static void queue_unplugged(struct request_queue *q, unsigned int depth)
+static void queue_unplugged(struct request_queue *q, unsigned int depth, bool run_from_wq)
 {
 	trace_block_unplug_io(q, depth);
-	__blk_run_queue(q, true);
+	__blk_run_queue(q, run_from_wq);
 
 	if (q->unplugged_fn)
 		q->unplugged_fn(q);
 }
 
-void blk_flush_plug_list(struct blk_plug *plug)
+void blk_flush_plug_list(struct blk_plug *plug, bool run_from_wq)
 {
 	struct request_queue *q;
 	unsigned long flags;
@@ -2706,7 +2706,7 @@ void blk_flush_plug_list(struct blk_plug *plug)
 		BUG_ON(!rq->q);
 		if (rq->q != q) {
 			if (q) {
-				queue_unplugged(q, depth);
+				queue_unplugged(q, depth, run_from_wq);
 				spin_unlock(q->queue_lock);
 			}
 			q = rq->q;
@@ -2727,7 +2727,7 @@ void blk_flush_plug_list(struct blk_plug *plug)
 	}
 
 	if (q) {
-		queue_unplugged(q, depth);
+		queue_unplugged(q, depth, run_from_wq);
 		spin_unlock(q->queue_lock);
 	}
 
@@ -2737,7 +2737,7 @@ EXPORT_SYMBOL(blk_flush_plug_list);
 
 void blk_finish_plug(struct blk_plug *plug)
 {
-	blk_flush_plug_list(plug);
+	blk_flush_plug_list(plug, false);
 
 	if (plug == current->plug)
 		current->plug = NULL;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ffe48ff..1c76506 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -865,14 +865,14 @@ struct blk_plug {
 
 extern void blk_start_plug(struct blk_plug *);
 extern void blk_finish_plug(struct blk_plug *);
-extern void blk_flush_plug_list(struct blk_plug *);
+extern void blk_flush_plug_list(struct blk_plug *, bool);
 
 static inline void blk_flush_plug(struct task_struct *tsk)
 {
 	struct blk_plug *plug = tsk->plug;
 
 	if (plug)
-		blk_flush_plug_list(plug);
+		blk_flush_plug_list(plug, true);
 }
 
 static inline bool blk_needs_flush_plug(struct task_struct *tsk)


-- 
Jens Axboe

