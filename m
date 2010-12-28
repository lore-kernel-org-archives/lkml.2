Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab0L1X60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 18:58:26 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59195 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751807Ab0L1X6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 18:58:25 -0500
Date: Tue, 28 Dec 2010 23:58:36 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, David Brownell <david-b@pacbell.net>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC/PATCH 3/3] mfd: twl4030-irq: implement bus_*lock
Message-ID: <20101228235836.GA2609@opensource.wolfsonmicro.com>
References: <20101228161657.GF2239@legolas.emea.dhcp.ti.com>
 <1293556459-28613-1-git-send-email-balbi@ti.com>
 <1293556459-28613-4-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293556459-28613-4-git-send-email-balbi@ti.com>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 28, 2010 at 07:14:19PM +0200, Felipe Balbi wrote:

> +static void twl4030_sih_bus_sync_unlock(unsigned int irq)
> +{
> +       struct sih_agent        *agent = get_irq_chip_data(irq);
> +
> +       mutex_unlock(&agent->irq_lock);
> +}

I suspect you need to do some sort of sync with the hardware here - the
_sync bit of the name comes from the fact that the mask and unmask stuff
is still called with IRQs disabled and so can't touch and I2C chip, this
is called after reenabling them give a chance for the updates done to
be reflected in the hardware.  The implementation everyone else has done
is to update a register cache in the other functions then write that
out here before dropping the mutex.

>  static struct irq_chip twl4030_sih_irq_chip = {
>  	.name		= "twl4030",
>  	.mask		= twl4030_sih_mask,
>  	.unmask		= twl4030_sih_unmask,
>  	.set_type	= twl4030_sih_set_type,
> +	.bus_lock	= twl4030_sih_bus_lock,
> +	.bus_sync_unlock = twl4030_sih_bus_sync_unlock,
>  };

I just realised that this collides with the conversion to the irq_
versions that has been done on the driver in -next by either myself or
Lennart (we both submitted essentially the same patches and a couple of
his went in) - that was a purely mechanical conversion that didn't
address any of the issues this patch addresses but they're touching the
same code.
