Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933942Ab2JKBTu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 21:19:50 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53726 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933794Ab2JKBTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 21:19:45 -0400
X-Sasl-enc: L/0QZMWWj3CgjO5XYSDq60krO3QdJCD6WyqMQxOGoOOW 1349918384
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Paolo Valente <paolo.valente@unimore.it>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 037/120] pkt_sched: fix virtual-start-time update in QFQ
Date: Thu, 11 Oct 2012 09:59:49 +0900
Message-Id: <20121011005832.331992604@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011005825.364610894@linuxfoundation.org>
References: <20121011005825.364610894@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_qfq.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -830,7 +830,10 @@ static void qfq_update_start(struct qfq_
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


