Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab1EQK1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 06:27:20 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37179 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664Ab1EQK1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 06:27:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:sender:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=b/F7uldMBT1Pe65oZplegnuSkaX/X+LTeVGB7Uikr3s8WpZn6nxraXqh9O/aQkfc0i
         pWBxIQkPSCZiYBaiy2U8kJldXM9zCyU3GCaf7N+FKh6C/2B6r4UG+sqktZDY0mg7or0D
         U6QMiFGEsqELWedQ6bSo5HE+mMS/+jVl1XDZ0=
Date: Tue, 17 May 2011 12:27:13 +0200
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>, Borislav Petkov <bp@alien8.de>,
        Meelis Roos <mroos@linux.ee>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 1/3 v2.6.39-rc7] block: don't use non-syncing event
 blocking in disk_check_events()
Message-ID: <20110517102713.GJ20624@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is part of fix for triggering of WARN_ON_ONCE() in
disk_clear_events() reported in bug#34662.

  https://bugzilla.kernel.org/show_bug.cgi?id=34662

disk_clear_events() blocks events, schedules and flushes the event
work.  It expects the work to have started execution on schedule and
finished on return from flush.  WARN_ON_ONCE() triggers if the event
work hasn't executed as expected.  This problem happens because
__disk_block_events() fails to guarantee that the event work item is
not in flight on return from the function in race-free manner.  The
problem is two-fold and this patch addresses one of them.

When __disk_block_events() is called with @sync == %false, it bumps
event block count, calls cancel_delayed_work() and return.  This makes
it impossible to guarantee that event polling is not in flight on
return from syncing __disk_block_events() - if the first blocker was
non-syncing, polling could still be in progress and later syncing ones
would assume that the first blocker already canceled it.

Making __disk_block_events() cancel_sync regardless of block count
isn't feasible either as it may race with forced event checking in
disk_clear_events().

As disk_check_events() is the only user of non-syncing
__disk_block_events(), updating it to directly cancel and schedule
event work is the easiest way to solve the issue.

Note that there's another bug in __disk_block_events() and this patch
doesn't fix the issue completely.  Later patch will fix the other bug.

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
(sorry, forgot to cc lkml, resending)

This is the first of three patches which (finally) fix the
WARN_ON_ONCE() in disk_clear_events() triggering.  It was me being
stupid about synchronization around event blocking.

Given that we're very late in -rc cycle and, although the fix isn't
invasive, it isn't obvious one-liner either, and that the bug happens
sporadically with non-critical failure mode, it might be better to
route this through block for v2.6.40-rc1 and then back port to v2.6.39
via -stable, unless v2.6.39 is gonna go through another -rc cycle.

Jens, Linus, what do you guys think?

Thank you.

 block/genhd.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

Index: work/block/genhd.c
===================================================================
--- work.orig/block/genhd.c
+++ work/block/genhd.c
@@ -1508,10 +1508,18 @@ void disk_unblock_events(struct gendisk
  */
 void disk_check_events(struct gendisk *disk)
 {
-	if (disk->ev) {
-		__disk_block_events(disk, false);
-		__disk_unblock_events(disk, true);
+	struct disk_events *ev = disk->ev;
+	unsigned long flags;
+
+	if (!ev)
+		return;
+
+	spin_lock_irqsave(&ev->lock, flags);
+	if (!ev->block) {
+		cancel_delayed_work(&ev->dwork);
+		queue_delayed_work(system_nrt_wq, &ev->dwork, 0);
 	}
+	spin_unlock_irqrestore(&ev->lock, flags);
 }
 EXPORT_SYMBOL_GPL(disk_check_events);
 
