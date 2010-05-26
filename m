Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab0EZP4Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 11:56:24 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:40726 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755054Ab0EZP4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 11:56:20 -0400
Date: Wed, 26 May 2010 17:56:14 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 7/17] arch/arm/common: Add missing spin_unlock_irqrestore
Message-ID: <Pine.LNX.4.64.1005261756000.23743@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Add a spin_unlock_irqrestore missing on the error path.  Although the lock
is destroyed with the rest of the sachip structure in the function
__sa1111_remove, it still seems useful to restore the interrupt state.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression E1;
@@

* spin_lock_irqsave(E1,...);
  <+... when != E1
  if (...) {
    ... when != E1
*   return ...;
  }
  ...+>
* spin_unlock_irqrestore(E1,...);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
Perhaps the unlock is now too early?

 arch/arm/common/sa1111.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/common/sa1111.c b/arch/arm/common/sa1111.c
index a52a27c..59e38ff 100644
--- a/arch/arm/common/sa1111.c
+++ b/arch/arm/common/sa1111.c
@@ -959,6 +959,7 @@ static int sa1111_resume(struct platform_device *dev)
 	 */
 	id = sa1111_readl(sachip->base + SA1111_SKID);
 	if ((id & SKID_ID_MASK) != SKID_SA1111_ID) {
+		spin_unlock_irqrestore(&sachip->lock, flags);
 		__sa1111_remove(sachip);
 		platform_set_drvdata(dev, NULL);
 		kfree(save);
