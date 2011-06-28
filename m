Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758888Ab1F1Ph6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 11:37:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758677Ab1F1PfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 11:35:13 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com,
        linux-fsdevel@vger.kernel.org
Cc: andrea@betterlinux.com, vgoyal@redhat.com
Subject: [PATCH 2/8] blk-throttle: do not enforce first queued bio check in tg_wait_dispatch
Date: Tue, 28 Jun 2011 11:35:03 -0400
Message-Id: <1309275309-12889-3-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1309275309-12889-1-git-send-email-vgoyal@redhat.com>
References: <1309275309-12889-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Soon we will be using same wait routines for checking the wait for
task also and no bio is involved. So get rid of any bio dependencies
and leave it to caller that if and bio or task is queued in the group
in same direction, then don't call this routine.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-throttle.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index d76717a..8facd17 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -696,14 +696,6 @@ tg_wait_dispatch(struct throtl_data *td, struct throtl_grp *tg, struct bio *bio)
 	bool rw = bio_data_dir(bio);
 	unsigned long bps_wait = 0, iops_wait = 0, max_wait = 0;
 
-	/*
- 	 * Currently whole state machine of group depends on first bio
-	 * queued in the group bio list. So one should not be calling
-	 * this function with a different bio if there are other bios
-	 * queued.
-	 */
-	BUG_ON(tg->nr_queued[rw] && bio != bio_list_peek(&tg->bio_lists[rw]));
-
 	/* If tg->bps = -1, then BW is unlimited */
 	if (tg->bps[rw] == -1 && tg->iops[rw] == -1)
 		return 0;
-- 
1.7.4.4

