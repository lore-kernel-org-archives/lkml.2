Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab1EQK26 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 06:28:58 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62029 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836Ab1EQK24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 06:28:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aEFd7PKy8wstC9d5j+EycMBB5VSztPPb8ZCUNEEELcVh67EV35Z0mlRBIADive4wTt
         pFp4zPvlmCin5ZdCGA6W07kodL74V/1IXWzJ73OZNm96sM6J3s882d2Whw5dB23+lP2q
         heAc0n79tXh94Leix3qOb8psoNIaM61A2+CLc=
Date: Tue, 17 May 2011 12:28:53 +0200
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>, Borislav Petkov <bp@alien8.de>,
        Meelis Roos <mroos@linux.ee>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 2/3 v2.6.39-rc7] block: make disk_block_events()
 properly wait for work cancellation
Message-ID: <20110517102853.GL20624@htj.dyndns.org>
References: <20110517102713.GJ20624@htj.dyndns.org>
 <20110517102824.GK20624@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110517102824.GK20624@htj.dyndns.org>
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

Fix it by introducing DISK_EVENT_CANCELING bit which is set by the
first blocker while cancellation is in progress.  Further blockers
wait until the bit is cleared by the first blocker.

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
 block/genhd.c |   36 +++++++++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

Index: work/block/genhd.c
===================================================================
--- work.orig/block/genhd.c
+++ work/block/genhd.c
@@ -1371,7 +1371,7 @@ struct disk_events {
 	struct gendisk		*disk;		/* the associated disk */
 	spinlock_t		lock;
 
-	int			block;		/* event blocking depth */
+	unsigned int		block;		/* event blocking depth */
 	unsigned int		pending;	/* events already sent out */
 	unsigned int		clearing;	/* events being cleared */
 
@@ -1379,6 +1379,8 @@ struct disk_events {
 	struct delayed_work	dwork;
 };
 
+#define DISK_EVENT_CANCELING			0x80000000U
+
 static const char *disk_events_strs[] = {
 	[ilog2(DISK_EVENT_MEDIA_CHANGE)]	= "media_change",
 	[ilog2(DISK_EVENT_EJECT_REQUEST)]	= "eject_request",
@@ -1414,6 +1416,12 @@ static unsigned long disk_events_poll_ji
 	return msecs_to_jiffies(intv_msecs);
 }
 
+static int disk_block_wait_canceling(void *word)
+{
+	schedule();
+	return 0;
+}
+
 /**
  * disk_block_events - block and flush disk event checking
  * @disk: disk to block events for
@@ -1438,12 +1446,34 @@ void disk_block_events(struct gendisk *d
 	if (!ev)
 		return;
 
+	/*
+	 * Bump block count and set CANCELLING if we're the first blocker
+	 * and have to cancel the event work.
+	 */
 	spin_lock_irqsave(&ev->lock, flags);
-	cancel = !ev->block++;
+	if ((cancel = !ev->block++))
+		ev->block |= DISK_EVENT_CANCELING;
 	spin_unlock_irqrestore(&ev->lock, flags);
 
-	if (cancel)
+	if (cancel) {
+		/*
+		 * Cancel the event work, clear CANCELING and wake up
+		 * waiters.
+		 */
 		cancel_delayed_work_sync(&disk->ev->dwork);
+
+		spin_lock_irqsave(&ev->lock, flags);
+		ev->block &= ~DISK_EVENT_CANCELING;
+		spin_unlock_irqrestore(&ev->lock, flags);
+		wake_up_bit(&ev->block, ilog2(DISK_EVENT_CANCELING));
+	} else {
+		/*
+		 * The first blocker might not have finished canceling the
+		 * event work.  Wait for CANCELING to clear.
+		 */
+		wait_on_bit(&ev->block, ilog2(DISK_EVENT_CANCELING),
+			    disk_block_wait_canceling, TASK_UNINTERRUPTIBLE);
+	}
 }
 
 static void __disk_unblock_events(struct gendisk *disk, bool check_now)
