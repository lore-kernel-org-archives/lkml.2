Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933367Ab0EYRPc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 13:15:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933018Ab0EYRP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 13:15:29 -0400
Date: Tue, 25 May 2010 13:15:15 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>,
       Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/1] block: make blk_init_free_list and elevator_init
 idempotent
Message-ID: <20100525171515.GB10155@redhat.com>
References: <1274744795-9825-1-git-send-email-snitzer@redhat.com>
 <1274744795-9825-3-git-send-email-snitzer@redhat.com>
 <4BFBB21A.3030105@ct.jp.nec.com>
 <20100525124912.GA7447@redhat.com>
 <20100525163455.GA10155@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100525163455.GA10155@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk_init_allocated_queue_node may fail and the caller _could_ retry.
Accommodate the unlikely event that blk_init_allocated_queue_node is
called on an already initialized (possibly partially) request_queue.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-core.c |    3 +++
 block/elevator.c |    6 ++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index c0179b7..2c208c3 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -467,6 +467,9 @@ static int blk_init_free_list(struct request_queue *q)
 {
 	struct request_list *rl = &q->rq;
 
+	if (unlikely(rl->rq_pool))
+		return 0;
+
 	rl->count[BLK_RW_SYNC] = rl->count[BLK_RW_ASYNC] = 0;
 	rl->starved[BLK_RW_SYNC] = rl->starved[BLK_RW_ASYNC] = 0;
 	rl->elvpriv = 0;
diff --git a/block/elevator.c b/block/elevator.c
index 0abce47..923a913 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -242,9 +242,11 @@ int elevator_init(struct request_queue *q, char *name)
 {
 	struct elevator_type *e = NULL;
 	struct elevator_queue *eq;
-	int ret = 0;
 	void *data;
 
+	if (unlikely(q->elevator))
+		return 0;
+
 	INIT_LIST_HEAD(&q->queue_head);
 	q->last_merge = NULL;
 	q->end_sector = 0;
@@ -284,7 +286,7 @@ int elevator_init(struct request_queue *q, char *name)
 	}
 
 	elevator_attach(q, eq, data);
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL(elevator_init);
 
