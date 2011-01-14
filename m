Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046Ab1ANSQ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 13:16:26 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43552 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757533Ab1ANSQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 13:16:13 -0500
Date: Fri, 14 Jan 2011 18:16:09 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: [PATCH] hwrng: add support for picoxcell TRNG
Message-ID: <20110114181609.GN2822@pulham.picochip.com>
References: <1295021448-25018-1-git-send-email-jamie@jamieiles.com>
 <1295027353.30392.20.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295027353.30392.20.camel@calx>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

Many thanks for the quick feedback!

On Fri, Jan 14, 2011 at 11:49:13AM -0600, Matt Mackall wrote:
> On Fri, 2011-01-14 at 16:10 +0000, Jamie Iles wrote:
> > This driver adds support for the True Random Number Generator in
> > diff --git a/drivers/char/hw_random/Makefile 
> > b/drivers/char/hw_random/Makefile
> > index 4273308..3db4eb8 100644
> > --- a/drivers/char/hw_random/Makefile
> > +++ b/drivers/char/hw_random/Makefile
> > @@ -19,3 +19,4 @@ obj-$(CONFIG_HW_RANDOM_TX4939) += tx4939-rng.o
> >  obj-$(CONFIG_HW_RANDOM_MXC_RNGA) += mxc-rnga.o
> >  obj-$(CONFIG_HW_RANDOM_OCTEON) += octeon-rng.o
> >  obj-$(CONFIG_HW_RANDOM_NOMADIK) += nomadik-rng.o
> > +obj-$(CONFIG_HW_RANDOM_PICOXCELL) += picoxcell-rng.o
> > diff --git a/drivers/char/hw_random/picoxcell-rng.c b/drivers/char/hw_random/picoxcell-rng.c
> > new file mode 100644
> > index 0000000..e750056
> > --- /dev/null
> > +++ b/drivers/char/hw_random/picoxcell-rng.c
> > @@ -0,0 +1,175 @@
> > +/*
> > + * Copyright (c) 2010-2011 Picochip Ltd., Jamie Iles
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + * All enquiries to support@picochip.com
> > + */
> > +#include <linux/clk.h>
> > +#include <linux/err.h>
> > +#include <linux/hw_random.h>
> > +#include <linux/io.h>
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/platform_device.h>
> > +
> > +#define DATA_REG_OFFSET			0x0200
> > +#define CSR_REG_OFFSET			0x0278
> > +#define		CSR_OUT_EMPTY_MASK	(1 << 24)
> > +#define TAI_REG_OFFSET			0x0380
> 
> Some whitespace weirdness here. Recommend never using tabs except at the
> beginning of a line.

I'll fix that up, not sure what happened there.

> > +static void __iomem *rng_base;
> > +static struct clk *rng_clk;
> > +
> > +/*
> > + * Get some random data from the random number generator. The hw_random core
> > + * layer provides us with locking. We can't rely on data being word aligned
> > + * though so we'll need to do a memcpy.
> > + */
> > +static int picoxcell_trng_read(struct hwrng *rng, void *buf, size_t max,
> > +			       bool wait)
> > +{
> > +	u32 __iomem *csr = rng_base + CSR_REG_OFFSET;
> > +	int data_avail = !(__raw_readl(csr) & CSR_OUT_EMPTY_MASK);
> > +	u32 data;
> > +
> > +	if (!data_avail && !wait)
> > +		return 0;
> > +
> > +	/* Wait for some data to become available. */
> > +	while (!data_avail) {
> > +		data_avail = !(__raw_readl(csr) & CSR_OUT_EMPTY_MASK);
> > +		cpu_relax();
> > +	}
> 
> This could be simplified a bit:
> 
> - deduplicate avail check
> - only relax when data's not available
> - drop some one use vars
> 
> while (!__raw_read(rng_base + ...) {
> 	if (!wait)
> 		return;
> 	cpu_relax();
> }	

Yes, that's much neater.

> > +	data = __raw_readl(rng_base + DATA_REG_OFFSET);
> > +	memcpy(buf, &data, min(max, sizeof(data)));
> 
> The buffer passed in is guaranteed aligned:
> 
> static u8 rng_buffer[SMP_CACHE_BYTES < 32 ? 32 : SMP_CACHE_BYTES]
> 	__cacheline_aligned;
> ...
> 		return rng->read(rng, (void *)buffer, size, wait);

Ok, that makes sense.  I must have confused myself with the __user 
buffer which doesn't have any alignment guarantees.

Thanks again for the review, I'll get a respin out early next week.

Jamie
