Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382Ab2EBFOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 01:14:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45424 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467Ab2EBFMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 01:12:17 -0400
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-mmc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        cjb@laptop.org, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        patches@linaro.org
Subject: [PATCH 2/7] mmc: dw_mmc: add quirk to indicate missing write protect line
Date: Tue,  1 May 2012 22:07:41 -0700
Message-Id: <1335935266-25289-3-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335935266-25289-1-git-send-email-thomas.abraham@linaro.org>
References: <1335935266-25289-1-git-send-email-thomas.abraham@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the write protect pad of the controller is not connected to the write
protect pin of the slot, the driver should be notified of this condition
so that incorrect check for write protection by reading the WRTORT
register can avoided. The get_ro platform callback can be used for in
such cases, but with device tree support enabled, such platform callbacks
cannot be supported.

Add a new quirk for notifying the driver about the missing write protect
line so the driver can assume that the card write protection is disabled.

Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
---
 drivers/mmc/host/dw_mmc.c  |    4 +++-
 include/linux/mmc/dw_mmc.h |    3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 036846f..38cb7f8 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -812,7 +812,9 @@ static int dw_mci_get_ro(struct mmc_host *mmc)
 	struct dw_mci_board *brd = slot->host->pdata;
 
 	/* Use platform get_ro function, else try on board write protect */
-	if (brd->get_ro)
+	if (brd->quirks & DW_MCI_QUIRK_NO_WRITE_PROTECT)
+		read_only = 0;
+	else if (brd->get_ro)
 		read_only = brd->get_ro(slot->id);
 	else
 		read_only =
diff --git a/include/linux/mmc/dw_mmc.h b/include/linux/mmc/dw_mmc.h
index fa9a139..fb51a5f 100644
--- a/include/linux/mmc/dw_mmc.h
+++ b/include/linux/mmc/dw_mmc.h
@@ -205,7 +205,8 @@ struct dw_mci_dma_ops {
 #define DW_MCI_QUIRK_HIGHSPEED			BIT(2)
 /* Unreliable card detection */
 #define DW_MCI_QUIRK_BROKEN_CARD_DETECTION	BIT(3)
-
+/* Write Protect detection not available */
+#define DW_MCI_QUIRK_NO_WRITE_PROTECT		BIT(4)
 
 struct dma_pdata;
 
-- 
1.7.5.4

