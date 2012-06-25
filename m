Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab2FYPRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 11:17:20 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64478 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575Ab2FYPRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 11:17:18 -0400
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Cc: Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Tobias Klauser <tklauser@distanz.ch>, David Jander <david@protonic.nl>,
        Laxman Dewangan <ldewangan@nvidia.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: [PATCH] input: gpio_keys: Cleanup devicetree parser
Date: Mon, 25 Jun 2012 12:17:01 -0300
Message-Id: <1340637423-12072-1-git-send-email-aletes.xgr@gmail.com>
X-Mailer: git-send-email 1.7.10
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix sizeof in memset.
Cleanup dt properties extraction.
Use for_each macro.
Use of_match_ptr macro.

Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
---
 drivers/input/keyboard/gpio_keys.c |   30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
index 62bfce4..1ef15ae 100644
--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -548,22 +548,16 @@ static int gpio_keys_get_devtree_pdata(struct device *dev,
 	struct device_node *node, *pp;
 	int i;
 	struct gpio_keys_button *buttons;
-	u32 reg;
 
 	node = dev->of_node;
 	if (node == NULL)
 		return -ENODEV;
 
-	memset(pdata, 0, sizeof *pdata);
+	memset(pdata, 0, sizeof(*pdata));
 
 	pdata->rep = !!of_get_property(node, "autorepeat", NULL);
 
-	/* First count the subnodes */
-	pdata->nbuttons = 0;
-	pp = NULL;
-	while ((pp = of_get_next_child(node, pp)))
-		pdata->nbuttons++;
-
+	pdata->nbuttons = of_get_child_count(node);
 	if (pdata->nbuttons == 0)
 		return -ENODEV;
 
@@ -571,9 +565,8 @@ static int gpio_keys_get_devtree_pdata(struct device *dev,
 	if (!buttons)
 		return -ENOMEM;
 
-	pp = NULL;
 	i = 0;
-	while ((pp = of_get_next_child(node, pp))) {
+	for_each_child_of_node(node, pp) {
 		enum of_gpio_flags flags;
 
 		if (!of_find_property(pp, "gpios", NULL)) {
@@ -584,24 +577,21 @@ static int gpio_keys_get_devtree_pdata(struct device *dev,
 		buttons[i].gpio = of_get_gpio_flags(pp, 0, &flags);
 		buttons[i].active_low = flags & OF_GPIO_ACTIVE_LOW;
 
-		if (of_property_read_u32(pp, "linux,code", &reg)) {
+		if (of_property_read_u32(pp, "linux,code", &buttons[i].code)) {
 			dev_err(dev, "Button without keycode: 0x%x\n", buttons[i].gpio);
 			goto out_fail;
 		}
-		buttons[i].code = reg;
 
 		buttons[i].desc = of_get_property(pp, "label", NULL);
 
-		if (of_property_read_u32(pp, "linux,input-type", &reg) == 0)
-			buttons[i].type = reg;
-		else
+		if (of_property_read_u32(pp, "linux,input-type",
+			&buttons[i].type))
 			buttons[i].type = EV_KEY;
 
 		buttons[i].wakeup = !!of_get_property(pp, "gpio-key,wakeup", NULL);
 
-		if (of_property_read_u32(pp, "debounce-interval", &reg) == 0)
-			buttons[i].debounce_interval = reg;
-		else
+		if (of_property_read_u32(pp, "debounce-interval",
+			&buttons[i].debounce_interval))
 			buttons[i].debounce_interval = 5;
 
 		i++;
@@ -630,8 +620,6 @@ static int gpio_keys_get_devtree_pdata(struct device *dev,
 	return -ENODEV;
 }
 
-#define gpio_keys_of_match NULL
-
 #endif
 
 static void gpio_remove_key(struct gpio_button_data *bdata)
@@ -823,7 +811,7 @@ static struct platform_driver gpio_keys_device_driver = {
 		.name	= "gpio-keys",
 		.owner	= THIS_MODULE,
 		.pm	= &gpio_keys_pm_ops,
-		.of_match_table = gpio_keys_of_match,
+		.of_match_table = of_match_ptr(gpio_keys_of_match),
 	}
 };
 
-- 
1.7.10

