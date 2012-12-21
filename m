Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab2LUPIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 10:08:18 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:44786 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab2LUPIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 10:08:06 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: linux-leds@vger.kernel.org
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [RESEND PATCH] leds: leds-gpio: set devm_gpio_request_one() flags correctly
Date: Fri, 21 Dec 2012 16:07:44 +0100
Message-Id: <1356102464-22234-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit a99d76f leds: leds-gpio: use gpio_request_one

changed the leds-gpio driver to use gpio_request_one() instead
of gpio_request() + gpio_direction_output()

Unfortunately, it also made a semantic change that breaks the
leds-gpio driver.

The gpio_request_one() flags parameter was set to:

GPIOF_DIR_OUT | (led_dat->active_low ^ state)

Since GPIOF_DIR_OUT is 0, the final flags value will just be the
XOR'ed value of led_dat->active_low and state.

This value were used to distinguish between HIGH/LOW output initial
level and call gpio_direction_output() accordingly.

With this new semantic gpio_request_one() will take the flags value
of 1 as a configuration of input direction (GPIOF_DIR_IN) and will
call gpio_direction_input() instead of gpio_direction_output().

int gpio_request_one(unsigned gpio, unsigned long flags, const char *label)
{
..
	if (flags & GPIOF_DIR_IN)
		err = gpio_direction_input(gpio);
	else
		err = gpio_direction_output(gpio,
				(flags & GPIOF_INIT_HIGH) ? 1 : 0);
..
}

The right semantic is to evaluate led_dat->active_low ^ state and
set the output initial level explicitly.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---

This makes LEDs to work again on my IGEPv2 board (TI OMAP3 based SoC).

I sent this patch before but then realized that I only cc'ed to linux-leds.
So, I'm resending the patch cc'ing linux-omap,linux-arm-kernel and LKML to
reach a broader audience and have more people review/test the patch.

Sorry for the noise if someone got it twice.

 drivers/leds/leds-gpio.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
index 1885a26..a0d931b 100644
--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@ -127,8 +127,9 @@ static int create_gpio_led(const struct gpio_led *template,
 		led_dat->cdev.flags |= LED_CORE_SUSPENDRESUME;
 
 	ret = devm_gpio_request_one(parent, template->gpio,
-			GPIOF_DIR_OUT | (led_dat->active_low ^ state),
-			template->name);
+				    (led_dat->active_low ^ state) ?
+				    GPIOF_OUT_INIT_HIGH : GPIOF_OUT_INIT_LOW,
+				    template->name);
 	if (ret < 0)
 		return ret;
 
-- 
1.7.7.6

