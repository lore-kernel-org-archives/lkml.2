Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab1G1Wfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 18:35:47 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58383 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079Ab1G1Wfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 18:35:44 -0400
Date: Thu, 28 Jul 2011 23:35:05 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Jaswinder Singh <jaswinder.singh@linaro.org>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, per.friden@stericsson.com,
        wei.zhang@freescale.com, ebony.zhu@freescale.com, iws@ovro.caltech.edu,
        s.hauer@pengutronix.de, maciej.sosnowski@intel.com, saeed@marvell.com,
        shawn.guo@freescale.com, yur@emcraft.com, agust@denx.de,
        iwamatsu.nobuhiro@renesas.com, per.forlin@stericsson.com,
        jonas.aberg@stericsson.com, anemo@mba.ocn.ne.jp
Subject: Re: [PATCHv2] DMAEngine: Let dmac drivers to set chan_id
Message-ID: <20110728223505.GC829@flint.arm.linux.org.uk>
References: <CAJe_ZhcNM7m-eWA0nDUrOrHxeAhNS00gewf=txmvOFL_uOPhrw@mail.gmail.com> <1311740499.1536.56.camel@vkoul-udesk3> <CAJe_ZhfaPfobs5P+q+t-kRSK4fAvm-v_brYgqmco8fwOOBeT8A@mail.gmail.com> <1311757347.1536.103.camel@vkoul-udesk3> <20110727095909.GB16623@intel.com> <CAJe_ZhdkPpVSyCyiUsFhOUUms8=JSQOiC33ztFzriW8jQHaa_w@mail.gmail.com> <CABE8wwuAFMYHH67sjEuy7whiZD+QBmU6bvzUUzEqJQFaYpkgdQ@mail.gmail.com> <CAJe_Zhfm5k9gNPaTfpZdQ__cp9fKLZoiSvG0GPciVFbkkU=QCw@mail.gmail.com> <20110727202859.GA5028@flint.arm.linux.org.uk> <CAJe_ZheB0uKn=Rk-i2y1rn5ZHJUJJy7D_3Pb6d4ggjNDhh+6VA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJe_ZheB0uKn=Rk-i2y1rn5ZHJUJJy7D_3Pb6d4ggjNDhh+6VA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 28, 2011 at 04:14:34PM +0530, Jaswinder Singh wrote:
> For ex, for 'PITA' board, the dmac driver (via info directly gotten
> from platform) will announce
>   cap_rs8  := 'MMC' | '2ndInstance' | 'Dev->Mem'   //via probe of DMAC0
>   cap_rs31 := 'MMC' | '2ndInstance' | 'Dev->Mem'   //via probe of DMAC1
>   cap_rs8  := 'MMC' | '2ndInstance' | 'Mem->Dev'   //via probe of DMAC3
>   cap_rs57 := 'MMC' | '2ndInstance' | 'Mem->Dev'   //via probe of DMAC4

Most of this didn't look too bad until I got to here.

> Assuming
> ************
> a) There are no more than 256 types of DMA'able devices
>    (MMC, USB, SPI etc) --  [8bits]

Who allocates the 'type of dma' number ?

> b) A type of device never has more than 16 instances in a platform
>    (MMC-0, MMC-1, MMC-2 etc) --  [4bits]

How is the instance number given to devices ?

Are we expecting to have subsystems register with some kind of entity
which gives out 'type' and 'instance' numbers just to satisfy this?

In any case, if you look at Linus W's patches on LAKML for DMA on the
Versatile/Realview platforms, or look at the way AMBA drivers like MMCI
and PL011 UART deal with the 'filter' business, then I think you'd
realize that there's ways to deal with this match problem which are far
more flexible than your solution.

What we do there is:

1. We provide a match function from the platform to the peripheral driver.
   ==> this could be your special generic filter function.
2. We provide the match functions data from the platform to the peripheral
   driver.
   ==> this could be your special capability mask for that specific device.

So, as things stand _today_ if a platform wants to use your scheme, it
can.  But - and this is what makes things more flexible - if it needs to
do something else which your scheme can't handle, such as controlling an
external MUX which has nothing to do with the DMAC or peripheral apart
from sitting in the middle between the two - then it can do it its own
way.

I think that's a more flexible approach than any which enforces random
kinds of capabilities.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
