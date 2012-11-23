Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389Ab2KWDEl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 22:04:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:55190 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757489Ab2KWDEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 22:04:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,304,1352102400"; 
   d="scan'208";a="246006945"
Subject: [PATCH] serial: ifx6x60: Add modem power off function in the
 platform reboot process
From: Jun Chen <jun.d.chen@intel.com>
To: Alan Cox <alan@linux.intel.com>
Cc: Jun Chen <jun.d.chen@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "russ.gorby" <russ.gorby@intel.com>,
        serial <linux-serial@vger.kernel.org>, Bi Chao <chao.bi@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Nov 2012 06:07:27 -0500
Message-ID: <1353668847.23300.13.camel@chenjun-workstation>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch add modem power off function in the reboot process according registering
reboot callback to the reboot_notifier_list. Also realizing the spi shutdown function.

Signed-off-by: Bi Chao <chao.bi@intel.com>
Signed-off-by: Chen Jun <jun.d.chen@intel.com>
---
 drivers/tty/serial/ifx6x60.c |   56 +++++++++++++++++++++++++++++++++++++++--
 1 files changed, 53 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/ifx6x60.c b/drivers/tty/serial/ifx6x60.c
index 5b9bc19..f3c54e9 100644
--- a/drivers/tty/serial/ifx6x60.c
+++ b/drivers/tty/serial/ifx6x60.c
@@ -60,6 +60,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/spi/ifx_modem.h>
 #include <linux/delay.h>
+#include <linux/reboot.h>
 
 #include "ifx6x60.h"
 
@@ -72,8 +73,14 @@
 #define IFX_SPI_HEADER_0		(-1)
 #define IFX_SPI_HEADER_F		(-2)
 
+#define PO_POST_DELAY		200
+#define IFX_MDM_RST_PMU	4
+
 /* forward reference */
 static void ifx_spi_handle_srdy(struct ifx_spi_device *ifx_dev);
+static int ifx_modem_reboot_callback(struct notifier_block *nfb,
+				unsigned long event, void *data);
+static int ifx_modem_power_off(struct ifx_spi_device *ifx_dev);
 
 /* local variables */
 static int spi_bpw = 16;		/* 8, 16 or 32 bit word length */
@@ -81,6 +88,29 @@ static struct tty_driver *tty_drv;
 static struct ifx_spi_device *saved_ifx_dev;
 static struct lock_class_key ifx_spi_key;
 
+static struct notifier_block ifx_modem_reboot_notifier_block = {
+	.notifier_call = ifx_modem_reboot_callback,
+};
+
+static int ifx_modem_power_off(struct ifx_spi_device *ifx_dev)
+{
+	gpio_set_value(IFX_MDM_RST_PMU, 1);
+	msleep(PO_POST_DELAY);
+
+	return 0;
+}
+
+static int ifx_modem_reboot_callback(struct notifier_block *nfb,
+				 unsigned long event, void *data)
+{
+	if (saved_ifx_dev)
+		ifx_modem_power_off(saved_ifx_dev);
+	else
+		pr_warn("no ifx modem active;\n");
+
+	return NOTIFY_OK;
+}
+
 /* GPIO/GPE settings */
 
 /**
@@ -1219,6 +1249,9 @@ static int ifx_spi_spi_remove(struct spi_device *spi)
 
 static void ifx_spi_spi_shutdown(struct spi_device *spi)
 {
+	struct ifx_spi_device *ifx_dev = spi_get_drvdata(spi);
+
+	ifx_modem_power_off(ifx_dev);
 }
 
 /*
@@ -1354,7 +1387,9 @@ static void __exit ifx_spi_exit(void)
 {
 	/* unregister */
 	tty_unregister_driver(tty_drv);
+	put_tty_driver(tty_drv);
 	spi_unregister_driver((void *)&ifx_spi_driver);
+	unregister_reboot_notifier(&ifx_modem_reboot_notifier_block);
 }
 
 /**
@@ -1389,16 +1424,31 @@ static int __init ifx_spi_init(void)
 	if (result) {
 		pr_err("%s: tty_register_driver failed(%d)",
 			DRVNAME, result);
-		put_tty_driver(tty_drv);
-		return result;
+		goto err_free_tty;
 	}
 
 	result = spi_register_driver((void *)&ifx_spi_driver);
 	if (result) {
 		pr_err("%s: spi_register_driver failed(%d)",
 			DRVNAME, result);
-		tty_unregister_driver(tty_drv);
+		goto err_unreg_tty;
+	}
+
+	result = register_reboot_notifier(&ifx_modem_reboot_notifier_block);
+	if (result) {
+		pr_err("%s: register ifx modem reboot notifier failed(%d)",
+			DRVNAME, result);
+		goto err_unreg_spi;
 	}
+
+	return 0;
+err_unreg_spi:
+	spi_unregister_driver((void *)&ifx_spi_driver);
+err_unreg_tty:
+	tty_unregister_driver(tty_drv);
+err_free_tty:
+	put_tty_driver(tty_drv);
+
 	return result;
 }
 
-- 
1.7.4.1



