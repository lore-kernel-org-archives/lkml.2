Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab1DQWTh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 18:19:37 -0400
Received: from cantor.suse.de ([195.135.220.2]:57169 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641Ab1DQWTc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 18:19:32 -0400
Date: Mon, 18 Apr 2011 08:19:22 +1000
From: NeilBrown <neilb@suse.de>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Mike Snitzer <snitzer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
Message-ID: <20110418081922.1651474a@notabene.brown>
In-Reply-To: <4DA2F00E.6010907@fusionio.com>
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
	<20110411145022.710c30e9@notabene.brown>
	<4DA2C7BE.6060804@fusionio.com>
	<20110411205928.13915719@notabene.brown>
	<4DA2E03A.2080607@fusionio.com>
	<20110411212635.7959de70@notabene.brown>
	<4DA2E7F0.9010904@fusionio.com>
	<20110411220505.1028816e@notabene.brown>
	<4DA2F00E.6010907@fusionio.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Apr 2011 14:11:58 +0200 Jens Axboe <jaxboe@fusionio.com> wrote:

> > Yes.  But I need to know when to release the requests that I have stored.
> > I need to know when ->write_pages or ->read_pages or whatever has finished
> > submitting a pile of pages so that I can start processing the request that I
> > have put aside.  So I need a callback from blk_finish_plug.
> 
> OK fair enough, I'll add your callback patch.
> 

But you didn't did you?  You added a completely different patch which is
completely pointless.
If you don't like my patch I would really prefer you said so rather than
silently replace it with something completely different (and broken).

I'll try to explain again.

md does not use __make_request.  At all.
md does not use 'struct request'.  At all.

The 'list' in 'struct blk_plug' is a list of 'struct request'.

Therefore md cannot put anything useful on the list in 'struct blk_plug'.

So when blk_flush_plug_list calls queue_unplugged() on a queue that belonged
to a request found on the blk_plug list, that queue cannot possibly ever be
for an 'md' device (because no 'struct request' ever belongs to an md device,
because md doesn't not use 'struct request').

So your patch (commit f75664570d8b) doesn't help MD at all.

For md, I need to attach something to blk_plug which somehow identifies an md
device, so that blk_finish_plug can get to that device and let it unplug.
The most sensible thing to have is a completely generic callback.  That way
different block devices (which choose not to use __make_request) can attach
different sorts of things to blk_plug.

So can we please have my original patch applied? (Revised version using
list_splice_init included below).

Or if not, a clear explanation of why not?

Thanks,
NeilBrown

>From 6a2aa888b855fd298c174bcee130cf43db0b3f7b Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Mon, 18 Apr 2011 08:15:45 +1000
Subject: [PATCH] Enhance new plugging support to support general callbacks.

md/raid requires an unplug callback, but as it does not uses
requests the current code cannot provide one.

So allow arbitrary callbacks to be attached to the blk_plug.

Cc: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---
 block/blk-core.c       |   20 ++++++++++++++++++++
 include/linux/blkdev.h |    7 ++++++-
 2 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 78b7b0c..c2b8006 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2638,6 +2638,7 @@ void blk_start_plug(struct blk_plug *plug)
 
 	plug->magic = PLUG_MAGIC;
 	INIT_LIST_HEAD(&plug->list);
+	INIT_LIST_HEAD(&plug->cb_list);
 	plug->should_sort = 0;
 
 	/*
@@ -2742,9 +2743,28 @@ void blk_flush_plug_list(struct blk_plug *plug, bool from_schedule)
 }
 EXPORT_SYMBOL(blk_flush_plug_list);
 
+static void flush_plug_callbacks(struct blk_plug *plug)
+{
+	LIST_HEAD(callbacks);
+
+	if (list_empty(&plug->cb_list))
+		return;
+
+	list_splice_init(&plug->cb_list, &callbacks);
+
+	while (!list_empty(&callbacks)) {
+		struct blk_plug_cb *cb = list_first_entry(&callbacks,
+							  struct blk_plug_cb,
+							  list);
+		list_del(&cb->list);
+		cb->callback(cb);
+	}
+}
+
 void blk_finish_plug(struct blk_plug *plug)
 {
 	blk_flush_plug_list(plug, false);
+	flush_plug_callbacks(plug);
 
 	if (plug == current->plug)
 		current->plug = NULL;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ec0357d..f3f7879 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -860,8 +860,13 @@ extern void blk_put_queue(struct request_queue *);
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
@@ -887,7 +892,7 @@ static inline bool blk_needs_flush_plug(struct task_struct *tsk)
 {
 	struct blk_plug *plug = tsk->plug;
 
-	return plug && !list_empty(&plug->list);
+	return plug && (!list_empty(&plug->list) || !list_empty(&plug->cb_list));
 }
 
 /*
-- 
1.7.3.4

