Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab1LVAqf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 19:46:35 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59028 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab1LVAqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 19:46:34 -0500
Date: Wed, 21 Dec 2011 16:46:29 -0800
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH UPDATED 2/2] mempool: fix first round failure behavior
Message-ID: <20111222004629.GO9213@google.com>
References: <20111222001800.GL9213@google.com>
 <20111222001939.GM9213@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111222001939.GM9213@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mempool modifies gfp_mask so that the backing allocator doesn't try
too hard or trigger warning message when there's pool to fall back on.
In addition, for the first try, it removes __GFP_WAIT and IO, so that
it doesn't trigger reclaim or wait when allocation can be fulfilled
from pool; however, when that allocation fails and pool is empty too,
it waits for the pool to be replenished before retrying.

Allocation which could have succeeded after a bit of reclaim has to
wait on the reserved items and it's not like mempool doesn't retry
with __GFP_WAIT and IO.  It just does that *after* someone returns an
element, pointlessly delaying things.

Fix it by retrying immediately if the first round of allocation
attempts w/o __GFP_WAIT and IO fails.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
The code hasn't changed.  Only the description and comment are
updated.  It doesn't affect anything regarding emergency pool.  It
just changes when the first retry happens.

That said, I still find it a bit unsettling that a GFP_ATOMIC
allocation which would otherwise succeed may fail when issued through
mempool.  Maybe the RTTD is clearing __GFP_NOMEMALLOC on retry if the
gfp requsted by the caller is !__GFP_WAIT && !__GFP_NOMEMALLOC?

Thanks.

 mm/mempool.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

Index: work/mm/mempool.c
===================================================================
--- work.orig/mm/mempool.c
+++ work/mm/mempool.c
@@ -221,14 +221,23 @@ repeat_alloc:
 		return element;
 	}
 
-	/* We must not sleep in the GFP_ATOMIC case */
+	/*
+	 * We use gfp mask w/o __GFP_WAIT or IO for the first round.  If
+	 * alloc failed with that and @pool was empty, retry immediately.
+	 */
+	if (gfp_temp != gfp_mask) {
+		gfp_temp = gfp_mask;
+		spin_unlock_irqrestore(&pool->lock, flags);
+		goto repeat_alloc;
+	}
+
+	/* We must not sleep if !__GFP_WAIT */
 	if (!(gfp_mask & __GFP_WAIT)) {
 		spin_unlock_irqrestore(&pool->lock, flags);
 		return NULL;
 	}
 
 	/* Let's wait for someone else to return an element to @pool */
-	gfp_temp = gfp_mask;
 	init_wait(&wait);
 	prepare_to_wait(&pool->wait, &wait, TASK_UNINTERRUPTIBLE);
 
