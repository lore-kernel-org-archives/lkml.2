Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268Ab0GGPX2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 11:23:28 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55320 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757220Ab0GGPXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 11:23:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=TQnWaBSIl9EAQP0pFvpxwDKOvyIREVeoBpB8o4cSbK/WdJUef5sFbDOOMFC/bgQ3zC
         j1sBnGD4r41ZG3pC8QM7NHxT17cB/u2leD38dTPzve3szKXJ2fKFuoigkUgIl7D/Xc+l
         6Domj1fNFLmYEiPftv4iE+ga14+eHZKehBf9o=
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
       Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Corrado Zoccolo <czoccolo@gmail.com>
Subject: [PATCH 2/2] cfq-iosched: RQ_NOIDLE enabled for SYNC_WORKLOAD
Date: Wed,  7 Jul 2010 17:23:47 +0200
Message-Id: <1278516227-1643-2-git-send-email-czoccolo@gmail.com>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1278516227-1643-1-git-send-email-czoccolo@gmail.com>
References: <1278516227-1643-1-git-send-email-czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RQ_NOIDLE flag is meaningful and should be honored for SYNC_WORKLOAD,
without further checks.
RQ_NOIDLE can be used to mark the last request of a sequence for which
- we want to idle between the requests of the sequence, to keep locality
- we don't want to idle after the sequence, because we know that no new
  nearby requests will follow, so we should switch servicing other
  queues.
This patch fixes this behaviour, making it similar to how it behaved
before 8e55063, but still fixing the corner cases that were the
motivation for it.

Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
---
 block/cfq-iosched.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 5ef9a5d..cac3afb 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -3356,12 +3356,17 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
 				cfqd->noidle_tree_requires_idle |= bitmask;
 
 			/*
-			 * Idling is enabled for SYNC_WORKLOAD.
-			 * SYNC_NOIDLE_WORKLOAD idles at the end of the tree
-			 * only if we processed at least one !rq_noidle request
+			 * Idling is enabled for:
+			 * - the last sync queue of a group
+			 * - SYNC_WORKLOAD queues, for !rq_noidle requests
+			 * - SYNC_NOIDLE_WORKLOAD "at the end of the tree"
+			 *   if at least one queue sent !rq_noidle requests
+			 *   not followed by at least one rq_noidle request.
 			 */
-			if (cfqd->serving_type == SYNC_WORKLOAD
-			    || cfqd->noidle_tree_requires_idle
+			if ((cfqd->serving_type == SYNC_WORKLOAD
+			     && !rq_noidle(rq))
+			    || (cfqd->serving_type == SYNC_NOIDLE_WORKLOAD
+				&& cfqd->noidle_tree_requires_idle)
 			    || cfqq->cfqg->nr_cfqq == 1)
 				cfq_arm_slice_timer(cfqd);
 		}
-- 
1.6.4.4

