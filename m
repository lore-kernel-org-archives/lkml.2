Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207Ab1DLQuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 12:50:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38132 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684Ab1DLQuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 12:50:44 -0400
Date: Tue, 12 Apr 2011 12:50:42 -0400
From: "hch@infradead.org" <hch@infradead.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: NeilBrown <neilb@suse.de>, Mike Snitzer <snitzer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
Message-ID: <20110412165042.GA23764@infradead.org>
References: <20110411205928.13915719@notabene.brown>
 <4DA2E03A.2080607@fusionio.com>
 <20110411212635.7959de70@notabene.brown>
 <4DA2E7F0.9010904@fusionio.com>
 <20110411220505.1028816e@notabene.brown>
 <4DA2F00E.6010907@fusionio.com>
 <20110411223623.4278fad1@notabene.brown>
 <4DA2F8AD.1060605@fusionio.com>
 <20110412011255.GA29236@infradead.org>
 <4DA40F0E.1070903@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA40F0E.1070903@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 10:36:30AM +0200, Jens Axboe wrote:
> The existance and out-of-line is for the scheduler() hook. It should be
> an unlikely event to schedule with a plug held, normally the plug should
> have been explicitly unplugged before that happens.

I still don't think unlikely() is the right thing to do.  The static
branch prediction hints cause a real massive slowdown if taken.  For
things like this that happen during normal operation you're much better
off leaving the dynamic branch prediction in the CPU predicting what's
going on.  And I don't think it's all that unlikely - e.g. for all the
metadata during readpages/writepages schedule/io_schedule will be
the unplugging point right now.  I'll see if I can run an I/O workload
with Steve's likely/unlikely profiling turned on.

> > void __blk_flush_plug(struct task_struct *tsk, struct blk_plug *plug)
> > {
> > 	flush_plug_list(plug);
> > 	if (plug == tsk->plug)
> > 		tsk->plug = NULL;
> > 	tsk->plug = plug;
> > }
> > 
> >    it would seem much smarted to just call flush_plug_list directly.
> >    In fact it seems like the tsk->plug is not nessecary at all and
> >    all remaining __blk_flush_plug callers could be replaced with
> >    flush_plug_list.
> 
> It depends on whether this was an explicit unplug (eg
> blk_finish_plug()), or whether it was an implicit event (eg on
> schedule()). If we do it on schedule(), then we retain the plug after
> the flush. Otherwise we clear it.

blk_finish_plug doesn't got through this codepath.

This is an untested patch how the area should look to me:


diff --git a/block/blk-core.c b/block/blk-core.c
index 90f22cc..6fa5ba1 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2668,7 +2668,7 @@ static int plug_rq_cmp(void *priv, struct list_head *a, struct list_head *b)
 	return !(rqa->q <= rqb->q);
 }
 
-static void flush_plug_list(struct blk_plug *plug)
+void blk_flush_plug_list(struct blk_plug *plug)
 {
 	struct request_queue *q;
 	unsigned long flags;
@@ -2716,29 +2716,16 @@ static void flush_plug_list(struct blk_plug *plug)
 	BUG_ON(!list_empty(&plug->list));
 	local_irq_restore(flags);
 }
-
-static void __blk_finish_plug(struct task_struct *tsk, struct blk_plug *plug)
-{
-	flush_plug_list(plug);
-
-	if (plug == tsk->plug)
-		tsk->plug = NULL;
-}
+EXPORT_SYMBOL_GPL(blk_flush_plug_list);
 
 void blk_finish_plug(struct blk_plug *plug)
 {
-	if (plug)
-		__blk_finish_plug(current, plug);
+	blk_flush_plug_list(plug);
+	if (plug == current->plug)
+		current->plug = NULL;
 }
 EXPORT_SYMBOL(blk_finish_plug);
 
-void __blk_flush_plug(struct task_struct *tsk, struct blk_plug *plug)
-{
-	__blk_finish_plug(tsk, plug);
-	tsk->plug = plug;
-}
-EXPORT_SYMBOL(__blk_flush_plug);
-
 int __init blk_dev_init(void)
 {
 	BUILD_BUG_ON(__REQ_NR_BITS > 8 *
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 32176cc..fa6a4e1 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -862,14 +862,14 @@ struct blk_plug {
 
 extern void blk_start_plug(struct blk_plug *);
 extern void blk_finish_plug(struct blk_plug *);
-extern void __blk_flush_plug(struct task_struct *, struct blk_plug *);
+extern void blk_flush_plug_list(struct blk_plug *);
 
 static inline void blk_flush_plug(struct task_struct *tsk)
 {
 	struct blk_plug *plug = tsk->plug;
 
-	if (unlikely(plug))
-		__blk_flush_plug(tsk, plug);
+	if (plug)
+		blk_flush_plug_list(plug);
 }
 
 static inline bool blk_needs_flush_plug(struct task_struct *tsk)
