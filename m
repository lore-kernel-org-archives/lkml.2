Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab2JOJ00 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 05:26:26 -0400
Received: from multi.imgtec.com ([194.200.65.239]:42070 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681Ab2JOJ0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 05:26:25 -0400
From: James Hogan <james.hogan@imgtec.com>
To: Alan Cox <alan@linux.intel.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Axel Lin <axel.lin@gmail.com>, <linux-serial@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH] tty: serial: 8250_dw: Implement suspend/resume
Date: Mon, 15 Oct 2012 10:25:58 +0100
Message-ID: <1350293158-27159-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
X-OriginalArrivalTime: 15 Oct 2012 09:26:20.0969 (UTC) FILETIME=[232FE190:01CDAAB7]
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2012_10_15_10_26_24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement suspend and resume callbacks for DesignWare 8250 driver.
They're simple wrappers around serial8250_{suspend,resume}_port.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 drivers/tty/serial/8250/8250_dw.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index f574eef..53db7e8 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -161,6 +161,29 @@ static int __devexit dw8250_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int dw8250_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct dw8250_data *data = platform_get_drvdata(pdev);
+
+	serial8250_suspend_port(data->line);
+
+	return 0;
+}
+
+static int dw8250_resume(struct platform_device *pdev)
+{
+	struct dw8250_data *data = platform_get_drvdata(pdev);
+
+	serial8250_resume_port(data->line);
+
+	return 0;
+}
+#else
+#define dw8250_suspend NULL
+#define dw8250_resume NULL
+#endif /* CONFIG_PM */
+
 static const struct of_device_id dw8250_match[] = {
 	{ .compatible = "snps,dw-apb-uart" },
 	{ /* Sentinel */ }
@@ -175,6 +198,8 @@ static struct platform_driver dw8250_platform_driver = {
 	},
 	.probe			= dw8250_probe,
 	.remove			= __devexit_p(dw8250_remove),
+	.suspend		= dw8250_suspend,
+	.resume			= dw8250_resume,
 };
 
 module_platform_driver(dw8250_platform_driver);
-- 
1.7.7.6


