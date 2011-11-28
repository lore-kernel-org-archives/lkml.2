Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab1K1WAZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 17:00:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258Ab1K1WAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 17:00:24 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jaxboe@fusionio.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Shuichi Ihara <sihara@ddn.com>, Mike Snitzer <snitzer@redhat.com>
Subject: [RFC PATCH] block: change max_segments default to USHRT_MAX
Date: Mon, 28 Nov 2011 17:00:15 -0500
Message-Id: <1322517615-28530-1-git-send-email-snitzer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reported problem was that a DM multipath device's max_segemnts was
constrained to BLK_MAX_SEGMENTS (128) even though the underlying paths'
max_segments were larger.  For example, SCSI establishes a max_segments
of SCSI_MAX_SG_CHAIN_SEGMENTS (2048).

If blk_set_default_limits() sets a block limit's value that is less than
the possible range of values for that limit, stacked devices will never
properly stack the affected limit via blk_stack_limits() if
min_not_zero() is used.

BLK_MAX_SEGMENTS (128) is not the maximum value that may be established
for the max_segments limit.  Setting max_segments to a default of
USHRT_MAX (65535) allows for proper stacking.  Device drivers use
blk_queue_max_segments() to override this default.

Reported-by: Shuichi Ihara <sihara@ddn.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-settings.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

[NOTE: I avoided changing BLK_MAX_SEGMENTS to 2048 or USHRT_MAX but
that may be the more appropriate fix.  Or splitting BLK_MAX_SEGMENTS
to BLK_DEF_MAX_SEGMENTS=2048 and BLK_SAFE_MAX_SEGMENTS=128.]

diff --git a/block/blk-settings.c b/block/blk-settings.c
index fa1eb04..0ec98e0 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -110,7 +110,7 @@ EXPORT_SYMBOL_GPL(blk_queue_lld_busy);
  */
 void blk_set_default_limits(struct queue_limits *lim)
 {
-	lim->max_segments = BLK_MAX_SEGMENTS;
+	lim->max_segments = USHRT_MAX;
 	lim->max_integrity_segments = 0;
 	lim->seg_boundary_mask = BLK_SEG_BOUNDARY_MASK;
 	lim->max_segment_size = BLK_MAX_SEGMENT_SIZE;
-- 
1.7.4.4

