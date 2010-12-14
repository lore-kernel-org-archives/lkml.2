Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759947Ab0LNUno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 15:43:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51656 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758310Ab0LNUnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 15:43:42 -0500
Date: Tue, 14 Dec 2010 12:43:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Mike Frysinger <vapier@gentoo.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [PATCH] gpiolib: Convert ADP5588 to new irq_ APIs
Message-Id: <20101214124332.07f2a212.akpm@linux-foundation.org>
In-Reply-To: <1292159988-28268-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1292159988-28268-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Dec 2010 13:19:48 +0000
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> The genirq core is being updated to pass struct irq_data to irq_chip
> operations instead of an irq number. Update the ADP5588 GPIO driver to
> the new API.

Seems to be the same as Lennert's patch, except he called it "d"?



From: Lennert Buytenhek <buytenh@wantstofly.org>

Signed-off-by: Lennert Buytenhek <buytenh@secretlab.ca>
Acked-by: "Hennerich, Michael" <Michael.Hennerich@analog.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/adp5588-gpio.c |   39 +++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 19 deletions(-)

diff -puN drivers/gpio/adp5588-gpio.c~gpio-adp5588-gpio-irq_data-conversion drivers/gpio/adp5588-gpio.c
--- a/drivers/gpio/adp5588-gpio.c~gpio-adp5588-gpio-irq_data-conversion
+++ a/drivers/gpio/adp5588-gpio.c
@@ -146,9 +146,10 @@ static int adp5588_gpio_to_irq(struct gp
 	return dev->irq_base + off;
 }
 
-static void adp5588_irq_bus_lock(unsigned int irq)
+static void adp5588_irq_bus_lock(struct irq_data *d)
 {
-	struct adp5588_gpio *dev = get_irq_chip_data(irq);
+	struct adp5588_gpio *dev = irq_data_get_irq_chip_data(d);
+
 	mutex_lock(&dev->irq_lock);
 }
 
@@ -160,9 +161,9 @@ static void adp5588_irq_bus_lock(unsigne
   * and unlocks the bus.
   */
 
-static void adp5588_irq_bus_sync_unlock(unsigned int irq)
+static void adp5588_irq_bus_sync_unlock(struct irq_data *d)
 {
-	struct adp5588_gpio *dev = get_irq_chip_data(irq);
+	struct adp5588_gpio *dev = irq_data_get_irq_chip_data(d);
 	int i;
 
 	for (i = 0; i <= ADP5588_BANK(ADP5588_MAXGPIO); i++)
@@ -175,31 +176,31 @@ static void adp5588_irq_bus_sync_unlock(
 	mutex_unlock(&dev->irq_lock);
 }
 
-static void adp5588_irq_mask(unsigned int irq)
+static void adp5588_irq_mask(struct irq_data *d)
 {
-	struct adp5588_gpio *dev = get_irq_chip_data(irq);
-	unsigned gpio = irq - dev->irq_base;
+	struct adp5588_gpio *dev = irq_data_get_irq_chip_data(d);
+	unsigned gpio = d->irq - dev->irq_base;
 
 	dev->irq_mask[ADP5588_BANK(gpio)] &= ~ADP5588_BIT(gpio);
 }
 
-static void adp5588_irq_unmask(unsigned int irq)
+static void adp5588_irq_unmask(struct irq_data *d)
 {
-	struct adp5588_gpio *dev = get_irq_chip_data(irq);
-	unsigned gpio = irq - dev->irq_base;
+	struct adp5588_gpio *dev = irq_data_get_irq_chip_data(d);
+	unsigned gpio = d->irq - dev->irq_base;
 
 	dev->irq_mask[ADP5588_BANK(gpio)] |= ADP5588_BIT(gpio);
 }
 
-static int adp5588_irq_set_type(unsigned int irq, unsigned int type)
+static int adp5588_irq_set_type(struct irq_data *d, unsigned int type)
 {
-	struct adp5588_gpio *dev = get_irq_chip_data(irq);
-	uint16_t gpio = irq - dev->irq_base;
+	struct adp5588_gpio *dev = irq_data_get_irq_chip_data(d);
+	uint16_t gpio = d->irq - dev->irq_base;
 	unsigned bank, bit;
 
 	if ((type & IRQ_TYPE_EDGE_BOTH)) {
 		dev_err(&dev->client->dev, "irq %d: unsupported type %d\n",
-			irq, type);
+			d->irq, type);
 		return -EINVAL;
 	}
 
@@ -222,11 +223,11 @@ static int adp5588_irq_set_type(unsigned
 
 static struct irq_chip adp5588_irq_chip = {
 	.name			= "adp5588",
-	.mask			= adp5588_irq_mask,
-	.unmask			= adp5588_irq_unmask,
-	.bus_lock		= adp5588_irq_bus_lock,
-	.bus_sync_unlock	= adp5588_irq_bus_sync_unlock,
-	.set_type		= adp5588_irq_set_type,
+	.irq_mask		= adp5588_irq_mask,
+	.irq_unmask		= adp5588_irq_unmask,
+	.irq_bus_lock		= adp5588_irq_bus_lock,
+	.irq_bus_sync_unlock	= adp5588_irq_bus_sync_unlock,
+	.irq_set_type		= adp5588_irq_set_type,
 };
 
 static int adp5588_gpio_read_intstat(struct i2c_client *client, u8 *buf)
_

