Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161044Ab2JXS1H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 14:27:07 -0400
Received: from dupo.coraid.com ([208.71.232.133]:52307 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935245Ab2JXS1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 14:27:05 -0400
From: Ed Cashin <ecashin@coraid.com>
Subject: [PATCH] aoe: avoid using skb member after dev_queue_xmit
To: akpm@linux-foundation.org
Cc: ecashin@coraid.com, dan.carpenter@oracle.com,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Wed, 24 Oct 2012 14:26:13 -0400
Message-ID: <d1523cdc8a606d65418dc242e958ff1c@coraid.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After calling dev_queue_xmit it is no longer safe to access the
members of the skb.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoenet.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/block/aoe/aoenet.c b/drivers/block/aoe/aoenet.c
index ae56828..2e47404 100644
--- a/drivers/block/aoe/aoenet.c
+++ b/drivers/block/aoe/aoenet.c
@@ -55,12 +55,14 @@ static int
 tx(void) __must_hold(&txlock)
 {
 	struct sk_buff *skb;
+	struct net_device *ifp;
 
 	while ((skb = skb_dequeue(&skbtxq))) {
 		spin_unlock_irq(&txlock);
+		ifp = skb->dev;
 		if (dev_queue_xmit(skb) == NET_XMIT_DROP && net_ratelimit())
 			pr_warn("aoe: packet could not be sent on %s.  %s\n",
-				skb->dev ? skb->dev->name : "netif",
+				ifp ? ifp->name : "netif",
 				"consider increasing tx_queue_len");
 		spin_lock_irq(&txlock);
 	}
-- 
1.7.1

