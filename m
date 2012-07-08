Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab2GHTmm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 15:42:42 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:58327 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075Ab2GHTml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 15:42:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4/4][update] hwmon / exynos4_tmu: Use struct dev_pm_ops for power management
Date: Sun, 8 Jul 2012 21:48:15 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Alistair John Strachan <alistair@devzero.co.uk>,
        lm-sensors@lm-sensors.org, Jean Delvare <khali@linux-fr.org>,
        Kukjin Kim <kgene.kim@samsung.com>
References: <201207072302.16491.rjw@sisk.pl> <201207072306.09305.rjw@sisk.pl> <20120708170244.GA16423@roeck-us.net>
In-Reply-To: <20120708170244.GA16423@roeck-us.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207082148.15674.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make the Exynos4 TMU driver define its PM callbacks through
a struct dev_pm_ops object rather than by using legacy PM hooks
in struct platform_driver.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/hwmon/exynos4_tmu.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

Index: linux/drivers/hwmon/exynos4_tmu.c
===================================================================
--- linux.orig/drivers/hwmon/exynos4_tmu.c
+++ linux/drivers/hwmon/exynos4_tmu.c
@@ -476,34 +476,38 @@ static int __devexit exynos4_tmu_remove(
 }
 
 #ifdef CONFIG_PM
-static int exynos4_tmu_suspend(struct platform_device *pdev, pm_message_t state)
+static int exynos4_tmu_suspend(struct device *dev)
 {
-	exynos4_tmu_control(pdev, false);
+	exynos4_tmu_control(to_platform_device(dev), false);
 
 	return 0;
 }
 
-static int exynos4_tmu_resume(struct platform_device *pdev)
+static int exynos4_tmu_resume(struct device *dev)
 {
+	struct platform_device *pdev = to_platform_device(dev);
+
 	exynos4_tmu_initialize(pdev);
 	exynos4_tmu_control(pdev, true);
 
 	return 0;
 }
+
+static SIMPLE_DEV_PM_OPS(exynos4_tmu_pm,
+			 exynos4_tmu_suspend, exynos4_tmu_resume);
+#define EXYNOS4_TMU_PM	(&exynos4_tmu_pm)
 #else
-#define exynos4_tmu_suspend NULL
-#define exynos4_tmu_resume NULL
+#define EXYNOS4_TMU_PM	NULL
 #endif
 
 static struct platform_driver exynos4_tmu_driver = {
 	.driver = {
 		.name   = "exynos4-tmu",
 		.owner  = THIS_MODULE,
+		.pm     = EXYNOS4_TMU_PM,
 	},
 	.probe = exynos4_tmu_probe,
 	.remove	= __devexit_p(exynos4_tmu_remove),
-	.suspend = exynos4_tmu_suspend,
-	.resume = exynos4_tmu_resume,
 };
 
 module_platform_driver(exynos4_tmu_driver);
