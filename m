Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009Ab2GGVxq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 17:53:46 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:57711 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878Ab2GGVxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 17:53:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4][update] hwmon / abituguru: Use struct dev_pm_ops for power management
Date: Sat, 7 Jul 2012 23:59:12 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Alistair John Strachan <alistair@devzero.co.uk>,
        lm-sensors@lm-sensors.org, Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <linux@roeck-us.net>, Kukjin Kim <kgene.kim@samsung.com>
References: <201207072302.16491.rjw@sisk.pl> <201207072304.10067.rjw@sisk.pl>
In-Reply-To: <201207072304.10067.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207072359.12439.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: hwmon / abituguru: Use struct dev_pm_ops for power management

Make the Abit uGuru driver define its PM callbacks through
a struct dev_pm_ops object rather than by using legacy PM hooks
in struct platform_driver.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---

dev_get_drvdata() may be used directly instead of being wrapped in
platform_get_drvdata(to_platform_device()).

---
 drivers/hwmon/abituguru.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

Index: linux/drivers/hwmon/abituguru.c
===================================================================
--- linux.orig/drivers/hwmon/abituguru.c
+++ linux/drivers/hwmon/abituguru.c
@@ -1514,9 +1514,9 @@ LEAVE_UPDATE:
 }
 
 #ifdef CONFIG_PM
-static int abituguru_suspend(struct platform_device *pdev, pm_message_t state)
+static int abituguru_suspend(struct device *dev)
 {
-	struct abituguru_data *data = platform_get_drvdata(pdev);
+	struct abituguru_data *data = dev_get_drvdata(dev);
 	/*
 	 * make sure all communications with the uguru are done and no new
 	 * ones are started
@@ -1525,29 +1525,30 @@ static int abituguru_suspend(struct plat
 	return 0;
 }
 
-static int abituguru_resume(struct platform_device *pdev)
+static int abituguru_resume(struct device *dev)
 {
-	struct abituguru_data *data = platform_get_drvdata(pdev);
+	struct abituguru_data *data = dev_get_drvdata(dev);
 	/* See if the uGuru is still ready */
 	if (inb_p(data->addr + ABIT_UGURU_DATA) != ABIT_UGURU_STATUS_INPUT)
 		data->uguru_ready = 0;
 	mutex_unlock(&data->update_lock);
 	return 0;
 }
+
+static SIMPLE_DEV_PM_OPS(abituguru_pm, abituguru_suspend, abituguru_resume);
+#define ABIT_UGURU_PM	(&abituguru_pm)
 #else
-#define abituguru_suspend	NULL
-#define abituguru_resume	NULL
+#define ABIT_UGURU_PM	NULL
 #endif /* CONFIG_PM */
 
 static struct platform_driver abituguru_driver = {
 	.driver = {
 		.owner	= THIS_MODULE,
 		.name	= ABIT_UGURU_NAME,
+		.pm	= ABIT_UGURU_PM,
 	},
 	.probe		= abituguru_probe,
 	.remove		= __devexit_p(abituguru_remove),
-	.suspend	= abituguru_suspend,
-	.resume		= abituguru_resume,
 };
 
 static int __init abituguru_detect(void)

