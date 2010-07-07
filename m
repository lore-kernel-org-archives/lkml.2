Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199Ab0GGPXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 11:23:20 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45468 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756833Ab0GGPXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 11:23:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=W0J7c4NXMnDDBFhFEeLl2dMA8dlMCheav92cNDYnbfUCTDwwsHy85+2UCcbhCQfe2O
         KqHzWhBZsNlDbbINHRjbgrrMOGDv33OfiPBvNv5dtdLp0KifjoFPbTc8h0ktTeEuVucB
         oiqfyONOvpvYfZmJuXYvCOrtCxladDV3FjhSo=
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
       Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Corrado Zoccolo <czoccolo@gmail.com>
Subject: [PATCH 1/2] cfq-iosched: fix tree-wide handling of rq_noidle
Date: Wed,  7 Jul 2010 17:23:46 +0200
Message-Id: <1278516227-1643-1-git-send-email-czoccolo@gmail.com>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch: 8e55063 cfq-iosched: fix corner cases in idling logic
introduced the possibility of iding even on no-idle requests
in the no_idle tree, if any previous request in the current slice
could idle. The implementation had a problem, though:
- if a queue sent several possibly idling requests and a noidle
  request as last one in the same time slice, the tree was still
  marked as idle.
This patch fixes this misbehaviour, by using a 31-bucket hash to
keep idling/non-idling status for queues in the noidle tree.

Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
---
 block/cfq-iosched.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index d1ad066..5ef9a5d 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -214,7 +214,7 @@ struct cfq_data {
 	enum wl_type_t serving_type;
 	unsigned long workload_expires;
 	struct cfq_group *serving_group;
-	bool noidle_tree_requires_idle;
+	u32 noidle_tree_requires_idle;
 
 	/*
 	 * Each priority tree is sorted by next_request position.  These
@@ -2066,7 +2066,7 @@ static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
 	slice = max_t(unsigned, slice, CFQ_MIN_TT);
 	cfq_log(cfqd, "workload slice:%d", slice);
 	cfqd->workload_expires = jiffies + slice;
-	cfqd->noidle_tree_requires_idle = false;
+	cfqd->noidle_tree_requires_idle = 0U;
 }
 
 static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd)
@@ -3349,7 +3349,12 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 			cfq_slice_expired(cfqd, 1);
 		else if (sync && cfqq_empty &&
 			 !cfq_close_cooperator(cfqd, cfqq)) {
-			cfqd->noidle_tree_requires_idle |= !rq_noidle(rq);
+			u32 bitmask = 1U << (((int)cfqq) % 31);
+			if (rq_noidle(rq))
+				cfqd->noidle_tree_requires_idle &= ~bitmask;
+			else
+				cfqd->noidle_tree_requires_idle |= bitmask;
+
 			/*
 			 * Idling is enabled for SYNC_WORKLOAD.
 			 * SYNC_NOIDLE_WORKLOAD idles at the end of the tree
-- 
1.6.4.4

