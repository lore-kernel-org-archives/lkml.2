Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab2CBRDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 12:03:33 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:43878 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab2CBRDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 12:03:31 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18Fm2pJAhiujdQSuD/+/rIi
Date: Fri, 2 Mar 2012 09:03:27 -0800
From: Tony Lindgren <tony@atomide.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>,
        Arnd Bergmann <arnd@arndb.de>, Rajendra Nayak <rnayak@ti.com>,
        linux-mmc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/4] gpiolib: Add gpiochip_find_by_name() and
 gpio_find_by_chip_name()
Message-ID: <20120302170327.GF18901@atomide.com>
References: <20120301185044.29210.44521.stgit@kaulin.local>
 <20120301185524.29210.60381.stgit@kaulin.local>
 <20120302075804.F28DB3E2DB4@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120302075804.F28DB3E2DB4@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Correcting a typo in the LKML address..

* Grant Likely <grant.likely@secretlab.ca> [120302 01:00]:
> On Thu, 01 Mar 2012 10:55:24 -0800, Tony Lindgren <tony@atomide.com> wrote:
> > Currently there is no way for drivers to request a GPIO on a particular
> > gpio chip. This makes it hard to support multiple GPIO controllers
> > with dynamic GPIO and interrupt numbering, such as with CONFIG_SPARSE_IRQ.
> > 
> > Make it easier for device drivers to find GPIOs on a specific gpio_chip
> > by adding two functions: gpiochip_find_by_name() and gpio_find_by_chip_name().
> > 
> > Note that as gpiochip_find() is already exported, we may as well
> > export gpiochip_find_by_name() too.
> 
> How is the device going to know the name of the gpio controller?  I
> don't particularly like interfaces that find devices by-names since
> I don't think device names can be relied to be stable when devices
> are instantiated from device tree data.

The gpio_chip name + gpio offset is coming from pdata until things
are converted over to use DT.

For DT, this should not be needed, this is needed for removing callbacks
in pdata so we can clean up some drivers and keep them working with
both pdata and DT until things are converted over to DT.

> > +static int match_name(struct gpio_chip *chip, void *data)
> 
> Even though this is a static, please keep the prefix to avoid
> namespace conflicts.  gpiochip_match_name()
> 
> > +{
> > +	const char *name = data;
> 
> This is unnecessary; the void* can be passed directly to sysfs_streq...
> but why is sysfs_streq being used here instead of strcmp?  This is 
> not sysfs related code.

That comes from the bus code, will take a look.
 
> > +
> > +	return sysfs_streq(name, chip->label);
> > +}
> > +
> > +/**
> > + * gpiochip_find_by_name() - iterator for locating a gpio_chip by name
> > + * @name: name of the gpio_chip
> > + *
> > + * Similar to bus_find_device_by_name. It returns a reference to the
> > + * first gpio_chip with matching name. It ignores NULL and empty names.
> > + * If you need to do something more complex, then use gpiochip_find.
> > + */
> > +struct gpio_chip *gpiochip_find_by_name(const char *name)
> > +{
> > +	if (!name || !strcmp(name, ""))
> > +		return NULL;
> > +
> > +	return gpiochip_find((void *)name, match_name);
> 
> Nasty cast.  Can the signature for gpiochip_find be changed to accept
> a (const void *)?

I think so, this too comes from the bus code.

Regards,

Tony 
