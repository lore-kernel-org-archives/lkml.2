Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab2HUJUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 05:20:38 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:57576 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755481Ab2HUJUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 05:20:30 -0400
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
Subject: [RFC/PATCH 11/13] serial: omap: set dev->drvdata before enabling pm_runtime
Date: Tue, 21 Aug 2012 12:15:53 +0300
Message-Id: <1345540555-24359-12-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.12.rc3
In-Reply-To: <1345540555-24359-1-git-send-email-balbi@ti.com>
References: <1345540555-24359-1-git-send-email-balbi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

by the time we call our first pm_runtme_get_sync()
after enable pm_runtime, our resume method might
be called. To avoid problems, we must make sure
that our dev->drvdata is set correctly before
our resume method gets called.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/tty/serial/omap-serial.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index 458d77c..ba9cdf1 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -1298,6 +1298,7 @@ static int serial_omap_probe(struct platform_device *pdev)
 	serial_omap_uart_wq = create_singlethread_workqueue(up->name);
 	INIT_WORK(&up->qos_work, serial_omap_uart_qos_work);
 
+	platform_set_drvdata(pdev, up);
 	pm_runtime_use_autosuspend(&pdev->dev);
 	pm_runtime_set_autosuspend_delay(&pdev->dev,
 			omap_up_info->autosuspend_timeout);
@@ -1317,7 +1318,6 @@ static int serial_omap_probe(struct platform_device *pdev)
 
 	pm_runtime_mark_last_busy(up->dev);
 	pm_runtime_put_autosuspend(up->dev);
-	platform_set_drvdata(pdev, up);
 	return 0;
 
 err_add_port:
-- 
1.7.12.rc3

