Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293Ab1FNFjR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 01:39:17 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54301 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab1FNFjN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 01:39:13 -0400
From: "Raju, Sundaram" <sundaram@ti.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "Koul, Vinod" <vinod.koul@intel.com>, Dan <dan.j.williams@intel.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Tue, 14 Jun 2011 11:08:51 +0530
Subject: RE: [RFC] dmaengine: add new api for preparing simple slave transfer
Thread-Topic: [RFC] dmaengine: add new api for preparing simple slave
 transfer
Thread-Index: Acwp1AuzHRHehwhDSluIXAeMxElYpAAf8iqA
Message-ID: <E0D41E29EB0DAC4E9F3FF173962E9E9403020B7B37@dbde02.ent.ti.com>
References: <E0D41E29EB0DAC4E9F3FF173962E9E940301FE2DED@dbde02.ent.ti.com>
	<20110609124723.GA24636@n2100.arm.linux.org.uk>
	<E0D41E29EB0DAC4E9F3FF173962E9E940301FE2EFB@dbde02.ent.ti.com>
	<20110609163206.GB24636@n2100.arm.linux.org.uk>
	<1307686397.10976.116.camel@vkoul-udesk3>
	<E0D41E29EB0DAC4E9F3FF173962E9E940301FE337F@dbde02.ent.ti.com>
	<20110610104318.GC24636@n2100.arm.linux.org.uk>
	<E0D41E29EB0DAC4E9F3FF173962E9E940301FE3452@dbde02.ent.ti.com>
	<20110610133338.GD24636@n2100.arm.linux.org.uk>
 <BANLkTimZ=v4W1hFJ7hvZRmyHMSU_3MmZEA@mail.gmail.com>
In-Reply-To: <BANLkTimZ=v4W1hFJ7hvZRmyHMSU_3MmZEA@mail.gmail.com>
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

Linus,

Thanks for the pointers.

> -----Original Message-----
> From: Linus Walleij [mailto:linus.walleij@linaro.org]
> Sent: Monday, June 13, 2011 7:43 PM
> To: Raju, Sundaram
> Cc: Russell King - ARM Linux; Koul, Vinod; Dan; davinci-linux-open-
> source@linux.davincidsp.com; linux-omap@vger.kernel.org; linux-
> kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org
> Subject: Re: [RFC] dmaengine: add new api for preparing simple slave transfer
> 
> On Fri, Jun 10, 2011 at 3:33 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Fri, Jun 10, 2011 at 05:18:46PM +0530, Raju, Sundaram wrote:
> >> Now DMACs capable of 3D transfer, do transfer of the whole 1D
> >> buffer per sync received or even whole 2D buffer per sync received
> >> (based on the sync rate programmed in the DMAC).
> >
> > The only issue which I see that we don't cover is the case where you want
> > to describe a single buffer which is organised as N bytes to be transferred,
> > M following bytes to be skipped, N bytes to be transferred, M bytes to be
> > skipped.  I doubt there are many controllers which can be programmed with
> > both 'N' and 'M' parameters directly.
> 
> Sundaram is this how your controller works?
> I mean the hardware can skip over sequences like this?
> 
> When we added the config interface to DMAengine I originally included
> a "custom config" call, but Dan wanted me to keep it out until we
> had some specific usecase for it. FSLDMA recently started
> to use it.
> 
> Notice how dmaengine_slave_config() is implemented:
> 
> static inline int dmaengine_slave_config(struct dma_chan *chan,
> 					  struct dma_slave_config *config)
> {
> 	return dmaengine_device_control(chan, DMA_SLAVE_CONFIG,
> 			(unsigned long)config);
> }
> 
> So what is passed to the driver is just an unsigned long.
> 
> This is actually modeled to be ioctl()-like so you can pass in a
> custom config to the same callback on the device driver,
> just use some other enumerator than DMA_SLAVE_CONFIG,
> say like FSLDMA already does with FSLDMA_EXTERNAL_START.
> 
> Just put some enumerator in enum dma_ctrl_cmd in
> dmaengine.h such as SDMA_TEXAS_STRIDE_CONFIG and call
> like this:
> 
> /* However that config struct needs to look, basically */
> static struct sdma_ti_stride_cgf = {
>      take = M,
>      skip = N,
> };
> 
> ret = chan->device->device_control(chan, SDMA_TEXAS_STRIDE_CONFIG,
> &sdma_ti_stride_cfg);
> 
> Or something like this.

Yes, the hardware can skip over sequences like that.
I also thought about your suggestion, at first before submitting the RFC.
But I dint pursue this because, this ioctl() call has to be made before
every single prepare call.

I may have to end up using this if we decide not to change the API
signature for prepare APIs.

I actually intend to use this for all DMAC related ioctl(). Configuring
the DMAC and programming various modes etc specific to the
DMAC. I suppose this is the only way to do it.
Let me know if there is any other way to do it.

Thanks,
Sundaram
