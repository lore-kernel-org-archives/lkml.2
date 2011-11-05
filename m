Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab1KEByi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 21:54:38 -0400
Received: from smtp-out.google.com ([74.125.121.67]:44276 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab1KEBx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 21:53:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:
	references:in-reply-to:references:organization:x-system-of-record;
	b=hsaxaoS/DT/RD+Ut4Z6V2EtI6DfkW3u8oYSHK19KrU6/A6FvIvNBkD1VRhzUZSt9+
	btfG+lNudqZSGXVjR9L+w==
From: David Decotigny <david.decotigny@google.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Ian Campbell <ian.campbell@citrix.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jiri Pirko <jpirko@redhat.com>, Joe Perches <joe@perches.com>,
        Szymon Janc <szymon@janc.net.pl>, Mike Ditto <mditto@google.com>,
        David Decotigny <david.decotigny@google.com>
Subject: [PATCH net v3 2/9] forcedeth: Acknowledge only interrupts that are being processed
Date: Fri,  4 Nov 2011 18:53:26 -0700
Message-Id: <63e4171ea60b7c5422794fba99a9cc155f546d1c.1320457247.git.david.decotigny@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <cover.1320457247.git.david.decotigny@google.com>
References: <cover.1320457247.git.david.decotigny@google.com>
In-Reply-To: <cover.1320457247.git.david.decotigny@google.com>
References: <cover.1320457247.git.david.decotigny@google.com>
Organization: Google, Inc.
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Ditto <mditto@google.com>

This is to avoid a race, accidentally acknowledging an interrupt that
we didn't notice and won't immediately process.  This is based solely
on code inspection; it is not known if there was an actual bug here.



Signed-off-by: David Decotigny <david.decotigny@google.com>
---
 drivers/net/ethernet/nvidia/forcedeth.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 2f884fc..9aefee1 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -3398,7 +3398,8 @@ static irqreturn_t nv_nic_irq_tx(int foo, void *data)
 
 	for (i = 0;; i++) {
 		events = readl(base + NvRegMSIXIrqStatus) & NVREG_IRQ_TX_ALL;
-		writel(NVREG_IRQ_TX_ALL, base + NvRegMSIXIrqStatus);
+		writel(events, base + NvRegMSIXIrqStatus);
+		netdev_dbg(dev, "tx irq events: %08x\n", events);
 		if (!(events & np->irqmask))
 			break;
 
@@ -3509,7 +3510,8 @@ static irqreturn_t nv_nic_irq_rx(int foo, void *data)
 
 	for (i = 0;; i++) {
 		events = readl(base + NvRegMSIXIrqStatus) & NVREG_IRQ_RX_ALL;
-		writel(NVREG_IRQ_RX_ALL, base + NvRegMSIXIrqStatus);
+		writel(events, base + NvRegMSIXIrqStatus);
+		netdev_dbg(dev, "rx irq events: %08x\n", events);
 		if (!(events & np->irqmask))
 			break;
 
@@ -3553,7 +3555,8 @@ static irqreturn_t nv_nic_irq_other(int foo, void *data)
 
 	for (i = 0;; i++) {
 		events = readl(base + NvRegMSIXIrqStatus) & NVREG_IRQ_OTHER;
-		writel(NVREG_IRQ_OTHER, base + NvRegMSIXIrqStatus);
+		writel(events, base + NvRegMSIXIrqStatus);
+		netdev_dbg(dev, "irq events: %08x\n", events);
 		if (!(events & np->irqmask))
 			break;
 
@@ -3617,10 +3620,10 @@ static irqreturn_t nv_nic_irq_test(int foo, void *data)
 
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

