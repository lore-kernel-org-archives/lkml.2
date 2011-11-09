Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933411Ab1KIBXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 20:23:48 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41908 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab1KIBXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 20:23:41 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        Sascha Hauer <kernel@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Michal Simek <monstr@monstr.eu>
Subject: [RFC 1/8] gpio/microblaze: Eliminate duplication of of_get_named_gpio_flags()
Date: Tue,  8 Nov 2011 18:19:36 -0700
Message-Id: <1320801583-12774-2-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1320801583-12774-1-git-send-email-grant.likely@secretlab.ca>
References: <1320801583-12774-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_reset_gpio_handle() is largely a cut-and-paste copy of
of_get_named_gpio_flags(). There really isn't any reason for the
split, so this patch deletes the duplicate function

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/reset.c |   43 +--------------------------------------
 1 files changed, 2 insertions(+), 41 deletions(-)

diff --git a/arch/microblaze/kernel/reset.c b/arch/microblaze/kernel/reset.c
index bd8ccab..88a0163 100644
--- a/arch/microblaze/kernel/reset.c
+++ b/arch/microblaze/kernel/reset.c
@@ -19,50 +19,11 @@
 static int handle; /* reset pin handle */
 static unsigned int reset_val;
 
-static int of_reset_gpio_handle(void)
-{
-	int ret; /* variable which stored handle reset gpio pin */
-	struct device_node *root; /* root node */
-	struct device_node *gpio; /* gpio node */
-	struct gpio_chip *gc;
-	u32 flags;
-	const void *gpio_spec;
-
-	/* find out root node */
-	root = of_find_node_by_path("/");
-
-	/* give me handle for gpio node to be possible allocate pin */
-	ret = of_parse_phandles_with_args(root, "hard-reset-gpios",
-				"#gpio-cells", 0, &gpio, &gpio_spec);
-	if (ret) {
-		pr_debug("%s: can't parse gpios property\n", __func__);
-		goto err0;
-	}
-
-	gc = of_node_to_gpiochip(gpio);
-	if (!gc) {
-		pr_debug("%s: gpio controller %s isn't registered\n",
-			 root->full_name, gpio->full_name);
-		ret = -ENODEV;
-		goto err1;
-	}
-
-	ret = gc->of_xlate(gc, root, gpio_spec, &flags);
-	if (ret < 0)
-		goto err1;
-
-	ret += gc->base;
-err1:
-	of_node_put(gpio);
-err0:
-	pr_debug("%s exited with status %d\n", __func__, ret);
-	return ret;
-}
-
 void of_platform_reset_gpio_probe(void)
 {
 	int ret;
-	handle = of_reset_gpio_handle();
+	handle = of_get_named_gpio(of_find_node_by_path("/"),
+				   "hard-reset-gpios", 0);
 
 	if (!gpio_is_valid(handle)) {
 		printk(KERN_INFO "Skipping unavailable RESET gpio %d (%s)\n",
-- 
1.7.5.4

