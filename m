Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397Ab1DKEuf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 00:50:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46844 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969Ab1DKEue convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 00:50:34 -0400
Date: Mon, 11 Apr 2011 14:50:22 +1000
From: NeilBrown <neilb@suse.de>
To: Mike Snitzer <snitzer@redhat.com>, Jens Axboe <jaxboe@fusionio.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>, dm-devel@redhat.com,
        linux-raid@vger.kernel.org
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
Message-ID: <20110411145022.710c30e9@notabene.brown>
In-Reply-To: <20110405130541.6c2b5f86@notabene.brown>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
	<1295659049-2688-6-git-send-email-jaxboe@fusionio.com>
	<AANLkTin8FoXX6oqUyW+scwhadyX-TfW16_oKjvngU9-m@mail.gmail.com>
	<20110303221353.GA10366@redhat.com>
	<4D761E0D.8050200@fusionio.com>
	<20110308202100.GA31744@redhat.com>
	<4D76912C.9040705@fusionio.com>
	<20110308220526.GA393@redhat.com>
	<20110310005810.GA17911@redhat.com>
	<20110405130541.6c2b5f86@notabene.brown>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Apr 2011 13:05:41 +1000 NeilBrown <neilb@suse.de> wrote:

> On Wed, 9 Mar 2011 19:58:10 -0500 Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > Also, in your MD changes, you removed all calls to md_unplug() but
> > didn't remove md_unplug().  Seems it should be removed along with the
> > 'plug' member of 'struct mddev_t'?  Neil?
> 
> I've been distracted by other things and only just managed to have a look at
> this.
> 
> The new plugging code seems to completely ignore the needs of stacked devices
> - or at least my needs in md.
> 
> For RAID1 with a write-intent-bitmap, I queue all write requests and then on
> an unplug I update the write-intent-bitmap to mark all the relevant blocks
> and then release the writes.
> 
> With the new code there is no way for an unplug event to wake up the raid1d
> thread to start the writeout - I haven't tested it but I suspect it will just
> hang.
> 
> Similarly for RAID5 I gather write bios (long before they become 'struct
> request' which is what the plugging code understands) and on an unplug event
> I release the writes - hopefully with enough bios per stripe so that we don't
> need to pre-read.
> 
> Possibly the simplest fix would be to have a second list_head in 'struct
> blk_plug' which contained callbacks (a function pointer a list_head in a
> struct which is passed as an arg to the function!).
> blk_finish_plug could then walk the list and call the call-backs.
> It would be quite easy to hook into that.

I've implemented this and it seems to work.
Jens:  could you please review and hopefully ack the patch below, and let
me know if you will submit it or should I?

My testing of this combined with some other patches which cause various md
personalities to use it shows up a bug somewhere.

The symptoms are crashes in various places in blk-core and sometimes
elevator.c
list_sort occurs fairly often included in the stack but not always.

This patch

diff --git a/block/blk-core.c b/block/blk-core.c
index 273d60b..903ce8d 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2674,19 +2674,23 @@ static void flush_plug_list(struct blk_plug *plug)
 	struct request_queue *q;
 	unsigned long flags;
 	struct request *rq;
+	struct list_head head;
 
 	BUG_ON(plug->magic != PLUG_MAGIC);
 
 	if (list_empty(&plug->list))
 		return;
+	list_add(&head, &plug->list);
+	list_del_init(&plug->list);
 
 	if (plug->should_sort)
-		list_sort(NULL, &plug->list, plug_rq_cmp);
+		list_sort(NULL, &head, plug_rq_cmp);
+	plug->should_sort = 0;
 
 	q = NULL;
 	local_irq_save(flags);
-	while (!list_empty(&plug->list)) {
-		rq = list_entry_rq(plug->list.next);
+	while (!list_empty(&head)) {
+		rq = list_entry_rq(head.next);
 		list_del_init(&rq->queuelist);
 		BUG_ON(!(rq->cmd_flags & REQ_ON_PLUG));
 		BUG_ON(!rq->q);


makes the symptom go away.  It simply moves the plug list onto a separate
list head before sorting and processing it.
My test was simply writing to a RAID1 with dd:
  while true; do dd if=/dev/zero of=/dev/md0 size=4k; done

Obviously all writes go to two devices so the plug list will always need
sorting.

The only explanation I can come up with is that very occasionally schedule on
2 separate cpus calls blk_flush_plug for the same task.  I don't understand
the scheduler nearly well enough to know if or how that can happen.
However with this patch in place I can write to a RAID1 constantly for half
an hour, and without it, the write rarely lasts for 3 minutes.

If you want to reproduce my experiment, you can pull from
  git://neil.brown.name/md plug-test
to get my patches for plugging in md (which are quite ready for submission
but seem to work), create a RAID1 using e.g.
   mdadm -C /dev/md0 --level=1 --raid-disks=2 /dev/device1 /dev/device2
   while true; do dd if=/dev/zero of=/dev/md0 bs=4K ; done


Thanks,
NeilBrown



>From 687b189c02276887dd7d5b87a817da9f67ed3c2c Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Thu, 7 Apr 2011 13:16:59 +1000
Subject: [PATCH] Enhance new plugging support to support general callbacks.

md/raid requires an unplug callback, but as it does not uses
requests the current code cannot provide one.

So allow arbitrary callbacks to be attached to the blk_plug.

Cc: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---
 block/blk-core.c       |   13 +++++++++++++
 include/linux/blkdev.h |    7 ++++++-
 2 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 725091d..273d60b 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2644,6 +2644,7 @@ void blk_start_plug(struct blk_plug *plug)
 
 	plug->magic = PLUG_MAGIC;
 	INIT_LIST_HEAD(&plug->list);
+	INIT_LIST_HEAD(&plug->cb_list);
 	plug->should_sort = 0;
 
 	/*
@@ -2717,9 +2718,21 @@ static void flush_plug_list(struct blk_plug *plug)
 	local_irq_restore(flags);
 }
 
+static void flush_plug_callbacks(struct blk_plug *plug)
+{
+	while (!list_empty(&plug->cb_list)) {
+		struct blk_plug_cb *cb = list_first_entry(&plug->cb_list,
+							  struct blk_plug_cb,
+							  list);
+		list_del(&cb->list);
+		cb->callback(cb);
+	}
+}
+
 static void __blk_finish_plug(struct task_struct *tsk, struct blk_plug *plug)
 {
 	flush_plug_list(plug);
+	flush_plug_callbacks(plug);
 
 	if (plug == tsk->plug)
 		tsk->plug = NULL;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 32176cc..3e5e604 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -857,8 +857,13 @@ extern void blk_put_queue(struct request_queue *);
 struct blk_plug {
 	unsigned long magic;
 	struct list_head list;
+	struct list_head cb_list;
 	unsigned int should_sort;
 };
+struct blk_plug_cb {
+	struct list_head list;
+	void (*callback)(struct blk_plug_cb *);
+};
 
 extern void blk_start_plug(struct blk_plug *);
 extern void blk_finish_plug(struct blk_plug *);
@@ -876,7 +881,7 @@ static inline bool blk_needs_flush_plug(struct task_struct *tsk)
 {
 	struct blk_plug *plug = tsk->plug;
 
-	return plug && !list_empty(&plug->list);
+	return plug && (!list_empty(&plug->list) || !list_empty(&plug->cb_list));
 }
 
 /*
-- 
1.7.3.4

