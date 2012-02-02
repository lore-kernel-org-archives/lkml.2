Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611Ab2BBWUA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 17:20:00 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:55781 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133Ab2BBWT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 17:19:58 -0500
Date: Thu, 2 Feb 2012 23:19:45 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: "Shimoda, Yoshihiro" <yoshihiro.shimoda.uh@renesas.com>
cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Vinod Koul <vinod.koul@intel.com>, Magnus Damm <magnus.damm@gmail.com>,
        linux-mmc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-serial@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 1/7 v2] dmaengine: add a simple dma library
In-Reply-To: <4F27CA7D.601@renesas.com>
Message-ID: <Pine.LNX.4.64.1202022317560.13860@axis700.grange>
References: <1327589784-4287-1-git-send-email-g.liakhovetski@gmx.de>
 <1327589784-4287-2-git-send-email-g.liakhovetski@gmx.de> <4F22624E.2090201@renesas.com>
 <Pine.LNX.4.64.1201270946150.32661@axis700.grange> <4F27CA7D.601@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:A/BGafrz5SnB5d+xv8H6j0NlXo0YEHxfhKKf/guQPoV
 PxX+nOXGrGRHNOpQwWEBNu3SWj0mY4/DIZom4ZlSSPaoOU6KEL
 +7d98mxWPluJKbgBg16lYaijFMkUZO3/ursKra/UasbLbpPvgH
 IDfd315Jn3FYamEFKSnwgvUWt/rKVbhkSkyMYSZ6mSz7f99yaV
 TyITNn/XJ1eBNlgDMDIuqaU3X1Wprgzf/UfLe3M5V+3l+/7EeL
 YZbaYq+tWZAOkRnUnp5UnQjfhzYnz0WJPJJ8trWBkbJfTwNeRb
 iGBoIKPArqxxTdC8eBuZwf79qFR7QJuk49hWcM6clVvwx26eOM
 H5FBIr3hmKmxFxUGiKyQ/7RpfvBr5sPu2ReysIE7IKzoV/OqAb
 aGyCh2Ix/tQsQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shimoda-san

On Tue, 31 Jan 2012, Shimoda, Yoshihiro wrote:

> Hi Guennadi-san,
> 
> 2012/01/27 17:48, Guennadi Liakhovetski wrote:
> > Hi Shimoda-san
> > 
> > On Fri, 27 Jan 2012, Shimoda, Yoshihiro wrote:
> [ snip ]
> >>>
> >>> 1. switch from using a tasklet to threaded IRQ, which allowed to
> >>
> >> I tested this driver on 2 environment, but it could not work correctly.
> >>  - renesas_usbhs driver with shdma driver on the mackerel board
> >>  - renesas_usbhs driver with experimental SUDMAC driver
> >>
> >> In this case, should we modify the renesas_usbhs driver?
> > 
> > Yes, you do. Please, see the respective version of the shdma patch. It 
> > doesn't request channel IRQs any more directly, instead, it uses a 
> > dma-simple wrapper function. Also operations change a bit.
> 
> Thank you for your comment.
> 
> I investigaed the issue. I found out the renesas_usbhs driver may
> call tx_submit() in the callback() of the dma-simple finally.

Sorry, in my first reply to this your email I misread the renesas_usbhs 
for an issue with your new SUDMAC driver. Since this is not the case and 
my patch seems to be causing a regression, I'll look at it.

Thanks
Guennadi

> In this case, the value of power_up in the simple_tx_submit is 0,
> the start_xfer() is not called. And then, even if the ld_queue is
> not empty, the DMA doesn't start.
> 
> 
> So, if I add codes like the following in the dma-simple.c,
> the renesas_usbhs driver can work correctly without the driver changes.
> If you think the code is good, would you merge it to your code?
> ======= chan_irqt() =======
> 	simple_chan_ld_cleanup(schan, false);
> 
> +	spin_lock_irq(&schan->chan_lock);
> +	/* Next desc */
> +	simple_chan_xfer_ld_queue(schan);
> +	spin_unlock_irq(&schan->chan_lock);
> 
> 	return IRQ_HANDLED;
> ==============
> 
> Best regards,
> Yoshihiro Shimoda
> 
> > Thanks
> > Guennadi
> > 
> >> For reference, if I changed the threaded IRQ to tasklet,
> >> the 2 environment worked correctly:
> >> ==============
> >> diff --git a/drivers/dma/dma-simple.c b/drivers/dma/dma-simple.c
> >> index 49d8f7d..65a5170 100644
> >> --- a/drivers/dma/dma-simple.c
> >> +++ b/drivers/dma/dma-simple.c
> >> @@ -715,16 +715,18 @@ static irqreturn_t chan_irq(int irq, void *dev)
> >>
> >>  	spin_lock(&schan->chan_lock);
> >>
> >> -	ret = ops->chan_irq(schan, irq) ? IRQ_WAKE_THREAD : IRQ_NONE;
> >> +	ret = ops->chan_irq(schan, irq) ? IRQ_HANDLED : IRQ_NONE;
> >> +	if (ret == IRQ_HANDLED)
> >> +		tasklet_schedule(&schan->tasklet);
> >>
> >>  	spin_unlock(&schan->chan_lock);
> >>
> >>  	return ret;
> >>  }
> >>
> >> -static irqreturn_t chan_irqt(int irq, void *dev)
> >> +static void chan_irqt(unsigned long dev)
> >>  {
> >> -	struct dma_simple_chan *schan = dev;
> >> +	struct dma_simple_chan *schan = (struct dma_simple_chan *)dev;
> >>  	const struct dma_simple_ops *ops =
> >>  		to_simple_dev(schan->dma_chan.device)->ops;
> >>  	struct dma_simple_desc *sdesc;
> >> @@ -744,15 +746,13 @@ static irqreturn_t chan_irqt(int irq, void *dev)
> >>  	spin_unlock_irq(&schan->chan_lock);
> >>
> >>  	simple_chan_ld_cleanup(schan, false);
> >> -
> >> -	return IRQ_HANDLED;
> >>  }
> >>
> >>  int dma_simple_request_irq(struct dma_simple_chan *schan, int irq,
> >>  			   unsigned long flags, const char *name)
> >>  {
> >> -	int ret = request_threaded_irq(irq, chan_irq, chan_irqt,
> >> -				       flags, name, schan);
> >> +	int ret = request_irq(irq, chan_irq, flags, name, schan);
> >> +	tasklet_init(&schan->tasklet, chan_irqt, (unsigned long)schan);
> >>
> >>  	schan->irq = ret < 0 ? ret : irq;
> >>
> >> diff --git a/include/linux/dma-simple.h b/include/linux/dma-simple.h
> >> index 5336674..beb1489 100644
> >> --- a/include/linux/dma-simple.h
> >> +++ b/include/linux/dma-simple.h
> >> @@ -68,6 +68,7 @@ struct dma_simple_chan {
> >>  	int id;				/* Raw id of this channel */
> >>  	int irq;			/* Channel IRQ */
> >>  	enum dma_simple_pm_state pm_state;
> >> +	struct tasklet_struct tasklet;
> >>  };
> >>
> >>  /**
> >> ==============
> >>
> >> Best regards,
> >> Yoshihiro Shimoda
> >>
> > 
> > ---
> > Guennadi Liakhovetski, Ph.D.
> > Freelance Open-Source Software Developer
> > http://www.open-technology.de/
> > 
> 
> 
> -- 
> Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> EC No.
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
