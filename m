Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab1GACix (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 22:38:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45727 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752373Ab1GACiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 22:38:52 -0400
Date: Thu, 30 Jun 2011 19:38:49 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@ti.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCH 1/8] regmap: Add generic non-memory mapped register
 access API
Message-ID: <20110701023848.GA7540@opensource.wolfsonmicro.com>
References: <20110622184407.GC13847@sirena.org.uk>
 <1308768353-19372-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1309479761.3093.1659.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309479761.3093.1659.camel@localhost>
X-Cookie: There is a fly on your nose.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 01, 2011 at 01:22:41AM +0100, Ben Hutchings wrote:
> On Wed, 2011-06-22 at 19:45 +0100, Mark Brown wrote:

> > +	b[0] = be16_to_cpu(b[0]);
> > +
> > +	return b[0];

> The assignment doesn't seem to be necessary and will irritate sparse,
> so:

> 	return be16_to_cpu(b[0]);

sparse is silent on whatever the issue is here and the assignment is
used (we both modify the buffer in place and return the result of the
conversion to make life more convenient for users).  Which isn't
urgently tasteful but felt less tasteless than anything else I thought
of.  Data manging doesn't lend itself to elegance.

> > + * dev: Device that will be interacted with
> > + * config: Configuration for register map

> Missing '@' before the parameter names.

You're looking at an old version of the code.

> > +	/* Otherwise fall back on linearising by hand. */
> > +	if (ret == -ENOTSUPP) {
> > +		len = map->format.reg_bytes + val_len;
> > +		buf = kmalloc(len, GFP_KERNEL);
> > +		if (!buf)
> > +			return -ENOMEM;
> > +		memcpy(buf, map->work_buf, map->format.reg_bytes);
> > +		memcpy(buf + map->format.reg_bytes, val, val_len);

> If I understand correctly, this is usually called by _regmap_write() and
> val is already at the appropriate offset in work_buf.  Is it not worth
> avoiding the allocation in that case?

It's marginal, and given that it's vanishingly rare to hit this case
(essentially all the interesting controllers for this API can do the
gather write) I didn't feel it was worth it for a first pass.  We can
always do the optimization later if someone finds it important.  I
suspect any controller that hits the issue is going to be slow enough to
dwarf the cost of the allocation with the I/O cost.

> General comments:

> - All the functions must be called in process context, but this isn't
> documented.

This should be obvious, none of the relevant buses can be interacted
with in anything other than process context anyway as they need to
sleep.

> - I think this could go in lib or drivers/base rather than in a new
> directory.  The specific support for I2C and SPI would go in their
> existing directories.

lib feels wrong, it's going to be peering into the drivers directory too
much.

drivers/base is a good point, but then the code will grow quite a bit
once we start layering cache support on top of it and until the code
settles down I don't really want to have to deal with cross tree issues
if we decide we need to update the interface to the bus code, that's
definitely a first pass thing right now.  The latter is the main thing
that made me do things this way rather than pushing things into the
buses, it's definitely not the finished product right now internally -
the client API should be reasonably stable so not have these issues.

My inclination is to start off isolating the code until we've reached
the point where things are more static.  I suppose we could put it in a
subdirectory of drivers/base in the meantime, though.  Will have a think
for the next repost.

Fixed everything else, thanks.
