Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662Ab2ILNDJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 09:03:09 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:15608 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758013Ab2ILMzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:55:54 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqECACCFUFBbdWObgWdsb2JhbABFu0AiAQEWJieCIAEBBSdSECAxVwYTiBG8YpFSA5Vfkwc
X-IronPort-AV: E=Sophos;i="4.80,410,1344204000"; 
   d="scan'208";a="950511757"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 12/24] Staging: ipack/bridges/tpci200: Clean up interrupt handling.
Date: Wed, 12 Sep 2012 14:55:34 +0200
Message-Id: <1347454546-23236-12-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
References: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

Previously the return value from tpci200_interrupt was not quite correct
if a slot had caused an interrupt but no handler was instellalled:
IRQ_NONE was returned.  However in this case we react to the interrupt
by disabling the IPack device interrupt.

Basically there are two cases the code now distinguishes:
 - The tpci200 has raised an interrupt.  We handle it and return
   IRQ_HANDLED.
 - Our device did not raise an interrupt. We return IRQ_NONE.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index b1ddbe3..0cbaf3a 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -116,7 +116,6 @@ static irqreturn_t tpci200_interrupt(int irq, void *dev_id)
 	struct tpci200_board *tpci200 = (struct tpci200_board *) dev_id;
 	int i;
 	unsigned short status_reg;
-	irqreturn_t ret = IRQ_NONE;
 	struct slot_irq *slot_irq;
 
 	/* Read status register */
@@ -130,7 +129,7 @@ static irqreturn_t tpci200_interrupt(int irq, void *dev_id)
 				continue;
 			slot_irq = rcu_dereference(tpci200->slots[i].irq);
 			if (slot_irq) {
-				ret = tpci200_slot_irq(slot_irq);
+				tpci200_slot_irq(slot_irq);
 			} else {
 				dev_info(&tpci200->info->pdev->dev,
 					 "No registered ISR for slot [%d:%d]!. IRQ will be disabled.\n",
@@ -141,9 +140,11 @@ static irqreturn_t tpci200_interrupt(int irq, void *dev_id)
 			}
 		}
 		rcu_read_unlock();
-	}
 
-	return ret;
+		return IRQ_HANDLED;
+	} else {
+		return IRQ_NONE;
+	}
 }
 
 static int tpci200_register(struct tpci200_board *tpci200)
-- 
1.7.10.4

