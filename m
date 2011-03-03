Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab1CCHaH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 02:30:07 -0500
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:46717 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754180Ab1CCHaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 02:30:06 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=tao.ma;
	h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:X-Identified-User;
	b=w9leRkxHwZSz4F4yp+uZat3d5tbfdi2Pz+GH9omO7lgmZHg7t/dy9gKCNfbtMWiW90KVnbgINcVlnIL+tny8ZRQlYpZQolsfqLRaXGypZM7H9QTAhoXtX2tlzELIdSHp;
From: Tao Ma <tm@tao.ma>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jaxboe@fusionio.com>
Subject: [PATCH] blktrace: Remove blk_fill_rwbs_rq.
Date: Thu,  3 Mar 2011 15:29:40 +0800
Message-Id: <1299137380-4119-1-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.1
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 114.251.86.0 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

If we enable trace events to trace block actions, We use
blk_fill_rwbs_rq to analyze the corresponding actions
in request's cmd_flags, but we only choose the minor 2 bits
from it, so most of other flags(e.g, REQ_SYNC) are missing.
For example, with a sync write we get:
write_test-2409  [001]   160.013869: block_rq_insert: 3,64 W 0 () 258135 + 8 [write_test]

Since now we have integrated the flags of both bio and request,
it is safe to pass rq->cmd_flags directly to blk_fill_rwbs and
blk_fill_rwbs_rq isn't needed any more.

With this patch, after a sync write we get:
write_test-2417  [000]   226.603878: block_rq_insert: 3,64 WS 0 () 258135 + 8 [write_test]

Cc: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 include/linux/blktrace_api.h |    1 -
 include/trace/events/block.h |    6 +++---
 kernel/trace/blktrace.c      |   16 ----------------
 3 files changed, 3 insertions(+), 20 deletions(-)

diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index 3395cf7..b22fb0d 100644
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -245,7 +245,6 @@ static inline int blk_cmd_buf_len(struct request *rq)
 
 extern void blk_dump_cmd(char *buf, struct request *rq);
 extern void blk_fill_rwbs(char *rwbs, u32 rw, int bytes);
-extern void blk_fill_rwbs_rq(char *rwbs, struct request *rq);
 
 #endif /* CONFIG_EVENT_TRACING && CONFIG_BLOCK */
 
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index aba421d..78f18ad 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -31,7 +31,7 @@ DECLARE_EVENT_CLASS(block_rq_with_error,
 					0 : blk_rq_sectors(rq);
 		__entry->errors    = rq->errors;
 
-		blk_fill_rwbs_rq(__entry->rwbs, rq);
+		blk_fill_rwbs(__entry->rwbs, rq->cmd_flags, blk_rq_bytes(rq));
 		blk_dump_cmd(__get_str(cmd), rq);
 	),
 
@@ -118,7 +118,7 @@ DECLARE_EVENT_CLASS(block_rq,
 		__entry->bytes     = (rq->cmd_type == REQ_TYPE_BLOCK_PC) ?
 					blk_rq_bytes(rq) : 0;
 
-		blk_fill_rwbs_rq(__entry->rwbs, rq);
+		blk_fill_rwbs(__entry->rwbs, rq->cmd_flags, blk_rq_bytes(rq));
 		blk_dump_cmd(__get_str(cmd), rq);
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
 	),
@@ -563,7 +563,7 @@ TRACE_EVENT(block_rq_remap,
 		__entry->nr_sector	= blk_rq_sectors(rq);
 		__entry->old_dev	= dev;
 		__entry->old_sector	= from;
-		blk_fill_rwbs_rq(__entry->rwbs, rq);
+		blk_fill_rwbs(__entry->rwbs, rq->cmd_flags, blk_rq_bytes(rq));
 	),
 
 	TP_printk("%d,%d %s %llu + %u <- (%d,%d) %llu",
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 07f4382..cfc059d 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1824,21 +1824,5 @@ void blk_fill_rwbs(char *rwbs, u32 rw, int bytes)
 	rwbs[i] = '\0';
 }
 
-void blk_fill_rwbs_rq(char *rwbs, struct request *rq)
-{
-	int rw = rq->cmd_flags & 0x03;
-	int bytes;
-
-	if (rq->cmd_flags & REQ_DISCARD)
-		rw |= REQ_DISCARD;
-
-	if (rq->cmd_flags & REQ_SECURE)
-		rw |= REQ_SECURE;
-
-	bytes = blk_rq_bytes(rq);
-
-	blk_fill_rwbs(rwbs, rw, bytes);
-}
-
 #endif /* CONFIG_EVENT_TRACING */
 
-- 
1.6.3.GIT

