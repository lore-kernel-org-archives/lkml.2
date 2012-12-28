Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437Ab2L1UgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 15:36:19 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46823 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371Ab2L1UgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 15:36:15 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, axboe@kernel.dk, vgoyal@redhat.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, ctalbott@google.com, rni@google.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/24] blkcg: fix minor bug in blkg_alloc()
Date: Fri, 28 Dec 2012 12:35:29 -0800
Message-Id: <1356726946-26037-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1356726946-26037-1-git-send-email-tj@kernel.org>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blkg_alloc() was mistakenly checking blkcg_policy_enabled() twice.
The latter test should have been on whether pol->pd_init_fn() exists.
This doesn't cause actual problems because both blkcg policies
implement pol->pd_init_fn().  Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index b8858fb..7ef747b 100644
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
1.8.0.2

