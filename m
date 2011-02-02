Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab1BBA77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:59:59 -0500
Received: from mga03.intel.com ([143.182.124.21]:7565 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753367Ab1BBAoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="382960620"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: xiaosuo@gmail.com, hadi@cyberus.ca, davem@davemloft.net, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [68/139] ifb: goto resched directly if error happens and dp->tq isn't empty
Message-Id: <20110202004424.F1BC33E09C6@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Changli Gao <xiaosuo@gmail.com>

[ Upstream commit 75c1c82566f23dd539fb7ccbf57a1caa7ba82628 ]

If we break the loop when there are still skbs in tq and no skb in
rq, the skbs will be left in txq until new skbs are enqueued into rq.
In rare cases, no new skb is queued, then these skbs will stay in rq
forever.

After this patch, if tq isn't empty when we break the loop, we goto
resched directly.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
Signed-off-by: Jamal Hadi Salim <hadi@cyberus.ca>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/net/ifb.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.35.y/drivers/net/ifb.c
===================================================================
--- linux-2.6.35.y.orig/drivers/net/ifb.c
+++ linux-2.6.35.y/drivers/net/ifb.c
@@ -104,6 +104,8 @@ static void ri_tasklet(unsigned long dev
 			rcu_read_unlock();
 			dev_kfree_skb(skb);
 			stats->tx_dropped++;
+			if (skb_queue_len(&dp->tq) != 0)
+				goto resched;
 			break;
 		}
 		rcu_read_unlock();
