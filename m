Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab2JATeG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 15:34:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188Ab2JATdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 15:33:02 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: tj@kernel.org, cgroups@vger.kernel.org, vgoyal@redhat.com
Subject: [PATCH 12/15] cfq-iosched: put cooperating queue at the front of service tree
Date: Mon,  1 Oct 2012 15:32:53 -0400
Message-Id: <1349119976-26837-13-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1349119976-26837-1-git-send-email-vgoyal@redhat.com>
References: <1349119976-26837-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently during select_queue(), if a cfqq runs out of requests, cfq
checks if there is a cooperating queue doing IO nearby. If yes, it
lets that queue run out of turn.

But while doing so, CFQ does not put that queue at the front of service
tree and select it. It just forces it to be active queue.

This will not play very nice with new algorithm where we keep track
of min_vdisktime on service tree and always select first queue on
the service tree to run.

So instead of force setting active queue, put desired cooperating
queue at the front of service tree (like preemption), and then
go through get_next_cfqq() to select first queue on service tree.

So end result still remains the same, just that this method will
play better with new algorithm.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index a2016f5..8912051 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2116,12 +2116,11 @@ static struct cfq_queue *cfq_get_next_queue_forced(struct cfq_data *cfqd)
 /*
  * Get and set a new active queue for service.
  */
-static struct cfq_queue *cfq_set_active_queue(struct cfq_data *cfqd,
-					      struct cfq_queue *cfqq)
+static struct cfq_queue *cfq_set_active_queue(struct cfq_data *cfqd)
 {
-	if (!cfqq)
-		cfqq = cfq_get_next_queue(cfqd);
+	struct cfq_queue *cfqq;
 
+	cfqq = cfq_get_next_queue(cfqd);
 	__cfq_set_active_queue(cfqd, cfqq);
 	return cfqq;
 }
@@ -2651,6 +2650,12 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 	 */
 	new_cfqq = cfq_close_cooperator(cfqd, cfqq);
 	if (new_cfqq) {
+		/*
+		 * This close cooperator queue will be selected next. Put
+		 * it at the front of servie tree and then go through normal
+		 * get_next_queue() logic.
+		 */
+		cfq_st_add(cfqd, new_cfqq, 1);
 		if (!cfqq->new_cfqq)
 			cfq_setup_merge(cfqq, new_cfqq);
 		goto expire;
@@ -2704,7 +2709,7 @@ new_queue:
 	if (!new_cfqq)
 		cfq_choose_cfqg(cfqd);
 
-	cfqq = cfq_set_active_queue(cfqd, new_cfqq);
+	cfqq = cfq_set_active_queue(cfqd);
 keep_queue:
 	return cfqq;
 }
-- 
1.7.7.6

