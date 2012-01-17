Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751283Ab2AQBX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 20:23:29 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:62587 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab2AQBX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 20:23:27 -0500
X-AuditID: 9c930179-b7b98ae000000791-99-4f14cd8c8f22
From: Namhyung Kim <namhyung.kim@lge.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Namhyung Kim <namhyung@gmail.com>, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/3] block: prevent duplicated bio completion report
Date: Tue, 17 Jan 2012 10:32:07 +0900
Message-Id: <1326763928-1972-2-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9.rc1.dirty
In-Reply-To: <1326763928-1972-1-git-send-email-namhyung.kim@lge.com>
References: <1326763928-1972-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since previous patch make block_bio_complete TP working,
it will generate duplicated BLK_TA_COMPLETEs for bounced
bios. Fix it.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Cc: Tejun Heo <tj@kernel.org>
---
 include/linux/blk_types.h    |    3 +++
 include/trace/events/block.h |    3 ++-
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 4053cbd4490e..45cd0074a1c8 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -97,6 +97,9 @@ struct bio {
 #define BIO_MAPPED_INTEGRITY 11/* integrity metadata has been remapped */
 #define bio_flagged(bio, flag)	((bio)->bi_flags & (1 << (flag)))
 
+/* masked bio's won't report its completion via tracepoint */
+#define BIO_COMPLETE_MASK	(1 << BIO_BOUNCED)
+
 /*
  * top 4 bits of bio flags indicate the pool this bio came from
  */
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index 96955f4828b3..72888542e186 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -219,7 +219,8 @@ TRACE_EVENT_CONDITION(block_bio_complete,
 
 	TP_ARGS(q, bio, error),
 
-	TP_CONDITION(bio->bi_bdev != NULL),
+	TP_CONDITION(bio->bi_bdev != NULL &&
+		     !(bio->bi_flags & BIO_COMPLETE_MASK)),
 
 	TP_STRUCT__entry(
 		__field( dev_t,		dev		)
-- 
1.7.9.rc1.dirty

