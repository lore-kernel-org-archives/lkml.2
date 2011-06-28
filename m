Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634Ab1F1PiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 11:38:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758681Ab1F1PfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 11:35:13 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com,
        linux-fsdevel@vger.kernel.org
Cc: andrea@betterlinux.com, vgoyal@redhat.com
Subject: [PATCH 7/8] blk-throttle: do not throttle writes at device level except direct io
Date: Tue, 28 Jun 2011 11:35:08 -0400
Message-Id: <1309275309-12889-8-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1309275309-12889-1-git-send-email-vgoyal@redhat.com>
References: <1309275309-12889-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now WRITES are not throttled at device level except any WRITES
which are marked as DIRECT. This patch I have lifted from Andrea
Righi's previously posted series on lkml.

This will mean that any filesystem internally generated WRITES
also all not be throttled. If need be, down the line situation can
be improved if file system can give a hint to throttling logic that
it is ok to throttle certain WRITES without risk of being
serialized.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-throttle.c      |    8 ++++++++
 fs/direct-io.c            |    1 +
 include/linux/blk_types.h |    2 ++
 3 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index be3b4b4..c6b9d76 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1293,6 +1293,14 @@ int blk_throtl_bio(struct request_queue *q, struct bio **biop)
 	}
 
 	/*
+	 * WRITES bio are throttled here only if they are directIO. Otherwise
+	 * these are coming from page cache and these must have been subjected
+	 * to throttling rules while process was writting to page cache.
+	 */
+	if (rw == WRITE && !(bio->bi_rw & REQ_DIRECT_IO))
+		return 0;
+
+	/*
 	 * A throtl_grp pointer retrieved under rcu can be used to access
 	 * basic fields like stats and io rates. If a group has no rules,
 	 * just update the dispatch stats in lockless manner and return.
diff --git a/fs/direct-io.c b/fs/direct-io.c
index ac5f164..7858828 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -361,6 +361,7 @@ static void dio_bio_submit(struct dio *dio)
 	unsigned long flags;
 
 	bio->bi_private = dio;
+	bio->bi_rw |= REQ_DIRECT_IO;
 
 	spin_lock_irqsave(&dio->bio_lock, flags);
 	dio->refcount++;
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 2a7cea5..f46e8a4 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -131,6 +131,7 @@ enum rq_flag_bits {
 	__REQ_RAHEAD,		/* read ahead, can fail anytime */
 	__REQ_THROTTLED,	/* This bio has already been subjected to
 				 * throttling rules. Don't do it again. */
+	__REQ_DIRECT_IO,	/* It is a direct IO operation */
 
 	/* request only flags */
 	__REQ_SORTED,		/* elevator knows about this request */
@@ -172,6 +173,7 @@ enum rq_flag_bits {
 
 #define REQ_RAHEAD		(1 << __REQ_RAHEAD)
 #define REQ_THROTTLED		(1 << __REQ_THROTTLED)
+#define REQ_DIRECT_IO		(1 << __REQ_DIRECT_IO)
 
 #define REQ_SORTED		(1 << __REQ_SORTED)
 #define REQ_SOFTBARRIER		(1 << __REQ_SOFTBARRIER)
-- 
1.7.4.4

