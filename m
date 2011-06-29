Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab1F2G2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 02:28:36 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:35161 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab1F2G2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 02:28:30 -0400
X-AuditID: cbfee61a-b7c53ae000002dc1-49-4e0ac60c54f0
Date: Wed, 29 Jun 2011 15:28:24 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH] tty: serial: samsung.c remove legacy PM code.
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, kyungmin.park@samsung.com,
        myungjoo.ham@gmail.com
Message-id: <1309328904-19267-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 29 Jun 2011 06:28:43.0323 (UTC)
 FILETIME=[CAEEA8B0:01CC3625]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch "modernize" tty/serial/samsung.c to use non-legacy code for
suspend/resume.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: KyungMin Park <kyungmin.park@samsung.com>
---
 drivers/tty/serial/samsung.c |   27 ++++++++++++++-------------
 1 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index f66f648..34b8afe 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -1194,12 +1194,10 @@ int __devexit s3c24xx_serial_remove(struct platform_device *dev)
 EXPORT_SYMBOL_GPL(s3c24xx_serial_remove);
 
 /* UART power management code */
-
-#ifdef CONFIG_PM
-
-static int s3c24xx_serial_suspend(struct platform_device *dev, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int s3c24xx_serial_suspend(struct device *dev)
 {
-	struct uart_port *port = s3c24xx_dev_to_port(&dev->dev);
+	struct uart_port *port = s3c24xx_dev_to_port(dev);
 
 	if (port)
 		uart_suspend_port(&s3c24xx_uart_drv, port);
@@ -1207,9 +1205,9 @@ static int s3c24xx_serial_suspend(struct platform_device *dev, pm_message_t stat
 	return 0;
 }
 
-static int s3c24xx_serial_resume(struct platform_device *dev)
+static int s3c24xx_serial_resume(struct device *dev)
 {
-	struct uart_port *port = s3c24xx_dev_to_port(&dev->dev);
+	struct uart_port *port = s3c24xx_dev_to_port(dev);
 	struct s3c24xx_uart_port *ourport = to_ourport(port);
 
 	if (port) {
@@ -1222,17 +1220,20 @@ static int s3c24xx_serial_resume(struct platform_device *dev)
 
 	return 0;
 }
-#endif
+
+static const struct dev_pm_ops s3c24xx_serial_pm_ops = {
+	.suspend = s3c24xx_serial_suspend,
+	.resume = s3c24xx_serial_resume,
+};
+#else /* !CONFIG_PM_SLEEP */
+#define s3c24xx_serial_pm_ops	NULL
+#endif /* CONFIG_PM_SLEEP */
 
 int s3c24xx_serial_init(struct platform_driver *drv,
 			struct s3c24xx_uart_info *info)
 {
 	dbg("s3c24xx_serial_init(%p,%p)\n", drv, info);
-
-#ifdef CONFIG_PM
-	drv->suspend = s3c24xx_serial_suspend;
-	drv->resume = s3c24xx_serial_resume;
-#endif
+	drv->driver.pm = &s3c24xx_serial_pm_ops;
 
 	return platform_driver_register(drv);
 }
-- 
1.7.4.1

