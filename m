Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759427Ab2CICJm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 21:09:42 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:10928 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757685Ab2CICJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 21:09:40 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19lNg/YXdaoPgeOBLBXmgnS
Date: Thu, 8 Mar 2012 18:09:36 -0800
From: Tony Lindgren <tony@atomide.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>,
        Arnd Bergmann <arnd@arndb.de>, Rajendra Nayak <rnayak@ti.com>,
        linux-mmc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/4] gpiolib: Add gpiochip_find_by_name() and
 gpio_find_by_chip_name()
Message-ID: <20120309020935.GD12083@atomide.com>
References: <20120301185044.29210.44521.stgit@kaulin.local>
 <20120301185524.29210.60381.stgit@kaulin.local>
 <20120302075804.F28DB3E2DB4@localhost>
 <20120302170327.GF18901@atomide.com>
 <20120302180848.GM18901@atomide.com>
 <20120302184833.C296A3E1C63@localhost>
 <20120302190614.GO18901@atomide.com>
 <20120309010555.8DE213E0901@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120309010555.8DE213E0901@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Grant Likely <grant.likely@secretlab.ca> [120308 17:08]:
> On Fri, 2 Mar 2012 11:06:15 -0800, Tony Lindgren <tony@atomide.com> wrote:
> > 
> > Want to do that as a separate patch or want me to fold it in?
> 
> I've got it as a separate commit in my gpio/next branch.

OK great, below is my patch updated against gpio/next if you
want to pick it up.

Regards,

Tony


From: Tony Lindgren <tony@atomide.com>
Date: Fri, 2 Mar 2012 11:30:23 -0800
Subject: [PATCH] gpiolib: Add gpiochip_find_by_name() and gpio_find_by_chip_name()

Currently there is no way for drivers to request a GPIO on a particular
gpio chip using platform data. This makes it hard to support multiple
GPIO controllers with platform driver with dynamic GPIO and interrupt
numbering, such as with CONFIG_SPARSE_IRQ.

Let's make it easier for platform device drivers to find GPIOs on a
specific gpio_chip by adding two functions: gpiochip_find_by_name()
and gpio_find_by_chip_name().

Note that these functions should not be used with device tree as
pointed out by Grant Likely <grant.likely@secretlab.ca> as the names
are instantiated from device tree.

As gpiochip_find() is already exported, we may as well export
gpiochip_find_by_name() too.

Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Rajendra Nayak <rnayak@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>

--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1178,6 +1178,51 @@ struct gpio_chip *gpiochip_find(const void *data,
 }
 EXPORT_SYMBOL_GPL(gpiochip_find);
 
+static int gpiochip_match_name(struct gpio_chip *chip, const void *name)
+{
+	return !strcmp(name, chip->label);
+}
+
+/**
+ * gpiochip_find_by_name() - iterator for locating a gpio_chip by name
+ * @name: name of the gpio_chip
+ *
+ * Similar to bus_find_device_by_name. It returns a reference to the
+ * first gpio_chip with matching name. It ignores NULL and empty names.
+ * If you need to do something more complex, then use gpiochip_find.
+ */
+struct gpio_chip *gpiochip_find_by_name(const char *name)
+{
+	if (!name || !strcmp(name, ""))
+		return NULL;
+
+	return gpiochip_find(name, gpiochip_match_name);
+}
+EXPORT_SYMBOL_GPL(gpiochip_find_by_name);
+
+/**
+ * gpio_find_by_chip_name() - find a gpio on a specific gpio_chip
+ * @chip_name: name of the gpio_chip
+ * @gpio_offset: offset of the gpio on the gpio_chip
+ *
+ * Note that gpiochip_find_by_name returns the first matching
+ * gpio_chip name. For more complex matching, see gpio_find.
+ */
+int gpio_find_by_chip_name(const char *chip_name, unsigned gpio_offset)
+{
+	struct gpio_chip *chip;
+	int gpio;
+
+	chip = gpiochip_find_by_name(chip_name);
+	if (!chip)
+		return -ENODEV;
+
+	gpio = chip->base + gpio_offset;
+
+	return gpio;
+}
+EXPORT_SYMBOL_GPL(gpio_find_by_chip_name);
+
 /* These "optional" allocation calls help prevent drivers from stomping
  * on each other, and help provide better diagnostics in debugfs.
  * They're called even less than the "set direction" calls.
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -145,7 +145,8 @@ extern int __must_check gpiochip_remove(struct gpio_chip *chip);
 extern struct gpio_chip *gpiochip_find(const void *data,
 					int (*match)(struct gpio_chip *chip,
 						     const void *data));
-
+extern struct gpio_chip *gpiochip_find_by_name(const char *name);
+extern int gpio_find_by_chip_name(const char *chip_name, unsigned gpio_offset);
 
 /* Always use the library code for GPIO management calls,
  * or when sleeping may be involved.
