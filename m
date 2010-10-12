Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488Ab0JLNBT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 09:01:19 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:36220 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932374Ab0JLNBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 09:01:17 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 4/7] ste_dma40: move mode_opt to separate config
Date: Tue, 12 Oct 2010 15:00:52 +0200
Message-ID: <1286888455-11385-5-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1286888455-11385-4-git-send-email-linus.walleij@stericsson.com>
References: <1286888455-11385-1-git-send-email-linus.walleij@stericsson.com>
 <1286888455-11385-2-git-send-email-linus.walleij@stericsson.com>
 <1286888455-11385-3-git-send-email-linus.walleij@stericsson.com>
 <1286888455-11385-4-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

Defaults are "basic mode" for physical channels, and "logical source
logical destination" for logical channels.

Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 arch/arm/mach-ux500/devices-db8500.c           |    4 +--
 arch/arm/plat-nomadik/include/plat/ste_dma40.h |   18 ++++++++------
 drivers/dma/ste_dma40.c                        |   28 ++++++++++++++++++++++-
 drivers/dma/ste_dma40_ll.h                     |    7 ++++++
 4 files changed, 44 insertions(+), 13 deletions(-)

diff --git a/arch/arm/mach-ux500/devices-db8500.c b/arch/arm/mach-ux500/devices-db8500.c
index 6440f9a..8a707b9 100644
--- a/arch/arm/mach-ux500/devices-db8500.c
+++ b/arch/arm/mach-ux500/devices-db8500.c
@@ -208,7 +208,6 @@ static struct resource dma40_resources[] = {
 
 /* Default configuration for physcial memcpy */
 struct stedma40_chan_cfg dma40_memcpy_conf_phy = {
-	.channel_type = STEDMA40_PCHAN_BASIC_MODE,
 	.mode = STEDMA40_MODE_PHYSICAL,
 	.dir = STEDMA40_MEM_TO_MEM,
 
@@ -224,8 +223,7 @@ struct stedma40_chan_cfg dma40_memcpy_conf_phy = {
 };
 /* Default configuration for logical memcpy */
 struct stedma40_chan_cfg dma40_memcpy_conf_log = {
-	.channel_type = (STEDMA40_LCHAN_SRC_LOG_DST_LOG |
-			 STEDMA40_NO_TIM_FOR_LINK),
+	.channel_type = STEDMA40_NO_TIM_FOR_LINK,
 	.dir = STEDMA40_MEM_TO_MEM,
 
 	.src_info.endianess = STEDMA40_LITTLE_ENDIAN,
diff --git a/arch/arm/plat-nomadik/include/plat/ste_dma40.h b/arch/arm/plat-nomadik/include/plat/ste_dma40.h
index e49a2a1..eb72423 100644
--- a/arch/arm/plat-nomadik/include/plat/ste_dma40.h
+++ b/arch/arm/plat-nomadik/include/plat/ste_dma40.h
@@ -29,14 +29,14 @@ enum stedma40_mode {
 	STEDMA40_MODE_OPERATION,
 };
 
-/* Mode options */
-#define STEDMA40_INFO_CH_MODE_OPT_POS 8
-#define STEDMA40_PCHAN_BASIC_MODE (0x1 << STEDMA40_INFO_CH_MODE_OPT_POS)
-#define STEDMA40_PCHAN_MODULO_MODE (0x2 << STEDMA40_INFO_CH_MODE_OPT_POS)
-#define STEDMA40_PCHAN_DOUBLE_DST_MODE (0x3 << STEDMA40_INFO_CH_MODE_OPT_POS)
-#define STEDMA40_LCHAN_SRC_PHY_DST_LOG (0x1 << STEDMA40_INFO_CH_MODE_OPT_POS)
-#define STEDMA40_LCHAN_SRC_LOG_DST_PHS (0x2 << STEDMA40_INFO_CH_MODE_OPT_POS)
-#define STEDMA40_LCHAN_SRC_LOG_DST_LOG (0x3 << STEDMA40_INFO_CH_MODE_OPT_POS)
+enum stedma40_mode_opt {
+	STEDMA40_PCHAN_BASIC_MODE = 0,
+	STEDMA40_LCHAN_SRC_LOG_DST_LOG = 0,
+	STEDMA40_PCHAN_MODULO_MODE,
+	STEDMA40_PCHAN_DOUBLE_DST_MODE,
+	STEDMA40_LCHAN_SRC_PHY_DST_LOG,
+	STEDMA40_LCHAN_SRC_LOG_DST_PHY,
+};
 
 /* Interrupt */
 #define STEDMA40_INFO_TIM_POS 10
@@ -116,6 +116,7 @@ struct stedma40_half_channel_info {
  * @channel_type: priority, mode, mode options and interrupt configuration.
  * @high_priority: true if high-priority
  * @mode: channel mode: physical, logical, or operation
+ * @mode_opt: options for the chosen channel mode
  * @src_dev_type: Src device type
  * @dst_dev_type: Dst device type
  * @src_info: Parameters for dst half channel
@@ -131,6 +132,7 @@ struct stedma40_chan_cfg {
 	unsigned int				 channel_type;
 	bool					 high_priority;
 	enum stedma40_mode			 mode;
+	enum stedma40_mode_opt			 mode_opt;
 	int					 src_dev_type;
 	int					 dst_dev_type;
 	struct stedma40_half_channel_info	 src_info;
diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index ca682df..e6e1504 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -693,6 +693,31 @@ static u32 d40_chan_has_events(struct d40_chan *d40c)
 	return val;
 }
 
+static u32 d40_get_prmo(struct d40_chan *d40c)
+{
+	static const unsigned int phy_map[] = {
+		[STEDMA40_PCHAN_BASIC_MODE]
+			= D40_DREG_PRMO_PCHAN_BASIC,
+		[STEDMA40_PCHAN_MODULO_MODE]
+			= D40_DREG_PRMO_PCHAN_MODULO,
+		[STEDMA40_PCHAN_DOUBLE_DST_MODE]
+			= D40_DREG_PRMO_PCHAN_DOUBLE_DST,
+	};
+	static const unsigned int log_map[] = {
+		[STEDMA40_LCHAN_SRC_PHY_DST_LOG]
+			= D40_DREG_PRMO_LCHAN_SRC_PHY_DST_LOG,
+		[STEDMA40_LCHAN_SRC_LOG_DST_PHY]
+			= D40_DREG_PRMO_LCHAN_SRC_LOG_DST_PHY,
+		[STEDMA40_LCHAN_SRC_LOG_DST_LOG]
+			= D40_DREG_PRMO_LCHAN_SRC_LOG_DST_LOG,
+	};
+
+	if (d40c->log_num == D40_PHY_CHAN)
+		return phy_map[d40c->dma_cfg.mode_opt];
+	else
+		return log_map[d40c->dma_cfg.mode_opt];
+}
+
 static void d40_config_write(struct d40_chan *d40c)
 {
 	u32 addr_base;
@@ -706,8 +731,7 @@ static void d40_config_write(struct d40_chan *d40c)
 	writel(var, d40c->base->virtbase + D40_DREG_PRMSE + addr_base);
 
 	/* Setup operational mode option register */
-	var = ((d40c->dma_cfg.channel_type >> STEDMA40_INFO_CH_MODE_OPT_POS) &
-	       0x3) << D40_CHAN_POS(d40c->phy_chan->num);
+	var = d40_get_prmo(d40c) << D40_CHAN_POS(d40c->phy_chan->num);
 
 	writel(var, d40c->base->virtbase + D40_DREG_PRMOE + addr_base);
 
diff --git a/drivers/dma/ste_dma40_ll.h b/drivers/dma/ste_dma40_ll.h
index 37f81e8..9e419b9 100644
--- a/drivers/dma/ste_dma40_ll.h
+++ b/drivers/dma/ste_dma40_ll.h
@@ -130,6 +130,13 @@
 #define D40_DREG_PRMSO		0x014
 #define D40_DREG_PRMOE		0x018
 #define D40_DREG_PRMOO		0x01C
+#define D40_DREG_PRMO_PCHAN_BASIC		0x1
+#define D40_DREG_PRMO_PCHAN_MODULO		0x2
+#define D40_DREG_PRMO_PCHAN_DOUBLE_DST		0x3
+#define D40_DREG_PRMO_LCHAN_SRC_PHY_DST_LOG	0x1
+#define D40_DREG_PRMO_LCHAN_SRC_LOG_DST_PHY	0x2
+#define D40_DREG_PRMO_LCHAN_SRC_LOG_DST_LOG	0x3
+
 #define D40_DREG_LCPA		0x020
 #define D40_DREG_LCLA		0x024
 #define D40_DREG_ACTIVE		0x050
-- 
1.6.3.3

