Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab2LJI41 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 03:56:27 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:49158 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab2LJI4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 03:56:23 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, ulf.hansson@linaro.org,
        Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 02/12] regulator: gpio-regulator: Only read GPIO [dis|en]able pin if not always-on
Date: Mon, 10 Dec 2012 08:55:51 +0000
Message-Id: <1355129761-8088-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355129761-8088-1-git-send-email-lee.jones@linaro.org>
References: <1355129761-8088-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a regulator is specified as always-on, then it can't have an
enable/disable pin, as it can't be turned off.

Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/regulator/gpio-regulator.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/gpio-regulator.c b/drivers/regulator/gpio-regulator.c
index 1a71be2..3afa46a 100644
--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -160,7 +160,14 @@ of_get_gpio_regulator_config(struct device *dev, struct device_node *np)
 
 	of_property_read_u32(np, "startup-delay-us", &config->startup_delay);
 
-	config->enable_gpio = of_get_named_gpio(np, "enable-gpio", 0);
+	if (!config->init_data->constraints.always_on) {
+		config->enable_gpio = of_get_named_gpio(np, "enable-gpio", 0);
+		if (config->enable_gpio < 0) {
+			dev_err(dev, "Couldn't get 'enable-gpio' (%d)\n",
+				config->enable_gpio);
+			return ERR_PTR(config->enable_gpio);
+		}
+	}
 
 	/* Fetch GPIOs. */
 	for (i = 0; ; i++)
-- 
1.7.9.5

