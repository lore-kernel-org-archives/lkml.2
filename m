Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab1GODZR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 23:25:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58408 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755137Ab1GODZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 23:25:15 -0400
Date: Fri, 15 Jul 2011 12:25:05 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Greg KH <greg@kroah.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        Graeme Gregory <gg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] regmap: Add generic non-memory mapped register
 access API
Message-ID: <20110715032503.GH32716@opensource.wolfsonmicro.com>
References: <20110709044923.GB13074@opensource.wolfsonmicro.com>
 <1310187044-13269-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20110715025326.GH2927@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110715025326.GH2927@ponder.secretlab.ca>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 08:53:26PM -0600, Grant Likely wrote:

Please delete unneeded context, I may have missed some of your comments
due to skimming.

> > +struct regmap {
> > +	struct mutex lock;
> > +
> > +	struct device *dev; /* Device we do I/O on */
> > +	void *work_buf;     /* Scratch buffer used to format I/O */
> > +	struct regmap_format format;  /* Buffer format */
> > +	const struct regmap_bus *bus;
> > +};

> Some /** kerneldoc on these structures would be helpful.

I didn't kerneldoc it because it's internal only and shouldn't appear in
the API reference for the API.

> > +/**
> > + * remap_init: Initialise register map

> nit: "remap_init() - Initialise reigster map"

> > +struct regmap *regmap_init(struct device *dev,
> > +			   const struct regmap_config *config)
> > +{
> > +	struct regmap *map;
> > +	int ret = -EINVAL;
> > +
> > +	map = kzalloc(sizeof(*map), GFP_KERNEL);
> > +	if (map == NULL) {
> > +		ret = -ENOMEM;
> > +		goto err;
> > +	}

> Wouldn't it be appropriate to allow drivers to embed the regmap in a
> private data structure?

Not until we're more confident of the internals, I'd rather not have to
worry about what people are doing with them until they seem more stable.

> Rather than a big case statement, could this be cleaner with a lookup
> table?

Yeah, I did it that way initially but it got annoying to write.  I'm
swithering about going back to that, though.  The problem was the 4x12
and 7x9 cases.  I don't really like either way and this just happened to
be the last one that got implemented.

> I'm a bit concerned that the overall structure of the init function
> will be inflexible in the long run.  Specifically, the way the

That's fine, we can rewrite it.  Like I said I'm not

> instance structure is hidden from the caller, there isn't any way for
> a device driver to explicitly override the accessor functions if it
> needs to.  One of the things I like about the generic irq_chip work
> that tglx did was that it set up a lot of things for the irq
> controller, but the controller could still provide its own hooks when
> necessary.

This is mostly the API internals thing again.

For overrides my plan was to let drivers set the hooks in the
regmap_config they pass in, but I'd like to try to get as far as we can
without needing to do that.  Specifically I'd like to get the cache
stuff in before exposing the internals as I think that that may suggest
some refactorings.

> > +	/* Figure out which bus to use, and also grab a lock on the
> > +	 * module supplying it. */
> > +	mutex_lock(&regmap_bus_lock);
> > +	list_for_each_entry(map->bus, &regmap_bus_list, list)
> > +		if (map->bus->type == dev->bus &&
> > +		    try_module_get(map->bus->owner))
> > +			break;
> > +	mutex_unlock(&regmap_bus_lock);

> Hmmmm.  Two things here.  First, grabbing a reference to the module
> mostly works, but it highlights a deficiency in the driver model.
> Really what we want here is a refcount on the /bound/ instance of the
> driver+device.  The driver model does actually support unbinding a
> device without removing the module.

I know, but all the other subsystems are doing it :)

> Second, combining a device reference with the register access library
> conflates two things which seem to me to be separate.  Actually, which
> it seems odd, it doesn't bother me too much, but it looks completely
> wrong for this library to need specific bus-type knowledge.  Why does
> the bus type need to be known (other than to choose the appropriate IO
> routines)?  If it is only for setting up the io accessors, I'd rather
> see the caller use a bus-specific setup funtion and pass the
> appropriate {i2c,spi,...}_device which will take care of type
> checking.

It's for the I/O accessors at present, though it will also get used for
trace and diagnostics - experience with ASoC has been that it's very
useful to have an off the shelf set of register I/O trace and dump
facilities that you can turn on easily.  For example, once we get the
drivers telling us more about their register maps I'd expect to
replicate the ASoC debugfs dump access.  For that stuff being able to
say what device we're talking about is obviously helpful.

The reasoning behind the I/O is that for all the I2C/SPI devices you
usually end up with a common probe()/exit() function which gets called
by the bus-specific ones and doing things this way means that for most
devices we move an extra call and check block from the bus specific code
into the common code.

> > +err:
> > +	return ERR_PTR(ret);

> Personal soapbox: I'm not at all a fan of the ERR_PTR() pattern
> because it provides no clues to the caller (gcc) if a failure is
> returned as a NULL or as a 0.  Unless there is a really strong
> argument for needing to differentiate between "no data" and "things
> went bad", I'd rather see APIs that return NULL on failure.

We should just switch to C++ and use exceptions :)
