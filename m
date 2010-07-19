Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966436Ab0GSSmF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 14:42:05 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:15285 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966397Ab0GSSlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 14:41:23 -0400
Subject: [PATCH 26/26] cciss: cleanup interrupt_not_for_us
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Date: Mon, 19 Jul 2010 13:46:54 -0500
Message-ID: <20100719184654.7908.98698.stgit@beardog.cce.hp.com>
In-Reply-To: <20100719184141.7908.26971.stgit@beardog.cce.hp.com>
References: <20100719184141.7908.26971.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

cciss: cleanup interrupt_not_for_us
In the case of MSI/MSIX interrutps, we don't need to check
if the interrupt is for us, and in the case of the intx interrupt
handler, when checking if the interrupt is for us, we don't need
to check if we're using MSI/MSIX, we know we're not.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |   15 +--------------
 1 files changed, 1 insertions(+), 14 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 35a9f08..fdf1b79 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3376,8 +3376,7 @@ static inline int interrupt_pending(ctlr_info_t *h)
 
 static inline long interrupt_not_for_us(ctlr_info_t *h)
 {
-	return !(h->msi_vector || h->msix_vector) &&
-		((h->access.intr_pending(h) == 0) ||
+	return ((h->access.intr_pending(h) == 0) ||
 		(h->interrupts_enabled == 0));
 }
 
@@ -3470,10 +3469,6 @@ static irqreturn_t do_cciss_intx(int irq, void *dev_id)
 
 	if (interrupt_not_for_us(h))
 		return IRQ_NONE;
-	/*
-	 * If there are completed commands in the completion queue,
-	 * we had better do something about it.
-	 */
 	spin_lock_irqsave(&h->lock, flags);
 	while (interrupt_pending(h)) {
 		raw_tag = get_next_completion(h);
@@ -3484,7 +3479,6 @@ static irqreturn_t do_cciss_intx(int irq, void *dev_id)
 				raw_tag = process_nonindexed_cmd(h, raw_tag);
 		}
 	}
-
 	spin_unlock_irqrestore(&h->lock, flags);
 	return IRQ_HANDLED;
 }
@@ -3498,12 +3492,6 @@ static irqreturn_t do_cciss_msix_intr(int irq, void *dev_id)
 	unsigned long flags;
 	u32 raw_tag;
 
-	if (interrupt_not_for_us(h))
-		return IRQ_NONE;
-	/*
-	 * If there are completed commands in the completion queue,
-	 * we had better do something about it.
-	 */
 	spin_lock_irqsave(&h->lock, flags);
 	raw_tag = get_next_completion(h);
 	while (raw_tag != FIFO_EMPTY) {
@@ -3512,7 +3500,6 @@ static irqreturn_t do_cciss_msix_intr(int irq, void *dev_id)
 		else
 			raw_tag = process_nonindexed_cmd(h, raw_tag);
 	}
-
 	spin_unlock_irqrestore(&h->lock, flags);
 	return IRQ_HANDLED;
 }

