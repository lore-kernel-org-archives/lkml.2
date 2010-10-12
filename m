Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516Ab0JLNBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 09:01:21 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:59921 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932473Ab0JLNBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 09:01:16 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 3/7] ste_dma40: move channel mode to a separate field
Date: Tue, 12 Oct 2010 15:00:51 +0200
Message-ID: <1286888455-11385-4-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1286888455-11385-3-git-send-email-linus.walleij@stericsson.com>
References: <1286888455-11385-1-git-send-email-linus.walleij@stericsson.com>
 <1286888455-11385-2-git-send-email-linus.walleij@stericsson.com>
 <1286888455-11385-3-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

And keep it logical by default.

Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 arch/arm/mach-ux500/devices-db8500.c           |    7 +++----
 arch/arm/plat-nomadik/include/plat/ste_dma40.h |   12 +++++++-----
 drivers/dma/ste_dma40.c                        |    8 ++------
 3 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/arch/arm/mach-ux500/devices-db8500.c b/arch/arm/mach-ux500/devices-db8500.c
index f672fe1..6440f9a 100644
--- a/arch/arm/mach-ux500/devices-db8500.c
+++ b/arch/arm/mach-ux500/devices-db8500.c
@@ -208,8 +208,8 @@ static struct resource dma40_resources[] = {
 
 /* Default configuration for physcial memcpy */
 struct stedma40_chan_cfg dma40_memcpy_conf_phy = {
-	.channel_type = (STEDMA40_CHANNEL_IN_PHY_MODE |
-			 STEDMA40_PCHAN_BASIC_MODE),
+	.channel_type = STEDMA40_PCHAN_BASIC_MODE,
+	.mode = STEDMA40_MODE_PHYSICAL,
 	.dir = STEDMA40_MEM_TO_MEM,
 
 	.src_info.endianess = STEDMA40_LITTLE_ENDIAN,
@@ -224,8 +224,7 @@ struct stedma40_chan_cfg dma40_memcpy_conf_phy = {
 };
 /* Default configuration for logical memcpy */
 struct stedma40_chan_cfg dma40_memcpy_conf_log = {
-	.channel_type = (STEDMA40_CHANNEL_IN_LOG_MODE |
-			 STEDMA40_LCHAN_SRC_LOG_DST_LOG |
+	.channel_type = (STEDMA40_LCHAN_SRC_LOG_DST_LOG |
 			 STEDMA40_NO_TIM_FOR_LINK),
 	.dir = STEDMA40_MEM_TO_MEM,
 
diff --git a/arch/arm/plat-nomadik/include/plat/ste_dma40.h b/arch/arm/plat-nomadik/include/plat/ste_dma40.h
index 9adcd9b..e49a2a1 100644
--- a/arch/arm/plat-nomadik/include/plat/ste_dma40.h
+++ b/arch/arm/plat-nomadik/include/plat/ste_dma40.h
@@ -23,11 +23,11 @@
  * the info structure.
  */
 
-/* Mode  */
-#define STEDMA40_INFO_CH_MODE_TYPE_POS 6
-#define STEDMA40_CHANNEL_IN_PHY_MODE (0x1 << STEDMA40_INFO_CH_MODE_TYPE_POS)
-#define STEDMA40_CHANNEL_IN_LOG_MODE (0x2 << STEDMA40_INFO_CH_MODE_TYPE_POS)
-#define STEDMA40_CHANNEL_IN_OPER_MODE (0x3 << STEDMA40_INFO_CH_MODE_TYPE_POS)
+enum stedma40_mode {
+	STEDMA40_MODE_LOGICAL = 0,
+	STEDMA40_MODE_PHYSICAL,
+	STEDMA40_MODE_OPERATION,
+};
 
 /* Mode options */
 #define STEDMA40_INFO_CH_MODE_OPT_POS 8
@@ -115,6 +115,7 @@ struct stedma40_half_channel_info {
  * @dir: MEM 2 MEM, PERIPH 2 MEM , MEM 2 PERIPH, PERIPH 2 PERIPH
  * @channel_type: priority, mode, mode options and interrupt configuration.
  * @high_priority: true if high-priority
+ * @mode: channel mode: physical, logical, or operation
  * @src_dev_type: Src device type
  * @dst_dev_type: Dst device type
  * @src_info: Parameters for dst half channel
@@ -129,6 +130,7 @@ struct stedma40_chan_cfg {
 	enum stedma40_xfer_dir			 dir;
 	unsigned int				 channel_type;
 	bool					 high_priority;
+	enum stedma40_mode			 mode;
 	int					 src_dev_type;
 	int					 dst_dev_type;
 	struct stedma40_half_channel_info	 src_info;
diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 535bff8..ca682df 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1151,8 +1151,7 @@ static int d40_validate_conf(struct d40_chan *d40c,
 	int res = 0;
 	u32 dst_event_group = D40_TYPE_TO_GROUP(conf->dst_dev_type);
 	u32 src_event_group = D40_TYPE_TO_GROUP(conf->src_dev_type);
-	bool is_log = (conf->channel_type & STEDMA40_CHANNEL_IN_OPER_MODE)
-		== STEDMA40_CHANNEL_IN_LOG_MODE;
+	bool is_log = conf->mode == STEDMA40_MODE_LOGICAL;
 
 	if (!conf->dir) {
 		dev_err(&d40c->chan.dev->device, "[%s] Invalid direction.\n",
@@ -1316,10 +1315,7 @@ static int d40_allocate_channel(struct d40_chan *d40c)
 	int j;
 	int log_num;
 	bool is_src;
-	bool is_log = (d40c->dma_cfg.channel_type &
-		       STEDMA40_CHANNEL_IN_OPER_MODE)
-		== STEDMA40_CHANNEL_IN_LOG_MODE;
-
+	bool is_log = d40c->dma_cfg.mode == STEDMA40_MODE_LOGICAL;
 
 	phys = d40c->base->phy_res;
 
-- 
1.6.3.3

