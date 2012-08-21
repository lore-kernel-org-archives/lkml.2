Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab2HUJUO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 05:20:14 -0400
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:58640 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755245Ab2HUJUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 05:20:07 -0400
From: Felipe Balbi <balbi@ti.com>
To: alan@linux.intel.com
Cc: Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [RFC/PATCH 03/13] serial: omap: define helpers for pdata function pointers
Date: Tue, 21 Aug 2012 12:15:45 +0300
Message-Id: <1345540555-24359-4-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.12.rc3
In-Reply-To: <1345540555-24359-1-git-send-email-balbi@ti.com>
References: <1345540555-24359-1-git-send-email-balbi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch is in preparation to a few other changes
which will align on the prototype for function
pointers passed through pdata.

It also helps cleaning up the driver a little by
agregating checks for pdata in a single location.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/tty/serial/omap-serial.c | 66 ++++++++++++++++++++++++++++------------
 1 file changed, 47 insertions(+), 19 deletions(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index b4b95fc..c3e6fa0 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -101,6 +101,40 @@ static inline void serial_omap_clear_fifos(struct uart_omap_port *up)
 	serial_out(up, UART_FCR, 0);
 }
 
+static int serial_omap_get_context_loss_count(struct uart_omap_port *up)
+{
+	struct omap_uart_port_info *pdata = up->pdev->dev.platform_data;
+
+	if (!pdata->get_context_loss_count)
+		return 0;
+
+	return pdata->get_context_loss_count(&up->pdev->dev);
+}
+
+static void serial_omap_set_forceidle(struct uart_omap_port *up)
+{
+	struct omap_uart_port_info *pdata = up->pdev->dev.platform_data;
+
+	if (pdata->set_forceidle)
+		pdata->set_forceidle(up->pdev);
+}
+
+static void serial_omap_set_noidle(struct uart_omap_port *up)
+{
+	struct omap_uart_port_info *pdata = up->pdev->dev.platform_data;
+
+	if (pdata->set_noidle)
+		pdata->set_noidle(up->pdev);
+}
+
+static void serial_omap_enable_wakeup(struct uart_omap_port *up, bool enable)
+{
+	struct omap_uart_port_info *pdata = up->pdev->dev.platform_data;
+
+	if (pdata->enable_wakeup)
+		pdata->enable_wakeup(up->pdev, enable);
+}
+
 /*
  * serial_omap_get_divisor - calculate divisor value
  * @port: uart port info
@@ -177,8 +211,8 @@ static void serial_omap_stop_tx(struct uart_port *port)
 		serial_out(up, UART_IER, up->ier);
 	}
 
-	if (!up->use_dma && pdata && pdata->set_forceidle)
-		pdata->set_forceidle(up->pdev);
+	if (!up->use_dma && pdata)
+		serial_omap_set_forceidle(up);
 
 	pm_runtime_mark_last_busy(&up->pdev->dev);
 	pm_runtime_put_autosuspend(&up->pdev->dev);
@@ -308,7 +342,6 @@ static inline void serial_omap_enable_ier_thri(struct uart_omap_port *up)
 static void serial_omap_start_tx(struct uart_port *port)
 {
 	struct uart_omap_port *up = to_uart_omap_port(port);
-	struct omap_uart_port_info *pdata = up->pdev->dev.platform_data;
 	struct circ_buf *xmit;
 	unsigned int start;
 	int ret = 0;
@@ -316,8 +349,7 @@ static void serial_omap_start_tx(struct uart_port *port)
 	if (!up->use_dma) {
 		pm_runtime_get_sync(&up->pdev->dev);
 		serial_omap_enable_ier_thri(up);
-		if (pdata && pdata->set_noidle)
-			pdata->set_noidle(up->pdev);
+		serial_omap_set_noidle(up);
 		pm_runtime_mark_last_busy(&up->pdev->dev);
 		pm_runtime_put_autosuspend(&up->pdev->dev);
 		return;
@@ -1648,28 +1680,26 @@ static int serial_omap_runtime_suspend(struct device *dev)
 	if (!up)
 		return -EINVAL;
 
-	if (!pdata || !pdata->enable_wakeup)
+	if (!pdata)
 		return 0;
 
-	if (pdata->get_context_loss_count)
-		up->context_loss_cnt = pdata->get_context_loss_count(dev);
+	up->context_loss_cnt = serial_omap_get_context_loss_count(up);
 
 	if (device_may_wakeup(dev)) {
 		if (!up->wakeups_enabled) {
-			pdata->enable_wakeup(up->pdev, true);
+			serial_omap_enable_wakeup(up, true);
 			up->wakeups_enabled = true;
 		}
 	} else {
 		if (up->wakeups_enabled) {
-			pdata->enable_wakeup(up->pdev, false);
+			serial_omap_enable_wakeup(up, false);
 			up->wakeups_enabled = false;
 		}
 	}
 
 	/* Errata i291 */
-	if (up->use_dma && pdata->set_forceidle &&
-			(up->errata & UART_ERRATA_i291_DMA_FORCEIDLE))
-		pdata->set_forceidle(up->pdev);
+	if (up->use_dma && (up->errata & UART_ERRATA_i291_DMA_FORCEIDLE))
+		serial_omap_set_forceidle(up);
 
 	up->latency = PM_QOS_CPU_DMA_LAT_DEFAULT_VALUE;
 	schedule_work(&up->qos_work);
@@ -1683,17 +1713,15 @@ static int serial_omap_runtime_resume(struct device *dev)
 	struct omap_uart_port_info *pdata = dev->platform_data;
 
 	if (up && pdata) {
-		if (pdata->get_context_loss_count) {
-			u32 loss_cnt = pdata->get_context_loss_count(dev);
+			u32 loss_cnt = serial_omap_get_context_loss_count(up);
 
 			if (up->context_loss_cnt != loss_cnt)
 				serial_omap_restore_context(up);
-		}
 
 		/* Errata i291 */
-		if (up->use_dma && pdata->set_noidle &&
-				(up->errata & UART_ERRATA_i291_DMA_FORCEIDLE))
-			pdata->set_noidle(up->pdev);
+		if ((up->errata & UART_ERRATA_i291_DMA_FORCEIDLE) &&
+				up->use_dma)
+			serial_omap_set_noidle(up);
 
 		up->latency = up->calc_latency;
 		schedule_work(&up->qos_work);
-- 
1.7.12.rc3

