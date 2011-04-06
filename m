Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765Ab1DFLL4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 07:11:56 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:33212 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755579Ab1DFLLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 07:11:19 -0400
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, tglx@linutronix.de, cbouatmailru@gmail.com,
        grant.likely@secretlab.ca, arnd@arndb.de, nico@fluxnic.net,
        Jamie Iles <jamie@jamieiles.com>
Subject: [RFC PATCH 4/7] basic_mmio_gpio: request register regions
Date: Wed,  6 Apr 2011 12:11:00 +0100
Message-Id: <1302088263-12714-5-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1302088263-12714-1-git-send-email-jamie@jamieiles.com>
References: <1302088263-12714-1-git-send-email-jamie@jamieiles.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure that we get the register regions with request_mem_region()
before ioremap() to make sure we have exclusive access.

Signed-off-by: Jamie Iles <jamie@jamieiles.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/gpio/basic_mmio_gpio.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/basic_mmio_gpio.c b/drivers/gpio/basic_mmio_gpio.c
index 68f8b8b..afa854b 100644
--- a/drivers/gpio/basic_mmio_gpio.c
+++ b/drivers/gpio/basic_mmio_gpio.c
@@ -193,6 +193,16 @@ static int bgpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
 	return 0;
 }
 
+static void __iomem *bgpio_request_and_map(struct device *dev,
+					   struct resource *res)
+{
+	if (!devm_request_mem_region(dev, res->start, resource_size(res),
+				     res->name ?: "mmio_gpio"))
+		return NULL;
+
+	return devm_ioremap(dev, res->start, resource_size(res));
+}
+
 static int bgpio_setup_accessors(struct platform_device *pdev,
 				 struct bgpio_chip *bgc)
 {
@@ -259,7 +269,7 @@ static int __devinit bgpio_probe(struct platform_device *pdev)
 	if (!bgc)
 		return -ENOMEM;
 
-	bgc->reg_dat = devm_ioremap(dev, res_dat->start, dat_sz);
+	bgc->reg_dat = bgpio_request_and_map(dev, res_dat);
 	if (!bgc->reg_dat)
 		return -ENOMEM;
 
@@ -270,8 +280,8 @@ static int __devinit bgpio_probe(struct platform_device *pdev)
 				resource_size(res_set) != dat_sz)
 			return -EINVAL;
 
-		bgc->reg_set = devm_ioremap(dev, res_set->start, dat_sz);
-		bgc->reg_clr = devm_ioremap(dev, res_clr->start, dat_sz);
+		bgc->reg_set = bgpio_request_and_map(dev, res_set);
+		bgc->reg_clr = bgpio_request_and_map(dev, res_clr);
 		if (!bgc->reg_set || !bgc->reg_clr)
 			return -ENOMEM;
 	} else if (res_set || res_clr) {
-- 
1.7.4

