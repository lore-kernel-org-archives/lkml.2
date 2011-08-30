Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab1H3XkI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 19:40:08 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:17871 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292Ab1H3XkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 19:40:05 -0400
From: David Daney <david.daney@cavium.com>
To: linux-kernel@vger.kernel.org
Cc: David Daney <david.daney@cavium.com>, Richard Purdie <rpurdie@rpsys.net>,
        Trent Piepho <xyzzy@speakeasy.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] leds/of: leds-gpio.c: Use gpio_get_value_cansleep() when initializing.
Date: Tue, 30 Aug 2011 16:39:52 -0700
Message-Id: <1314747592-20975-1-git-send-email-david.daney@cavium.com>
X-Mailer: git-send-email 1.7.2.3
X-OriginalArrivalTime: 30 Aug 2011 23:40:05.0417 (UTC) FILETIME=[25255990:01CC676E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I get the following warning:

------------[ cut here ]------------
WARNING: at drivers/gpio/gpiolib.c:1559 __gpio_get_value+0x90/0x98()
Modules linked in:
Call Trace:
[<ffffffff81440950>] dump_stack+0x8/0x34
[<ffffffff81141478>] warn_slowpath_common+0x78/0xa0
[<ffffffff812f0958>] __gpio_get_value+0x90/0x98
[<ffffffff81434f04>] create_gpio_led+0xdc/0x194
[<ffffffff8143524c>] gpio_led_probe+0x290/0x36c
[<ffffffff8130e8b0>] driver_probe_device+0x78/0x1b0
[<ffffffff8130eaa8>] __driver_attach+0xc0/0xc8
[<ffffffff8130d7ac>] bus_for_each_dev+0x64/0xb0
[<ffffffff8130e130>] bus_add_driver+0x1c8/0x2a8
[<ffffffff8130f100>] driver_register+0x90/0x180
[<ffffffff81100438>] do_one_initcall+0x38/0x160

---[ end trace ee38723fbefcd65c ]---

My GPIOs are on an I2C port expander, so we must use the *_cansleep()
variant of the GPIO functions.  This is was not being done in
create_gpio_led().

We can change gpio_get_value() to gpio_get_value_cansleep() because it
is only called from the platform_driver probe function, which is a
context where we can sleep.

Only tested on my gpio_cansleep() system, but it seems safe for all
systems.

Signed-off-by: David Daney <david.daney@cavium.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Trent Piepho <xyzzy@speakeasy.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/leds/leds-gpio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
index 3d8bc32..504cc26 100644
--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@ -121,7 +121,7 @@ static int __devinit create_gpio_led(const struct gpio_led *template,
 	}
 	led_dat->cdev.brightness_set = gpio_led_set;
 	if (template->default_state == LEDS_GPIO_DEFSTATE_KEEP)
-		state = !!gpio_get_value(led_dat->gpio) ^ led_dat->active_low;
+		state = !!gpio_get_value_cansleep(led_dat->gpio) ^ led_dat->active_low;
 	else
 		state = (template->default_state == LEDS_GPIO_DEFSTATE_ON);
 	led_dat->cdev.brightness = state ? LED_FULL : LED_OFF;
-- 
1.7.2.3

