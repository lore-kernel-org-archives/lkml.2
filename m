Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120Ab2CLUll (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 16:41:41 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:49460 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932095Ab2CLUlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 16:41:40 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl: fix error path in pinconf_map_to_setting()
Date: Mon, 12 Mar 2012 21:41:10 +0100
Message-ID: <1331584870-10077-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.8
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

The code was using the union member
setting->data.configs.group_or_pin to store a potential
error code, but since that member is unsigned the
< 0 comparison was not true, letting errors pass thru,
ending up as mapped to pin "-22". Fix this up and print
the error.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinconf.c |   27 +++++++++++++++++----------
 1 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c
index 247b9f2..f9c9cd1 100644
--- a/drivers/pinctrl/pinconf.c
+++ b/drivers/pinctrl/pinconf.c
@@ -282,21 +282,28 @@ int pinconf_map_to_setting(struct pinctrl_map const *map,
 			  struct pinctrl_setting *setting)
 {
 	struct pinctrl_dev *pctldev = setting->pctldev;
+	int ret;
 
 	switch (setting->type) {
 	case PIN_MAP_TYPE_CONFIGS_PIN:
-		setting->data.configs.group_or_pin =
-			pin_get_from_name(pctldev,
-					  map->data.configs.group_or_pin);
-		if (setting->data.configs.group_or_pin < 0)
-			return setting->data.configs.group_or_pin;
+		ret = pin_get_from_name(pctldev,
+					map->data.configs.group_or_pin);
+		if (ret < 0) {
+			dev_err(pctldev->dev, "could not map pin config for \"%s\"",
+				map->data.configs.group_or_pin);
+			return ret;
+		}
+		setting->data.configs.group_or_pin = ret;
 		break;
 	case PIN_MAP_TYPE_CONFIGS_GROUP:
-		setting->data.configs.group_or_pin =
-			pinctrl_get_group_selector(pctldev,
-					map->data.configs.group_or_pin);
-		if (setting->data.configs.group_or_pin < 0)
-			return setting->data.configs.group_or_pin;
+		ret = pinctrl_get_group_selector(pctldev,
+					 map->data.configs.group_or_pin);
+		if (ret < 0) {
+			dev_err(pctldev->dev, "could not map group config for \"%s\"",
+				map->data.configs.group_or_pin);
+			return ret;
+		}
+		setting->data.configs.group_or_pin = ret;
 		break;
 	default:
 		return -EINVAL;
-- 
1.7.8

