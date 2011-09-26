Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837Ab1IZOYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 10:24:48 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37047 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab1IZOYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 10:24:45 -0400
From: Sangwook Lee <sangwook.lee@linaro.org>
To: Rhyland Klein <rklein@nvidia.com>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sangwook Lee <sangwook.lee@linaro.org>
Subject: [PATCH] net:rfkill: add a gpio setup function into GPIO rfkill
Date: Mon, 26 Sep 2011 15:22:52 +0100
Message-Id: <1317046972-18570-1-git-send-email-sangwook.lee@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a gpio setup function which gives a chance to set up
platform specific configuration such as pin multiplexing,
input/output direction at the runtime or booting time.

Signed-off-by: Sangwook Lee <sangwook.lee@linaro.org>
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
index 256c5dd..d6cec90 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -101,6 +101,14 @@ static int rfkill_gpio_probe(struct platform_device *pdev)
 	if (!rfkill)
 		return -ENOMEM;
 
+	if (pdata->gpio_runtime_setup) {
+		ret = pdata->gpio_runtime_setup(pdev);
+		if (ret) {
+			pr_warn("%s: can't set up gpio\n", __func__);
+			return -EINVAL;
+		}
+	}
+
 	rfkill->pdata = pdata;
 
 	len = strlen(pdata->name);
-- 
1.7.4.1

