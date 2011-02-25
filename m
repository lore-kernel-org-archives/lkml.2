Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab1BYVQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 16:16:50 -0500
Received: from vs1.gondor.com ([78.47.100.202]:54051 "EHLO
	mail.moria.gondor.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752525Ab1BYVQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 16:16:48 -0500
Date: Fri, 25 Feb 2011 22:16:46 +0100
From: Jan Niehusmann <jan@gondor.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
Subject: Re: [PATCH] intel-gtt: fix memory corruption with GM965 and >4GB
 RAM
Message-ID: <20110225211646.GA6837@x61s.reliablesolutions.de>
References: <20110223233022.GA3439@x61s.reliablesolutions.de>
 <20110225123056.GA3759@x61s.reliablesolutions.de>
 <b9dded$i2gkhr@orsmga002.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9dded$i2gkhr@orsmga002.jf.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

On Fri, Feb 25, 2011 at 08:22:53PM +0000, Chris Wilson wrote:
> On Fri, 25 Feb 2011 13:30:56 +0100, Jan Niehusmann <jan@gondor.com> wrote:
> > Further investigation revealed that the corrupted address is
> > (dev_priv->status_page_dmah->busaddr & 0xffffffff), ie. the beginning of
> > the hardware status page of the i965 graphics card, cut to 32 bits.
> 
> 965GM explicitly supports 36bits of addressing in the PTE. The only
> exception is that general state (part of the 3D engine) must be located in
> the lower 4GiB.

I'm not claiming that 965GM doesn't do 36 bits. In fact I actually see
activity in /sys/kernel/debug/dri/64/i915_gem_hws, and everything seems
to be working well, when the status page is above 4GB - if one ignores
the tiny detail that the wrong memory location gets overwritten,
sometimes...

> Simply ignoring the upper 4bits is the wrong approach and means that the
> PTE then point to random pages, and completely irrelevant to the physical
> address used in the hardware status page address register.

Doesn't setting DMA_BIT_MASK(32) only change the region DMA memory is
allocated from? I made that change just to make sure one gets addresses
which are safe even if the chipset sometimes ignores address bit 32. The
only negative impact I could think of is the allocation may fail if no
appropriate memory is available. Am I wrong?

> I have been considering:

> +       if (IS_BRROADWATER(dev) || IS_CRESTLINE(dev))
> +               dma_set_coherent_mask(&dev->pdev->dev, DMA_BIT_MASK(32));

> to prevent hitting the erratum.

So is there a known erratum about these chips? I didn't find errata
documents online, but I only did a short google search and may have
missed them.

> However your bug looks to be:

> -       if (INTEL_INFO(dev)->gen >= 4)
> -               dev_priv->dma_status_page |= (dev_priv->dma_status_page >> 28) &
> -                                            0xf0;
> +       if (INTEL_INFO(dev)->gen >= 4) /* 36-bit addressing */
> +               dev_priv->dma_status_page |=
> +                       (dev_priv->status_page_dmah->busaddr >> 28) & 0xf0;

Don't think so. dev_priv->dma_status_page gets initialized to
dev_priv->status_page_dmah->busaddr a few lines above, and it's 64 bit,
so that diff doesn't change the result of the computation.

Jan

