Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529Ab0JLNBX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 09:01:23 -0400
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:50439 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932474Ab0JLNBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 09:01:21 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 2/7] ste_dma40: move priority to separate field
Date: Tue, 12 Oct 2010 15:00:50 +0200
Message-ID: <1286888455-11385-3-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1286888455-11385-2-git-send-email-linus.walleij@stericsson.com>
References: <1286888455-11385-1-git-send-email-linus.walleij@stericsson.com>
 <1286888455-11385-2-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

And keep it low priority by default.

Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 arch/arm/mach-ux500/devices-db8500.c           |    2 --
 arch/arm/plat-nomadik/include/plat/ste_dma40.h |    7 ++-----
 drivers/dma/ste_dma40_ll.c                     |    2 +-
 3 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-ux500/devices-db8500.c b/arch/arm/mach-ux500/devices-db8500.c
index d60ecb2..f672fe1 100644
--- a/arch/arm/mach-ux500/devices-db8500.c
+++ b/arch/arm/mach-ux500/devices-db8500.c
@@ -209,7 +209,6 @@ static struct resource dma40_resources[] = {
 /* Default configuration for physcial memcpy */
 struct stedma40_chan_cfg dma40_memcpy_conf_phy = {
 	.channel_type = (STEDMA40_CHANNEL_IN_PHY_MODE |
-			 STEDMA40_LOW_PRIORITY_CHANNEL |
 			 STEDMA40_PCHAN_BASIC_MODE),
 	.dir = STEDMA40_MEM_TO_MEM,
 
@@ -226,7 +225,6 @@ struct stedma40_chan_cfg dma40_memcpy_conf_phy = {
 /* Default configuration for logical memcpy */
 struct stedma40_chan_cfg dma40_memcpy_conf_log = {
 	.channel_type = (STEDMA40_CHANNEL_IN_LOG_MODE |
-			 STEDMA40_LOW_PRIORITY_CHANNEL |
 			 STEDMA40_LCHAN_SRC_LOG_DST_LOG |
 			 STEDMA40_NO_TIM_FOR_LINK),
 	.dir = STEDMA40_MEM_TO_MEM,
diff --git a/arch/arm/plat-nomadik/include/plat/ste_dma40.h b/arch/arm/plat-nomadik/include/plat/ste_dma40.h
index 3dd4255..9adcd9b 100644
--- a/arch/arm/plat-nomadik/include/plat/ste_dma40.h
+++ b/arch/arm/plat-nomadik/include/plat/ste_dma40.h
@@ -23,11 +23,6 @@
  * the info structure.
  */
 
-/* Priority */
-#define STEDMA40_INFO_PRIO_TYPE_POS 2
-#define STEDMA40_HIGH_PRIORITY_CHANNEL (0x1 << STEDMA40_INFO_PRIO_TYPE_POS)
-#define STEDMA40_LOW_PRIORITY_CHANNEL (0x2 << STEDMA40_INFO_PRIO_TYPE_POS)
-
 /* Mode  */
 #define STEDMA40_INFO_CH_MODE_TYPE_POS 6
 #define STEDMA40_CHANNEL_IN_PHY_MODE (0x1 << STEDMA40_INFO_CH_MODE_TYPE_POS)
@@ -119,6 +114,7 @@ struct stedma40_half_channel_info {
  *
  * @dir: MEM 2 MEM, PERIPH 2 MEM , MEM 2 PERIPH, PERIPH 2 PERIPH
  * @channel_type: priority, mode, mode options and interrupt configuration.
+ * @high_priority: true if high-priority
  * @src_dev_type: Src device type
  * @dst_dev_type: Dst device type
  * @src_info: Parameters for dst half channel
@@ -132,6 +128,7 @@ struct stedma40_half_channel_info {
 struct stedma40_chan_cfg {
 	enum stedma40_xfer_dir			 dir;
 	unsigned int				 channel_type;
+	bool					 high_priority;
 	int					 src_dev_type;
 	int					 dst_dev_type;
 	struct stedma40_half_channel_info	 src_info;
diff --git a/drivers/dma/ste_dma40_ll.c b/drivers/dma/ste_dma40_ll.c
index 86a306d..cfc86a5 100644
--- a/drivers/dma/ste_dma40_ll.c
+++ b/drivers/dma/ste_dma40_ll.c
@@ -108,7 +108,7 @@ void d40_phy_cfg(struct stedma40_chan_cfg *cfg,
 		src |= 1 << D40_SREG_CFG_LOG_GIM_POS;
 	}
 
-	if (cfg->channel_type & STEDMA40_HIGH_PRIORITY_CHANNEL) {
+	if (cfg->high_priority) {
 		src |= 1 << D40_SREG_CFG_PRI_POS;
 		dst |= 1 << D40_SREG_CFG_PRI_POS;
 	}
-- 
1.6.3.3

