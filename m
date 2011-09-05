Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365Ab1IEIE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 04:04:29 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:63738 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab1IEIEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 04:04:21 -0400
Date: Mon, 5 Sep 2011 10:04:18 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Vinod Koul <vinod.koul@linux.intel.com>
cc: Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Magnus Damm <damm@opensource.se>
Subject: Re: [PATCH] serial: sh-sci: don't filter on DMA device, use only
 channel ID
In-Reply-To: <Pine.LNX.4.64.1108301332190.19151@axis700.grange>
Message-ID: <Pine.LNX.4.64.1109051002400.1112@axis700.grange>
References: <Pine.LNX.4.64.1106241354060.6014@axis700.grange> 
 <1308916071.1536.4.camel@vkoul-udesk3>  <20110829080047.GJ31809@linux-sh.org>
  <CANqRtoRn-Csu+Rns6dn6=cJmRqbZfLKXA9brs8Ug9rFvGRn78w@mail.gmail.com> 
 <1314618931.1606.114.camel@vkoul-udesk3>  <Pine.LNX.4.64.1108300931220.19151@axis700.grange>
  <1314698522.1606.164.camel@vkoul-udesk3>  <Pine.LNX.4.64.1108301317280.19151@axis700.grange>
 <1314703426.1606.167.camel@vkoul-udesk3> <Pine.LNX.4.64.1108301332190.19151@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:2ZPKevBWtA2lranUb6cfV9zlVct5tUdciaaoSDFtor9
 5hyk2fpYgF5P1Qf6dTX7m2mPSShIUByW5QwPl/PJdQXahP8+2+
 AOsik9ZPdrjCoUFW9uV/73xl00D8J4gsaa4UjmgfDEGUOXZRi3
 DUXW2G8oNA7njPBBK2Mf9vY+zgIC+U2iBHQy3C9+uPI+08lLM0
 EdytUO/58kyWD2fHVBu96IQORoJvqIgZRlqityy1+1cVqhdSCV
 L5z4ZKcu+Kn0g1p4daLiGX/G+vMfwUR6HgCokYIalfyMFBOiZH
 xradn/f0zJHZQKPj3b2xIxXyc5qsE+iFDyYjaR5iN5ITvJPERb
 RAhtrV5SRBiKIqFFOwU7/8yWAJmVjpVsPN5KtCUsgMjwzC/32G
 v68K92EwtdksQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod

On Tue, 30 Aug 2011, Guennadi Liakhovetski wrote:

> On Tue, 30 Aug 2011, Vinod Koul wrote:
> 
> > On Tue, 2011-08-30 at 13:20 +0200, Guennadi Liakhovetski wrote:
> > > On Tue, 30 Aug 2011, Vinod Koul wrote:
> > > 
> > > > On Tue, 2011-08-30 at 09:54 +0200, Guennadi Liakhovetski wrote:
> > > > > On Mon, 29 Aug 2011, Vinod Koul wrote:
> > > > > > > >> You should not assign chan->private.
> > > > > > > >> Please move this  to dma_slave_control API
> > > > > > > >
> > > > > > > > I haven't seen any reply to this comment and this patch seems to still be
> > > > > > > > outstanding, is there an updated version of this patch that I've missed?
> > > > > > I don't recall seeing any updated version fixing this 
> > > > > 
> > > > > As a matter of fact, when you say "use dma_slave_control API," you 
> > > > > actually mean the dma_slave_config, right? Then, how is one supposed to 
> > > > > use it in this case? Shall we be issuing a DMA_SLAVE_CONFIG call inside of 
> > > > > the filter and check the return code? The problem is, that not all DMA 
> > > > > controllers on sh-mobile SoCs can service the same slave devices. So, if 
> > > > > we don't check in the filter we might well get an unsuitable DMA channel.
> > > > Here you are assigning to chan->private your specific values, which
> > > > should be moved to the dma_slave_config. 
> > > > But here you are removing the checks, and accepting the first channel
> > > > you got, so how do you find channel is suitable or not.
> > > 
> > > That's done in the driver's .device_alloc_chan_resources() method. It 
> > > checkx the .private pointer, tries to find a suitable channel, if it fails 
> > > - it returns -EINVAL. See 
> > > drivers/dma/shdma.c::sh_dmae_alloc_chan_resources():
> > > 
> > > 	if (param) {
> > > 		const struct sh_dmae_slave_config *cfg;
> > > 
> > > 		cfg = sh_dmae_find_slave(sh_chan, param);
> > > 		if (!cfg) {
> > > 			ret = -EINVAL;
> > > 			goto efindslave;
> > > 		}
> > Now am doubly confused. Are you saying that you are using
> > alloc_chan_resources for doing filtering??
> 
> Let's look at __dma_request_channel(). It iterates over DMA devices and 
> calls private_candidate() for each of them, which in turn calls the filter 
> function for each free channel on the current device. As soon as the 
> filter returns "true" for one of channels, a private candidate is found. 
> And in my filter I do exactly this - assign the .private pointer and 
> return "true." Next dma_chan_get() is called, which in turn calls driver's 
> .device_alloc_chan_resources() method. There we check the previously set 
> .private pointer to see, if this slave can be served by this DMA device. 
> On sh-mobile you can freely configure single DMA channels for different 
> slaves, as long as this slave is at all supported by the current DMA 
> controller device. If this slave can be supported - all is good, we use 
> the private data to configure the channel. If not - we return an error and 
> __dma_request_channel() iterates to the next DMA controller device, which 
> is exactly what we need.

Haven't heard back from you after this my reply. Does this mean, that 
you're now satisfied with my explanation and are going to apply my patch?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
