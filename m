Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391Ab1FUAOm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 20:14:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47870 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756151Ab1FUAOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 20:14:41 -0400
Date: Tue, 21 Jun 2011 01:14:38 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCH 1/8] regmap: Add generic non-memory mapped register
 access API
Message-ID: <20110621001438.GD1905@opensource.wolfsonmicro.com>
References: <20110620124608.GB31140@opensource.wolfsonmicro.com>
 <1308574489-31322-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <4DFFD486.7020901@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFFD486.7020901@metafoo.de>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 01:15:18AM +0200, Lars-Peter Clausen wrote:

> > +	void (*format_reg)(void *buf, unsigned int reg);
> > +	void (*format_val)(void *buf, unsigned int val);
> > +	unsigned int (*parse_val)(void *buf);

> const void *buf. It probably also makes sense to pass the regmap to all

Hrm, yeah.

> callbacks, so we can write generic format/parser functions which use
> information for example from the regmap_format.

I'd rather add it when we need it, it's not much work to refactor and
it's entirely in this file.  Right now I like being sure I know what
knows about what bit of data mangling.

> > +static void regmap_format_4_12_write(struct regmap *map,
> > +				     unsigned int reg, unsigned int val)
> > +{
> > +	u16 *out = map->work_buf;
> > +	*out = cpu_to_be16((reg << 12) | val);
> > +}

> > +static void regmap_format_7_9_write(struct regmap *map,
> > +				    unsigned int reg, unsigned int val)
> > +{
> > +	u16 *out = map->work_buf;
> > +	*out = cpu_to_be16((reg << 9) | val);
> > +}

> It would make sense to keep val_bits around and implement these two generically:
> 	*out = cpu_to_be16((reg << map->format.val_bits) | val);

I'm not sure it's worth it for the two cases we know about, and as with
passing the map into these I like keeping the byte oriented assumption
in the interfaces as much as possible as it makes things easier to think
about.

> > +struct regmap *regmap_init(struct device *dev, struct regmap_config *config)

> regmap_alloc would in my opinion be a better name.

I like init, especially considering the plan to add cache support as
there's more work in setting that up once you start doing the advanced
caches.

> > +	/*
> > +	 * Some buses flag reads by setting the high bit in the
> > +	 * register addresss; since it's always the high bit for all
> > +	 * current formats we can do this here rather than in
> > +	 * formatting.  This may break if we get interesting formats.
> > +	 */
> > +	if (map->bus->read_flag_in_reg)
> > +		u8[0] |= 0x80;

> This is rather specific. Making this a per device mask or bit offset, would
> make more sense in my opinion. I have for example one SPI codec device which
> uses the 7th bit to indicate a read. And I also have devices on a custom bus,

Can you say what device this is?  I'm just going on the devices we've
seen in the kernel so far here...  Still easy enough to do.

> which needs to set the upper bit to indicate a write, so a mask for both write
> and read would be good.

Sure, though for stuff like this I'd say just implement them when we
need them.

> > +	for (i = 0; i < val_count * val_bytes; i += val_bytes)
> > +		map->format.parse_val(val + i);

> This doesn't make sense. parse_val returns the parsed value, but doesn't modify

Oh, meh.  It used to.

> the parsed data. It would make sense to make the interface similar to
> regmap_read and make the returned values a unsigned integer array and use a
> bounce buffer for reading them from the device.

I thought about that but what it actually ends up meaning for most of
the current users is that they then need to either implement their own
bounce buffer or do some cross tree updates to switch from using the
native type to ints.  Neither seemed terribly appealing and it did seem
reasonable to expect devices to know how big their own registers are.

> > +struct regmap_config {
> > +	int reg_bits;
> > +	int val_bits;

> size_t for both?

It doesn't seem particularly appropriate as we're working with a bit
count not the usual byte count where size_t gets used and I can't see it
ever making any difference.

> > +int regmap_bulk_read(struct regmap *map, unsigned int reg, void *val,
> > +		     size_t val_count);

> What about bulk_write?

It's painful to implement efficiently due to the need to mangle the data
on the way down, and most of the time if you're doing a bulk operation
it's because you want it to be efficient.  I'm punting it until someone
really wants it so we can have a separate think about what makes sense.
