Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707Ab2JRIQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 04:16:20 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:47777 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab2JRIQQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 04:16:16 -0400
X-Auth-Info: 5tVyBKQGt0ivHA/m82XpuLOP64N7i6qYo7dGcviuDIo=
From: Marek Vasut <marex@denx.de>
To: Huang Shijie <b32955@freescale.com>
Subject: Re: [PATCH] dma: add new DMA control commands
Date: Thu, 18 Oct 2012 10:16:06 +0200
User-Agent: KMail/1.13.7 (Linux/3.4-trunk-amd64; KDE/4.8.4; x86_64; ; )
Cc: Vinod Koul <vinod.koul@linux.intel.com>, djbw@fb.com, khali@linux-fr.org,
        ben-linux@fluff.org, w.sang@pengutronix.de, cjb@laptop.org,
        dwmw2@infradead.org, lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        perex@perex.cz, tiwai@suse.de, shawn.guo@linaro.org,
        artem.bityutskiy@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        Huang Shijie <shijie8@gmail.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        artem.bityutskiy@linux.intel.com
References: <1350538335-29026-1-git-send-email-b32955@freescale.com> <201210180914.58527.marex@denx.de> <507FB495.7050104@freescale.com>
In-Reply-To: <507FB495.7050104@freescale.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201210181016.06782.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Huang Shijie,

> 于 2012年10月18日 15:14, Marek Vasut 写道:
> > Dear Huang Shijie,
> > 
> > Why such massive CC ?
> > 
> >> 于 2012年10月18日 14:18, Vinod Koul 写道:
> >>> Why cant you do start (prepare clock etc) when you submit the
> >>> descriptor to dmaengine. Can be done in tx_submit callback.
> >>> Similarly remove the clock when dma transaction gets completed.
> >> 
> >> I ever thought this method too.
> >> 
> >> But it will become low efficient in the following case:
> >>     Assuming the gpmi-nand driver has to read out 1024 pages in one
> >> 
> >> _SINGLE_ read operation.
> >> The gpmi-nand will submit the descriptor to dmaengine per page.
> > 
> > It will? Then GPMI NAND is flat our broken ... again.
> 
> yes.
> 
> Please read the NAND chip spec about the comand READ PAGE(00h-30h) and
> the code
> nand_do_read_ops(). The nand chip limits us only read one page out one
> time. So the driver will submit the descriptor to dmaengine per page.

So we can't stream data from the chip? About time to adjust the MTD framework to 
allow that. Maybe implement a command queue?

> >> So with
> >> your method,
> >> the system will repeat the enable/disable dma clock 1024 time.
> > 
> > Yes, it is the driver that's wrong.
> 
> not the driver.
> 
> >> At every
> >> enable/disable dma clock,
> >> the system has to enable the clock chain and it's parents ...
> >> 
> >> But with this patch, we only need to enable/disable dma clock one time,
> >> just at we select the nand chip.
> > 
> > You are fixing a driver problem at a framework level, wrong.
> > 
> > So, check how the MXS SPI driver handles descriptor chaining. Indeed, the
> > Sigmatel screwed the DMA stuff good. But if you analyze the SPI driver,
> > you'll notice a few important points that might come handy when you fix
> > the GPMI NAND driver properly.
> > 
> > The direction to take here is:
> > 1) Implement DMA chaining into the GPMI NAND driver
> 
> How can i implement the DMA chain if the nand chip READ-PAGE command
> gives us the one page limit?

This smells like a time to extend the MTD api ?

> thanks
> Huang Shijie
> 
> > 2) You might need to do one PIO transfer to reconfigure the IP registers
> > between each segment of the DMA chain (just as MXS SPI does it)
> > 3) You might run out of DMA descriptors when doing too long chains -- so
> > you might need to fix that part of the mxs DMA driver.

Best regards,
Marek Vasut
