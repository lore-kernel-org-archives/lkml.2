Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643Ab1IGSmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 14:42:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:35642 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab1IGSmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 14:42:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="46158217"
From: "Koul, Vinod" <vinod.koul@intel.com>
To: "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>
CC: "Williams, Dan J" <dan.j.williams@intel.com>,
        "magnus.damm@gmail.com" <magnus.damm@gmail.com>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "damm@opensource.se" <damm@opensource.se>
Date: Thu, 8 Sep 2011 00:12:34 +0530
Subject: Re: [PATCH] serial: sh-sci: don't filter on DMA device, use only
 channel ID
Thread-Topic: [PATCH] serial: sh-sci: don't filter on DMA device, use only
 channel ID
Thread-Index: Acxtjej13mD+VLEKRMWAggmjFDnFaA==
Message-ID: <438BB0150E931F4B9CE701519A4463010871804A4B@bgsmsx502.gar.corp.intel.com>
References: <Pine.LNX.4.64.1106241354060.6014@axis700.grange>
 <1308916071.1536.4.camel@vkoul-udesk3> <20110829080047.GJ31809@linux-sh.org>
 <CANqRtoRn-Csu+Rns6dn6=cJmRqbZfLKXA9brs8Ug9rFvGRn78w@mail.gmail.com>
 <1314618931.1606.114.camel@vkoul-udesk3>
 <Pine.LNX.4.64.1108300931220.19151@axis700.grange>
 <1314698522.1606.164.camel@vkoul-udesk3>
 <Pine.LNX.4.64.1108301317280.19151@axis700.grange>
 <1314703426.1606.167.camel@vkoul-udesk3>
 <Pine.LNX.4.64.1108301332190.19151@axis700.grange>
 <Pine.LNX.4.64.1109051002400.1112@axis700.grange>
 <1315228408.26251.75.camel@vkoul-udesk3>
 <Pine.LNX.4.64.1109051532220.1112@axis700.grange>
 <1315233788.26251.163.camel@vkoul-udesk3>
 <Pine.LNX.4.64.1109051700030.1112@axis700.grange>
 <1315235335.26251.194.camel@vkoul-udesk3>
 <Pine.LNX.4.64.1109051716530.1112@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1109051716530.1112@axis700.grange>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p87Iglsj021895

On Mon, 2011-09-05 at 17:21 +0200, Guennadi Liakhovetski wrote:
> On Mon, 5 Sep 2011, Vinod Koul wrote:
> 
> > On Mon, 2011-09-05 at 17:01 +0200, Guennadi Liakhovetski wrote:
> > > On Mon, 5 Sep 2011, Vinod Koul wrote:
> > > 
> > > > On Mon, 2011-09-05 at 15:48 +0200, Guennadi Liakhovetski wrote:
> > > > > 
> > > > > Let me try again. DMA channels on these DMA controllers are not dedicated. 
> > > > > On one such SoC there can be several such DMA controllers of different 
> > > > > kinds. One kind is "generic" - it can do memcpy(), besides channels can be 
> > > > > freely configured for one of onboard peripherals: serial, mmc, etc. Some 
> > > > > of them can also serve external DMA-capable devices. Another kind of DMA 
> > > > > controllers, served by the same driver, can only be used with USB 
> > > > > controllers. Now, if the MMC driver requests a DMA channel, let's say, the 
> > > > > dmaengine core first finds the USB DMA controller. The MMC driver cannot 
> > > > > know this. It assigns its MMC DMA configuration to the.private pointer and 
> > > > > returns true. Next the DMA driver is entered, it checks the private 
> > > > > pointer, sees an MMC channel request, looks at the DMA controller and 
> > > > > sees, that it doesn't support MMC. So, .device_alloc_chan_resources() 
> > > > > fails. When the same is attempted with a suitable DMA controller, the 
> > > > > shdma driver recognises, that the controller can service MMC and uses the 
> > > > > data, provided the MMC driver, to configure the DMA channel for MMC.
> > > > Hmmm, Can't you know in filter function if the respective channel can do
> > > > the dma for you or not? Maybe export a dma function or use platform data
> > > > for this (wont you soc have these caps fixed), i prefer latter.
> > > > That maybe a better approach. 
> > > 
> > > How? On a system you can have 3 suitable DMA controllers and 2 unsuitable. 
> > > Do you want to pass a list of 3 suitable DMA controllers to each 
> > > peripheral driver?...
> > The peripheral driver (client driver in slave-dma terminology) should
> > already know which dmac it wants. (base on information in platform data
> > etc) That is why the filter function is provided. Please use it properly
> > Other soc have similar capabilities and they can filter properly so why
> > cant you..?
> 
> Sorry, I have been thinking about these possibilities, but I really didn't 
> find any similar case in existing drivers. Normally either channels are 
> fixed - only one channel can be used for a specific peripheral, or any at 
> all, or there is only one suitable controller. I only see two 
> possibilities here, and they both look ugly to me:
> 
> (1) pass a list of suitable DMA controllers to slave-dma drivers, there in 
> the filter you'd have to scan that list.
> (2) select only one out of several suitable DMA controllers in the 
> platform configuration - that needlessly reduces flexibility.
> 
> Whereas on the contrary, the DMA controller itself can perfectly look 
> through the list of supported peripherals on the current controller and 
> decide, whether the requested one is among them or not.
Then why not have shdma_filter_func() exported and then used by all your
clients for proper filtering.

I cant agree to the whole point of filtering in alloc

One channel is allocated, we should _not_ do any further filtering

> 
> > PS: This might well be my last post before Tue EOD PST, traveling to
> > LPC, if you are there feel free to chat with me on this.
> 
> No, unfortunately, I won#t be there. Are you coming to the KS in Prague in 
> October?
Not decided yet...

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
