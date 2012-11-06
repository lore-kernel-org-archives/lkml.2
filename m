Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab2KFLer (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 06:34:47 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45627 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab2KFLep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 06:34:45 -0500
Date: Tue, 6 Nov 2012 19:34:28 +0800
From: Shaohua Li <shli@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: block CFQ: avoid moving request to different queue
Message-ID: <20121106113428.GA19182@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

request is queued in cfqq->fifo list. Looks it's possible we are moving a
request from one cfqq to another in request merge case. In such case, adjusting
the fifo list order doesn't make sense and is impossible if we don't iterate
the whole fifo list.

My test does hit one case the two cfqq are different, but didn't cause kernel
crash, maybe it's because fifo list isn't used frequently. Anyway, from the
code logic, this is buggy.

I thought we can re-enable the recusive merge logic after this is fixed.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 block/cfq-iosched.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/block/cfq-iosched.c
===================================================================
--- linux.orig/block/cfq-iosched.c	2012-08-29 16:18:35.339907814 +0800
+++ linux/block/cfq-iosched.c	2012-11-06 19:26:05.575446275 +0800
@@ -1973,7 +1973,8 @@ cfq_merged_requests(struct request_queue
 	 * reposition in fifo if next is older than rq
 	 */
 	if (!list_empty(&rq->queuelist) && !list_empty(&next->queuelist) &&
-	    time_before(rq_fifo_time(next), rq_fifo_time(rq))) {
+	    time_before(rq_fifo_time(next), rq_fifo_time(rq)) &&
+	    cfqq == RQ_CFQQ(next)) {
 		list_move(&rq->queuelist, &next->queuelist);
 		rq_set_fifo_time(rq, rq_fifo_time(next));
 	}
