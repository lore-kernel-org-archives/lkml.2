Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab2GTVv4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 17:51:56 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:37705 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab2GTVvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 17:51:54 -0400
From: Denis Efremov <yefremov.denis@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Denis Efremov <yefremov.denis@gmail.com>,
        David Decotigny <david.decotigny@google.com>,
        Eric Dumazet <edumazet@google.com>, Jiri Pirko <jpirko@redhat.com>,
        Ian Campbell <ian.campbell@citrix.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] forcedeth: spin_unlock_irq in interrupt handler fix
Date: Sat, 21 Jul 2012 01:54:34 +0400
Message-Id: <1342821274-20623-1-git-send-email-yefremov.denis@gmail.com>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The replacement of spin_lock_irq/spin_unlock_irq pair in interrupt
handler by spin_lock_irqsave/spin_lock_irqrestore pair.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
---
 drivers/net/ethernet/nvidia/forcedeth.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 928913c..7e68c00 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -3776,7 +3776,7 @@ static irqreturn_t nv_nic_irq_other(int foo, void *data)
 			np->link_timeout = jiffies + LINK_TIMEOUT;
 		}
 		if (events & NVREG_IRQ_RECOVER_ERROR) {
-			spin_lock_irq(&np->lock);
+			spin_lock_irqsave(&np->lock, flags);
 			/* disable interrupts on the nic */
 			writel(NVREG_IRQ_OTHER, base + NvRegIrqMask);
 			pci_push(base);
@@ -3786,7 +3786,7 @@ static irqreturn_t nv_nic_irq_other(int foo, void *data)
 				np->recover_error = 1;
 				mod_timer(&np->nic_poll, jiffies + POLL_WAIT);
 			}
-			spin_unlock_irq(&np->lock);
+			spin_unlock_irqrestore(&np->lock, flags);
 			break;
 		}
 		if (unlikely(i > max_interrupt_work)) {
-- 
1.7.7

