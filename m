Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759442Ab2DZWDI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 18:03:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53858 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759332Ab2DZV7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 17:59:37 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, fengguang.wu@intel.com,
        hughd@google.com, akpm@linux-foundation.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/11] blkcg: fix blkg_alloc() failure path
Date: Thu, 26 Apr 2012 14:59:11 -0700
Message-Id: <1335477561-11131-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1335477561-11131-1-git-send-email-tj@kernel.org>
References: <1335477561-11131-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When policy data allocation fails in the middle, blkg_alloc() invokes
blkg_free() to destroy the half constructed blkg.  This ends up
calling pd_exit_fn() on policy datas which didn't go through
pd_init_fn().  Fix it by making blkg_alloc() call pd_init_fn()
immediately after each policy data allocation.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 02cf633..4ab7420 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -125,12 +125,8 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct request_queue *q)
 
 		blkg->pd[i] = pd;
 		pd->blkg = blkg;
-	}
-
-	/* invoke per-policy init */
-	for (i = 0; i < BLKCG_MAX_POLS; i++) {
-		struct blkcg_policy *pol = blkcg_policy[i];
 
+		/* invoke per-policy init */
 		if (blkcg_policy_enabled(blkg->q, pol))
 			pol->pd_init_fn(blkg);
 	}
-- 
1.7.7.3

