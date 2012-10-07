Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab2JGXju (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:39:50 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38337 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753769Ab2JGXW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:22:26 -0400
Message-Id: <20121007225846.860685998@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 08 Oct 2012 00:00:02 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Paolo Valente <paolo.valente@unimore.it>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 088/108] pkt_sched: fix virtual-start-time update in QFQ
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Valente <paolo.valente@unimore.it>

[ Upstream commit 71261956973ba9e0637848a5adb4a5819b4bae83 ]

If the old timestamps of a class, say cl, are stale when the class
becomes active, then QFQ may assign to cl a much higher start time
than the maximum value allowed. This may happen when QFQ assigns to
the start time of cl the finish time of a group whose classes are
characterized by a higher value of the ratio
max_class_pkt/weight_of_the_class with respect to that of
cl. Inserting a class with a too high start time into the bucket list
corrupts the data structure and may eventually lead to crashes.
This patch limits the maximum start time assigned to a class.

Signed-off-by: Paolo Valente <paolo.valente@unimore.it>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sched/sch_qfq.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index 7b03254..ca0fb48 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -829,7 +829,10 @@ static void qfq_update_start(struct qfq_sched *q, struct qfq_class *cl)
 		if (mask) {
 			struct qfq_group *next = qfq_ffs(q, mask);
 			if (qfq_gt(roundedF, next->F)) {
-				cl->S = next->F;
+				if (qfq_gt(limit, next->F))
+					cl->S = next->F;
+				else /* preserve timestamp correctness */
+					cl->S = limit;
 				return;
 			}
 		}


