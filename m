Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab0C2QXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 12:23:37 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:33825 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754296Ab0C2QXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 12:23:35 -0400
Date: Mon, 29 Mar 2010 18:23:30 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 4/12] drivers/gpio: Add missing unlock
In-Reply-To: <Pine.LNX.4.64.1003291734110.21896@ask.diku.dk>
Message-ID: <Pine.LNX.4.64.1003291822470.21896@ask.diku.dk>
References: <Pine.LNX.4.64.1003291734110.21896@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In an error handling case the lock is not unlocked.  The return is
converted to a goto, to share the unlock at the end of the function.

A simplified version of the semantic patch that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
expression E1;
identifier f;
@@

f (...) { <+...
* spin_lock_irqsave (E1,...);
... when != E1
* return ...;
...+> }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
Corrected patch.  Adjusted the return value.

 drivers/gpio/timbgpio.c             |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/timbgpio.c b/drivers/gpio/timbgpio.c
index d4295fa..871608b 100644
--- a/drivers/gpio/timbgpio.c
+++ b/drivers/gpio/timbgpio.c
@@ -130,6 +130,7 @@ static int timbgpio_irq_type(unsigned irq, unsigned trigger)
 	unsigned long flags;
 	u32 lvr, flr, bflr = 0;
 	u32 ver;
+	int ret = 0;
 
 	if (offset < 0 || offset > tgpio->gpio.ngpio)
 		return -EINVAL;
@@ -153,8 +154,10 @@ static int timbgpio_irq_type(unsigned irq, unsigned trigger)
 	}
 
 	if ((trigger & IRQ_TYPE_EDGE_BOTH) == IRQ_TYPE_EDGE_BOTH) {
-		if (ver < 3)
-			return -EINVAL;
+		if (ver < 3) {
+			ret = -EINVAL;
+			goto out;
+		}
 		else {
 			flr |= 1 << offset;
 			bflr |= 1 << offset;
@@ -174,9 +177,10 @@ static int timbgpio_irq_type(unsigned irq, unsigned trigger)
 		iowrite32(bflr, tgpio->membase + TGPIO_BFLR);
 
 	iowrite32(1 << offset, tgpio->membase + TGPIO_ICR);
-	spin_unlock_irqrestore(&tgpio->lock, flags);
 
-	return 0;
+out:
+	spin_unlock_irqrestore(&tgpio->lock, flags);
+	return ret;
 }
 
 static void timbgpio_irq(unsigned int irq, struct irq_desc *desc)
