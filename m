Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965042Ab2CBSsi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 13:48:38 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33507 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539Ab2CBSsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 13:48:36 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of grant.likely@secretlab.ca designates 10.68.212.232 as permitted sender) smtp.mail=grant.likely@secretlab.ca
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/4] gpiolib: Add gpiochip_find_by_name() and gpio_find_by_chip_name()
To: Tony Lindgren <tony@atomide.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>,
        Arnd Bergmann <arnd@arndb.de>, Rajendra Nayak <rnayak@ti.com>,
        linux-mmc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <20120302180848.GM18901@atomide.com>
References: <20120301185044.29210.44521.stgit@kaulin.local> <20120301185524.29210.60381.stgit@kaulin.local> <20120302075804.F28DB3E2DB4@localhost> <20120302170327.GF18901@atomide.com> <20120302180848.GM18901@atomide.com>
Date: Fri, 02 Mar 2012 11:48:33 -0700
Message-Id: <20120302184833.C296A3E1C63@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2012 10:08:48 -0800, Tony Lindgren <tony@atomide.com> wrote:
> * Tony Lindgren <tony@atomide.com> [120302 08:31]:
> > * Grant Likely <grant.likely@secretlab.ca> [120302 01:00]:
> > > On Thu, 01 Mar 2012 10:55:24 -0800, Tony Lindgren <tony@atomide.com> wrote:
> > > > +
> > > > +/**
> > > > + * gpiochip_find_by_name() - iterator for locating a gpio_chip by name
> > > > + * @name: name of the gpio_chip
> > > > + *
> > > > + * Similar to bus_find_device_by_name. It returns a reference to the
> > > > + * first gpio_chip with matching name. It ignores NULL and empty names.
> > > > + * If you need to do something more complex, then use gpiochip_find.
> > > > + */
> > > > +struct gpio_chip *gpiochip_find_by_name(const char *name)
> > > > +{
> > > > +	if (!name || !strcmp(name, ""))
> > > > +		return NULL;
> > > > +
> > > > +	return gpiochip_find((void *)name, match_name);
> > > 
> > > Nasty cast.  Can the signature for gpiochip_find be changed to accept
> > > a (const void *)?
> > 
> > I think so, this too comes from the bus code.
> 
> Looks like it can't be const as of_node_to_gpiochip uses it with
> a struct device_node * that for of_get_named_gpio_flags comes from
> of_parse_phandle_with_args.

Really? It sees to work fine here:

---

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index d773540..e633a2a 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1152,8 +1152,9 @@ EXPORT_SYMBOL_GPL(gpiochip_remove);
  * non-zero, this function will return to the caller and not iterate over any
  * more gpio_chips.
  */
-struct gpio_chip *gpiochip_find(void *data,
-				int (*match)(struct gpio_chip *chip, void *data))
+struct gpio_chip *gpiochip_find(const void *data,
+				int (*match)(struct gpio_chip *chip,
+					     const void *data))
 {
 	struct gpio_chip *chip = NULL;
 	unsigned long flags;
diff --git a/drivers/of/gpio.c b/drivers/of/gpio.c
index e034b38..bba8121 100644
--- a/drivers/of/gpio.c
+++ b/drivers/of/gpio.c
@@ -229,7 +229,7 @@ void of_gpiochip_remove(struct gpio_chip *chip)
 }
 
 /* Private function for resolving node pointer to gpio_chip */
-static int of_gpiochip_is_match(struct gpio_chip *chip, void *data)
+static int of_gpiochip_is_match(struct gpio_chip *chip, const void *data)
 {
 	return chip->of_node == data;
 }
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 1ff4e22..5f52690 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -142,9 +142,9 @@ extern int __must_check gpiochip_reserve(int start, int ngpio);
 /* add/remove chips */
 extern int gpiochip_add(struct gpio_chip *chip);
 extern int __must_check gpiochip_remove(struct gpio_chip *chip);
-extern struct gpio_chip *gpiochip_find(void *data,
+extern struct gpio_chip *gpiochip_find(const void *data,
 					int (*match)(struct gpio_chip *chip,
-						     void *data));
+						     const void *data));
 
 
 /* Always use the library code for GPIO management calls,

