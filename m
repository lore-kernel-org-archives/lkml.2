Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197Ab2EaShG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 14:37:06 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:39020 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab2EaShE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 14:37:04 -0400
From: Krystian Garbaciak <Krystian.Garbaciak@diasemi.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anthony Olech <Anthony.Olech@diasemi.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Javier Martin <javier.martin@vista-silicon.com>
Subject: RE: [PATCH 3/4] regmap: Add support for register indirect
 addressing.
Thread-Topic: [PATCH 3/4] regmap: Add support for register indirect
 addressing.
Thread-Index: AQHNP1JpXpnNdSw4KUOXyJAa20XWt5bkLv9A
Date: Thu, 31 May 2012 18:37:00 +0000
Message-ID: <751C305CD2876B4990194D0512DE8BF2441CA8F3@SW-EX-MBX01.diasemi.com>
References: <201205311619.q4VGJ8S2014801@sw-eng-lt-dc-vm2>
 <20120531172541.GM2666@opensource.wolfsonmicro.com>
In-Reply-To: <20120531172541.GM2666@opensource.wolfsonmicro.com>
Accept-Language: pl-PL, en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +       /* Partition all accessible registers on address ranges,
> > +          either to be accessed directly or indirectly. Arrange range
> > +          list by ascending addresses. */
> 
> Wouldn't something naturally sorted like a rbtree be a more direct way of doing
> this?

I expect here to have one or two ranges registered. Do you think, rbtree will be more efficient?

> > +		range_cfg = NULL;
> > +		for (n = 0, min_base = UINT_MAX; n < config->n_ranges; n++)
> > +			if (range_base <= config->ranges[n].base_reg &&
> > +			    config->ranges[n].base_reg <= min_base)
> > +				range_cfg = &config->ranges[n];
> > +
> 
> I've stared at this for a little while and I'm really not sure what it's supposed to
> do.  The whole thing with min_base is just a bit odd, we're doing comparisons
> against it but we never update it so why aren't we using a constant, and in fact
> the comparison is always going to be true since we're comparing against
> UINT_MAX.
> 
> I suspect it's supposed to pick the range with the lowest base but I'm not
> convinced it does that.

I  am searching for a range configuration with the lowest address range, that was not added yet.
I use range_base as a pointer to mark the position of base address for the next range to be added.
 
> > +		if (!range_cfg || range_cfg->base_reg > range_base) {
> > +			/* Range of registers for direct access */
> > +			range = kzalloc(sizeof(*range), GFP_KERNEL);
> > +			if (range == NULL) {
> > +				ret = -ENOMEM;
> > +				goto err_range;
> > +			}
> > +			range->base_reg = range_base;
> > +			if (range_cfg)
> > +				range->max_reg = range_cfg->base_reg - 1;
> > +			else
> > +				range->max_reg = UINT_MAX;
> > +			list_add_tail(&range->list, &map->range_list);
> > +		}
> 
> This is making my head hurt too, possibly because of the lack of clarity in the
> above.

Any empty space before configured virtual range is filled with range used for direct access. Empty address space, after all defined ranges, is used for direct access too (If that makes sense?). To mark such range (translate_reg==NULL).

> > +	/* Bulk write should not cross single range boundaries */
> > +	if (val_num != 0 &&
> > +	    reg + val_num - 1 > range->max_reg)
> > +		return -EINVAL;
> 
> When would val_num ever be zero?

There is no checking against (val_num == 0)  before this point.
But after reviewing the code after this, it seems not to do any harm in such case.

> > +			/* Update page register (may use caching) */
> > +			ret = _regmap_update_bits(map, range-
> >page_sel_reg,
> > +						range->page_sel_mask,
> > +						_page << range-
> >page_sel_shift,
> > +						&change);
> > +			if (ret < 0)
> > +				return ret;
> 
> Why the comment about the cache - why would this go wrong?

Nothing. _regmap_update_bits() is used, so the cache can be hit here and speed up paging.

> > +			/* There is no point to pass cache for data
> > +			   registers, as they should be volatile anyway */
> > +			ret = _regmap_range_access(regmap_bus_access,
> > +						   map, _reg, _val, _num);
> > +			if (ret < 0)
> > +				return ret;
> 
> That comment needs some clarification too...

Here, _regmap_range_access() is called directly (not _regmap_raw_read), as I expect everybody to define data window for indirect access as volatile, readable and writeable.

> > + * @translate_reg: Function should return indirect address/page number and
> > + *                 register number (out of this range) matching virtual_reg.
> 
> Why does the user need to specify this?  Shouldn't we just specify a size for the
> underlying window and then have a default which does the obvious
> translations?  I'd imagine an *overwhelming* proportion of users will want to
> do that.  Allowing an override is fine but requiring code seems wrong for
> something like this.

If so, I can easily make translate_reg() something internal for regmap and leave the window size to be configurable.

Legal Disclaimer: This e-mail communication (and any attachment/s) is confidential and contains proprietary information, 
some or all of which may be legally privileged. It is intended solely for the use of the individual or entity to which it
is addressed. Access to this email by anyone else is unauthorized. If you are not the intended recipient, any disclosure, 
copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited and may be unlawful.

Please consider the environment before printing this e-mail
