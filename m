Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab2JONQK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 09:16:10 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:48323 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203Ab2JONQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 09:16:08 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>, Chris Ball <cjb@laptop.org>,
        Russell King <linux@arm.linux.org.uk>, linux-mmc@vger.kernel.org
Subject: [PATCH 1/2] mmc: core: Support all MMC capabilities when booting from Device Tree
Date: Mon, 15 Oct 2012 14:15:58 +0100
Message-Id: <1350306959-5843-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Capabilities are an important part of the MMC subsystem. Much
supported functionality would be lost if we didn't provide the
same level of support when booting Device Tree as we currently
do when the subsystem is passed capabilities via platform data.
This patch supplies this support with one simple call to a
DT parsing function.

Cc: Chris Ball <cjb@laptop.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-mmc@vger.kernel.org
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mmc/core/host.c  |   93 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mmc/host.h |    3 +-
 2 files changed, 95 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index ee2e16b..61a02db 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -20,6 +20,7 @@
 #include <linux/leds.h>
 #include <linux/slab.h>
 #include <linux/suspend.h>
+#include <linux/of.h>
 
 #include <linux/mmc/host.h>
 #include <linux/mmc/card.h>
@@ -436,3 +437,95 @@ void mmc_free_host(struct mmc_host *host)
 }
 
 EXPORT_SYMBOL(mmc_free_host);
+
+/**
+ *	mmc_of_populate_caps - support all MMC capabilities from Device Tree
+ *	@np: MMC OF device node
+ *	@caps: Host capabilities - as per linux/mmc/host.h
+ *	@caps2: More host cabibilies - as per linux/mmc/host.h
+ *
+ *	Read capability string from the device node provided and populate
+ *	the capability container accordingly.
+ */
+void mmc_of_populate_caps(struct device_node *np,
+			  unsigned long *caps,
+			  unsigned int *caps2)
+{
+	if(of_property_read_bool(np, "mmc-cap-4-bit-data"))
+		*caps |= MMC_CAP_4_BIT_DATA;
+	if(of_property_read_bool(np, "mmc-cap-mmc-highspeed"))
+		*caps |= MMC_CAP_MMC_HIGHSPEED;
+	if(of_property_read_bool(np, "mmc-cap-sd-highspeed"))
+		*caps |= MMC_CAP_SD_HIGHSPEED;
+	if(of_property_read_bool(np, "mmc-cap-sdio-irq"))
+		*caps |= MMC_CAP_SDIO_IRQ;
+	if(of_property_read_bool(np, "mmc-cap-spi"))
+		*caps |= MMC_CAP_SPI;
+	if(of_property_read_bool(np, "mmc-cap-needs-poll"))
+		*caps |= MMC_CAP_NEEDS_POLL;
+	if(of_property_read_bool(np, "mmc-cap-8-bit-data"))
+		*caps |= MMC_CAP_8_BIT_DATA;
+	if(of_property_read_bool(np, "mmc-cap-nonremovable"))
+		*caps |= MMC_CAP_NONREMOVABLE;
+	if(of_property_read_bool(np, "mmc-cap-wait-while-busy"))
+		*caps |= MMC_CAP_WAIT_WHILE_BUSY;
+	if(of_property_read_bool(np, "mmc-cap-erase"))
+		*caps |= MMC_CAP_ERASE;
+	if(of_property_read_bool(np, "mmc-cap-1-8v-ddr"))
+		*caps |= MMC_CAP_1_8V_DDR;
+	if(of_property_read_bool(np, "mmc-cap-1-2v-ddr"))
+		*caps |= MMC_CAP_1_2V_DDR;
+	if(of_property_read_bool(np, "mmc-cap-power-off-card"))
+		*caps |= MMC_CAP_POWER_OFF_CARD;
+	if(of_property_read_bool(np, "mmc-cap-bus-width-test"))
+		*caps |= MMC_CAP_BUS_WIDTH_TEST;
+	if(of_property_read_bool(np, "mmc-cap-uhs-sdr12"))
+		*caps |= MMC_CAP_UHS_SDR12;
+	if(of_property_read_bool(np, "mmc-cap-uhs-sdr25"))
+		*caps |= MMC_CAP_UHS_SDR25;
+	if(of_property_read_bool(np, "mmc-cap-uhs-sdr50"))
+		*caps |= MMC_CAP_UHS_SDR50;
+	if(of_property_read_bool(np, "mmc-cap-uhs-sdr104"))
+		*caps |= MMC_CAP_UHS_SDR104;
+	if(of_property_read_bool(np, "mmc-cap-uhs-ddr50"))
+		*caps |= MMC_CAP_UHS_DDR50;
+	if(of_property_read_bool(np, "mmc-cap-driver-type-a"))
+		*caps |= MMC_CAP_DRIVER_TYPE_A;
+	if(of_property_read_bool(np, "mmc-cap-driver-type-c"))
+		*caps |= MMC_CAP_DRIVER_TYPE_C;
+	if(of_property_read_bool(np, "mmc-cap-driver-type-d"))
+		*caps |= MMC_CAP_DRIVER_TYPE_D;
+	if(of_property_read_bool(np, "mmc-cap-cmd23"))
+		*caps |= MMC_CAP_CMD23;
+	if(of_property_read_bool(np, "mmc-cap-hw-reset"))
+		*caps |= MMC_CAP_HW_RESET;
+
+	if(of_property_read_bool(np, "mmc-cap2-bootpart-noacc"))
+		*caps2 |= MMC_CAP2_BOOTPART_NOACC;
+	if(of_property_read_bool(np, "mmc-cap2-cache-ctrl"))
+		*caps2 |= MMC_CAP2_CACHE_CTRL;
+	if(of_property_read_bool(np, "mmc-cap2-poweroff-notify"))
+		*caps2 |= MMC_CAP2_POWEROFF_NOTIFY;
+	if(of_property_read_bool(np, "mmc-cap2-no-multi-read"))
+		*caps2 |= MMC_CAP2_NO_MULTI_READ;
+	if(of_property_read_bool(np, "mmc-cap2-no-sleep-cmd"))
+		*caps2 |= MMC_CAP2_NO_SLEEP_CMD;
+	if(of_property_read_bool(np, "mmc-cap2-hs200-1-8v-sdr"))
+		*caps2 |= MMC_CAP2_HS200_1_8V_SDR;
+	if(of_property_read_bool(np, "mmc-cap2-hs200-1-2v-sdr"))
+		*caps2 |= MMC_CAP2_HS200_1_2V_SDR;
+	if(of_property_read_bool(np, "mmc-cap2-hs200"))
+		*caps2 |= MMC_CAP2_HS200;
+	if(of_property_read_bool(np, "mmc-cap2-broken-voltage"))
+		*caps2 |= MMC_CAP2_BROKEN_VOLTAGE;
+	if(of_property_read_bool(np, "mmc-cap2-detect-on-err"))
+		*caps2 |= MMC_CAP2_DETECT_ON_ERR;
+	if(of_property_read_bool(np, "mmc-cap2-hc-erase-sz"))
+		*caps2 |= MMC_CAP2_HC_ERASE_SZ;
+	if(of_property_read_bool(np, "mmc-cap2-cd-active-high"))
+		*caps2 |= MMC_CAP2_CD_ACTIVE_HIGH;
+	if(of_property_read_bool(np, "mmc-cap2-ro-active-high"))
+		*caps2 |= MMC_CAP2_RO_ACTIVE_HIGH;
+}
+
+EXPORT_SYMBOL(mmc_of_populate_caps);
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 7abb0e1..612cf0e 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -344,7 +344,8 @@ extern struct mmc_host *mmc_alloc_host(int extra, struct device *);
 extern int mmc_add_host(struct mmc_host *);
 extern void mmc_remove_host(struct mmc_host *);
 extern void mmc_free_host(struct mmc_host *);
-
+extern void mmc_of_populate_caps(struct device_node *,
+				 unsigned long *, unsigned int *);
 static inline void *mmc_priv(struct mmc_host *host)
 {
 	return (void *)host->private;
-- 
1.7.9.5

