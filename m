Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab2IOLZ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 07:25:56 -0400
Received: from spostino.sms.unimo.it ([155.185.44.3]:40820 "EHLO
	spostino.sms.unimo.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab2IOLZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 07:25:55 -0400
X-Greylist: delayed 2638 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Sep 2012 07:25:54 EDT
Date: Sat, 15 Sep 2012 12:41:35 +0200
From: Paolo Valente <paolo.valente@unimore.it>
To: davem@davemloft.net, shemminger@vyatta.com, jhs@mojatatu.com
Cc: fchecconi@gmail.com, rizzo@iet.unipi.it, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, paolo.valente@unimore.it
Subject: [PATCH] sched: fix virtual-start-time update in QFQ
Message-ID: <20120915104134.GA29862@paolo-ThinkPad-W520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
UNIMORE-X-SA-Score: -2.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 net/sched/sch_qfq.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index e4723d3..211a212 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -865,7 +865,10 @@ static void qfq_update_start(struct qfq_sched *q, struct qfq_class *cl)
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
-- 
1.7.9.5

