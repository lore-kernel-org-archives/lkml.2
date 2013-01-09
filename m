Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933716Ab3AIUjx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:39:53 -0500
Received: from mail.kernel.org ([198.145.19.201]:42954 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933699Ab3AIUju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:39:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Gabor Juhos <juhosg@openwrt.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [ 059/123] Input: gpio_keys_polled - defer probing if GPIO probing is deferred
Date: Wed,  9 Jan 2013 12:34:58 -0800
Message-Id: <20130109201506.147164124@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <juhosg@openwrt.org>

commit d46329a708c1a3301e272a029266b69339c0877f upstream.

If GPIO probing is deferred, the driver tries to claim an invalid GPIO line
which leads to an error message like this:

  gpio-keys-polled buttons.2: unable to claim gpio 4294966779, err=-22
  gpio-keys-polled: probe of buttons.2 failed with error -22

We should make sure that error code returned by of_get_gpio_flags (including
-EPROBE_DEFER) is propagated up the stack.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/keyboard/gpio_keys_polled.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/input/keyboard/gpio_keys_polled.c
+++ b/drivers/input/keyboard/gpio_keys_polled.c
@@ -136,6 +136,7 @@ gpio_keys_polled_get_devtree_pdata(struc
 
 	i = 0;
 	for_each_child_of_node(node, pp) {
+		int gpio;
 		enum of_gpio_flags flags;
 
 		if (!of_find_property(pp, "gpios", NULL)) {
@@ -144,9 +145,19 @@ gpio_keys_polled_get_devtree_pdata(struc
 			continue;
 		}
 
+		gpio = of_get_gpio_flags(pp, 0, &flags);
+		if (gpio < 0) {
+			error = gpio;
+			if (error != -EPROBE_DEFER)
+				dev_err(dev,
+					"Failed to get gpio flags, error: %d\n",
+					error);
+			goto err_free_pdata;
+		}
+
 		button = &pdata->buttons[i++];
 
-		button->gpio = of_get_gpio_flags(pp, 0, &flags);
+		button->gpio = gpio;
 		button->active_low = flags & OF_GPIO_ACTIVE_LOW;
 
 		if (of_property_read_u32(pp, "linux,code", &button->code)) {


