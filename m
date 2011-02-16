Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021Ab1BPBaS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:30:18 -0500
Received: from kroah.org ([198.145.64.141]:39358 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757311Ab1BPAVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:21:41 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:37 2011
Message-Id: <20110216001437.735315206@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:13:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jan Kara <jack@suse.cz>, Wu Fengguang <fengguang.wu@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>,
        Jan Engelhardt <jengelh@medozas.de>, Jens Axboe <axboe@kernel.dk>
Subject: [127/272] writeback: stop background/kupdate works from livelocking other works
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jan Kara <jack@suse.cz>

commit aa373cf550994623efb5d49a4d8775bafd10bbc1 upstream.

Background writeback is easily livelockable in a loop in wb_writeback() by
a process continuously re-dirtying pages (or continuously appending to a
file).  This is in fact intended as the target of background writeback is
to write dirty pages it can find as long as we are over
dirty_background_threshold.

But the above behavior gets inconvenient at times because no other work
queued in the flusher thread's queue gets processed.  In particular, since
e.g.  sync(1) relies on flusher thread to do all the IO for it, sync(1)
can hang forever waiting for flusher thread to do the work.

Generally, when a flusher thread has some work queued, someone submitted
the work to achieve a goal more specific than what background writeback
does.  Moreover by working on the specific work, we also reduce amount of
dirty pages which is exactly the target of background writeout.  So it
makes sense to give specific work a priority over a generic page cleaning.

Thus we interrupt background writeback if there is some other work to do.
We return to the background writeback after completing all the queued
work.

This may delay the writeback of expired inodes for a while, however the
expired inodes will eventually be flushed to disk as long as the other
works won't livelock.

[fengguang.wu@intel.com: update comment]
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Engelhardt <jengelh@medozas.de>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/fs-writeback.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -650,6 +650,16 @@ static long wb_writeback(struct bdi_writ
 			break;
 
 		/*
+		 * Background writeout and kupdate-style writeback may
+		 * run forever. Stop them if there is other work to do
+		 * so that e.g. sync can proceed. They'll be restarted
+		 * after the other works are all done.
+		 */
+		if ((work->for_background || work->for_kupdate) &&
+		    !list_empty(&wb->bdi->work_list))
+			break;
+
+		/*
 		 * For background writeout, stop when we are below the
 		 * background dirty threshold
 		 */


