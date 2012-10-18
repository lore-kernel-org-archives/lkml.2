Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab2JRBpi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 21:45:38 -0400
Received: from noserose.net ([66.220.18.76]:33271 "HELO noserose.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753095Ab2JRBph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 21:45:37 -0400
Date: Wed, 17 Oct 2012 18:45:30 -0700
Message-Id: <95597096f5b352c6ab5cdf7e6a5f3bc258283af1.1350524227.git.ecashin@coraid.com>
In-Reply-To: <cover.1350524227.git.ecashin@coraid.com>
References: <cover.1350524227.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Subject: [PATCH 2/9] aoe: print warning regarding a common reason for dropped transmits
To: akpm@linux-foundation.org
Cc: ecashin@coraid.com, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dropped transmits are not common, but when they do occur, increasing
the transmit queue length often helps.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoenet.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/block/aoe/aoenet.c b/drivers/block/aoe/aoenet.c
index 162c647..3cf068b 100644
--- a/drivers/block/aoe/aoenet.c
+++ b/drivers/block/aoe/aoenet.c
@@ -52,13 +52,16 @@ static struct sk_buff_head skbtxq;
 
 /* enters with txlock held */
 static int
-tx(void)
+tx(void) __must_hold(&txlock)
 {
 	struct sk_buff *skb;
 
 	while ((skb = skb_dequeue(&skbtxq))) {
 		spin_unlock_irq(&txlock);
-		dev_queue_xmit(skb);
+		if (dev_queue_xmit(skb) == NET_XMIT_DROP && net_ratelimit())
+			pr_warn("aoe: packet could not be sent on %s.  %s\n",
+				skb->dev ? skb->dev->name : "netif",
+				"consider increasing tx_queue_len");
 		spin_lock_irq(&txlock);
 	}
 	return 0;
-- 
1.7.1

