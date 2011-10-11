Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab1JKDTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 23:19:30 -0400
Received: from smtp-out.google.com ([74.125.121.67]:44689 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467Ab1JKDT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 23:19:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=U8pquoD24BPZ6+McLuNSWqkMBS+lfjWDL3NhehULiIkoJL2BxLodhz0NQPvD1WPOB
	K8JMAIJBny5xd4ZOlw1IA==
Subject: [PATCH 11/12] sparc/pci: use pci_create_bus() instead of
	pci_scan_bus_parented()
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 10 Oct 2011 21:19:24 -0600
Message-ID: <20111011031924.5149.77974.stgit@bhelgaas.mtv.corp.google.com>
In-Reply-To: <20111011030726.5149.23793.stgit@bhelgaas.mtv.corp.google.com>
References: <20111011030726.5149.23793.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to pci_create_bus() so we can supply the correct root bus
resources up front.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/sparc/kernel/leon_pci.c |   27 +++++++++++++++------------
 1 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/arch/sparc/kernel/leon_pci.c b/arch/sparc/kernel/leon_pci.c
index a8a9a27..a9cd28c 100644
--- a/arch/sparc/kernel/leon_pci.c
+++ b/arch/sparc/kernel/leon_pci.c
@@ -20,21 +20,24 @@ void leon_pci_init(struct platform_device *ofdev, struct leon_pci_info *info)
 {
 	struct pci_bus *root_bus;
 
-	root_bus = pci_scan_bus_parented(&ofdev->dev, 0, info->ops, info);
-	if (root_bus) {
-		root_bus->resource[0] = &info->io_space;
-		root_bus->resource[1] = &info->mem_space;
-		root_bus->resource[2] = NULL;
+	root_bus = pci_create_bus(&ofdev->dev, 0, info->ops, info, NULL);
+	if (!root_bus)
+		return;
 
-		/* Init all PCI devices into PCI tree */
-		pci_bus_add_devices(root_bus);
+	root_bus->subordinate = pci_scan_child_bus(root_bus);
 
-		/* Setup IRQs of all devices using custom routines */
-		pci_fixup_irqs(pci_common_swizzle, info->map_irq);
+	root_bus->resource[0] = &info->io_space;
+	root_bus->resource[1] = &info->mem_space;
+	root_bus->resource[2] = NULL;
 
-		/* Assign devices with resources */
-		pci_assign_unassigned_resources();
-	}
+	/* Init all PCI devices into PCI tree */
+	pci_bus_add_devices(root_bus);
+
+	/* Setup IRQs of all devices using custom routines */
+	pci_fixup_irqs(pci_common_swizzle, info->map_irq);
+
+	/* Assign devices with resources */
+	pci_assign_unassigned_resources();
 }
 
 /* PCI Memory and Prefetchable Memory is direct-mapped. However I/O Space is

