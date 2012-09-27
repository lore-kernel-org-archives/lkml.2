Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913Ab2I0KlE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 06:41:04 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:21131 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756270Ab2I0Kg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 06:36:58 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkECAEQrZFBbdWObgWdsb2JhbABFvg8jAQEWJieCIAEBBSdAEhAgMVcGE4gJt2+RNQOVaYk8iVg
X-IronPort-AV: E=Sophos;i="4.80,496,1344204000"; 
   d="scan'208";a="956447826"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 13/17] staging: ipack: Add support for IPACK_MEM16_SPACE.
Date: Thu, 27 Sep 2012 12:37:37 +0200
Message-Id: <1348742261-28145-13-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1348742261-28145-1-git-send-email-siglesias@igalia.com>
References: <1348742261-28145-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |   19 +++++++++++++++++++
 drivers/staging/ipack/ipack.h           |    1 +
 2 files changed, 20 insertions(+)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index 7127a3b..376e794 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -33,6 +33,7 @@ static const size_t tpci200_space_size[IPACK_SPACE_COUNT] = {
 	[IPACK_ID_SPACE]    = TPCI200_ID_SPACE_SIZE,
 	[IPACK_INT_SPACE]   = TPCI200_INT_SPACE_SIZE,
 	[IPACK_MEM8_SPACE]  = TPCI200_MEM8_SPACE_SIZE,
+	[IPACK_MEM16_SPACE] = TPCI200_MEM16_SPACE_SIZE,
 };
 
 static const size_t tpci200_space_interval[IPACK_SPACE_COUNT] = {
@@ -40,6 +41,7 @@ static const size_t tpci200_space_interval[IPACK_SPACE_COUNT] = {
 	[IPACK_ID_SPACE]    = TPCI200_ID_SPACE_INTERVAL,
 	[IPACK_INT_SPACE]   = TPCI200_INT_SPACE_INTERVAL,
 	[IPACK_MEM8_SPACE]  = TPCI200_MEM8_SPACE_INTERVAL,
+	[IPACK_MEM16_SPACE] = TPCI200_MEM16_SPACE_INTERVAL,
 };
 
 static struct tpci200_board *check_slot(struct ipack_device *dev)
@@ -94,6 +96,7 @@ static void tpci200_unregister(struct tpci200_board *tpci200)
 
 	pci_release_region(tpci200->info->pdev, TPCI200_IP_INTERFACE_BAR);
 	pci_release_region(tpci200->info->pdev, TPCI200_IO_ID_INT_SPACES_BAR);
+	pci_release_region(tpci200->info->pdev, TPCI200_MEM16_SPACE_BAR);
 	pci_release_region(tpci200->info->pdev, TPCI200_MEM8_SPACE_BAR);
 	pci_release_region(tpci200->info->pdev, TPCI200_CFG_MEM_BAR);
 
@@ -282,6 +285,17 @@ static int tpci200_register(struct tpci200_board *tpci200)
 		goto out_release_ioid_int_space;
 	}
 
+	/* Request MEM16 space (Bar 4) */
+	res = pci_request_region(tpci200->info->pdev, TPCI200_MEM16_SPACE_BAR,
+				 "Carrier MEM16 space");
+	if (res) {
+		dev_err(&tpci200->info->pdev->dev,
+			"(bn 0x%X, sn 0x%X) failed to allocate PCI resource for BAR 4!",
+			tpci200->info->pdev->bus->number,
+			tpci200->info->pdev->devfn);
+		goto out_release_mem8_space;
+	}
+
 	/* Map internal tpci200 driver user space */
 	tpci200->info->interface_regs =
 		ioremap_nocache(pci_resource_start(tpci200->info->pdev,
@@ -300,6 +314,9 @@ static int tpci200_register(struct tpci200_board *tpci200)
 	tpci200->mod_mem[IPACK_MEM8_SPACE] =
 		pci_resource_start(tpci200->info->pdev,
 				   TPCI200_MEM8_SPACE_BAR);
+	tpci200->mod_mem[IPACK_MEM16_SPACE] =
+		pci_resource_start(tpci200->info->pdev,
+				   TPCI200_MEM16_SPACE_BAR);
 
 	/* Set the default parameters of the slot
 	 * INT0 disabled, level sensitive
@@ -326,6 +343,8 @@ static int tpci200_register(struct tpci200_board *tpci200)
 
 	return 0;
 
+out_release_mem8_space:
+	pci_release_region(tpci200->info->pdev, TPCI200_MEM8_SPACE_BAR);
 out_release_ioid_int_space:
 	pci_release_region(tpci200->info->pdev, TPCI200_IO_ID_INT_SPACES_BAR);
 out_release_ip_space:
diff --git a/drivers/staging/ipack/ipack.h b/drivers/staging/ipack/ipack.h
index e35fe54..689af92 100644
--- a/drivers/staging/ipack/ipack.h
+++ b/drivers/staging/ipack/ipack.h
@@ -36,6 +36,7 @@ enum ipack_space {
 	IPACK_ID_SPACE,
 	IPACK_INT_SPACE,
 	IPACK_MEM8_SPACE,
+	IPACK_MEM16_SPACE,
 	/* Dummy for counting the number of entries.  Must remain the last
 	 * entry */
 	IPACK_SPACE_COUNT,
-- 
1.7.10.4

