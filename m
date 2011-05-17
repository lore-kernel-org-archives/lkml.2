Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933413Ab1ERSHY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 14:07:24 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:26559 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624Ab1ERSHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 14:07:15 -0400
Message-Id: <201105181807.p4II7BKA015222@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 17 May 2011 15:25:21 -0400
Subject: [PATCH] arch/tile: allocate PCI IRQs later in boot
To: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 18 May 2011 18:07:11.0727 (UTC) FILETIME=[68F01FF0:01CC1586]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change became required due to some recent reworking in the
platform-independent IRQ code.  It is required for 2.6.38 and later.

Cc: stable@kernel.org
Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/pci.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/tile/kernel/pci.c b/arch/tile/kernel/pci.c
index 65add02..6d4cb5d 100644
--- a/arch/tile/kernel/pci.c
+++ b/arch/tile/kernel/pci.c
@@ -188,12 +188,6 @@ int __devinit tile_pci_init(void)
 
 			controller = &controllers[i];
 
-			if (tile_init_irqs(i, controller)) {
-				pr_err("PCI: Could not initialize "
-				       "IRQs, aborting.\n");
-				goto err_cont;
-			}
-
 			controller->index = i;
 			controller->hv_cfg_fd[0] = hv_cfg_fd0;
 			controller->hv_cfg_fd[1] = hv_cfg_fd1;
@@ -316,6 +310,11 @@ int __devinit pcibios_init(void)
 			struct pci_controller *controller = &controllers[i];
 			struct pci_bus *bus;
 
+			if (tile_init_irqs(i, controller)) {
+				pr_err("PCI: Could not initialize IRQs\n");
+				continue;
+			}
+
 			pr_info("PCI: initializing controller #%d\n", i);
 
 			/*
-- 
1.6.5.2

