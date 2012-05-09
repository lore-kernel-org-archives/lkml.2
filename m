Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021Ab2EIGLq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:11:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38913 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756183Ab2EIFxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:31 -0400
Message-Id: <20120509055040.894735234@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:51:49 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, David Ward <david.ward@ll.mit.edu>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 080/167] [PATCH 20/26] net_sched: gred: Fix oops in gred_dump() in WRED mode
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sched/sch_gred.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/sched/sch_gred.c b/net/sched/sch_gred.c
index 6cd8ddf..e1afe0c 100644
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
1.7.10



