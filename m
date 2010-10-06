Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799Ab0JFJFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 05:05:40 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:58154 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754360Ab0JFJFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 05:05:39 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Per Forlin <per.friden@stericsson.com>,
        Per Forlin <per.forlin@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 1/3] DMAENGINE: Set burst size for phy and log chans in ste_dma40 dev_control
Date: Wed, 6 Oct 2010 11:05:27 +0200
Message-ID: <1286355929-31226-2-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1286355929-31226-1-git-send-email-linus.walleij@stericsson.com>
References: <1286355929-31226-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Per Forlin <per.friden@stericsson.com>

Set burst for physical or logical channels respectively.
Convert the values in dma_cfg to dma reg bits
for physical or logical channels.

Signed-off-by: Per Forlin <per.forlin@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c |   34 ++++++++++++++++++++++++++--------
 1 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index c07d989..ad8d6df 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2246,14 +2246,25 @@ static void d40_set_runtime_config(struct dma_chan *chan,
 		return;
 	}
 
-	if (config_maxburst >= 16)
-		psize = STEDMA40_PSIZE_LOG_16;
-	else if (config_maxburst >= 8)
-		psize = STEDMA40_PSIZE_LOG_8;
-	else if (config_maxburst >= 4)
-		psize = STEDMA40_PSIZE_LOG_4;
-	else
-		psize = STEDMA40_PSIZE_LOG_1;
+	if (d40c->log_num != D40_PHY_CHAN) {
+		if (config_maxburst >= 16)
+			psize = STEDMA40_PSIZE_LOG_16;
+		else if (config_maxburst >= 8)
+			psize = STEDMA40_PSIZE_LOG_8;
+		else if (config_maxburst >= 4)
+			psize = STEDMA40_PSIZE_LOG_4;
+		else
+			psize = STEDMA40_PSIZE_LOG_1;
+	} else {
+		if (config_maxburst >= 16)
+			psize = STEDMA40_PSIZE_PHY_16;
+		else if (config_maxburst >= 8)
+			psize = STEDMA40_PSIZE_PHY_8;
+		else if (config_maxburst >= 4)
+			psize = STEDMA40_PSIZE_PHY_4;
+		else
+			psize = STEDMA40_PSIZE_PHY_1;
+	}
 
 	/* Set up all the endpoint configs */
 	cfg->src_info.data_width = addr_width;
@@ -2265,6 +2276,13 @@ static void d40_set_runtime_config(struct dma_chan *chan,
 	cfg->dst_info.endianess = STEDMA40_LITTLE_ENDIAN;
 	cfg->dst_info.flow_ctrl = STEDMA40_NO_FLOW_CTRL;
 
+	/* Fill in register values */
+	if (d40c->log_num != D40_PHY_CHAN)
+		d40_log_cfg(cfg, &d40c->log_def.lcsp1, &d40c->log_def.lcsp3);
+	else
+		d40_phy_cfg(cfg, &d40c->src_def_cfg,
+			    &d40c->dst_def_cfg, false);
+
 	/* These settings will take precedence later */
 	d40c->runtime_addr = config_addr;
 	d40c->runtime_direction = config->direction;
-- 
1.6.3.3

