Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab2JPBms (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 21:42:48 -0400
Received: from noserose.net ([66.220.18.76]:44518 "HELO noserose.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755509Ab2JPBmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 21:42:47 -0400
Date: Mon, 15 Oct 2012 18:42:43 -0700
Message-Id: <8691a45b39d4f93743f93360c467789a75e25fb7.1350331035.git.ecashin@coraid.com>
In-Reply-To: <cover.1350331035.git.ecashin@coraid.com>
References: <cover.1350331035.git.ecashin@coraid.com>
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
 drivers/block/aoe/aoenet.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/block/aoe/aoenet.c b/drivers/block/aoe/aoenet.c
index 162c647..a1bb692 100644
--- a/drivers/block/aoe/aoenet.c
+++ b/drivers/block/aoe/aoenet.c
@@ -50,7 +50,11 @@ __setup("aoe_iflist=", aoe_iflist_setup);
 static spinlock_t txlock;
 static struct sk_buff_head skbtxq;
 
-/* enters with txlock held */
+/* enters with txlock held
+ *
+ * Use __must_hold(&txlock) for sparse when upcoming patch adds it to
+ * compiler.h.
+ */
 static int
 tx(void)
 {
@@ -58,7 +62,10 @@ tx(void)
 
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

