Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab1HISFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 14:05:35 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:14988 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313Ab1HISFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 14:05:34 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-160.messagelabs.com!1312913073!31116557!14
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.72]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: gpio-ep93xx: Add helper function to convert irq to gpio, port, and mask.
Date: Tue, 9 Aug 2011 11:04:13 -0700
User-Agent: KMail/1.9.9
CC: <rmallon@gmail.com>, <grant.likely@secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201108091104.14053.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This consolidates the irq_to_gpio() call and the shift magic used to convert
a GPIO irq into it's relevant GPIO, port, and mask values.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>

---

diff --git a/drivers/gpio/gpio-ep93xx.c b/drivers/gpio/gpio-ep93xx.c
index 468b27d..788c7c4 100644
--- a/drivers/gpio/gpio-ep93xx.c
+++ b/drivers/gpio/gpio-ep93xx.c
@@ -46,6 +46,20 @@ static const u8 eoi_register_offset[3]		= { 0x98, 0xb4, 0x54 };
 static const u8 int_en_register_offset[3]	= { 0x9c, 0xb8, 0x58 };
 static const u8 int_debounce_register_offset[3]	= { 0xa8, 0xc4, 0x64 };
 
+/*
+ * Map a sw irq to it's GPIO port and mask.
+ */
+static int ep93xx_gpio_irq_to_gpio_port_mask(unsigned int irq,
+			int *port, int *port_mask)
+{
+	int gpio = irq_to_gpio(irq);
+
+	*port = gpio >> 3;
+	*port_mask = 1 << (gpio & 7);
+
+	return gpio;
+}
+
 static void ep93xx_gpio_update_int_params(unsigned port)
 {
 	BUG_ON(port > 2);
@@ -69,9 +83,9 @@ static inline void ep93xx_gpio_int_mask(unsigned line)
 
 static void ep93xx_gpio_int_debounce(unsigned int irq, bool enable)
 {
-	int line = irq_to_gpio(irq);
-	int port = line >> 3;
-	int port_mask = 1 << (line & 7);
+	int port, port_mask;
+
+	ep93xx_gpio_irq_to_gpio_port_mask(irq, &port, &port_mask);
 
 	if (enable)
 		gpio_int_debounce[port] |= port_mask;
@@ -119,9 +133,9 @@ static void ep93xx_gpio_f_irq_handler(unsigned int irq, struct irq_desc *desc)
 
 static void ep93xx_gpio_irq_ack(struct irq_data *d)
 {
-	int line = irq_to_gpio(d->irq);
-	int port = line >> 3;
-	int port_mask = 1 << (line & 7);
+	int port, port_mask;
+
+	ep93xx_gpio_irq_to_gpio_port_mask(d->irq, &port, &port_mask);
 
 	if (irqd_get_trigger_type(d) == IRQ_TYPE_EDGE_BOTH) {
 		gpio_int_type2[port] ^= port_mask; /* switch edge direction */
@@ -133,9 +147,9 @@ static void ep93xx_gpio_irq_ack(struct irq_data *d)
 
 static void ep93xx_gpio_irq_mask_ack(struct irq_data *d)
 {
-	int line = irq_to_gpio(d->irq);
-	int port = line >> 3;
-	int port_mask = 1 << (line & 7);
+	int port, port_mask;
+
+	ep93xx_gpio_irq_to_gpio_port_mask(d->irq, &port, &port_mask);
 
 	if (irqd_get_trigger_type(d) == IRQ_TYPE_EDGE_BOTH)
 		gpio_int_type2[port] ^= port_mask; /* switch edge direction */
@@ -148,19 +162,21 @@ static void ep93xx_gpio_irq_mask_ack(struct irq_data *d)
 
 static void ep93xx_gpio_irq_mask(struct irq_data *d)
 {
-	int line = irq_to_gpio(d->irq);
-	int port = line >> 3;
+	int port, port_mask;
+
+	ep93xx_gpio_irq_to_gpio_port_mask(d->irq, &port, &port_mask);
 
-	gpio_int_unmasked[port] &= ~(1 << (line & 7));
+	gpio_int_unmasked[port] &= ~port_mask;
 	ep93xx_gpio_update_int_params(port);
 }
 
 static void ep93xx_gpio_irq_unmask(struct irq_data *d)
 {
-	int line = irq_to_gpio(d->irq);
-	int port = line >> 3;
+	int port, port_mask;
+
+	ep93xx_gpio_irq_to_gpio_port_mask(d->irq, &port, &port_mask);
 
-	gpio_int_unmasked[port] |= 1 << (line & 7);
+	gpio_int_unmasked[port] |= port_mask;
 	ep93xx_gpio_update_int_params(port);
 }
 
@@ -171,11 +187,11 @@ static void ep93xx_gpio_irq_unmask(struct irq_data *d)
  */
 static int ep93xx_gpio_irq_type(struct irq_data *d, unsigned int type)
 {
-	const int gpio = irq_to_gpio(d->irq);
-	const int port = gpio >> 3;
-	const int port_mask = 1 << (gpio & 7);
+	int gpio, port, port_mask;
 	irq_flow_handler_t handler;
 
+	gpio = ep93xx_gpio_irq_to_gpio_port_mask(d->irq, &port, &port_mask);
+
 	gpio_direction_input(gpio);
 
 	switch (type) {
