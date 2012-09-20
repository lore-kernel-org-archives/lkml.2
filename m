Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab2ITJmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 05:42:18 -0400
Received: from mga14.intel.com ([143.182.124.37]:32348 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506Ab2ITJmR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 05:42:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,453,1344236400"; 
   d="scan'208";a="147085643"
Message-ID: <1348134130.13371.39.camel@smile>
Subject: Re: [PATCH 5/7] dw_dmac: autoconfigure data_width or get it via
 platform data
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: viresh kumar <viresh.kumar@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, Hein Tibosch <hein_tibosch@yahoo.es>
Date: Thu, 20 Sep 2012 12:42:10 +0300
In-Reply-To: <CAOh2x=kRV-K+0SfBwoTkA641G9CeQWP4-4COMZKmkZGNL=1Dgw@mail.gmail.com>
References: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1347867577-13170-6-git-send-email-andriy.shevchenko@linux.intel.com>
	 <CAOh2x=kRV-K+0SfBwoTkA641G9CeQWP4-4COMZKmkZGNL=1Dgw@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-18 at 12:41 +0530, viresh kumar wrote: 
> On Mon, Sep 17, 2012 at 1:09 PM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > @@ -647,7 +657,11 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
> >                 return NULL;
> >         }
> >
> > -       src_width = dst_width = dwc_fast_fls(src | dest | len);
> > +       src_width = dst_width = min_t(unsigned int,
> > +                                     /* For memory-to-memory transfers we
> > +                                      * always use AHB master 1 */
> 
> Sorry couldn't understand your comment. :(
> We use master 0 for src and master 1 for dst in memcpy.
Yeah, it might require to rewrite the logic a bit to depend on proper
AHB master properties.

I will fix it.

> > @@ -747,7 +764,9 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
> >                         mem = sg_dma_address(sg);
> >                         len = sg_dma_len(sg);
> >
> > -                       mem_width = dwc_fast_fls(mem | len);
> > +                       mem_width = min_t(unsigned int,
> > +                                         data_width,
> > +                                         dwc_fast_fls(mem | len));
> 
> can above three be merged into a single line or two lines?
I think so, if there no objections from checkpatch.pl side.

> > @@ -807,7 +828,9 @@ slave_sg_todev_fill_desc:
> >                         mem = sg_dma_address(sg);
> >                         len = sg_dma_len(sg);
> >
> > -                       mem_width = dwc_fast_fls(mem | len);
> > +                       mem_width = min_t(unsigned int,
> > +                                         data_width,
> > +                                         dwc_fast_fls(mem | len));
> 
> ditto
See above.

> > @@ -1413,6 +1436,17 @@ static int __devinit dw_probe(struct platform_device *pdev)
> >
> >         /* get hardware configuration parameters */
> >         max_blk_size = dma_readl(dw, MAX_BLK_SIZE);
> > +       if (autocfg)
> > +               dw->nr_masters = (dw_params >> DW_PARAMS_NR_MASTER & 3) + 1;
> > +       else
> > +               dw->nr_masters = pdata->nr_masters;
> > +       for (i = 0; i < dw->nr_masters; i++) {
> > +               if (autocfg)
> > +                       dw->data_width[i] =
> > +                               (dw_params >> DW_PARAMS_DATA_WIDTH(i) & 3) + 2;
> > +               else
> > +                       dw->data_width[i] = pdata->data_width[i];
> > +       }
> 
> There are many autocfg, if, else statements now in probe. Can you try
> to group these
> into as minimum if, else calls?
Ok, will try to optimize it.

> > --- a/drivers/dma/dw_dmac_regs.h
> > +++ b/drivers/dma/dw_dmac_regs.h
> > @@ -106,6 +106,12 @@ struct dw_dma_regs {
> >
> >  /* Bitfields in DW_PARAMS */
> >  #define DW_PARAMS_NR_CHAN      8               /* number of channels */
> > +#define DW_PARAMS_NR_MASTER    11              /* number of AHB masters */
> > +#define DW_PARAMS_DATA_WIDTH(n)        (15 + 2 * (n))
> > +#define DW_PARAMS_DATA_WIDTH1  15              /* master 1 data width */
> > +#define DW_PARAMS_DATA_WIDTH2  17              /* master 2 data width */
> > +#define DW_PARAMS_DATA_WIDTH3  19              /* master 3 data width */
> > +#define DW_PARAMS_DATA_WIDTH4  21              /* master 4 data width */
> >  #define DW_PARAMS_EN           28              /* encoded parameters */

> Do these changes in a single patch 2/7
>From this comment I guess you would like to have dw_dmac_regs.h changes
at one place. Am I right?


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
