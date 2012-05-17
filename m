Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762078Ab2EQPAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 11:00:21 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:59555 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761329Ab2EQPAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 11:00:14 -0400
X-AuditID: cbfee61b-b7bb6ae0000006fb-0e-4fb5127b2c49
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-mmc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        cjb@laptop.org, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        patches@linaro.org
Subject: [PATCH v2 4/6] mmc: dw_mmc: add quirk to indicate missing write
 protect line
Date: Thu, 17 May 2012 20:40:09 +0530
Message-id: <1337267411-28226-5-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.6.6.rc2
In-reply-to: <1337267411-28226-1-git-send-email-thomas.abraham@linaro.org>
References: <1337267411-28226-1-git-send-email-thomas.abraham@linaro.org>
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
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
Acked-by: Will Newton <will.newton@imgtec.com>
---
 drivers/mmc/host/dw_mmc.c  |    4 +++-
 include/linux/mmc/dw_mmc.h |    3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index eb5fa59..c862b7f 100644
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
index 787ad56..b72e4aa 100644
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
1.6.6.rc2

