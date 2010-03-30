Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504Ab0C3X6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:58:39 -0400
Received: from kroah.org ([198.145.64.141]:45523 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932082Ab0C3XTB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:19:01 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:57:09 2010
Message-Id: <20100330225709.206181912@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:56:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Richard Purdie <rpurdie@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [105/116] leds-gpio: fix default state handling on OF platforms
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Anton Vorontsov <avorontsov@ru.mvista.com>

commit 0493a4ff10959ff4c8e0d65efee25b7ffd4fa5db upstream.

The driver wrongly sets default state for LEDs that don't specify
default-state property.

Currently the driver handles default state this way:

memset(&led, 0, sizeof(led));
for_each_child_of_node(np, child) {
	state = of_get_property(child, "default-state", NULL);
	if (state) {
		if (!strcmp(state, "keep"))
			led.default_state = LEDS_GPIO_DEFSTATE_KEEP;
		...
	}
	ret = create_gpio_led(&led, ...);
}

Which means that all LEDs that do not specify default-state will inherit
the last value of the default-state property, which is wrong.

This patch fixes the issue by moving LED's template initialization into
the loop body.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Richard Purdie <rpurdie@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@ -211,7 +211,6 @@ static int __devinit of_gpio_leds_probe(struct of_device *ofdev,
 					const struct of_device_id *match)
 {
 	struct device_node *np = ofdev->node, *child;
-	struct gpio_led led;
 	struct gpio_led_of_platform_data *pdata;
 	int count = 0, ret;
 
@@ -226,8 +225,8 @@ static int __devinit of_gpio_leds_probe(struct of_device *ofdev,
 	if (!pdata)
 		return -ENOMEM;
 
-	memset(&led, 0, sizeof(led));
 	for_each_child_of_node(np, child) {
+		struct gpio_led led = {};
 		enum of_gpio_flags flags;
 		const char *state;
 


