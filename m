Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab0GMHvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 03:51:22 -0400
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:37589 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752129Ab0GMHvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 03:51:21 -0400
From: Dave Chinner <david@fromorbit.com>
To: xfs@oss.sgi.com
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: [PATCH 2/2] blkdev: check for valid request queue before issuing flush
Date: Tue, 13 Jul 2010 17:50:50 +1000
Message-Id: <1279007450-10457-3-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1279007450-10457-1-git-send-email-david@fromorbit.com>
References: <1279007450-10457-1-git-send-email-david@fromorbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Issuing a blkdev_issue_flush() on an unconfigured loop device causes a panic as
q->make_request_fn is not configured. This can occur when trying to mount the
unconfigured loop device as an XFS filesystem. There are no guards that catch
the bio before the request function is called because we don't add a payload to
the bio. Instead, manually check this case as soon as we have a pointer to the
queue to flush.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 block/blk-barrier.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index 0d710c9..0fd766e 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -319,6 +319,15 @@ int blkdev_issue_flush(struct block_device *bdev, gfp_t gfp_mask,
 	if (!q)
 		return -ENXIO;
 
+	/*
+	 * some block devices may not have their queue correctly set up here
+	 * (e.g. loop device without a backing file) and so issuing a flush
+	 * here will panic. Ensure there is a request function before issuing
+	 * the barrier.
+	 */
+	if (!q->make_request_fn)
+		return -ENXIO;
+
 	bio = bio_alloc(gfp_mask, 0);
 	bio->bi_end_io = bio_end_empty_barrier;
 	bio->bi_bdev = bdev;
-- 
1.7.1

