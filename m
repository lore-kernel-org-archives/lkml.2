Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917Ab2JQMjg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 08:39:36 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:54222 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755778Ab2JQMhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 08:37:46 -0400
From: Roland Stigge <stigge@antcom.de>
To: gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, plagnioj@jcrosoft.com, highguy@gmail.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH RFC 09/15 v5] gpio-em: Add block GPIO API
Date: Wed, 17 Oct 2012 14:31:41 +0200
Message-Id: <1350477107-26512-10-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1350477107-26512-1-git-send-email-stigge@antcom.de>
References: <1350477107-26512-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds block GPIO API support to the gpio-em driver.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
 drivers/gpio/gpio-em.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- linux-2.6.orig/drivers/gpio/gpio-em.c
+++ linux-2.6/drivers/gpio/gpio-em.c
@@ -203,6 +203,27 @@ static void em_gio_set(struct gpio_chip
 		__em_gio_set(chip, GIO_OH, offset - 16, value);
 }
 
+static unsigned long em_gio_get_block(struct gpio_chip *chip,
+				      unsigned long mask)
+{
+	return (int)(em_gio_read(gpio_to_priv(chip), GIO_I) & mask);
+}
+
+static void em_gio_set_block(struct gpio_chip *chip, unsigned long mask,
+			     unsigned long values)
+{
+	unsigned long mask_ol = mask & 0xFFFF;
+	unsigned long mask_oh = mask >> 16;
+
+	unsigned long values_ol = values & mask_ol;
+	unsigned long values_oh = (values >> 16) & mask_oh;
+
+	em_gio_write(gpio_to_priv(chip), GIO_OL,
+		     mask_ol << 16 | values_ol);
+	em_gio_write(gpio_to_priv(chip), GIO_OH,
+		     mask_oh << 16 | values_oh);
+}
+
 static int em_gio_direction_output(struct gpio_chip *chip, unsigned offset,
 				   int value)
 {
@@ -317,8 +338,10 @@ static int __devinit em_gio_probe(struct
 	gpio_chip = &p->gpio_chip;
 	gpio_chip->direction_input = em_gio_direction_input;
 	gpio_chip->get = em_gio_get;
+	gpio_chip->get_block = em_gio_get_block;
 	gpio_chip->direction_output = em_gio_direction_output;
 	gpio_chip->set = em_gio_set;
+	gpio_chip->set_block = em_gio_set_block;
 	gpio_chip->to_irq = em_gio_to_irq;
 	gpio_chip->label = name;
 	gpio_chip->owner = THIS_MODULE;
