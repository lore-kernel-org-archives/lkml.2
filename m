Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab0DICT2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 22:19:28 -0400
Received: from smtp-out.google.com ([74.125.121.35]:43387 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab0DICT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 22:19:26 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=lY4+7MQaHRJSAybYDyZjEyaoHjaFjKc9H6nDXQj5U+TBbNoG32L7u7q3uZMBzF5u2
	TQvHiKpWy3/cs7cAjgjrQ==
From: Divyesh Shah <dpshah@google.com>
Subject: [PATCH] cfq-iosched: Fix the incorrect timeslice accounting with
	forced_dispatch.
To: jens.axboe@oracle.com, vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, nauman@google.com, ctalbott@google.com
Date: Thu, 08 Apr 2010 19:19:00 -0700
Message-ID: <20100409021054.13511.52377.stgit@austin.mtv.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CFQ dispatches requests forcefully due to a barrier or changing iosched,
it runs through all cfqq's dispatching requests and then expires each queue.
However, it does not activate a cfqq before flushing its IOs resulting in
using stale values for computing slice_used.
This patch fixes it by calling activate queue before flushing reuqests from
each queue.

This is useful mostly for barrier requests because when the iosched is changing
it really doesnt matter if we have incorrect accounting since we're going to
break down all structures anyway.

We also now expire the current timeslice before moving on with the dispatch
to accurately account slice used for that cfqq.

Signed-off-by: Divyesh Shah<dpshah@google.com>
---
Side question that is related:
(W/o the change to expire the current timeslice) If there is a currently active
queue which has no requests pending and is idling and we enter forced_dispatch,
it seems to me that it is pure chance that we are not hitting the BUG_ON for
cfqd->busy_queues in cfq_forced_dispatch(). The current active queue (which is
on rr and included in the busy_queues count) can appear in any order from
get_next_queue_forced() and it may well happen that all non-empty cfqqs were
dispatched from before it and by the time we get to this queue cfqd->rq_queued
goes down to zero and we bail out. Hence, __cfq_slice_expired() never gets
called for this cfqq and it is not taken off from rr which should result in
cfqd->busy_queues to be non-zero and the BUG_ON I mentioned earlier should be
hit.
Does this sound correct?

 block/cfq-iosched.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 9102ffc..39b9a36 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2196,10 +2196,13 @@ static int cfq_forced_dispatch(struct cfq_data *cfqd)
 	struct cfq_queue *cfqq;
 	int dispatched = 0;
 
-	while ((cfqq = cfq_get_next_queue_forced(cfqd)) != NULL)
+	/* Expire the timeslice of the current active queue first */
+	cfq_slice_expired(cfqd, 0);
+	while ((cfqq = cfq_get_next_queue_forced(cfqd)) != NULL) {
+		__cfq_set_active_queue(cfqd, cfqq);
 		dispatched += __cfq_forced_dispatch_cfqq(cfqq);
+	}
 
-	cfq_slice_expired(cfqd, 0);
 	BUG_ON(cfqd->busy_queues);
 
 	cfq_log(cfqd, "forced_dispatch=%d", dispatched);

