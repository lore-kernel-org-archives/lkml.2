Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab1I2L70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 07:59:26 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34854 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab1I2L7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 07:59:25 -0400
From: Sangwook Lee <sangwook.lee@linaro.org>
To: johannes@sipsolutions.net, rklein@nvidia.com
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        patches@linaro.org, Sangwook Lee <sangwook.lee@linaro.org>
Subject: [PATCH v3] net:rfkill: add a gpio setup function into GPIO rfkill
Date: Thu, 29 Sep 2011 12:57:17 +0100
Message-Id: <1317297437-1155-1-git-send-email-sangwook.lee@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a gpio setup function which gives a chance to set up
platform specific configuration such as pin multiplexing,
input/output direction at the runtime or booting time.

Signed-off-by: Sangwook Lee <sangwook.lee@linaro.org>
---
v3:
  add a gpio clean-up function into GPIO rfkill
v2:
- fixed the return type after checking gpio_runtime_setup

 include/linux/rfkill-gpio.h |    4 ++++
 net/rfkill/rfkill-gpio.c    |   11 +++++++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/include/linux/rfkill-gpio.h b/include/linux/rfkill-gpio.h
index a175d05..4d09f6e 100644
--- a/include/linux/rfkill-gpio.h
+++ b/include/linux/rfkill-gpio.h
@@ -30,6 +30,8 @@
  * @reset_gpio:		GPIO which is used for reseting rfkill switch
  * @shutdown_gpio:	GPIO which is used for shutdown of rfkill switch
  * @power_clk_name:	[optional] name of clk to turn off while blocked
+ * @gpio_runtime_close:	clean up platform specific gpio configuration
+ * @gpio_runtime_setup:	set up platform specific gpio configuration
  */
 
 struct rfkill_gpio_platform_data {
@@ -38,6 +40,8 @@ struct rfkill_gpio_platform_data {
 	int			shutdown_gpio;
 	const char		*power_clk_name;
 	enum rfkill_type	type;
+	void	(*gpio_runtime_close)(struct platform_device *);
+	int	(*gpio_runtime_setup)(struct platform_device *);
 };
 
 #endif /* __RFKILL_GPIO_H */
diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
index 256c5dd..128677d 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -101,6 +101,14 @@ static int rfkill_gpio_probe(struct platform_device *pdev)
 	if (!rfkill)
 		return -ENOMEM;
 
+	if (pdata->gpio_runtime_setup) {
+		ret = pdata->gpio_runtime_setup(pdev);
+		if (ret) {
+			pr_warn("%s: can't set up gpio\n", __func__);
+			return ret;
+		}
+	}
+
 	rfkill->pdata = pdata;
 
 	len = strlen(pdata->name);
@@ -182,7 +190,10 @@ fail_alloc:
 static int rfkill_gpio_remove(struct platform_device *pdev)
 {
 	struct rfkill_gpio_data *rfkill = platform_get_drvdata(pdev);
+	struct rfkill_gpio_platform_data *pdata = pdev->dev.platform_data;
 
+	if (pdata->gpio_runtime_close)
+		pdata->gpio_runtime_close(pdev);
 	rfkill_unregister(rfkill->rfkill_dev);
 	rfkill_destroy(rfkill->rfkill_dev);
 	if (gpio_is_valid(rfkill->pdata->shutdown_gpio))
-- 
1.7.4.1

