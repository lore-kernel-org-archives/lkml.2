Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab0LFM6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 07:58:45 -0500
Received: from mga11.intel.com ([192.55.52.93]:22913 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752839Ab0LFM6o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 07:58:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,305,1288594800"; 
   d="scan'208";a="864957934"
From: "Wang, Yong Y" <yong.y.wang@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ewe, Kok Howg" <kok.howg.ewe@intel.com>,
        "Wang, Qi" <qi.wang@intel.com>, "Clark, Joel" <joel.clark@intel.com>,
        "Foster, Margie" <margie.foster@intel.com>,
        "Khor, Andrew Chih Howe" <andrew.chih.howe.khor@intel.com>
Date: Mon, 6 Dec 2010 20:58:28 +0800
Subject: RE: [PATCH] dma : EG20T PCH: Fix miss-setting DMA descriptor
Thread-Topic: [PATCH] dma : EG20T PCH: Fix miss-setting DMA descriptor
Thread-Index: AcuTU1Ky46Dq5H8+RZutrajrJ1ICBwB8VAMg
Message-ID: <FC2FB65B4D919844ADE4BE3C2BB739AD331B2807@shsmsx501.ccr.corp.intel.com>
References: <4CF6284C.1010802@dsn.okisemi.com>
 <AANLkTi=BOYUwEAxWBhYVhco-Eo2n1isbb_kbJkao11XP@mail.gmail.com>
In-Reply-To: <AANLkTi=BOYUwEAxWBhYVhco-Eo2n1isbb_kbJkao11XP@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
> > index 92b6790..a3d54c0 100644
> > --- a/drivers/dma/pch_dma.c
> > +++ b/drivers/dma/pch_dma.c
> [..]
> > @@ -273,10 +268,16 @@ static void pdc_dostart(struct pch_dma_chan
> *pd_chan, struct pch_dma_desc* desc)
> >        dev_dbg(chan2dev(&pd_chan->chan), "chan %d -> next: %x\n",
> >                pd_chan->chan.chan_id, desc->regs.next);
> >
> > -       if (list_empty(&desc->tx_list))
> > +       if (list_empty(&desc->tx_list)) {
> > +               channel_writel(pd_chan, DEV_ADDR,
> desc->regs.dev_addr);
> > +               channel_writel(pd_chan, MEM_ADDR,
> desc->regs.mem_addr);
> > +               channel_writel(pd_chan, SIZE, desc->regs.size);
> > +               channel_writel(pd_chan, NEXT, desc->regs.next);
> >                pdc_set_mode(&pd_chan->chan,
> DMA_CTL0_ONESHOT);
> > -       else
> > +       } else {
> > +               channel_writel(pd_chan, NEXT,
> virt_to_phys(&desc->regs));
> 
> There is a reason for the following comment for virt_to_phys():
> 
> /*      This function does not give bus mappings for DMA transfers. In
>  *      almost all conceivable cases a device driver should not be using
>  *      this function
>  */
> 
> ...in this case this wants to be:
> 
>      channel_write(pd_chan, NEXT, desc->txd.phys);
> 
> I'll let Yong comment on the correctness of the rest.
> 

Hi Dan,

Apart from the issue you pointed out, the patch looks good to me. If it is convenient for you, please help make the change and merge this patch. Otherwise, please let Tomoya know that you want him to send an updated patch. Thanks!

Acked-by: Yong Wang <youg.y.wang@intel.com>

-Yong

