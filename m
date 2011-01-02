Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab1ABHhx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:37:53 -0500
Received: from mail.windriver.com ([147.11.1.11]:36875 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673Ab1ABHZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:25:05 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Stanislaw Gruszka <sgruszka@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 203/260] skge: add quirk to limit DMA
Date: Sun,  2 Jan 2011 02:18:19 -0500
Message-Id: <1293952756-15010-204-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:23:52.0745 (UTC) FILETIME=[01F8E190:01CBAA4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 392bd0cb000d4aac9e88e4f50823db85e7220688 upstream.

Skge devices installed on some Gigabyte motherboards are not able to
perform 64 dma correctly due to board PCI implementation, so limit
DMA to 32bit if such boards are detected.

Bug was reported here:
https://bugzilla.redhat.com/show_bug.cgi?id=447489

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Tested-by: Luya Tshimbalanga <luya@fedoraproject.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/skge.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/drivers/net/skge.c b/drivers/net/skge.c
index 50eb706..e13cbd9 100644
--- a/drivers/net/skge.c
+++ b/drivers/net/skge.c
@@ -43,6 +43,7 @@
 #include <linux/seq_file.h>
 #include <linux/mii.h>
 #include <linux/slab.h>
+#include <linux/dmi.h>
 #include <asm/irq.h>
 
 #include "skge.h"
@@ -3868,6 +3869,8 @@ static void __devinit skge_show_addr(struct net_device *dev)
 	netif_info(skge, probe, skge->netdev, "addr %pM\n", dev->dev_addr);
 }
 
+static int only_32bit_dma;
+
 static int __devinit skge_probe(struct pci_dev *pdev,
 				const struct pci_device_id *ent)
 {
@@ -3889,7 +3892,7 @@ static int __devinit skge_probe(struct pci_dev *pdev,
 
 	pci_set_master(pdev);
 
-	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
+	if (!only_32bit_dma && !pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
 		using_dac = 1;
 		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
 	} else if (!(err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32)))) {
@@ -4147,8 +4150,21 @@ static struct pci_driver skge_driver = {
 	.shutdown =	skge_shutdown,
 };
 
+static struct dmi_system_id skge_32bit_dma_boards[] = {
+	{
+		.ident = "Gigabyte nForce boards",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Gigabyte Technology Co"),
+			DMI_MATCH(DMI_BOARD_NAME, "nForce"),
+		},
+	},
+	{}
+};
+
 static int __init skge_init_module(void)
 {
+	if (dmi_check_system(skge_32bit_dma_boards))
+		only_32bit_dma = 1;
 	skge_debug_init();
 	return pci_register_driver(&skge_driver);
 }
-- 
1.7.3.3

