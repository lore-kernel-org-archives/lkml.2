Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971Ab1ILNP5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 09:15:57 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:54755 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755900Ab1ILNP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 09:15:56 -0400
X-Sasl-enc: fu3OKKIIi4clDSmRIwyyGkWSFT9N6yk/nABNhrJn8g5C 1315833355
Message-ID: <4E6E061E.2010000@ladisch.de>
Date: Mon, 12 Sep 2011 15:16:14 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org,
        Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org
Subject: Re: [RFC] [PATCH 02/62] mpu401:snd_mpu401_uart_new(): split semantic
 of irq_flags
References: <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com>	<1315383059-3673-3-git-send-email-yong.zhang0@gmail.com>	<4E689E9A.8000407@ladisch.de>	<20110908133700.GB2310@zhy>	<4E68CA15.8000504@ladisch.de>	<20110908144519.GB3069@zhy>	<4E69253F.3090705@ladisch.de>	<20110909013143.GB18249@zhy>	<4E6CCF6C.2020301@ladisch.de> <s5hvcsy6nr2.wl%tiwai@suse.de>
In-Reply-To: <s5hvcsy6nr2.wl%tiwai@suse.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> Clemens Ladisch wrote:
> > --- a/sound/isa/als100.c
> > +++ b/sound/isa/als100.c
> > @@ -245,18 +245,22 @@ static int __devinit snd_card_als100_probe(int dev,
> > 
> >  	if (mpu_port[dev] > 0 && mpu_port[dev] != SNDRV_AUTO_PORT) {
> >  		int mpu_type = MPU401_HW_ALS100;
> > +		int mpu_flags = 0;
> > 
> > -		if (mpu_irq[dev] == SNDRV_AUTO_IRQ)
> > +		if (mpu_irq[dev] == SNDRV_AUTO_IRQ) {
> >  			mpu_irq[dev] = -1;
> > +			mpu_flags = MPU401_INFO_RX_POLL;
> > +		}
> 
> When mpu_irq[dev] is set to -1, it won't work.

Thanks for noticing this!

> Instead of setting mpu_flag in this if block, you'd need another check
> of mpu_irq[], i.e.
> 
> 		if (mpu_irq[dev] == SNDRV_AUTO_IRQ)
> 			mpu_irq[dev] = -1;
> 		if (mpu_irq[dev] < 0)
> 			mpu_flags = MPU401_INFO_RX_POLL;

I didn't like all the duplicated code I added to the ISA drivers, and
the more code it becomes, the less I like it.

But it should be possible to avoid this duplication:
snd_mpu401_uart_new() needs to differentiate between three cases:
1) allocate a separate interrupt;
2) do not allocate, use the callback from the driver's interrupt handler;
3) do not allocate, use a timer for polling.
Case 1) is indicated by a valid irq number, the other two cases need
a flag.  All drivers that might use polling switch between 1) or 3),
while 2) is always used unconditionally.  So if we have this flag for 2)
instead of 3), no additional logic is needed in the drivers.

(Furthermore, snd_mpu401_uart_new() could check for SNDRV_AUTO_IRQ
instead of letting all drivers do this, and the hardware and info_flags
parameters could be merged.  But this can wait for later.)


I'll have a new patch until tomorrow.


Regards,
Clemens
