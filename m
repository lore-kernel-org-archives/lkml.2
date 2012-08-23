Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030309Ab2HWKkO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 06:40:14 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:56659 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933862Ab2HWKhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 06:37:47 -0400
From: Felipe Balbi <balbi@ti.com>
To: alan@linux.intel.com
Cc: Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, Felipe Balbi <balbi@ti.com>,
        Ruchika Kharwar <ruchika@ti.com>
Subject: [PATCH v3 15/23] serial: omap: optimization with section annotations
Date: Thu, 23 Aug 2012 13:32:55 +0300
Message-Id: <1345717983-18179-16-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.12.rc3
In-Reply-To: <1345717983-18179-1-git-send-email-balbi@ti.com>
References: <1345717983-18179-1-git-send-email-balbi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two functions:
omap_serial_fill_features_erratas() and
of_get_uart_port_info() are only called from probe().
Marking them as __devinit gives us another
oportunity to free some code after .init.text
is done.

Tested-by: Shubhrajyoti D <shubhrajyoti@ti.com>
Signed-off-by: Ruchika Kharwar <ruchika@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/tty/serial/omap-serial.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index 8254561..bdfd019 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -1154,7 +1154,7 @@ static int serial_omap_resume(struct device *dev)
 }
 #endif
 
-static void omap_serial_fill_features_erratas(struct uart_omap_port *up)
+static void __devinit omap_serial_fill_features_erratas(struct uart_omap_port *up)
 {
 	u32 mvr, scheme;
 	u16 revision, major, minor;
@@ -1207,7 +1207,7 @@ static void omap_serial_fill_features_erratas(struct uart_omap_port *up)
 	}
 }
 
-static struct omap_uart_port_info *of_get_uart_port_info(struct device *dev)
+static __devinit struct omap_uart_port_info *of_get_uart_port_info(struct device *dev)
 {
 	struct omap_uart_port_info *omap_up_info;
 
@@ -1220,7 +1220,7 @@ static struct omap_uart_port_info *of_get_uart_port_info(struct device *dev)
 	return omap_up_info;
 }
 
-static int serial_omap_probe(struct platform_device *pdev)
+static int __devinit serial_omap_probe(struct platform_device *pdev)
 {
 	struct uart_omap_port	*up;
 	struct resource		*mem, *irq;
@@ -1331,7 +1331,7 @@ err_port_line:
 	return ret;
 }
 
-static int serial_omap_remove(struct platform_device *dev)
+static int __devexit serial_omap_remove(struct platform_device *dev)
 {
 	struct uart_omap_port *up = platform_get_drvdata(dev);
 
@@ -1475,7 +1475,7 @@ MODULE_DEVICE_TABLE(of, omap_serial_of_match);
 
 static struct platform_driver serial_omap_driver = {
 	.probe          = serial_omap_probe,
-	.remove         = serial_omap_remove,
+	.remove         = __devexit_p(serial_omap_remove),
 	.driver		= {
 		.name	= DRIVER_NAME,
 		.pm	= &serial_omap_dev_pm_ops,
-- 
1.7.12.rc3

