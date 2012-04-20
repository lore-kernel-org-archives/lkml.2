Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab2DTKEy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 06:04:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:57468 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754010Ab2DTKEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 06:04:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="132028580"
Subject: Re: [dmaengine] Cyclic DMA regression.
From: Vinod Koul <vinod.koul@linux.intel.com>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <s.hauer@pengutronix.de>
In-Reply-To: <CACKLOr2ZUpLQDWp4sBSxEWPmh15dO4exOvydZfm1FcCcGspnJg@mail.gmail.com>
References: <CACKLOr2-=BF4AV=ZDizj9D37OL-d9D06p6R+dp9cJ_vDbBwqBw@mail.gmail.com>
	 <1333606083.31825.4.camel@vkoul-udesk3>
	 <CACKLOr2ZUpLQDWp4sBSxEWPmh15dO4exOvydZfm1FcCcGspnJg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Apr 2012 15:32:19 +0530
Message-ID: <1334916139.31825.31.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-09 at 09:09 +0200, javier Martin wrote:
> On 5 April 2012 08:08, Vinod Koul <vinod.koul@linux.intel.com> wrote:
> > this is not right fix. The problem is that we shouldn't mark the cyclic
> > descriptor as complete. So for all drivers using cyclic API they should
> > do something like this. Can you test if this fixes your issue.
> > -----------------
> > diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
> > index a45b5d2..0c7362a 100644
> > --- a/drivers/dma/imx-dma.c
> > +++ b/drivers/dma/imx-dma.c
> > @@ -571,11 +571,14 @@ static void imxdma_tasklet(unsigned long data)
> >        if (desc->desc.callback)
> >                desc->desc.callback(desc->desc.callback_param);
> >
> > -       dma_cookie_complete(&desc->desc);
> > -
> > -       /* If we are dealing with a cyclic descriptor keep it on ld_active */
> > +       /* If we are dealing with a cyclic descriptor keep it on ld_active
> > +        * and don't mark the descriptor as complete.
> > +        * Only in non-cyclic cases it would be marked as complete
> > +        */
> >        if (imxdma_chan_is_doing_cyclic(imxdmac))
> >                goto out;
> > +       else
> > +               dma_cookie_complete(&desc->desc);
> >
> >        /* Free 2D slot if it was an interleaved transfer */
> >        if (imxdmac->enabled_2d) {
> >
> >
> > --
> > ~Vinod
> >
> 
> Hi Vinod,
> thank you for your patch.
> 
> It works fine for me:
> 
> Tested-by: Javier Martin <javier.martin@vista-silicon.com>
> 
> Could you apply it in your tree as a fix for 3.4?
Thanks, Applied now


-- 
~Vinod

