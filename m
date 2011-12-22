Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab1LVATp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 19:19:45 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:39036 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752593Ab1LVATo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 19:19:44 -0500
Date: Wed, 21 Dec 2011 16:19:39 -0800
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mempool: fix first round failure behavior
Message-ID: <20111222001939.GM9213@google.com>
References: <20111222001800.GL9213@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111222001800.GL9213@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the initial allocation, mempool passes modified gfp mask to the
backing allocator so that it doesn't try too hard when there are
reserved elements waiting in the pool; however, when that allocation
fails and pool is empty too, it either waits for the pool to be
replenished before retrying or fails if !__GFP_WAIT.

* If the caller was calling in with GFP_ATOMIC, it never gets to try
  emergency reserve.  Allocations which would have succeeded without
  mempool may fail, which is just wrong.

* Allocation which could have succeeded after a bit of reclaim now has
  to wait on the reserved items and it's not like mempool doesn't
  retry with the original gfp mask.  It just does that *after* someone
  returns an element, pointlessly delaying things.

Fix it by retrying immediately with the gfp mask requested by the
caller if the first round of allocation attempts fails with modified
mask.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@kernel.org
---
 mm/mempool.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

Index: work/mm/mempool.c
===================================================================
--- work.orig/mm/mempool.c
+++ work/mm/mempool.c
@@ -221,14 +221,24 @@ repeat_alloc:
 		return element;
 	}
 
-	/* We must not sleep in the GFP_ATOMIC case */
+	/*
+	 * We use modified gfp mask for the first round.  If alloc failed
+	 * with that and @pool was empty too, immediately retry with the
+	 * original gfp mask.
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
 
