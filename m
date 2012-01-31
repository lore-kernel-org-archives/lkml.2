Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab2AaI7n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 03:59:43 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:52680 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab2AaI7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 03:59:41 -0500
Date: Tue, 31 Jan 2012 09:59:36 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Vinod Koul <vinod.koul@intel.com>
cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        linux-mmc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-serial@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 1/7 v2] dmaengine: add a simple dma library
In-Reply-To: <1327992090.1527.116.camel@vkoul-udesk3>
Message-ID: <Pine.LNX.4.64.1201310746470.31226@axis700.grange>
References: <1327589784-4287-1-git-send-email-g.liakhovetski@gmx.de> 
 <1327589784-4287-2-git-send-email-g.liakhovetski@gmx.de> 
 <1327912346.1527.13.camel@vkoul-udesk3>  <Pine.LNX.4.64.1201300944360.7932@axis700.grange>
 <1327992090.1527.116.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:2Tta/zryeEHDBefwNpsGA3Ip8nRAQnaSeAP0iTz+qCn
 oHoVaxvO80XRB67Gkb0t+JuHAWVhxMlSDdhxOSQxASe7bn4m6f
 wqNF7urbMPinWps1gVVlh21Sj1Y1FpUjwLA5Kjo1mzUvgc2bZb
 dwpBVX2t7hJFYsiWS25MRYIcCVoE5qk9oIx6YXWjATvJyNqRrU
 oq4teA9+iQ8TTbLrQNIFOWyolJUqk1uVcXv08jZGF3PAhWre6B
 2C9Xlm/zYiROkhl5DuTxhehdB2YmHwvyJJy3iZE2td51b8imbJ
 KwqSGftolxtCQ+mZ8AQv0EddUZBXHrMr5Rf9oM7VB0yYDXPTpv
 JUrEM0jzPcSAhVKdZepOBxaBkejk/1Q66IEt1ZBsND9BOybx6Y
 ynpgNwBCyMADw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod

Thanks for your reply.

On Tue, 31 Jan 2012, Vinod Koul wrote:

> On Mon, 2012-01-30 at 10:34 +0100, Guennadi Liakhovetski wrote:
> > > I don't still comprehend the need for a library on top of dmaengine
> > > which gain is just a library between clients and dmacs. Surely we don't
> > > want to write another abstraction on top of one provided?
> > > 
> > > If the question is to handle scatter-gather even if the hardware doesn't
> > > have the capability, then why don't add that in dmaengine itself rather
> > > than one more layer?
> > 
> > Well, yes, adding new abstraction layers is always a decision, that has to 
> > be well justified. In this case it does at least make the life easier for 
> > two sh-mobile drivers: shdma and the new SUDMAC driver.
> > 
> > However, I did name the library in a generic way without reference to sh, 
> > assuming, that it might with time become useful for other architectures 
> > too. The reasons why I prefered to keep it as an optional addition to 
> > dmaengine core, instead of tightly integrating it with it are, that (1) I 
> > did not want to add useless code to drivers, that do not need it, 
> So are we sure that only sh-mobile drivers need this capablity?

If I was sure about that, I'd call the library shmobile-dma or something 
similar:-)

> Btw does you hardware only support single transfers and no sg support,

Well, the controller does have some repeat- and reload-modes, but they are 
currently not supported by the driver and from the documentation I cannot 
easily understand, how useful those modes could be to implement SG.

> would this remain the same in future?

Who knows?...

> > (2) I am 
> > not sure if and when this library will become useful for other drivers: 
> > apart from sh I am only familiar with one more dmaengine driver: 
> > ipu/ipu_idmac.c, and that one supports scatter-gather lists in a limited 
> > way and has some further peculiarities, that would likely make it a bad 
> > match for the simple DMA library,
> typically the dmacs will support this in some form or other, so your
> point is valid :)
> >  (3) keeping it separate makes its 
> > further development easier.
> > 
> > OTOH, I'm certainly fine with a tighter library integration with the 
> > dmaengine core. I think, it still would be better to keep it in a separate 
> > file and only build it if needed, right? This woult also simplify code 
> > debugging and further development. I can remove the "simple" notation, 
> > which does make it look like an additional abstraction layer, and replace 
> > it with, say, sgsoft (scatter-gather software implementation)?
> that would be more apt :)
> >  A more 
> > interesting question is what to do with struct dma_simple_dev, struct 
> > dma_simple_chan, struct dma_simple_desc, that embed struct dma_device, 
> > struct dma_chan and struct dma_async_tx_descriptor respectively. I don't 
> > think we want to merge all the additions from those wrapping structs back 
> > into their dmaengine counterparts?
> Sure they should be kept separate. I like the wrapping, this keeps it
> simple.
> > 
> > How would you like to do this? Don't you think, it would be good to allow 
> > both: either implement a dmaengine driver directly, exactly as all drivers 
> > are doing now, or use the additional helper library for suitable (simple) 
> > hardware types? I see it similar to I2C, where you either implement an I2C 
> > driver directly, or you use the bitbanging abstraction for simpler 
> > hardware.
> I think it would be good to have both, this can be used by folks who
> don't have sg support available.

Ok, so, should I just rename the driver to sgsoft? Is this the only 
change, that you'd like to see?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
