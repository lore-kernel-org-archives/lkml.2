Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913Ab2JQNhO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 09:37:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:1473 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756754Ab2JQNhM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 09:37:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,600,1344236400"; 
   d="scan'208";a="205587848"
Message-ID: <1350481018.3568.3.camel@smile>
Subject: Re: [PATCHv2 3/4] dw_dmac: change {dev_}printk() to corresponding
 macros
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: balbi@ti.com
Cc: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Date: Wed, 17 Oct 2012 16:36:58 +0300
In-Reply-To: <20121017130918.GD11394@arwen.pp.htv.fi>
References: <1350469879-16018-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1350469879-16018-4-git-send-email-andriy.shevchenko@linux.intel.com>
	 <20121017130918.GD11394@arwen.pp.htv.fi>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-17 at 16:09 +0300, Felipe Balbi wrote: 
> Hi,
> 
> On Wed, Oct 17, 2012 at 01:31:17PM +0300, Andy Shevchenko wrote:
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > ---
> >  drivers/dma/dw_dmac.c |   15 ++++++---------
> >  1 file changed, 6 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> > index c27c125..60b172a 100644
> > --- a/drivers/dma/dw_dmac.c
> > +++ b/drivers/dma/dw_dmac.c
> > @@ -456,9 +456,8 @@ static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
> >  
> >  static inline void dwc_dump_lli(struct dw_dma_chan *dwc, struct dw_lli *lli)
> >  {
> > -	dev_printk(KERN_CRIT, chan2dev(&dwc->chan),
> > -			"  desc: s0x%x d0x%x l0x%x c0x%x:%x\n",
> > -			lli->sar, lli->dar, lli->llp, lli->ctlhi, lli->ctllo);
> > +	dev_crit(chan2dev(&dwc->chan), "  desc: s0x%x d0x%x l0x%x c0x%x:%x\n",
> > +		 lli->sar, lli->dar, lli->llp, lli->ctlhi, lli->ctllo);
> 
> is this really critical ? To me it looks more like a debugging message.
This one is used in two cases, where one is marked as "error", another -
"critical"

> 
> >  }
> >  
> >  static void dwc_handle_error(struct dw_dma *dw, struct dw_dma_chan *dwc)
> > @@ -492,10 +491,8 @@ static void dwc_handle_error(struct dw_dma *dw, struct dw_dma_chan *dwc)
> >  	 * controller flagged an error instead of scribbling over
> >  	 * random memory locations.
> >  	 */
> > -	dev_printk(KERN_CRIT, chan2dev(&dwc->chan),
> > -			"Bad descriptor submitted for DMA!\n");
> > -	dev_printk(KERN_CRIT, chan2dev(&dwc->chan),
> > -			"  cookie: %d\n", bad_desc->txd.cookie);
> > +	dev_crit(chan2dev(&dwc->chan), "Bad descriptor submitted for DMA!\n");
> > +	dev_crit(chan2dev(&dwc->chan), "  cookie: %d\n", bad_desc->txd.cookie);
> 
> now this is critical, indeed. I would suggest using dev_WARN_ONCE() so
> that it's noisy enough to catch the failing user.
To this and upper comment, there is an explanation why it's critical. I
guess the WARN_ONCE is not good enough, for example if we have more than
one user making such noise.

> 
> >  	dwc_dump_lli(dwc, &bad_desc->lli);
> >  	list_for_each_entry(child, &bad_desc->tx_list, desc_node)
> >  		dwc_dump_lli(dwc, &child->lli);
> > @@ -1625,8 +1622,8 @@ static int __devinit dw_probe(struct platform_device *pdev)
> >  
> >  	dma_writel(dw, CFG, DW_CFG_DMA_EN);
> >  
> > -	printk(KERN_INFO "%s: DesignWare DMA Controller, %d channels\n",
> > -			dev_name(&pdev->dev), nr_channels);
> > +	pr_info("%s: DesignWare DMA Controller, %d channels\n",
> > +		dev_name(&pdev->dev), nr_channels);
> 
> you have a struct device available in platform_device, please use
> dev_info() or dev_dbg().
Agreed.


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
