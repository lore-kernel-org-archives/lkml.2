Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327Ab1IZPpD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 11:45:03 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63565 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab1IZPpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 11:45:01 -0400
From: Sangwook Lee <sangwook.lee@linaro.org>
To: Rhyland Klein <rklein@nvidia.com>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sangwook Lee <sangwook.lee@linaro.org>
Subject: [PATCH v2] net:rfkill: add a gpio setup function into GPIO rfkill
Date: Mon, 26 Sep 2011 16:43:07 +0100
Message-Id: <1317051787-24142-1-git-send-email-sangwook.lee@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a gpio setup function which gives a chance to set up
platform specific configuration such as pin multiplexing,
input/output direction at the runtime or booting time.

Signed-off-by: Sangwook Lee <sangwook.lee@linaro.org>

v2:
- fixed the return type after checking gpio_runtime_setup
---
 include/linux/rfkill-gpio.h |    2 ++
 net/rfkill/rfkill-gpio.c    |    8 ++++++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/linux/rfkill-gpio.h b/include/linux/rfkill-gpio.h
index a175d05..786e7bb 100644
--- a/include/linux/rfkill-gpio.h
+++ b/include/linux/rfkill-gpio.h
@@ -30,6 +30,7 @@
  * @reset_gpio:		GPIO which is used for reseting rfkill switch
  * @shutdown_gpio:	GPIO which is used for shutdown of rfkill switch
  * @power_clk_name:	[optional] name of clk to turn off while blocked
+ * @gpio_runtime_setup:	set up platform specific gpio configuration
  */
 
 struct rfkill_gpio_platform_data {
@@ -38,6 +39,7 @@ struct rfkill_gpio_platform_data {
 	int			shutdown_gpio;
 	const char		*power_clk_name;
 	enum rfkill_type	type;
+	int	(*gpio_runtime_setup)(struct platform_device *);
 };
 
 #endif /* __RFKILL_GPIO_H */
diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
index 256c5dd..96a910c 100644
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
-- 
1.7.4.1

