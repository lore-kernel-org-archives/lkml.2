Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596Ab1KOXc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 18:32:58 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:41196 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757309Ab1KOXc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 18:32:56 -0500
From: Joe Perches <joe@perches.com>
To: Pierre Ossman <pierre@ossman.eu>
Cc: Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] wbsd: Use current logging
Date: Tue, 15 Nov 2011 15:32:06 -0800
Message-Id: <6f82953de3539a33c4c5499cd7310ed54528f118.1321398814.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1321398814.git.joe@perches.com>
References: <cover.1321398814.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pr_fmt.
Remove DRIVER_NAME from logging calls.
Remove DBG, use pr_debug.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/mmc/host/wbsd.c |   36 ++++++++++++++++--------------------
 1 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/mmc/host/wbsd.c b/drivers/mmc/host/wbsd.c
index a4944c8e..deaed8c 100644
--- a/drivers/mmc/host/wbsd.c
+++ b/drivers/mmc/host/wbsd.c
@@ -22,6 +22,8 @@
  * - On APIC systems the FIFO empty interrupt is sometimes lost.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/init.h>
@@ -43,10 +45,8 @@
 
 #define DRIVER_NAME "wbsd"
 
-#define DBG(x...) \
-	pr_debug(DRIVER_NAME ": " x)
-#define DBGF(f, x...) \
-	pr_debug(DRIVER_NAME " [%s()]: " f, __func__ , ##x)
+#define DBGF(fmt, ...)						\
+	pr_debug("[%s()]: " fmt, __func__, ##__VA_ARGS__)
 
 /*
  * Device resources
@@ -964,7 +964,7 @@ static void wbsd_reset_ignore(unsigned long data)
 
 	BUG_ON(host == NULL);
 
-	DBG("Resetting card detection ignore\n");
+	pr_debug("Resetting card detection ignore\n");
 
 	spin_lock_bh(&host->lock);
 
@@ -1018,13 +1018,13 @@ static void wbsd_tasklet_card(unsigned long param)
 
 	if (csr & WBSD_CARDPRESENT) {
 		if (!(host->flags & WBSD_FCARD_PRESENT)) {
-			DBG("Card inserted\n");
+			pr_debug("Card inserted\n");
 			host->flags |= WBSD_FCARD_PRESENT;
 
 			delay = 500;
 		}
 	} else if (host->flags & WBSD_FCARD_PRESENT) {
-		DBG("Card removed\n");
+		pr_debug("Card removed\n");
 		host->flags &= ~WBSD_FCARD_PRESENT;
 
 		if (host->mrq) {
@@ -1325,8 +1325,8 @@ static int __devinit wbsd_scan(struct wbsd_host *host)
 			}
 
 			if (id != 0xFFFF) {
-				DBG("Unknown hardware (id %x) found at %x\n",
-					id, config_ports[i]);
+				pr_debug("Unknown hardware (id %x) found at %x\n",
+					 id, config_ports[i]);
 			}
 		}
 
@@ -1428,7 +1428,7 @@ free:
 	free_dma(dma);
 
 err:
-	pr_warn(DRIVER_NAME ": Unable to allocate DMA %d. Falling back on FIFO.\n",
+	pr_warn("Unable to allocate DMA %d. Falling back on FIFO.\n",
 		dma);
 }
 
@@ -1663,8 +1663,7 @@ static int __devinit wbsd_init(struct device *dev, int base, int irq, int dma,
 	ret = wbsd_scan(host);
 	if (ret) {
 		if (pnp && (ret == -ENODEV)) {
-			pr_warn(DRIVER_NAME
-				": Unable to confirm device presence. You may experience lock-ups.\n");
+			pr_warn("Unable to confirm device presence. You may experience lock-ups.\n");
 		} else {
 			wbsd_free_mmc(dev);
 			return ret;
@@ -1686,8 +1685,7 @@ static int __devinit wbsd_init(struct device *dev, int base, int irq, int dma,
 	 */
 	if (pnp) {
 		if ((host->config != 0) && !wbsd_chip_validate(host)) {
-			pr_warn(DRIVER_NAME
-				": PnP active but chip not configured! You probably have a buggy BIOS. Configuring chip manually.\n");
+			pr_warn("PnP active but chip not configured! You probably have a buggy BIOS. Configuring chip manually.\n");
 			wbsd_chip_config(host);
 		}
 	} else
@@ -1905,8 +1903,7 @@ static int wbsd_pnp_resume(struct pnp_dev *pnp_dev)
 	 */
 	if (host->config != 0) {
 		if (!wbsd_chip_validate(host)) {
-			pr_warn(DRIVER_NAME
-				": PnP active but chip not configured! You probably have a buggy BIOS. Configuring chip manually.\n");
+			pr_warn("PnP active but chip not configured! You probably have a buggy BIOS. Configuring chip manually.\n");
 			wbsd_chip_config(host);
 		}
 	}
@@ -1967,9 +1964,8 @@ static int __init wbsd_drv_init(void)
 {
 	int result;
 
-	pr_info(DRIVER_NAME
-		": Winbond W83L51xD SD/MMC card interface driver\n");
-	pr_info(DRIVER_NAME ": Copyright(c) Pierre Ossman\n");
+	pr_info("Winbond W83L51xD SD/MMC card interface driver\n");
+	pr_info("Copyright(c) Pierre Ossman\n");
 
 #ifdef CONFIG_PNP
 
@@ -2017,7 +2013,7 @@ static void __exit wbsd_drv_exit(void)
 		platform_driver_unregister(&wbsd_driver);
 	}
 
-	DBG("unloaded\n");
+	pr_debug("unloaded\n");
 }
 
 module_init(wbsd_drv_init);
-- 
1.7.6.405.gc1be0

