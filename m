Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab1KQWex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 17:34:53 -0500
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:49338 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751721Ab1KQWew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 17:34:52 -0500
From: Kevin Hilman <khilman@ti.com>
To: Tero Kristo <t-kristo@ti.com>
Cc: <linux-omap@vger.kernel.org>, Paul Walmsley <paul@pwsan.com>,
        "Cousson\, Benoit" <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        "Govindraj.R" <govindraj.raja@ti.com>,
        "Avinash.H.M" <avinashhm@ti.com>, linux-arm-kernel@lists.infradead.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCHv9 06/18] mfd: omap-prm: added chain interrupt handler
Organization: Texas Instruments, Inc.
References: <1316781986-30642-1-git-send-email-t-kristo@ti.com>
	<1316781986-30642-7-git-send-email-t-kristo@ti.com>
Date: Thu, 17 Nov 2011 14:34:46 -0800
In-Reply-To: <1316781986-30642-7-git-send-email-t-kristo@ti.com> (Tero
	Kristo's message of "Fri, 23 Sep 2011 15:46:14 +0300")
Message-ID: <87aa7u1ipl.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tero Kristo <t-kristo@ti.com> writes:

> Introduce a chained interrupt handler mechanism for the PRCM
> interrupt, so that individual PRCM event can cleanly be handled by
> handlers in separate drivers. We do this by introducing PRCM event
> names, which are then matched to the particular PRCM interrupt bit
> depending on the specific OMAP SoC being used.
>
> PRCM interrupts have two priority levels, high or normal. High priority
> is needed for IO event handling, so that we can be sure that IO events
> are processed before other events. This reduces latency for IO event
> customers and also prevents incorrect ack sequence on OMAP3.
>
> Signed-off-by: Tero Kristo <t-kristo@ti.com>
> Cc: Paul Walmsley <paul@pwsan.com>
> Cc: Kevin Hilman <khilman@ti.com>
> Cc: Avinash.H.M <avinashhm@ti.com>
> Cc: Cousson, Benoit <b-cousson@ti.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Govindraj.R <govindraj.raja@ti.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> ---
>  drivers/mfd/omap-prm-common.c |  239 +++++++++++++++++++++++++++++++++++++++++
>  drivers/mfd/omap-prm.h        |   40 +++++++
>  drivers/mfd/omap3xxx-prm.c    |   29 +++++-
>  drivers/mfd/omap4xxx-prm.c    |   28 +++++-
>  4 files changed, 334 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/mfd/omap-prm.h
>
> diff --git a/drivers/mfd/omap-prm-common.c b/drivers/mfd/omap-prm-common.c
> index 39b199c8..2886eb2 100644
> --- a/drivers/mfd/omap-prm-common.c
> +++ b/drivers/mfd/omap-prm-common.c
> @@ -15,10 +15,249 @@
>  #include <linux/ctype.h>
>  #include <linux/module.h>
>  #include <linux/io.h>
> +#include <linux/irq.h>
> +#include <linux/interrupt.h>
>  #include <linux/slab.h>
>  #include <linux/init.h>
>  #include <linux/err.h>
>  
> +#include "omap-prm.h"
> +
> +#define OMAP_PRCM_MAX_NR_PENDING_REG 2
> +
> +struct omap_prm_device {
> +	const struct omap_prcm_irq_setup *irq_setup;
> +	const struct omap_prcm_irq *irqs;
> +	struct irq_chip_generic **irq_chips;
> +	int nr_irqs;
> +	u32 *saved_mask;
> +	u32 *priority_mask;
> +	int base_irq;
> +	int irq;
> +	void __iomem *base;
> +};
> +
> +static struct omap_prm_device prm_dev;

This shouldn't be statically allocated, and needlessly forces us to
assume a single, global PRM (which is the case today, but who knows...)

Instead, it should be allocated at init time and associated with the
instance (using set_drvdata or somthing.) 

> +static inline u32 prm_read_reg(int offset)
> +{
> +	return __raw_readl(prm_dev.base + offset);
> +}
> +
> +static inline void prm_write_reg(u32 value, int offset)
> +{
> +	__raw_writel(value, prm_dev.base + offset);
> +}

This doesn't seem right either.

The register layout/access parts are what are are different between the
OMAP3 and OMAP4 versions, so I would expect anything that accesses
registers to be going through the SoC specific code.

I'm having some second thoughts about the split of common and SoC
specific code here.  Currently the SoC specific code is basically
identical (ignoring the s/omap3/omap4/ throughout.)

I think we need to discuss this further, but what seems to me that the
current design is to have 2 separate drivers, with some common helper
functions.  I'm starting to think that what we need instead is a single,
common driver with a set of SoC-specific functions that implement the
SoC-specific details.   This latter approach follows what is done in the
powerdomain code today for example: common code in powerdomain.c and SoC
specific implementation of all the "ops" in powerdomain2xxx_3xxx.c and
powerdomain4xxx.c.

Kevin

