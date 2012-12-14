Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531Ab2LNWlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 17:41:40 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:46932 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122Ab2LNWlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 17:41:37 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, axboe@kernel.dk, vgoyal@redhat.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, ctalbott@google.com, rni@google.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/12] blkcg: fix minor bug in blkg_alloc()
Date: Fri, 14 Dec 2012 14:41:14 -0800
Message-Id: <1355524885-22719-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1355524885-22719-1-git-send-email-tj@kernel.org>
References: <1355524885-22719-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blkg_alloc() was mistakenly checking blkcg_policy_enabled() twice.
The latter test should have been on whether pol->pd_init_fn() exists.
This doesn't cause actual problems because both blkcg policies
implement pol->pd_init_fn().  Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 3f6d39d..feda49f 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -114,7 +114,7 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct request_queue *q,
 		pd->blkg = blkg;
 
 		/* invoke per-policy init */
-		if (blkcg_policy_enabled(blkg->q, pol))
+		if (pol->pd_init_fn)
 			pol->pd_init_fn(blkg);
 	}
 
-- 
1.7.11.7

