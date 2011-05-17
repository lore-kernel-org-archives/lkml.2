Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab1EQK2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 06:28:30 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62029 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535Ab1EQK23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 06:28:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OmOynlCgkDcv3cQv2/uG0qW9nonFEdpkdAU0P5ecE29fdxyum5MX1J33kri4wdWHEc
         I/bkmZ3f13e/NJMLd/qfGIfpfZe4mUL0/cKFmoyJHleKiNV9cjl+ZR4peDWGTDm94sic
         2nPvcpHn7bRZmnQND+gV1WdfLKfmiYgyaSH3w=
Date: Tue, 17 May 2011 12:28:24 +0200
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>, Borislav Petkov <bp@alien8.de>,
        Meelis Roos <mroos@linux.ee>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 2/3 v2.6.39-rc7] block: remove non-syncing
 __disk_block_events() and fold it into disk_block_events()
Message-ID: <20110517102824.GK20624@htj.dyndns.org>
References: <20110517102713.GJ20624@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110517102713.GJ20624@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the previous update to disk_check_events(), nobody is using
non-syncing __disk_block_events().  Remove @sync and, as this makes
__disk_block_events() virtually identical to disk_block_events(),
remove the underscore prefixed version.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/genhd.c |   55 ++++++++++++++++++++++++-------------------------------
 1 file changed, 24 insertions(+), 31 deletions(-)

Index: work/block/genhd.c
===================================================================
--- work.orig/block/genhd.c
+++ work/block/genhd.c
@@ -1414,22 +1414,36 @@ static unsigned long disk_events_poll_ji
 	return msecs_to_jiffies(intv_msecs);
 }
 
-static void __disk_block_events(struct gendisk *disk, bool sync)
+/**
+ * disk_block_events - block and flush disk event checking
+ * @disk: disk to block events for
+ *
+ * On return from this function, it is guaranteed that event checking
+ * isn't in progress and won't happen until unblocked by
+ * disk_unblock_events().  Events blocking is counted and the actual
+ * unblocking happens after the matching number of unblocks are done.
+ *
+ * Note that this intentionally does not block event checking from
+ * disk_clear_events().
+ *
+ * CONTEXT:
+ * Might sleep.
+ */
+void disk_block_events(struct gendisk *disk)
 {
 	struct disk_events *ev = disk->ev;
 	unsigned long flags;
 	bool cancel;
 
+	if (!ev)
+		return;
+
 	spin_lock_irqsave(&ev->lock, flags);
 	cancel = !ev->block++;
 	spin_unlock_irqrestore(&ev->lock, flags);
 
-	if (cancel) {
-		if (sync)
-			cancel_delayed_work_sync(&disk->ev->dwork);
-		else
-			cancel_delayed_work(&disk->ev->dwork);
-	}
+	if (cancel)
+		cancel_delayed_work_sync(&disk->ev->dwork);
 }
 
 static void __disk_unblock_events(struct gendisk *disk, bool check_now)
@@ -1461,27 +1475,6 @@ out_unlock:
 }
 
 /**
- * disk_block_events - block and flush disk event checking
- * @disk: disk to block events for
- *
- * On return from this function, it is guaranteed that event checking
- * isn't in progress and won't happen until unblocked by
- * disk_unblock_events().  Events blocking is counted and the actual
- * unblocking happens after the matching number of unblocks are done.
- *
- * Note that this intentionally does not block event checking from
- * disk_clear_events().
- *
- * CONTEXT:
- * Might sleep.
- */
-void disk_block_events(struct gendisk *disk)
-{
-	if (disk->ev)
-		__disk_block_events(disk, true);
-}
-
-/**
  * disk_unblock_events - unblock disk event checking
  * @disk: disk to unblock events for
  *
@@ -1554,7 +1547,7 @@ unsigned int disk_clear_events(struct ge
 	spin_unlock_irq(&ev->lock);
 
 	/* uncondtionally schedule event check and wait for it to finish */
-	__disk_block_events(disk, true);
+	disk_block_events(disk);
 	queue_delayed_work(system_nrt_wq, &ev->dwork, 0);
 	flush_delayed_work(&ev->dwork);
 	__disk_unblock_events(disk, false);
@@ -1672,7 +1665,7 @@ static ssize_t disk_events_poll_msecs_st
 	if (intv < 0 && intv != -1)
 		return -EINVAL;
 
-	__disk_block_events(disk, true);
+	disk_block_events(disk);
 	disk->ev->poll_msecs = intv;
 	__disk_unblock_events(disk, true);
 
@@ -1778,7 +1771,7 @@ static void disk_del_events(struct gendi
 	if (!disk->ev)
 		return;
 
-	__disk_block_events(disk, true);
+	disk_block_events(disk);
 
 	mutex_lock(&disk_events_mutex);
 	list_del_init(&disk->ev->node);
