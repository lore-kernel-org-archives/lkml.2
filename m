Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab0HXOih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 10:38:37 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:59330 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab0HXOig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 10:38:36 -0400
Date: Tue, 24 Aug 2010 16:38:33 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Samuel Ortiz <samuel@sortiz.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/5] drivers/net/irda: Eliminate memory leak
Message-ID: <Pine.LNX.4.64.1008241638130.15172@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

dev_alloc_skb allocates some memory, so that memory should be freed before
leaving the function in an error case.

Corrected some typos in a nearby comment as well.

A simplified version of the semantic match that finds this problem is:
(http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
local idexpression x;
expression E;
identifier f1;
iterator I;
@@

x = dev_alloc_skb(...);
<... when != x
     when != true (x == NULL || ...)
     when != if (...) { <+...x...+> }
     when != I (...) { <+...x...+> }
(
 x == NULL
|
 x == E
|
 x->f1
)
...>
* return ...;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/net/irda/via-ircc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/irda/via-ircc.c b/drivers/net/irda/via-ircc.c
index b0a6cd8..67c0ad4 100644
--- a/drivers/net/irda/via-ircc.c
+++ b/drivers/net/irda/via-ircc.c
@@ -1182,12 +1182,13 @@ F01_E */
 
 		skb = dev_alloc_skb(len + 1 - 4);
 		/*
-		 * if frame size,data ptr,or skb ptr are wrong ,the get next
+		 * if frame size, data ptr, or skb ptr are wrong, then get next
 		 * entry.
 		 */
 		if ((skb == NULL) || (skb->data == NULL) ||
 		    (self->rx_buff.data == NULL) || (len < 6)) {
 			self->netdev->stats.rx_dropped++;
+			kfree_skb(skb);
 			return TRUE;
 		}
 		skb_reserve(skb, 1);
