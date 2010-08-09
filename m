Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296Ab0HIMHy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 08:07:54 -0400
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:38697 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756276Ab0HIMHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 08:07:51 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Jonas Aaberg <jonas.aberg@stericsson.com>
Subject: [PATCH 01/14] DMAENGINE: ste_dma40: config checks
Date: Mon, 9 Aug 2010 14:07:36 +0200
Message-ID: <1281355656-13000-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added various configuration checks.

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 arch/arm/plat-nomadik/include/plat/ste_dma40.h |    2 +-
 drivers/dma/ste_dma40.c                        |   29 ++++++++++++++++++++++-
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/arch/arm/plat-nomadik/include/plat/ste_dma40.h b/arch/arm/plat-nomadik/include/plat/ste_dma40.h
index 5fbde4b..ee5d8b2 100644
--- a/arch/arm/plat-nomadik/include/plat/ste_dma40.h
+++ b/arch/arm/plat-nomadik/include/plat/ste_dma40.h
@@ -98,7 +98,7 @@ struct stedma40_half_channel_info {
 };
 
 enum stedma40_xfer_dir {
-	STEDMA40_MEM_TO_MEM,
+	STEDMA40_MEM_TO_MEM = 1,
 	STEDMA40_MEM_TO_PERIPH,
 	STEDMA40_PERIPH_TO_MEM,
 	STEDMA40_PERIPH_TO_PERIPH
diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 17e2600..df2e1a3 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -981,14 +981,39 @@ static int d40_validate_conf(struct d40_chan *d40c,
 	bool is_log = (conf->channel_type & STEDMA40_CHANNEL_IN_OPER_MODE)
 		== STEDMA40_CHANNEL_IN_LOG_MODE;
 
-	if (d40c->dma_cfg.dir == STEDMA40_MEM_TO_PERIPH &&
+	if (!conf->dir) {
+		dev_err(&d40c->chan.dev->device, "[%s] Invalid direction.\n",
+			__func__);
+		res = -EINVAL;
+	}
+
+	if (conf->dst_dev_type != STEDMA40_DEV_DST_MEMORY &&
+	    d40c->base->plat_data->dev_tx[conf->dst_dev_type] == 0 &&
+	    d40c->runtime_addr == 0) {
+
+		dev_err(&d40c->chan.dev->device,
+			"[%s] Invalid TX channel address (%d)\n",
+			__func__, conf->dst_dev_type);
+		res = -EINVAL;
+	}
+
+	if (conf->src_dev_type != STEDMA40_DEV_SRC_MEMORY &&
+	    d40c->base->plat_data->dev_rx[conf->src_dev_type] == 0 &&
+	    d40c->runtime_addr == 0) {
+		dev_err(&d40c->chan.dev->device,
+			"[%s] Invalid RX channel address (%d)\n",
+			__func__, conf->src_dev_type);
+		res = -EINVAL;
+	}
+
+	if (conf->dir == STEDMA40_MEM_TO_PERIPH &&
 	    dst_event_group == STEDMA40_DEV_DST_MEMORY) {
 		dev_err(&d40c->chan.dev->device, "[%s] Invalid dst\n",
 			__func__);
 		res = -EINVAL;
 	}
 
-	if (d40c->dma_cfg.dir == STEDMA40_PERIPH_TO_MEM &&
+	if (conf->dir == STEDMA40_PERIPH_TO_MEM &&
 	    src_event_group == STEDMA40_DEV_SRC_MEMORY) {
 		dev_err(&d40c->chan.dev->device, "[%s] Invalid src\n",
 			__func__);
-- 
1.6.3.3

