Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab2A3JeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 04:34:18 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:50782 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab2A3JeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 04:34:15 -0500
Date: Mon, 30 Jan 2012 10:34:02 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Vinod Koul <vinod.koul@intel.com>
cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        linux-mmc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-serial@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 1/7 v2] dmaengine: add a simple dma library
In-Reply-To: <1327912346.1527.13.camel@vkoul-udesk3>
Message-ID: <Pine.LNX.4.64.1201300944360.7932@axis700.grange>
References: <1327589784-4287-1-git-send-email-g.liakhovetski@gmx.de> 
 <1327589784-4287-2-git-send-email-g.liakhovetski@gmx.de>
 <1327912346.1527.13.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:LMcK7UPt3pCvq3gqhwRk4QnNxsjUGjmBby27nRlSTyy
 NCBtS93ur+Lf4uTvVR4gLToj19ZSUTuaP6vHajCUTpRx7friv+
 z6jVphp+sxfTX0vRlEUCKnHPBsG4i7+Y/pRP7WdtfyJz/ReXKL
 DW+6p/xk3HYxq3wZuFZnkRrHwahYKQ9Tk41l0SXF2KCFS7ERHz
 O7YtvIGBWfg3uS8FjaKiJI9AoDrfeimGtVKqkd3Lg1X5Bd+K2a
 KAcgJ7FfLqpPqO/fmjc3W/BZwZ+yf0ct+j3Z3+pMYN/UdJMDIg
 QPAyNb9nVl93lfuGsP/OSdA9hmBgs+KgdVeC06i5R7XuYWwYK4
 cmdAVDfygM2eFgRl9lWNZP+CuESfeIoDvdq4563c54KZXphvVw
 V1HSmjAn1TWAw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod

Thanks for your email.

On Mon, 30 Jan 2012, Vinod Koul wrote:

> On Thu, 2012-01-26 at 15:56 +0100, Guennadi Liakhovetski wrote:
> > This patch adds a library of functions, helping to implement dmaengine
> > drivers for hardware, unable to handle scatter-gather lists natively.
> > The first version of this driver only supports memcpy and slave DMA
> > operation.
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> > 
> > v2:
> > 
> > 1. switch from using a tasklet to threaded IRQ, which allowed to
> > 2. remove lock / unlock inline functions
> > 3. remove __devinit, __devexit annotations
> Sorry to join the discussion late, was on vacation, travel, long
> weekend...
> 
> I don't still comprehend the need for a library on top of dmaengine
> which gain is just a library between clients and dmacs. Surely we don't
> want to write another abstraction on top of one provided?
> 
> If the question is to handle scatter-gather even if the hardware doesn't
> have the capability, then why don't add that in dmaengine itself rather
> than one more layer?

Well, yes, adding new abstraction layers is always a decision, that has to 
be well justified. In this case it does at least make the life easier for 
two sh-mobile drivers: shdma and the new SUDMAC driver.

However, I did name the library in a generic way without reference to sh, 
assuming, that it might with time become useful for other architectures 
too. The reasons why I prefered to keep it as an optional addition to 
dmaengine core, instead of tightly integrating it with it are, that (1) I 
did not want to add useless code to drivers, that do not need it, (2) I am 
not sure if and when this library will become useful for other drivers: 
apart from sh I am only familiar with one more dmaengine driver: 
ipu/ipu_idmac.c, and that one supports scatter-gather lists in a limited 
way and has some further peculiarities, that would likely make it a bad 
match for the simple DMA library, (3) keeping it separate makes its 
further development easier.

OTOH, I'm certainly fine with a tighter library integration with the 
dmaengine core. I think, it still would be better to keep it in a separate 
file and only build it if needed, right? This woult also simplify code 
debugging and further development. I can remove the "simple" notation, 
which does make it look like an additional abstraction layer, and replace 
it with, say, sgsoft (scatter-gather software implementation)? A more 
interesting question is what to do with struct dma_simple_dev, struct 
dma_simple_chan, struct dma_simple_desc, that embed struct dma_device, 
struct dma_chan and struct dma_async_tx_descriptor respectively. I don't 
think we want to merge all the additions from those wrapping structs back 
into their dmaengine counterparts?

How would you like to do this? Don't you think, it would be good to allow 
both: either implement a dmaengine driver directly, exactly as all drivers 
are doing now, or use the additional helper library for suitable (simple) 
hardware types? I see it similar to I2C, where you either implement an I2C 
driver directly, or you use the bitbanging abstraction for simpler 
hardware.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
