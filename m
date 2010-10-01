Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab0JAQUn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 12:20:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494Ab0JAQUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 12:20:42 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: vgoyal@redhat.com
Subject: [PATCH 3/3] blkio-throttle: Fix possible multiplication overflow in iops calculations
Date: Fri,  1 Oct 2010 12:20:29 -0400
Message-Id: <1285950029-30205-4-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1285950029-30205-1-git-send-email-vgoyal@redhat.com>
References: <1285950029-30205-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o User can specify max iops value of 32bit (UINT_MAX), through cgroup
  interface. If a user has specified say 4294967294 (UNIT_MAX  - 2), then
  on 32bit platform, following multiplication can overflow.

  io_allowed = (tg->iops[rw] * jiffy_elapsed_rnd)

o Explicitly cast the multiplication to 64bit and then perform division and
  then check whether result is still great then UNINT_MAX.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-throttle.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index c1bc1b6..56ad453 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -430,6 +430,7 @@ static bool tg_with_in_iops_limit(struct throtl_data *td, struct throtl_grp *tg,
 	bool rw = bio_data_dir(bio);
 	unsigned int io_allowed;
 	unsigned long jiffy_elapsed, jiffy_wait, jiffy_elapsed_rnd;
+	u64 tmp;
 
 	jiffy_elapsed = jiffy_elapsed_rnd = jiffies - tg->slice_start[rw];
 
@@ -439,7 +440,20 @@ static bool tg_with_in_iops_limit(struct throtl_data *td, struct throtl_grp *tg,
 
 	jiffy_elapsed_rnd = roundup(jiffy_elapsed_rnd, throtl_slice);
 
-	io_allowed = (tg->iops[rw] * jiffy_elapsed_rnd) / HZ;
+	/*
+	 * jiffy_elapsed_rnd should not be a big value as minimum iops can be
+	 * 1 then at max jiffy elapsed should be equivalent of 1 second as we
+	 * will allow dispatch after 1 second and after that slice should
+	 * have been trimmed.
+	 */
+
+	tmp = (u64)tg->iops[rw] * jiffy_elapsed_rnd;
+	do_div(tmp, HZ);
+
+	if (tmp > UINT_MAX)
+		io_allowed = UINT_MAX;
+	else
+		io_allowed = tmp;
 
 	if (tg->io_disp[rw] + 1 <= io_allowed) {
 		if (wait)
-- 
1.7.2.3

