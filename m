Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab1IENtM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 09:49:12 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:52251 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab1IENtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 09:49:09 -0400
Date: Mon, 5 Sep 2011 15:48:58 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Vinod Koul <vinod.koul@linux.intel.com>
cc: Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Magnus Damm <damm@opensource.se>
Subject: Re: [PATCH] serial: sh-sci: don't filter on DMA device, use only
 channel ID
In-Reply-To: <1315228408.26251.75.camel@vkoul-udesk3>
Message-ID: <Pine.LNX.4.64.1109051532220.1112@axis700.grange>
References: <Pine.LNX.4.64.1106241354060.6014@axis700.grange> 
 <1308916071.1536.4.camel@vkoul-udesk3>  <20110829080047.GJ31809@linux-sh.org>
  <CANqRtoRn-Csu+Rns6dn6=cJmRqbZfLKXA9brs8Ug9rFvGRn78w@mail.gmail.com> 
 <1314618931.1606.114.camel@vkoul-udesk3>  <Pine.LNX.4.64.1108300931220.19151@axis700.grange>
  <1314698522.1606.164.camel@vkoul-udesk3>  <Pine.LNX.4.64.1108301317280.19151@axis700.grange>
  <1314703426.1606.167.camel@vkoul-udesk3>  <Pine.LNX.4.64.1108301332190.19151@axis700.grange>
  <Pine.LNX.4.64.1109051002400.1112@axis700.grange> <1315228408.26251.75.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:c1eFj9OG662ThE4lmRW1yifBUQPtJQlyZd62ykUcch2
 4LEpgeNZXvdDCPukTvxjKzwLnveUuzIBBuRkitBdoXBpZPm5CV
 eBirOPkO1pxbmGdwtBkBCQ0hxSUmOUFRDec8u6s+ltLRPODQpj
 s5J1HalD9P9ZHKlUkEC8aKWdi53DQClretu5q+LF0OYFmtJ/JJ
 rtJG6gWs+IbVL54mxHcEuvr7KKFaSowewnoFWOOZPScuF4nyBY
 BofnIMYS9PyUv4Mxc25nilZDqlHqHcNFe7cUuyPeoZstECg1AV
 i7kpVEWCWuezGZOwNrXXYPSiC9PFhgl5RwFiIKMD581Xr70Fgm
 4Vik7NfO5dcziDVA4MNas64q6AdYBIM+f/EXtTUMzU4pOH3nQ9
 /iBVgPF/N7zBQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Sep 2011, Vinod Koul wrote:

> On Mon, 2011-09-05 at 10:04 +0200, Guennadi Liakhovetski wrote:
> > Hi Vinod
> > 
> > On Tue, 30 Aug 2011, Guennadi Liakhovetski wrote:
> > 
> > > On Tue, 30 Aug 2011, Vinod Koul wrote:
> > > 
> > > > On Tue, 2011-08-30 at 13:20 +0200, Guennadi Liakhovetski wrote:
> > > > > On Tue, 30 Aug 2011, Vinod Koul wrote:
> > > > > 
> > > > > > On Tue, 2011-08-30 at 09:54 +0200, Guennadi Liakhovetski wrote:
> > > > > > > On Mon, 29 Aug 2011, Vinod Koul wrote:
> > > > > > > > > >> You should not assign chan->private.
> > > > > > > > > >> Please move this  to dma_slave_control API
> > > > > > > > > >
> > > > > > > > > > I haven't seen any reply to this comment and this patch seems to still be
> > > > > > > > > > outstanding, is there an updated version of this patch that I've missed?
> > > > > > > > I don't recall seeing any updated version fixing this 
> > > > > > > 
> > > > > > > As a matter of fact, when you say "use dma_slave_control API," you 
> > > > > > > actually mean the dma_slave_config, right? Then, how is one supposed to 
> > > > > > > use it in this case? Shall we be issuing a DMA_SLAVE_CONFIG call inside of 
> > > > > > > the filter and check the return code? The problem is, that not all DMA 
> > > > > > > controllers on sh-mobile SoCs can service the same slave devices. So, if 
> > > > > > > we don't check in the filter we might well get an unsuitable DMA channel.
> > > > > > Here you are assigning to chan->private your specific values, which
> > > > > > should be moved to the dma_slave_config. 
> > > > > > But here you are removing the checks, and accepting the first channel
> > > > > > you got, so how do you find channel is suitable or not.
> > > > > 
> > > > > That's done in the driver's .device_alloc_chan_resources() method. It 
> > > > > checkx the .private pointer, tries to find a suitable channel, if it fails 
> > > > > - it returns -EINVAL. See 
> > > > > drivers/dma/shdma.c::sh_dmae_alloc_chan_resources():
> > > > > 
> > > > > 	if (param) {
> > > > > 		const struct sh_dmae_slave_config *cfg;
> > > > > 
> > > > > 		cfg = sh_dmae_find_slave(sh_chan, param);
> > > > > 		if (!cfg) {
> > > > > 			ret = -EINVAL;
> > > > > 			goto efindslave;
> > > > > 		}
> > > > Now am doubly confused. Are you saying that you are using
> > > > alloc_chan_resources for doing filtering??
> > > 
> > > Let's look at __dma_request_channel(). It iterates over DMA devices and 
> > > calls private_candidate() for each of them, which in turn calls the filter 
> > > function for each free channel on the current device. As soon as the 
> > > filter returns "true" for one of channels, a private candidate is found. 
> > > And in my filter I do exactly this - assign the .private pointer and 
> > > return "true." Next dma_chan_get() is called, which in turn calls driver's 
> > > .device_alloc_chan_resources() method. There we check the previously set 
> > > .private pointer to see, if this slave can be served by this DMA device. 
> > > On sh-mobile you can freely configure single DMA channels for different 
> > > slaves, as long as this slave is at all supported by the current DMA 
> > > controller device. If this slave can be supported - all is good, we use 
> > > the private data to configure the channel. If not - we return an error and 
> > > __dma_request_channel() iterates to the next DMA controller device, which 
> > > is exactly what we need.
> > 
> > Haven't heard back from you after this my reply. Does this mean, that 
> > you're now satisfied with my explanation and are going to apply my patch?
> > 
> Sorry for the delay, we had a v long weekend here in India :)
> I am still not fully convinced yet. Why do you need the private pointer
> to be assigned in filter function? Once you return true for a channel in
> filter function, you should be able to use the channel properly.
> Assuming that you are calling for correct channel and you have set your
> private pointer (i don't understand for why/what), then above check
> seems to be bogus, why should you check again
> in .device_alloc_chan_resources?

That's exactly what I tried to explain above:

> > > On sh-mobile you can freely configure single DMA channels for different
> > > slaves, as long as this slave is at all supported by the current DMA
> > > controller device. If this slave can be supported - all is good, we use
> > > the private data to configure the channel. If not - we return an error and
> > > __dma_request_channel() iterates to the next DMA controller device, which
> > > is exactly what we need.

Let me try again. DMA channels on these DMA controllers are not dedicated. 
On one such SoC there can be several such DMA controllers of different 
kinds. One kind is "generic" - it can do memcpy(), besides channels can be 
freely configured for one of onboard peripherals: serial, mmc, etc. Some 
of them can also serve external DMA-capable devices. Another kind of DMA 
controllers, served by the same driver, can only be used with USB 
controllers. Now, if the MMC driver requests a DMA channel, let's say, the 
dmaengine core first finds the USB DMA controller. The MMC driver cannot 
know this. It assigns its MMC DMA configuration to the.private pointer and 
returns true. Next the DMA driver is entered, it checks the private 
pointer, sees an MMC channel request, looks at the DMA controller and 
sees, that it doesn't support MMC. So, .device_alloc_chan_resources() 
fails. When the same is attempted with a suitable DMA controller, the 
shdma driver recognises, that the controller can service MMC and uses the 
data, provided the MMC driver, to configure the DMA channel for MMC.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
