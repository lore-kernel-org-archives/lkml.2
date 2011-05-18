Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067Ab1ERVLV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:11:21 -0400
Received: from smtp-out.google.com ([74.125.121.67]:43651 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889Ab1ERVLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:11:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:organization;
	b=v3v7xSd+mlhcPthtZ9LfdP12t8yxSJ6bdEEW/Rj9UFD0enWui6QI4Vv9BA+W/tiLl
	3lTConmNN/9ou6G5Ev18w==
From: David Decotigny <decot@google.com>
To: "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
        Szymon Janc <szymon@janc.net.pl>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kernel-net-upstream@google.com, Mike Ditto <mditto@google.com>,
        David Decotigny <decot@google.com>
Subject: [PATCH] forcedeth: Acknowledge only interrupts that are being processed
Date: Wed, 18 May 2011 14:10:47 -0700
Message-Id: <1305753049-15025-1-git-send-email-decot@google.com>
X-Mailer: git-send-email 1.7.3.1
Organization: Google, Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Ditto <mditto@google.com>

This is to avoid a race, accidentally acknowledging an interrupt that
we didn't notice and won't immediately process.  This is based solely
on code inspection; it is not known if there was an actual bug here.


Signed-off-by: David Decotigny <decot@google.com>
---
 drivers/net/forcedeth.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/forcedeth.c b/drivers/net/forcedeth.c
index 2c176ff..c9bdee6 100644
--- a/drivers/net/forcedeth.c
+++ b/drivers/net/forcedeth.c
@@ -3403,7 +3403,8 @@ static irqreturn_t nv_nic_irq_tx(int foo, void *data)
 
 	for (i = 0;; i++) {
 		events = readl(base + NvRegMSIXIrqStatus) & NVREG_IRQ_TX_ALL;
-		writel(NVREG_IRQ_TX_ALL, base + NvRegMSIXIrqStatus);
+		writel(events, base + NvRegMSIXIrqStatus);
+		netdev_dbg(dev, "%s: tx irq: %08x\n", dev->name, events);
 		if (!(events & np->irqmask))
 			break;
 
@@ -3514,7 +3515,8 @@ static irqreturn_t nv_nic_irq_rx(int foo, void *data)
 
 	for (i = 0;; i++) {
 		events = readl(base + NvRegMSIXIrqStatus) & NVREG_IRQ_RX_ALL;
-		writel(NVREG_IRQ_RX_ALL, base + NvRegMSIXIrqStatus);
+		writel(events, base + NvRegMSIXIrqStatus);
+		netdev_dbg(dev, "%s: rx irq: %08x\n", dev->name, events);
 		if (!(events & np->irqmask))
 			break;
 
@@ -3558,7 +3560,8 @@ static irqreturn_t nv_nic_irq_other(int foo, void *data)
 
 	for (i = 0;; i++) {
 		events = readl(base + NvRegMSIXIrqStatus) & NVREG_IRQ_OTHER;
-		writel(NVREG_IRQ_OTHER, base + NvRegMSIXIrqStatus);
+		writel(events, base + NvRegMSIXIrqStatus);
+		netdev_dbg(dev, "%s: irq: %08x\n", dev->name, events);
 		if (!(events & np->irqmask))
 			break;
 
@@ -3622,10 +3625,10 @@ static irqreturn_t nv_nic_irq_test(int foo, void *data)
 
 	if (!(np->msi_flags & NV_MSI_X_ENABLED)) {
 		events = readl(base + NvRegIrqStatus) & NVREG_IRQSTAT_MASK;
-		writel(NVREG_IRQ_TIMER, base + NvRegIrqStatus);
+		writel(events & NVREG_IRQ_TIMER, base + NvRegIrqStatus);
 	} else {
 		events = readl(base + NvRegMSIXIrqStatus) & NVREG_IRQSTAT_MASK;
-		writel(NVREG_IRQ_TIMER, base + NvRegMSIXIrqStatus);
+		writel(events & NVREG_IRQ_TIMER, base + NvRegMSIXIrqStatus);
 	}
 	pci_push(base);
 	if (!(events & NVREG_IRQ_TIMER))
-- 
1.7.3.1

