Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab1EKQlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:41:36 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60919 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732Ab1EKPot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:44:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=WNEH72QeJNiOZyfSrKIxYdxYgBxVrGf9h2tOjvzvszfmLeFletfs6v9i+DHM5WB4pU
         vH0UMB+a+DRgHvZ3KP1p1yBoVPxCd82qxx7Y+ZQ6vK4vT9NfHl2EOTCsYyFTN7FXdZwE
         g0yArV4JL0TbwaAVRuatZfgZg8Tq03awushoY=
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH] blk-throttle: get rid of wrong initialization of 'limits_changed'
Date: Wed, 11 May 2011 23:50:43 +0900
Message-Id: <1305125443-5683-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a new group is initialized, we should set @tg->limits_changed
to false instead of setting @td->limits_changed. But @td and @tg
are initialized to zero via kzalloc_node(), there is no need to set
it explicitly. Just get rid of them.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-throttle.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 0475a22a420d..5e241ce2695b 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -201,7 +201,6 @@ static struct throtl_grp * throtl_find_alloc_tg(struct throtl_data *td,
 	RB_CLEAR_NODE(&tg->rb_node);
 	bio_list_init(&tg->bio_lists[0]);
 	bio_list_init(&tg->bio_lists[1]);
-	td->limits_changed = false;
 
 	/*
 	 * Take the initial reference that will be released on destroy
@@ -1060,7 +1059,6 @@ int blk_throtl_init(struct request_queue *q)
 
 	INIT_HLIST_HEAD(&td->tg_list);
 	td->tg_service_tree = THROTL_RB_ROOT;
-	td->limits_changed = false;
 
 	/* Init root group */
 	tg = &td->root_tg;
@@ -1072,7 +1070,6 @@ int blk_throtl_init(struct request_queue *q)
 	/* Practically unlimited BW */
 	tg->bps[0] = tg->bps[1] = -1;
 	tg->iops[0] = tg->iops[1] = -1;
-	td->limits_changed = false;
 
 	/*
 	 * Set root group reference to 2. One reference will be dropped when
-- 
1.7.5

