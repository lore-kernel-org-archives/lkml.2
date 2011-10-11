Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547Ab1JKDTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 23:19:34 -0400
Received: from smtp-out.google.com ([216.239.44.51]:23325 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319Ab1JKDTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 23:19:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=Axui93x6uRH0Lx2NIqEPeAIaFhJsKQWJXLNNlHRspOYes2gjgh+IgM+pBxE/urjih
	8j5+5KtTJnQ2vVYLk/xMA==
Subject: [PATCH 12/12] sparc/pci: supply root bus resources to pci_create_bus()
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 10 Oct 2011 21:19:29 -0600
Message-ID: <20111011031929.5149.58149.stgit@bhelgaas.mtv.corp.google.com>
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

Pass root bus resources to pci_create_bus() so the bus resources are
correct from the beginning.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/sparc/kernel/leon_pci.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/sparc/kernel/leon_pci.c b/arch/sparc/kernel/leon_pci.c
index a9cd28c..e2d3870 100644
--- a/arch/sparc/kernel/leon_pci.c
+++ b/arch/sparc/kernel/leon_pci.c
@@ -18,18 +18,19 @@
  */
 void leon_pci_init(struct platform_device *ofdev, struct leon_pci_info *info)
 {
+	struct list_head resources;
 	struct pci_bus *root_bus;
 
+	INIT_LIST_HEAD(&resources);
+	pci_add_resource(&resources, &info->io_space);
+	pci_add_resource(&resources, &info->mem_space);
+
 	root_bus = pci_create_bus(&ofdev->dev, 0, info->ops, info, NULL);
 	if (!root_bus)
 		return;
 
 	root_bus->subordinate = pci_scan_child_bus(root_bus);
 
-	root_bus->resource[0] = &info->io_space;
-	root_bus->resource[1] = &info->mem_space;
-	root_bus->resource[2] = NULL;
-
 	/* Init all PCI devices into PCI tree */
 	pci_bus_add_devices(root_bus);
 

