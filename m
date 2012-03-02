Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509Ab2CBTGV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 14:06:21 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:60576 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759084Ab2CBTGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 14:06:19 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/83xbXlnxMWZhtXWbpWOpq
Date: Fri, 2 Mar 2012 11:06:15 -0800
From: Tony Lindgren <tony@atomide.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>,
        Arnd Bergmann <arnd@arndb.de>, Rajendra Nayak <rnayak@ti.com>,
        linux-mmc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/4] gpiolib: Add gpiochip_find_by_name() and
 gpio_find_by_chip_name()
Message-ID: <20120302190614.GO18901@atomide.com>
References: <20120301185044.29210.44521.stgit@kaulin.local>
 <20120301185524.29210.60381.stgit@kaulin.local>
 <20120302075804.F28DB3E2DB4@localhost>
 <20120302170327.GF18901@atomide.com>
 <20120302180848.GM18901@atomide.com>
 <20120302184833.C296A3E1C63@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120302184833.C296A3E1C63@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Grant Likely <grant.likely@secretlab.ca> [120302 10:16]:
> On Fri, 2 Mar 2012 10:08:48 -0800, Tony Lindgren <tony@atomide.com> wrote:
> > * Tony Lindgren <tony@atomide.com> [120302 08:31]:
> > > * Grant Likely <grant.likely@secretlab.ca> [120302 01:00]:
> > > > On Thu, 01 Mar 2012 10:55:24 -0800, Tony Lindgren <tony@atomide.com> wrote:
> > > > > +
> > > > > +/**
> > > > > + * gpiochip_find_by_name() - iterator for locating a gpio_chip by name
> > > > > + * @name: name of the gpio_chip
> > > > > + *
> > > > > + * Similar to bus_find_device_by_name. It returns a reference to the
> > > > > + * first gpio_chip with matching name. It ignores NULL and empty names.
> > > > > + * If you need to do something more complex, then use gpiochip_find.
> > > > > + */
> > > > > +struct gpio_chip *gpiochip_find_by_name(const char *name)
> > > > > +{
> > > > > +	if (!name || !strcmp(name, ""))
> > > > > +		return NULL;
> > > > > +
> > > > > +	return gpiochip_find((void *)name, match_name);
> > > > 
> > > > Nasty cast.  Can the signature for gpiochip_find be changed to accept
> > > > a (const void *)?
> > > 
> > > I think so, this too comes from the bus code.
> > 
> > Looks like it can't be const as of_node_to_gpiochip uses it with
> > a struct device_node * that for of_get_named_gpio_flags comes from
> > of_parse_phandle_with_args.
> 
> Really? It sees to work fine here:

Hmm right you are. I must have missed adding the const to
of_gpiochip_is_match, that's good news :)

Want to do that as a separate patch or want me to fold it in?

Tony
 
> ---
> 
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index d773540..e633a2a 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -1152,8 +1152,9 @@ EXPORT_SYMBOL_GPL(gpiochip_remove);
>   * non-zero, this function will return to the caller and not iterate over any
>   * more gpio_chips.
>   */
> -struct gpio_chip *gpiochip_find(void *data,
> -				int (*match)(struct gpio_chip *chip, void *data))
> +struct gpio_chip *gpiochip_find(const void *data,
> +				int (*match)(struct gpio_chip *chip,
> +					     const void *data))
>  {
>  	struct gpio_chip *chip = NULL;
>  	unsigned long flags;
> diff --git a/drivers/of/gpio.c b/drivers/of/gpio.c
> index e034b38..bba8121 100644
> --- a/drivers/of/gpio.c
> +++ b/drivers/of/gpio.c
> @@ -229,7 +229,7 @@ void of_gpiochip_remove(struct gpio_chip *chip)
>  }
>  
>  /* Private function for resolving node pointer to gpio_chip */
> -static int of_gpiochip_is_match(struct gpio_chip *chip, void *data)
> +static int of_gpiochip_is_match(struct gpio_chip *chip, const void *data)
>  {
>  	return chip->of_node == data;
>  }
> diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
> index 1ff4e22..5f52690 100644
> --- a/include/asm-generic/gpio.h
> +++ b/include/asm-generic/gpio.h
> @@ -142,9 +142,9 @@ extern int __must_check gpiochip_reserve(int start, int ngpio);
>  /* add/remove chips */
>  extern int gpiochip_add(struct gpio_chip *chip);
>  extern int __must_check gpiochip_remove(struct gpio_chip *chip);
> -extern struct gpio_chip *gpiochip_find(void *data,
> +extern struct gpio_chip *gpiochip_find(const void *data,
>  					int (*match)(struct gpio_chip *chip,
> -						     void *data));
> +						     const void *data));
>  
>  
>  /* Always use the library code for GPIO management calls,
> 
