Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab0G1HvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 03:51:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:36884 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754334Ab0G1HvE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 03:51:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,272,1278313200"; 
   d="scan'208";a="590426332"
From: "Koul, Vinod" <vinod.koul@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linus.ml.walleij@gmail.com" <linus.ml.walleij@gmail.com>,
        Alan Cox <alan@linux.intel.com>
Date: Wed, 28 Jul 2010 13:20:37 +0530
Subject: RE: Resend [PATCH] intel_mid: Add Mrst & Mfld DMA Drivers
Thread-Topic: Resend [PATCH] intel_mid: Add Mrst & Mfld DMA Drivers
Thread-Index: AcsuHtgSWUVf//yHSbuE2z/5Mv9lqQACMl9A
Message-ID: <438BB0150E931F4B9CE701519A44630104A547AD6D@bgsmsx502.gar.corp.intel.com>
References: <1279699090-26032-1-git-send-email-vinod.koul@intel.com>
 <AANLkTi=dORrwVO4H-JkN42=Er-21haEHcxnrhC+NC24J@mail.gmail.com>
In-Reply-To: <AANLkTi=dORrwVO4H-JkN42=Er-21haEHcxnrhC+NC24J@mail.gmail.com>
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

> The use of the prep_dma_memcpy routine instead of prep_slave_sg is a
> bit odd for device-to-memory dma because the dma_addr_t type only
> describes the bus address view of host memory from the device
> perspective.  Other slave dma devices are using a backdoor method
> (since a good abstraction does not exist) to associate a known channel
> to a known device and then specifying the host address and a direction
> via prep_slave_sg.  I see that this usage of dma_addr_t was inherited
> from the dw_spi implementation, so not much we can do about it now,
> but I don't think its a model we want to perpetuate.
For the four controllers this drivers supports, two don't have sg support in 
hardware. For the other two I am going to add the sg support next, expect the 
patch for that in few weeks or so.


> I do see that the dw_spi_mid driver is only calling
> dma_request_channel(mask, NULL, NULL).  Are we guaranteed that
> dw_spi_mid silicon collateral will only ever exist on an intel_mid_dma
> platform?  Otherwise can the dw_mid_spi driver survive talking to
> another random DMA_SLAVE|DMA_MEMCPY channel?  The purpose of the
> filter_fn parameter to dma_request_channel() is to guarantee (by
> arch-specific hackery) that you are talking to a known compatible
> channel for your device.
Yes, the filter function in these drivers is supposed to look for this device 
and accept dma channel for specific controller only.
I looked at dw_spi_mid driver and yes it is indeed doing the wrong thing, I will 
send the patch to its maintainer to fix this.
Other driver which use this and are not upstream seem to be using the filter 
function properly

> > +{
> > +       struct intel_mid_dma_chan *midc;
> > +       struct intel_mid_dma_desc *desc = NULL;
> > +       struct intel_mid_dma_slave *mids;
> > +       union intel_mid_dma_ctl_lo ctl_lo;
> > +       union intel_mid_dma_ctl_hi ctl_hi;
> > +       union intel_mid_dma_cfg_lo cfg_lo;
> > +       union intel_mid_dma_cfg_hi cfg_hi;
> > +       enum intel_mid_dma_width width = 0;
> > +
> > +       pr_debug("MDMA: Prep for memcpy\n");
> > +       WARN_ON(!chan);
> > +       if (!len)
> > +               return NULL;
> > +
> > +       mids = chan->private;
> > +       WARN_ON(!mids);
> > +
> > +       midc = to_intel_mid_dma_chan(chan);
> > +       WARN_ON(!midc);
> 
> These WARN_ONs are a bit odd because if they trigger we'll hit null
> pointer dereferences soon afterwards.  Is that what you wanted?
Agreed, I will send another patch to fix this

> > +struct intel_mid_dma_slave {
[snip]
> 
> For 2.6.37 I'd like to see a conversion of this to the result of
> Linus' dma_slave_config work, but this isn't a blocker for 2.6.36.
Yes, I will update this to use dma_slave_config when I add the DMA sg support

> 
> *applied with a fix for:
> drivers/dma/intel_mid_dma.c:511: warning: format %d expects type int,
> but argument 4 has type size_t
