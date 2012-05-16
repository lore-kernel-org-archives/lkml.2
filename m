Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758937Ab2EPRJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 13:09:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53756 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab2EPRJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 13:09:24 -0400
Date: Wed, 16 May 2012 10:09:19 -0700
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, rni@google.com
Subject: [PATCH block/for-3.5/core] blkcg: drop local variable @q from
 blkg_destroy()
Message-ID: <20120516170919.GB21275@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blkg_destroy() caches @blkg->q in local variable @q.  While there are
two places which needs @blkg->q, only lockdep_assert_held() used the
local variable leading to unused local variable warning if lockdep is
configured out.  Drop the local variable and just use @blkg->q
directly.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Rakesh Iyer <rni@google.com>
---
 block/blk-cgroup.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 4465329..3186404 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -271,11 +271,10 @@ EXPORT_SYMBOL_GPL(blkg_lookup_create);
 
 static void blkg_destroy(struct blkcg_gq *blkg)
 {
-	struct request_queue *q = blkg->q;
 	struct blkcg *blkcg = blkg->blkcg;
 	int i;
 
-	lockdep_assert_held(q->queue_lock);
+	lockdep_assert_held(blkg->q->queue_lock);
 	lockdep_assert_held(&blkcg->lock);
 
 	/* Something wrong if we are trying to remove same group twice */
-- 
1.7.7.3

