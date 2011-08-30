Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029Ab1H3LU6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 07:20:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59174 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab1H3LU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 07:20:57 -0400
Date: Tue, 30 Aug 2011 13:20:52 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Vinod Koul <vinod.koul@linux.intel.com>
cc: Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Magnus Damm <damm@opensource.se>
Subject: Re: [PATCH] serial: sh-sci: don't filter on DMA device, use only
 channel ID
In-Reply-To: <1314698522.1606.164.camel@vkoul-udesk3>
Message-ID: <Pine.LNX.4.64.1108301317280.19151@axis700.grange>
References: <Pine.LNX.4.64.1106241354060.6014@axis700.grange> 
 <1308916071.1536.4.camel@vkoul-udesk3>  <20110829080047.GJ31809@linux-sh.org>
  <CANqRtoRn-Csu+Rns6dn6=cJmRqbZfLKXA9brs8Ug9rFvGRn78w@mail.gmail.com> 
 <1314618931.1606.114.camel@vkoul-udesk3>  <Pine.LNX.4.64.1108300931220.19151@axis700.grange>
 <1314698522.1606.164.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:VR6HDirRMSda/7SZg2dTErR+hHQkkOTnhQs9wLabAlq
 OjMFjnPApnwUkLS+1V1BZD2TgRVwjaKUpDsa6+u8/dZQh7upR6
 p6spnAvtheNuR7cHCQlBxbUczSRP1Ki1EOelzYyaHHIIeYJYH+
 GiSRxurAhC2Q5OjBsfUDRbDPEJ4SKlOdCTMkzzpxNa8TvoUw5n
 0QLOGeLpjkwUkYbrpTbTDKzOJnkwviKpRFhRk0KjenOtWzkLJb
 JDbfjkkBWTbKnsE+sp7HIttl+X1KTQBIt9g0dUt1Pmq2nJrVTV
 u4vaefXcDGDVjtVhHuHHW+NTZyfwzTu53gyXWo2JJYPLWf8lN7
 1cfWiHCtYToFjcDpXtn9f54l00LOlEGwDpD0nCfGZP9jy5sYp7
 A9BS89e7Axqig==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Aug 2011, Vinod Koul wrote:

> On Tue, 2011-08-30 at 09:54 +0200, Guennadi Liakhovetski wrote:
> > On Mon, 29 Aug 2011, Vinod Koul wrote:
> > > > >> You should not assign chan->private.
> > > > >> Please move this  to dma_slave_control API
> > > > >
> > > > > I haven't seen any reply to this comment and this patch seems to still be
> > > > > outstanding, is there an updated version of this patch that I've missed?
> > > I don't recall seeing any updated version fixing this 
> > 
> > As a matter of fact, when you say "use dma_slave_control API," you 
> > actually mean the dma_slave_config, right? Then, how is one supposed to 
> > use it in this case? Shall we be issuing a DMA_SLAVE_CONFIG call inside of 
> > the filter and check the return code? The problem is, that not all DMA 
> > controllers on sh-mobile SoCs can service the same slave devices. So, if 
> > we don't check in the filter we might well get an unsuitable DMA channel.
> Here you are assigning to chan->private your specific values, which
> should be moved to the dma_slave_config. 
> But here you are removing the checks, and accepting the first channel
> you got, so how do you find channel is suitable or not.

That's done in the driver's .device_alloc_chan_resources() method. It 
checkx the .private pointer, tries to find a suitable channel, if it fails 
- it returns -EINVAL. See 
drivers/dma/shdma.c::sh_dmae_alloc_chan_resources():

	if (param) {
		const struct sh_dmae_slave_config *cfg;

		cfg = sh_dmae_find_slave(sh_chan, param);
		if (!cfg) {
			ret = -EINVAL;
			goto efindslave;
		}

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
