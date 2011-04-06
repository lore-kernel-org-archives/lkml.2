Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab1DFMMc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 08:12:32 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54907 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869Ab1DFMMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 08:12:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=avX4SsIMQRYGihrNMuiOAII/lz++EwULN2j9wH7KrWt3A2ct7c/Hdky2Deo1YC3K1Z
         QzNW//ylCEWOPf+vr0RKJZVoN0uV79n76VvP23sQ+aQh1Ws0p7GdRVsHyVYE0ozG5Ced
         eBcZtIlcn3MZ9pdbaoLUApDVKEFgeMjmC957M=
Date: Wed, 6 Apr 2011 16:12:25 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, tglx@linutronix.de,
        grant.likely@secretlab.ca, arnd@arndb.de, nico@fluxnic.net
Subject: Re: [RFC PATCH 7/7] basic_mmio_gpio: support direction registers
Message-ID: <20110406121225.GA8865@oksana.dev.rtsoft.ru>
References: <1302088263-12714-1-git-send-email-jamie@jamieiles.com>
 <1302088263-12714-8-git-send-email-jamie@jamieiles.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1302088263-12714-8-git-send-email-jamie@jamieiles.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 12:11:03PM +0100, Jamie Iles wrote:
> Most controllers require the direction of a GPIO to be set by writing to
> a direction register.  Add support for either an input direction
> register or an output direction register.
> 
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> Cc: Anton Vorontsov <cbouatmailru@gmail.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
[...]
> @@ -71,6 +71,8 @@ struct bgpio_chip {
>       void __iomem *reg_set;
>       void __iomem *reg_clr;
>       void __iomem *reg_in;
> +     void __iomem *reg_dirout;
> +     void __iomem *reg_dirin;
>

I guess you don't need both reg_dirout and reg_dirin in the runtime.
How about just renaming it to "reg_dir" and just assinging it with
either dirout or dirin in bgpio_setup_direction()?

[...]
> +	/* Shadowed direction registers to clear/set direction safely. */
> +	unsigned long outputs, inputs;

Same as obove, maybe just a single 'dir' variable?

Plus, a minor nit: the coding style suggests:

	unsigned long outputs;
	unsigned long inputs;

[...]
>  static int bgpio_dir_in(struct gpio_chip *gc, unsigned int gpio)
>  {
> +	struct bgpio_chip *bgc = to_bgpio_chip(gc);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&bgc->lock, flags);
> +	bgc->outputs &= ~bgc->pin2mask(bgc, gpio);
> +	bgc->write_reg(bgc->reg_dirout, bgc->outputs);
> +	spin_unlock_irqrestore(&bgc->lock, flags);
>

Because of the lock, the code in these routines is dense and hard to
read, so I would rather add empty lines near the locking calls, just
like in bgpio_set() (also makes it look consistent).

Otherwise,

Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
