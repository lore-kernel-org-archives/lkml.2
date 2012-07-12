Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892Ab2GLMkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 08:40:55 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:34058 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab2GLMku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 08:40:50 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-21-4ffec5d18a15
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-mmc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        cjb@laptop.org, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        patches@linaro.org
Subject: [PATCH v3 4/6] mmc: dw_mmc: add quirk to indicate missing write
 protect line
Date: Thu, 12 Jul 2012 18:24:26 +0530
Message-id: <1342097668-25243-5-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.6.6.rc2
In-reply-to: <1342097668-25243-1-git-send-email-thomas.abraham@linaro.org>
References: <1342097668-25243-1-git-send-email-thomas.abraham@linaro.org>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFJMWRmVeSWpSXmKPExsVy+t9jAd2LR//5G6zv0rK4vGsOm8WR//2M
	FjPO72NyYPb4vEkugDGKyyYlNSezLLVI3y6BK6P73E/Wgk6+ih2L6hoYr3F3MXJySAiYSHx6
	v5MdwhaTuHBvPVsXIxeHkMAiRol3rz8yQzhtTBJflzeAVbEJGEg8WvgOzBYRcJJYMncCWBGz
	wB1GiUezTjKCJIQFwiVerDrNBGKzCKhKNP/YDTSWg4NXwFPiygE1iG1KEht6j4KVcAp4SVxf
	2cIKUiIEVPLqj8MERt4FjAyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYJD4JnUDsaVDRaH
	GAU4GJV4eD8c+OcvxJpYVlyZe4hRgoNZSYS3PxcoxJuSWFmVWpQfX1Sak1p8iFGag0VJnNfY
	+6u/kEB6YklqdmpqQWoRTJaJg1OqgbFELHluvPKSgOqpkf/mpnStY1tm5CJwy1tIcFmXpt6j
	8n0KX3auvl5u46Hq2V0lba3C5TkhJW+RXHqPi5OJsspqp0NsDM92b3pnuvD7f2+Jwnc3350L
	OhOXIP05fVbD2aPOKxmMVX9aHky+eDYzzMpi65x7m5aoPK15mGf4buLBkFc2Dw++OKvEUpyR
	aKjFXFScCAABwnyi/QEAAA==
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
index 679473c..075f89d 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -827,7 +827,9 @@ static int dw_mci_get_ro(struct mmc_host *mmc)
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

