Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab2ALJcS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 04:32:18 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:58810 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753103Ab2ALJcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 04:32:13 -0500
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <linux-serial@vger.kernel.org>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH RFC] omap-serial: Fix the error handling in the omap_serial probe
Date: Thu, 12 Jan 2012 15:02:04 +0530
Message-ID: <1326360724-7898-1-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch does the following

- The pm_runtime_disable is called in the remove not in the error
  case of probe.The patch calls the pm_runtime_disable in the error
  case.
- The  up is not freed in the error path. Fix the memory leak by calling
 kfree in the error path.
- Also the iounmap is not called fix the same by calling iounmap in the
  error case of probe and remove .
- Make the name of the error tags more meaningful.

Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/tty/serial/omap-serial.c |   27 +++++++++++++++++----------
 1 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index eb90a01..29fe6fd 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -1369,14 +1369,14 @@ static int serial_omap_probe(struct platform_device *pdev)
 
 	dma_rx = platform_get_resource_byname(pdev, IORESOURCE_DMA, "rx");
 	if (!dma_rx) {
-		ret = -EINVAL;
-		goto err;
+		ret = -ENXIO;
+		goto do_release_region;
 	}
 
 	dma_tx = platform_get_resource_byname(pdev, IORESOURCE_DMA, "tx");
 	if (!dma_tx) {
-		ret = -EINVAL;
-		goto err;
+		ret = -ENXIO;
+		goto do_release_region;
 	}
 
 	up = kzalloc(sizeof(*up), GFP_KERNEL);
@@ -1403,7 +1403,7 @@ static int serial_omap_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "failed to get alias/pdev id, errno %d\n",
 								up->port.line);
 		ret = -ENODEV;
-		goto err;
+		goto err_port_line;
 	}
 
 	sprintf(up->name, "OMAP UART%d", up->port.line);
@@ -1412,7 +1412,7 @@ static int serial_omap_probe(struct platform_device *pdev)
 	if (!up->port.membase) {
 		dev_err(&pdev->dev, "can't ioremap UART\n");
 		ret = -ENOMEM;
-		goto err;
+		goto err_ioremap;
 	}
 
 	up->port.flags = omap_up_info->flags;
@@ -1458,16 +1458,22 @@ static int serial_omap_probe(struct platform_device *pdev)
 
 	ret = uart_add_one_port(&serial_omap_reg, &up->port);
 	if (ret != 0)
-		goto do_release_region;
+		goto err_add_port;
 
 	pm_runtime_put(&pdev->dev);
 	platform_set_drvdata(pdev, up);
 	return 0;
-err:
-	dev_err(&pdev->dev, "[UART%d]: failure [%s]: %d\n",
-				pdev->id, __func__, ret);
+
+err_add_port:
+	pm_runtime_disable(&pdev->dev);
+	iounmap(up->port.membase);
+err_ioremap:
+err_port_line:
+	kfree(up);
 do_release_region:
 	release_mem_region(mem->start, resource_size(mem));
+	dev_err(&pdev->dev, "[UART%d]: failure [%s]: %d\n",
+				pdev->id, __func__, ret);
 	return ret;
 }
 
@@ -1476,6 +1482,7 @@ static int serial_omap_remove(struct platform_device *dev)
 	struct uart_omap_port *up = platform_get_drvdata(dev);
 
 	if (up) {
+		iounmap(up->port.membase);
 		pm_runtime_disable(&up->pdev->dev);
 		uart_remove_one_port(&serial_omap_reg, &up->port);
 		pm_qos_remove_request(&up->pm_qos_request);
-- 
1.7.1

