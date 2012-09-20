Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab2ITJqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 05:46:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:42284 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753807Ab2ITJqn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 05:46:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,453,1344236400"; 
   d="scan'208";a="224484259"
Message-ID: <1348134396.13371.42.camel@smile>
Subject: Re: [PATCH 7/7] dw_dmac: introduce software emulation of LLP
 transfers
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: viresh kumar <viresh.kumar@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, Hein Tibosch <hein_tibosch@yahoo.es>
Date: Thu, 20 Sep 2012 12:46:36 +0300
In-Reply-To: <CAOh2x=m3-XYEjJTh02AmnzoKJODAFf+OyQXtXaAdKTx3=GLrdg@mail.gmail.com>
References: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1347867577-13170-8-git-send-email-andriy.shevchenko@linux.intel.com>
	 <CAOh2x=m3-XYEjJTh02AmnzoKJODAFf+OyQXtXaAdKTx3=GLrdg@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-18 at 12:47 +0530, viresh kumar wrote: 
> On Mon, Sep 17, 2012 at 1:09 PM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > @@ -555,8 +594,36 @@ static void dw_dma_tasklet(unsigned long data)
> >                         dwc_handle_cyclic(dw, dwc, status_err, status_xfer);
> >                 else if (status_err & (1 << i))
> >                         dwc_handle_error(dw, dwc);
> > -               else if (status_xfer & (1 << i))
> > +               else if (status_xfer & (1 << i)) {
> > +                       unsigned long flags;
> > +
> > +                       spin_lock_irqsave(&dwc->lock, flags);
> > +                       if (test_bit(DW_DMA_IS_SOFT_LLP, &dwc->flags)) {
> > +                               if (dwc->tx_node_active != dwc->tx_list) {
> > +                                       struct dw_desc *desc =
> > +                                               list_entry(dwc->tx_node_active,
> > +                                                          struct dw_desc,
> > +                                                          desc_node);
> 
> can come in single line.
Depends on checkpatch.pl. Anyway I'll try to squeeze it.

> > @@ -647,12 +714,6 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
> >         unsigned int            dst_width;
> >         u32                     ctllo;
> >
> > -       if (dwc->nollp) {
> > -               dev_dbg(chan2dev(&dwc->chan),
> > -                               "channel doesn't support LLP transfers\n");
> > -               return NULL;
> > -       }
> > -
> 
> :)
> You should actually merge 6/7 with 7/7... You can't revert something
> in the same patchset.
Ok. It was done just in regard to have a bisectability working.


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
