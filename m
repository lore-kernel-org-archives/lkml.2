Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab2K3FH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 00:07:57 -0500
Received: from mail-ie0-f202.google.com ([209.85.223.202]:50595 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab2K3FHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 00:07:30 -0500
From: Doug Anderson <dianders@chromium.org>
To: linux-mmc@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Will Newton <will.newton@imgtec.com>,
        Chris Ball <cjb@laptop.org>, Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>, linux-kernel@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>
Subject: [PATCH v3 4/4] mmc: dw_mmc: Handle wp-gpios from device tree
Date: Thu, 29 Nov 2012 21:04:17 -0800
Message-Id: <1354251857-21587-4-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1354251857-21587-1-git-send-email-dianders@chromium.org>
References: <1353624835-19137-1-git-send-email-dianders@chromium.org>
 <1354251857-21587-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some SoCs (like exynos5250) you need to use an external GPIO for
write protect.  Add support for wp-gpios to the core dw_mmc driver
since it could be useful across multiple SoCs.

With this change I am able to make use of the write protect for the
external SD slot on exynos5250-snow.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
Changes in v3: None
Changes in v2:
- Fixed return type from u32 to int
- Return -EINVAL instead of -1

 drivers/mmc/host/dw_mmc.c |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index b47b1e9..8f8bac5 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -34,6 +34,7 @@
 #include <linux/regulator/consumer.h>
 #include <linux/workqueue.h>
 #include <linux/of.h>
+#include <linux/of_gpio.h>
 
 #include "dw_mmc.h"
 
@@ -75,6 +76,7 @@ struct idmac_desc {
  * @mmc: The mmc_host representing this slot.
  * @host: The MMC controller this slot is using.
  * @quirks: Slot-level quirks (DW_MCI_SLOT_QUIRK_XXX)
+ * @wp_gpio: If gpio_is_valid() we'll use this to read write protect.
  * @ctype: Card type for this slot.
  * @mrq: mmc_request currently being processed or waiting to be
  *	processed, or NULL when the slot is idle.
@@ -90,6 +92,7 @@ struct dw_mci_slot {
 	struct dw_mci		*host;
 
 	int			quirks;
+	int			wp_gpio;
 
 	u32			ctype;
 
@@ -836,6 +839,8 @@ static int dw_mci_get_ro(struct mmc_host *mmc)
 		read_only = 0;
 	else if (brd->get_ro)
 		read_only = brd->get_ro(slot->id);
+	else if (gpio_is_valid(slot->wp_gpio))
+		read_only = gpio_get_value(slot->wp_gpio);
 	else
 		read_only =
 			mci_readl(slot->host, WRTPRT) & (1 << slot->id) ? 1 : 0;
@@ -1830,6 +1835,29 @@ static u32 dw_mci_of_get_bus_wd(struct device *dev, u8 slot)
 			       " as 1\n");
 	return bus_wd;
 }
+
+/* find the write protect gpio for a given slot; or -1 if none specified */
+static int dw_mci_of_get_wp_gpio(struct device *dev, u8 slot)
+{
+	struct device_node *np = dw_mci_of_find_slot_node(dev, slot);
+	int gpio;
+
+	if (!np)
+		return -EINVAL;
+
+	gpio = of_get_named_gpio(np, "wp-gpios", 0);
+
+	/* Having a missing entry is valid; return silently */
+	if (!gpio_is_valid(gpio))
+		return -EINVAL;
+
+	if (devm_gpio_request(dev, gpio, "dw-mci-wp")) {
+		dev_warn(dev, "gpio [%d] request failed\n", gpio);
+		return -EINVAL;
+	}
+
+	return gpio;
+}
 #else /* CONFIG_OF */
 static int dw_mci_of_get_slot_quirks(struct device *dev, u8 slot)
 {
@@ -1843,6 +1871,10 @@ static struct device_node *dw_mci_of_find_slot_node(struct device *dev, u8 slot)
 {
 	return NULL;
 }
+static int dw_mci_of_get_wp_gpio(struct device *dev, u8 slot)
+{
+	return -EINVAL;
+}
 #endif /* CONFIG_OF */
 
 static int dw_mci_init_slot(struct dw_mci *host, unsigned int id)
@@ -1960,6 +1992,8 @@ static int dw_mci_init_slot(struct dw_mci *host, unsigned int id)
 	else
 		clear_bit(DW_MMC_CARD_PRESENT, &slot->flags);
 
+	slot->wp_gpio = dw_mci_of_get_wp_gpio(host->dev, slot->id);
+
 	mmc_add_host(mmc);
 
 #if defined(CONFIG_DEBUG_FS)
-- 
1.7.7.3

