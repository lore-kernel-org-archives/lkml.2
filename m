Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab2GWHZg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 03:25:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50584 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892Ab2GWHZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 03:25:35 -0400
Date: Mon, 23 Jul 2012 00:24:50 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Grant Likely <grant.likely@secretlab.ca>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: next/mmotm unbootable on G5: irqdomain
In-Reply-To: <1343011543.2957.2.camel@pasglop>
Message-ID: <alpine.LSU.2.00.1207230023380.6948@eggly.anvils>
References: <alpine.LSU.2.00.1207211911160.1585@eggly.anvils> <1343011543.2957.2.camel@pasglop>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2012, Benjamin Herrenschmidt wrote:
> On Sat, 2012-07-21 at 19:47 -0700, Hugh Dickins wrote:
> > I have to revert the patch below from mmotm 2012-07-20-16-30 or
> > next-20120720 in order to boot on the PowerPC G5: otherwise it
> > freezes before switching to the framebuffer console - but I'm
> > not certain where because that initial console doesn't scroll
> > (there are mpic messages at bottom and at top of screen, probably
> > later messages at the top but I don't know the sequence).
> 
> This fixes it

Confirmed: many thanks, Ben.

> (Grant, how do we avoid bisection breakage here ? I can
> put that in -powerpc and we can make sure that gets merged before your
> tree ?)
> 
> powerpc/mpic: Create a revmap with enough entries for IPIs and timers
> 
> The current mpic code creates a linear revmap just big enough for all
> the sources, which happens to miss the IPIs and timers on some machines.
> 
> This will in turn break when the irqdomain code loses the fallback of
> doing a linear search when the revmap fails (and really slows down IPIs
> otherwise).
> 
> This happens for example on the U4 based Apple machines such as the
> dual core PowerMac G5s.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
> diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
> index 906f29c..bfc6211 100644
> --- a/arch/powerpc/sysdev/mpic.c
> +++ b/arch/powerpc/sysdev/mpic.c
> @@ -1376,7 +1376,7 @@ struct mpic * __init mpic_alloc(struct device_node *node,
>  	mpic->isu_mask = (1 << mpic->isu_shift) - 1;
>  
>  	mpic->irqhost = irq_domain_add_linear(mpic->node,
> -				       last_irq + 1,
> +				       intvec_top,
>  				       &mpic_host_ops, mpic);
>  
>  	/*
> 
> 
> 
