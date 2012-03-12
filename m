Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab2CLSCZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 14:02:25 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43730 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092Ab2CLSCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 14:02:23 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: axboe@kernel.dk
Cc: tj@kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH] blk-cgroup: Call cgroup_path only under cgroup lock
Date: Mon, 12 Mar 2012 16:01:18 -0400
Message-Id: <1331582478-2259-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we can't keep rcu read lock during blkg_alloc(), we currently
call cgroup_path() without any locks at all.

This patch adds cgroup locking before calling cgroup_path.

This also fixes a lockdep warning on boot.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 block/blk-cgroup.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index cb6b176..b5f539c 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -508,7 +508,9 @@ static struct blkio_group *blkg_alloc(struct blkio_cgroup *blkcg,
 	INIT_LIST_HEAD(&blkg->q_node);
 	blkg->blkcg = blkcg;
 	blkg->refcnt = 1;
+	cgroup_lock();
 	cgroup_path(blkcg->css.cgroup, blkg->path, sizeof(blkg->path));
+	cgroup_unlock();
 
 	for (i = 0; i < BLKIO_NR_POLICIES; i++) {
 		struct blkio_policy_type *pol = blkio_policy[i];
-- 
1.7.8.4

