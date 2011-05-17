Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab1EQPrz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 11:47:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49850 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238Ab1EQPrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 11:47:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KYurGdsJJYb/89xmkiVsQkGlLbEc9YrR5TSE9+hpQy119Jh7l4jY5RFo48q8WwdrIM
         hHbvbLzfOF0v5Zigvc1fxAK3FudgrIoTO/nUax/jOxwLRGgLkh/HzW15Or5DBBXO2986
         /wZjryB4iQ+8ycgXJjWmFZ3E4KJvomifUnBnc=
Date: Tue, 17 May 2011 17:47:48 +0200
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>, Borislav Petkov <bp@alien8.de>,
        Meelis Roos <mroos@linux.ee>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: [PATCH UPDATED 2/3 v2.6.39-rc7] block: make disk_block_events()
 properly wait for work cancellation
Message-ID: <20110517154748.GS20624@htj.dyndns.org>
References: <20110517102713.GJ20624@htj.dyndns.org>
 <20110517102824.GK20624@htj.dyndns.org>
 <20110517102853.GL20624@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110517102853.GL20624@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

disk_block_events() should guarantee that the event work is not in
flight on return and once blocked it shouldn't issue further
cancellations.

Because there was no synchronization between the first blocker doing
cancel_delayed_work_sync() and the following blockers, the following
blockers could finish before cancellation was complete, which broke
both guarantees - event work could be in flight and cancellation could
happen after return.

This bug triggered WARN_ON_ONCE() in disk_clear_events() reported in
bug#34662.

  https://bugzilla.kernel.org/show_bug.cgi?id=34662

Fix it by adding an outer mutex which protects both block count
manipulation and work cancellation.

-v2: Use outer mutex instead of bit waitqueue per Linus.

Signed-off-by: Tejun Heo <tj@kernel.org>
Tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>
Reported-by: Sitsofe Wheeler <sitsofe@yahoo.com>
Reported-by: Borislav Petkov <bp@alien8.de>
Reported-by: Meelis Roos <mroos@linux.ee>
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kay Sievers <kay.sievers@vrfy.org>
---
Yeap, it's so much simpler this way.  Thanks.

 block/genhd.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: work/block/genhd.c
===================================================================
--- work.orig/block/genhd.c
+++ work/block/genhd.c
@@ -1371,6 +1371,7 @@ struct disk_events {
 	struct gendisk		*disk;		/* the associated disk */
 	spinlock_t		lock;
 
+	struct mutex		block_mutex;	/* protects blocking */
 	int			block;		/* event blocking depth */
 	unsigned int		pending;	/* events already sent out */
 	unsigned int		clearing;	/* events being cleared */
@@ -1438,12 +1439,20 @@ void disk_block_events(struct gendisk *d
 	if (!ev)
 		return;
 
+	/*
+	 * Outer mutex ensures that the first blocker completes canceling
+	 * the event work before further blockers are allowed to finish.
+	 */
+	mutex_lock(&ev->block_mutex);
+
 	spin_lock_irqsave(&ev->lock, flags);
 	cancel = !ev->block++;
 	spin_unlock_irqrestore(&ev->lock, flags);
 
 	if (cancel)
 		cancel_delayed_work_sync(&disk->ev->dwork);
+
+	mutex_unlock(&ev->block_mutex);
 }
 
 static void __disk_unblock_events(struct gendisk *disk, bool check_now)
@@ -1751,6 +1760,7 @@ static void disk_add_events(struct gendi
 	INIT_LIST_HEAD(&ev->node);
 	ev->disk = disk;
 	spin_lock_init(&ev->lock);
+	mutex_init(&ev->block_mutex);
 	ev->block = 1;
 	ev->poll_msecs = -1;
 	INIT_DELAYED_WORK(&ev->dwork, disk_events_workfn);
