Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758630Ab2JAX1r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:27:47 -0400
Received: from 1wt.eu ([62.212.114.60]:35259 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932756Ab2JAXAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:00:54 -0400
Message-Id: <20121001225201.043384456@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:53:18 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: David Ward <david.ward@ll.mit.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 081/180] net_sched: gred: Fix oops in gred_dump() in WRED mode
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: David Ward <david.ward@ll.mit.edu>

[ Upstream commit 244b65dbfede788f2fa3fe2463c44d0809e97c6b ]

A parameter set exists for WRED mode, called wred_set, to hold the same
values for qavg and qidlestart across all VQs. The WRED mode values had
been previously held in the VQ for the default DP. After these values
were moved to wred_set, the VQ for the default DP was no longer created
automatically (so that it could be omitted on purpose, to have packets
in the default DP enqueued directly to the device without using RED).

However, gred_dump() was overlooked during that change; in WRED mode it
still reads qavg/qidlestart from the VQ for the default DP, which might
not even exist. As a result, this command sequence will cause an oops:

tc qdisc add dev $DEV handle $HANDLE parent $PARENT gred setup \
    DPs 3 default 2 grio
tc qdisc change dev $DEV handle $HANDLE gred DP 0 prio 8 $RED_OPTIONS
tc qdisc change dev $DEV handle $HANDLE gred DP 1 prio 8 $RED_OPTIONS

This fixes gred_dump() in WRED mode to use the values held in wred_set.

Signed-off-by: David Ward <david.ward@ll.mit.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/sched/sch_gred.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/sched/sch_gred.c b/net/sched/sch_gred.c
index 40408d5..bf98414 100644
--- a/net/sched/sch_gred.c
+++ b/net/sched/sch_gred.c
@@ -544,11 +544,8 @@ static int gred_dump(struct Qdisc *sch, struct sk_buff *skb)
 		opt.packets	= q->packetsin;
 		opt.bytesin	= q->bytesin;
 
-		if (gred_wred_mode(table)) {
-			q->parms.qidlestart =
-				table->tab[table->def]->parms.qidlestart;
-			q->parms.qavg = table->tab[table->def]->parms.qavg;
-		}
+		if (gred_wred_mode(table))
+			gred_load_wred_set(table, q);
 
 		opt.qave = red_calc_qavg(&q->parms, q->parms.qavg);
 
-- 
1.7.2.1.45.g54fbc



