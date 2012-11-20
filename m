Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072Ab2KTPKo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 10:10:44 -0500
Received: from mga03.intel.com ([143.182.124.21]:10086 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312Ab2KTPKn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 10:10:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,286,1352102400"; 
   d="scan'208";a="170579798"
Message-ID: <1353424232.20110.18.camel@smile>
Subject: Re: [PATCH 1/2] dw_dmac: store direction in the custom channel
 structure
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>, spear-devel <spear-devel@list.st.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 20 Nov 2012 17:10:32 +0200
In-Reply-To: <CAKohpom4Dd=ubVL8shGSOvCCUBYqRRPOViS6V0_7SrOzADb95A@mail.gmail.com>
References: <1353418726-7879-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <CAKohpom4Dd=ubVL8shGSOvCCUBYqRRPOViS6V0_7SrOzADb95A@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-20 at 19:38 +0530, Viresh Kumar wrote: 
> On 20 November 2012 19:08, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > Currently the direction value is come from the generic slave configuration
> 
> s/is come/comes
> 
> > structure and explicitly as a preparation function parameter. The first one is
> > kinda obsoleted. Thus, we have to store the value passed to the preparation
> > function somewhere in our structures to be able to use it later. The best
> > candidate to provide the storage is a custom channel structure. Until now we
> > still keep and check the direction field of the slave config structure as well.
> >
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > ---
> >  drivers/dma/dw_dmac.c      |   10 ++++++++--
> >  drivers/dma/dw_dmac_regs.h |    2 ++
> >  2 files changed, 10 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> > index 5e2c4dc..58c6d3c 100644
> > --- a/drivers/dma/dw_dmac.c
> > +++ b/drivers/dma/dw_dmac.c
> > @@ -178,9 +178,9 @@ static void dwc_initialize(struct dw_dma_chan *dwc)
> >                 cfghi = dws->cfg_hi;
> >                 cfglo |= dws->cfg_lo & ~DWC_CFGL_CH_PRIOR_MASK;
> >         } else {
> > -               if (dwc->dma_sconfig.direction == DMA_MEM_TO_DEV)
> > +               if (dwc->direction == DMA_MEM_TO_DEV)
> >                         cfghi = DWC_CFGH_DST_PER(dwc->dma_sconfig.slave_id);
> > -               else if (dwc->dma_sconfig.direction == DMA_DEV_TO_MEM)
> > +               else if (dwc->direction == DMA_DEV_TO_MEM)
> >                         cfghi = DWC_CFGH_SRC_PER(dwc->dma_sconfig.slave_id);
> >         }
> 
> I have a doubt here. This routine is called both for memcpy and slave transfers.
> Earlier if (dws), code was used to check slave/non-slave transfer but with your
> earlier patch, for if (!dws) case too, there can be slave transfers
> based on direction.
> 
> Consider a situation. A channel is used for slave transfers and have
> direction set
> to DMA_DEV_TO_MEM. Now, channel is freed and used for memcpy. Now the
> direction value is retained as we haven't updated it. So, is this a
> potential bug?

Yeah, good point. I think we have to set direction in all possible entry
points (prep functions only?). It means at least we need to update
memcpy prep as well.

I'll update patch tomorrow.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
