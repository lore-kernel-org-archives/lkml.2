Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032Ab1ANRtV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 12:49:21 -0500
Received: from waste.org ([173.11.57.241]:39733 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757705Ab1ANRtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 12:49:17 -0500
Subject: Re: [PATCH] hwrng: add support for picoxcell TRNG
From: Matt Mackall <mpm@selenic.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Herbert Xu <herbert@gondor.hengli.com.au>
In-Reply-To: <1295021448-25018-1-git-send-email-jamie@jamieiles.com>
References: <1295021448-25018-1-git-send-email-jamie@jamieiles.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Jan 2011 11:49:13 -0600
Message-ID: <1295027353.30392.20.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-14 at 16:10 +0000, Jamie Iles wrote:
> This driver adds support for the True Random Number Generator in
> the Picochip PC3X3 and later devices.
> 
> Cc: Matt Mackall <mpm@selenic.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> 
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> ---
> 
> ARCH_PICOXCELL machine support patches have been posted the ARM mailing
> lists for review (with another revision to follow soon).
> 
>  drivers/char/hw_random/Kconfig         |   12 ++
>  drivers/char/hw_random/Makefile        |    1 +
>  drivers/char/hw_random/picoxcell-rng.c |  175 ++++++++++++++++++++++++++++++++
>  3 files changed, 188 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/char/hw_random/picoxcell-rng.c
> 
> diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
> index d31483c..beecd1c 100644
> --- a/drivers/char/hw_random/Kconfig
> +++ b/drivers/char/hw_random/Kconfig
> @@ -198,3 +198,15 @@ config HW_RANDOM_NOMADIK
>  	  module will be called nomadik-rng.
>  
>  	  If unsure, say Y.
> +
> +config HW_RANDOM_PICOXCELL
> +	tristate "Picochip picoXcell true random number generator support"
> +	depends on HW_RANDOM && ARCH_PICOXCELL && PICOXCELL_PC3X3
> +	---help---
> +	  This driver provides kernel-side support for the Random Number
> +	  Generator hardware found on Picochip PC3x3 and later devices.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called picoxcell-rng.
> +
> +	  If unsure, say Y.
> diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
> index 4273308..3db4eb8 100644
> --- a/drivers/char/hw_random/Makefile
> +++ b/drivers/char/hw_random/Makefile
> @@ -19,3 +19,4 @@ obj-$(CONFIG_HW_RANDOM_TX4939) += tx4939-rng.o
>  obj-$(CONFIG_HW_RANDOM_MXC_RNGA) += mxc-rnga.o
>  obj-$(CONFIG_HW_RANDOM_OCTEON) += octeon-rng.o
>  obj-$(CONFIG_HW_RANDOM_NOMADIK) += nomadik-rng.o
> +obj-$(CONFIG_HW_RANDOM_PICOXCELL) += picoxcell-rng.o
> diff --git a/drivers/char/hw_random/picoxcell-rng.c b/drivers/char/hw_random/picoxcell-rng.c
> new file mode 100644
> index 0000000..e750056
> --- /dev/null
> +++ b/drivers/char/hw_random/picoxcell-rng.c
> @@ -0,0 +1,175 @@
> +/*
> + * Copyright (c) 2010-2011 Picochip Ltd., Jamie Iles
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * All enquiries to support@picochip.com
> + */
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/hw_random.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +
> +#define DATA_REG_OFFSET			0x0200
> +#define CSR_REG_OFFSET			0x0278
> +#define		CSR_OUT_EMPTY_MASK	(1 << 24)
> +#define TAI_REG_OFFSET			0x0380

Some whitespace weirdness here. Recommend never using tabs except at the
beginning of a line.

> +static void __iomem *rng_base;
> +static struct clk *rng_clk;
> +
> +/*
> + * Get some random data from the random number generator. The hw_random core
> + * layer provides us with locking. We can't rely on data being word aligned
> + * though so we'll need to do a memcpy.
> + */
> +static int picoxcell_trng_read(struct hwrng *rng, void *buf, size_t max,
> +			       bool wait)
> +{
> +	u32 __iomem *csr = rng_base + CSR_REG_OFFSET;
> +	int data_avail = !(__raw_readl(csr) & CSR_OUT_EMPTY_MASK);
> +	u32 data;
> +
> +	if (!data_avail && !wait)
> +		return 0;
> +
> +	/* Wait for some data to become available. */
> +	while (!data_avail) {
> +		data_avail = !(__raw_readl(csr) & CSR_OUT_EMPTY_MASK);
> +		cpu_relax();
> +	}

This could be simplified a bit:

- deduplicate avail check
- only relax when data's not available
- drop some one use vars

while (!__raw_read(rng_base + ...) {
	if (!wait)
		return;
	cpu_relax();
}	
	
> +	data = __raw_readl(rng_base + DATA_REG_OFFSET);
> +	memcpy(buf, &data, min(max, sizeof(data)));

The buffer passed in is guaranteed aligned:

static u8 rng_buffer[SMP_CACHE_BYTES < 32 ? 32 : SMP_CACHE_BYTES]
	__cacheline_aligned;
...
		return rng->read(rng, (void *)buffer, size, wait);

-- 
Mathematics is the supreme nostalgia of our time.


