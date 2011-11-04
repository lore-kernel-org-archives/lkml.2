Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab1KDBnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 21:43:37 -0400
Received: from smtp-out.google.com ([74.125.121.67]:52629 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab1KDBmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 21:42:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:
	references:in-reply-to:references:organization:x-system-of-record;
	b=gAaLYZYaqW3Z1snMJLA5aWifvV5eySTXWt/WoH5PfUOjOLOWudrTlfom87r6JLTQn
	rvs2yXT8jq++Rxk4ahLow==
From: David Decotigny <david.decotigny@google.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Ian Campbell <ian.campbell@citrix.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jiri Pirko <jpirko@redhat.com>, Joe Perches <joe@perches.com>,
        Szymon Janc <szymon@janc.net.pl>, Mike Ditto <mditto@google.com>,
        David Decotigny <david.decotigny@google.com>
Subject: [PATCH net v2 4/8] forcedeth: Acknowledge only interrupts that are being processed
Date: Thu,  3 Nov 2011 18:41:19 -0700
Message-Id: <0b7c2cb46e4d24a996233869a9c63452bc7e2ca4.1320369398.git.david.decotigny@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <cover.1320369398.git.david.decotigny@google.com>
References: <cover.1320369398.git.david.decotigny@google.com>
In-Reply-To: <cover.1320369398.git.david.decotigny@google.com>
References: <cover.1320369398.git.david.decotigny@google.com>
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
index 375b03b..4a45a46 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -3419,7 +3419,8 @@ static irqreturn_t nv_nic_irq_tx(int foo, void *data)
 
 	for (i = 0;; i++) {
 		events = readl(base + NvRegMSIXIrqStatus) & NVREG_IRQ_TX_ALL;
-		writel(NVREG_IRQ_TX_ALL, base + NvRegMSIXIrqStatus);
+		writel(events, base + NvRegMSIXIrqStatus);
+		netdev_dbg(dev, "tx irq events: %08x\n", events);
 		if (!(events & np->irqmask))
 			break;
 
@@ -3530,7 +3531,8 @@ static irqreturn_t nv_nic_irq_rx(int foo, void *data)
 
 	for (i = 0;; i++) {
 		events = readl(base + NvRegMSIXIrqStatus) & NVREG_IRQ_RX_ALL;
-		writel(NVREG_IRQ_RX_ALL, base + NvRegMSIXIrqStatus);
+		writel(events, base + NvRegMSIXIrqStatus);
+		netdev_dbg(dev, "rx irq events: %08x\n", events);
 		if (!(events & np->irqmask))
 			break;
 
@@ -3574,7 +3576,8 @@ static irqreturn_t nv_nic_irq_other(int foo, void *data)
 
 	for (i = 0;; i++) {
 		events = readl(base + NvRegMSIXIrqStatus) & NVREG_IRQ_OTHER;
-		writel(NVREG_IRQ_OTHER, base + NvRegMSIXIrqStatus);
+		writel(events, base + NvRegMSIXIrqStatus);
+		netdev_dbg(dev, "irq events: %08x\n", events);
 		if (!(events & np->irqmask))
 			break;
 
@@ -3638,10 +3641,10 @@ static irqreturn_t nv_nic_irq_test(int foo, void *data)
 
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

