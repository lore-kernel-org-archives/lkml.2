Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047Ab1LVVpr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 16:45:47 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37320 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab1LVVpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 16:45:39 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org, avi@redhat.com, nate@cpanel.net,
        cl@linux-foundation.org, oleg@redhat.com, axboe@kernel.dk,
        vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/7] mempool: fix first round failure behavior
Date: Thu, 22 Dec 2011 13:45:22 -0800
Message-Id: <1324590326-10135-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1324590326-10135-1-git-send-email-tj@kernel.org>
References: <1324590326-10135-1-git-send-email-tj@kernel.org>
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
 mm/mempool.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/mm/mempool.c b/mm/mempool.c
index e3a802a..6326cc6 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
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
 
-- 
1.7.3.1

