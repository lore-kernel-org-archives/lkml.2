Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab2GDFNt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 01:13:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54681 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab2GDFNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 01:13:45 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux-leds@vger.kernel.org, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 22/25] leds: convert GPIO LED trigger driver to devm_kzalloc() and cleanup error exit path
Date: Wed,  4 Jul 2012 13:10:14 +0800
Message-Id: <1341378617-10386-23-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
References: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Felipe Balbi <me@felipebalbi.com>
Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 drivers/leds/ledtrig-gpio.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/leds/ledtrig-gpio.c b/drivers/leds/ledtrig-gpio.c
index ba215dc..39bd8e4 100644
--- a/drivers/leds/ledtrig-gpio.c
+++ b/drivers/leds/ledtrig-gpio.c
@@ -181,13 +181,13 @@ static void gpio_trig_activate(struct led_classdev *led)
 	struct gpio_trig_data *gpio_data;
 	int ret;
 
-	gpio_data = kzalloc(sizeof(*gpio_data), GFP_KERNEL);
+	gpio_data = devm_kzalloc(led->dev, sizeof(*gpio_data), GFP_KERNEL);
 	if (!gpio_data)
 		return;
 
 	ret = device_create_file(led->dev, &dev_attr_gpio);
 	if (ret)
-		goto err_gpio;
+		return;
 
 	ret = device_create_file(led->dev, &dev_attr_inverted);
 	if (ret)
@@ -209,9 +209,6 @@ err_brightness:
 
 err_inverted:
 	device_remove_file(led->dev, &dev_attr_gpio);
-
-err_gpio:
-	kfree(gpio_data);
 }
 
 static void gpio_trig_deactivate(struct led_classdev *led)
@@ -225,7 +222,6 @@ static void gpio_trig_deactivate(struct led_classdev *led)
 		flush_work(&gpio_data->work);
 		if (gpio_data->gpio != 0)
 			free_irq(gpio_to_irq(gpio_data->gpio), led);
-		kfree(gpio_data);
 		led->activated = false;
 	}
 }
-- 
1.7.10.4

