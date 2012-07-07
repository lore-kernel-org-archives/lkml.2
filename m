Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab2GGVya (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 17:54:30 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:57734 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799Ab2GGVy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 17:54:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4][update] hwmon / abituguru3: Use struct dev_pm_ops for power management
Date: Sun, 8 Jul 2012 00:00:01 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Alistair John Strachan <alistair@devzero.co.uk>,
        lm-sensors@lm-sensors.org, Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <linux@roeck-us.net>, Kukjin Kim <kgene.kim@samsung.com>
References: <201207072302.16491.rjw@sisk.pl> <201207072304.42750.rjw@sisk.pl>
In-Reply-To: <201207072304.42750.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207080000.02081.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make the Abit uGuru rev. 3 driver define its PM callbacks through
a struct dev_pm_ops object rather than by using legacy PM hooks
in struct platform_driver.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---

dev_get_drvdata() may be used directly instead of being wrapped in
platform_get_drvdata(to_platform_device()).

---
 drivers/hwmon/abituguru3.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

Index: linux/drivers/hwmon/abituguru3.c
===================================================================
--- linux.orig/drivers/hwmon/abituguru3.c
+++ linux/drivers/hwmon/abituguru3.c
@@ -1142,9 +1142,9 @@ LEAVE_UPDATE:
 }
 
 #ifdef CONFIG_PM
-static int abituguru3_suspend(struct platform_device *pdev, pm_message_t state)
+static int abituguru3_suspend(struct device *dev)
 {
-	struct abituguru3_data *data = platform_get_drvdata(pdev);
+	struct abituguru3_data *data = dev_get_drvdata(dev);
 	/*
 	 * make sure all communications with the uguru3 are done and no new
 	 * ones are started
@@ -1153,26 +1153,27 @@ static int abituguru3_suspend(struct pla
 	return 0;
 }
 
-static int abituguru3_resume(struct platform_device *pdev)
+static int abituguru3_resume(struct device *dev)
 {
-	struct abituguru3_data *data = platform_get_drvdata(pdev);
+	struct abituguru3_data *data = dev_get_drvdata(dev);
 	mutex_unlock(&data->update_lock);
 	return 0;
 }
+
+static SIMPLE_DEV_PM_OPS(abituguru3_pm, abituguru3_suspend, abituguru3_resume);
+#define ABIT_UGURU3_PM	(&abituguru3_pm)
 #else
-#define abituguru3_suspend	NULL
-#define abituguru3_resume	NULL
+#define ABIT_UGURU3_PM	NULL
 #endif /* CONFIG_PM */
 
 static struct platform_driver abituguru3_driver = {
 	.driver = {
 		.owner	= THIS_MODULE,
 		.name	= ABIT_UGURU3_NAME,
+		.pm	= ABIT_UGURU3_PM
 	},
 	.probe	= abituguru3_probe,
 	.remove	= __devexit_p(abituguru3_remove),
-	.suspend = abituguru3_suspend,
-	.resume = abituguru3_resume
 };
 
 static int __init abituguru3_dmi_detect(void)

