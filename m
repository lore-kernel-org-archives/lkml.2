Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab0LIOu6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 09:50:58 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53835 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897Ab0LIOu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 09:50:56 -0500
Date: Thu, 9 Dec 2010 15:50:51 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] dmaengine i.MX SDMA: protect channel0
Message-ID: <20101209145051.GO6017@pengutronix.de>
References: <1291630198-9690-1-git-send-email-s.hauer@pengutronix.de> <1291630198-9690-3-git-send-email-s.hauer@pengutronix.de> <AANLkTi=T3OCRy9VOVE5JvQe3x8zcKH+fcGBQgOxZbHM1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=T3OCRy9VOVE5JvQe3x8zcKH+fcGBQgOxZbHM1@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:54:22 up 159 days,  5:05, 50 users,  load average: 0.16, 0.15,
	0.17
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 07, 2010 at 03:50:33PM -0800, Dan Williams wrote:
> On Mon, Dec 6, 2010 at 2:09 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > Channel 0 of the SDMA engine is a shared resource used by the
> > other channels, thus we have to protect it with a mutex.
> >
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > ---
> 
> This one is not making sense to me...
> 
> >  drivers/dma/imx-sdma.c |   11 +++++++++++
> >  1 files changed, 11 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
> > index 01c4a5f..b1f5947 100644
> > --- a/drivers/dma/imx-sdma.c
> > +++ b/drivers/dma/imx-sdma.c
> > @@ -355,6 +355,7 @@ struct sdma_engine {
> >        struct dma_device               dma_device;
> >        struct clk                      *clk;
> >        struct sdma_script_start_addrs  *script_addrs;
> > +       struct mutex                    channel0_mutex;
> >  };
> >
> >  #define SDMA_H_CONFIG_DSPDMA   (1 << 12) /* indicates if the DSPDMA is used */
> > @@ -437,6 +438,8 @@ static int sdma_load_script(struct sdma_engine *sdma, void *buf, int size,
> >        if (!buf_virt)
> >                return -ENOMEM;
> >
> > +       mutex_lock(&sdma->channel0_mutex);
> > +
> >        bd0->mode.command = C0_SETPM;
> >        bd0->mode.status = BD_DONE | BD_INTR | BD_WRAP | BD_EXTD;
> >        bd0->mode.count = size / 2;
> > @@ -447,6 +450,8 @@ static int sdma_load_script(struct sdma_engine *sdma, void *buf, int size,
> >
> >        ret = sdma_run_channel(&sdma->channel[0]);
> >
> > +       mutex_unlock(&sdma->channel0_mutex);
> > +
> 
> In sdma_load_script() what data structure are we protecting at single
> threaded init time prior to registering channels?

At the moment the lock in sdma_load_script is not needed, but I have a
patch in the queue using request_firmware_nowait instead of
request_firmware, so the firmware might come in after initialization
(The SDMA does not really depend on the firmware, it can just offer more
features when it is available)

> 
> >        dma_free_coherent(NULL, size, buf_virt, buf_phys);
> >
> >        return ret;
> 
> > @@ -684,6 +689,8 @@ static int sdma_load_context(struct sdma_channel *sdmac)
> >        context->gReg[6] = sdmac->shp_addr;
> >        context->gReg[7] = sdmac->watermark_level;
> >
> > +       mutex_lock(&sdma->channel0_mutex);
> > +
> >        bd0->mode.command = C0_SETDM;
> >        bd0->mode.status = BD_DONE | BD_INTR | BD_WRAP | BD_EXTD;
> >        bd0->mode.count = sizeof(*context) / 4;
> > @@ -692,6 +699,8 @@ static int sdma_load_context(struct sdma_channel *sdmac)
> >
> >        ret = sdma_run_channel(&sdma->channel[0]);
> >
> > +       mutex_unlock(&sdma->channel0_mutex);
> > +
> 
> This sdma_load_context() is called from various ->prep() contexts.
> What guarantees are there that we can sleep in these contexts?  At
> least ->prep_memcpy() might be called in a atomic context.  I have
> been assuming the same for all prep routines across archs.

Currently it is only called from non interrupt context.

Fact is that we need some kind of locking because channel 0 is used by
the other channels. I just made a check and it shows running channel 0
only takes about 6us, so a spinlock might be a better weapon here.

So forget this patch for now and I'll send an updated one using a
spinlock (and no completion interrupt for channel 0).

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
