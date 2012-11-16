Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301Ab2KPPXp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 10:23:45 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47620 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab2KPPXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 10:23:43 -0500
Subject: Re: [PATCH v6 3/4] media: coda: use genalloc API
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Richard Zhao <richard.zhao@freescale.com>,
        Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, Matt Porter <mporter@ti.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Javier Martin <javier.martin@vista-silicon.com>, kernel@pengutronix.de,
        devicetree-discuss@lists.ozlabs.org
In-Reply-To: <50A656E2.707@windriver.com>
References: <1353061817-3207-1-git-send-email-p.zabel@pengutronix.de>
	 <1353061817-3207-4-git-send-email-p.zabel@pengutronix.de>
	 <50A656E2.707@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Nov 2012 16:21:13 +0100
Message-ID: <1353079273.2413.160.camel@pizza.hi.pengutronix.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 16.11.2012, 10:08 -0500 schrieb Paul Gortmaker:
> On 12-11-16 05:30 AM, Philipp Zabel wrote:
> > This patch depends on "genalloc: add a global pool list,
> > allow to find pools by phys address", which provides the
> > of_get_named_gen_pool function.
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> >  drivers/media/platform/Kconfig |    3 +--
> >  drivers/media/platform/coda.c  |   47 ++++++++++++++++++++++++++++------------
> >  2 files changed, 34 insertions(+), 16 deletions(-)
> > 
> > diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> > index 181c768..09d45c6 100644
> > --- a/drivers/media/platform/Kconfig
> > +++ b/drivers/media/platform/Kconfig
> > @@ -130,10 +130,9 @@ if V4L_MEM2MEM_DRIVERS
> >  
> >  config VIDEO_CODA
> >  	tristate "Chips&Media Coda multi-standard codec IP"
> > -	depends on VIDEO_DEV && VIDEO_V4L2 && ARCH_MXC
> > +	depends on VIDEO_DEV && VIDEO_V4L2
> 
> What was the logic for reducing the dependency scope here?
> Your commit log doesn't mention that at all, and when I see
> things like that, I predict allyesconfig build failures,
> unless there is a similar dependency elsewhere that isn't
> visible in just the context of this patch alone.
> 
> P.

iram_alloc and iram_free are i.MX specific wrappers around
gen_pool_alloc and gen_pool_free, located in <mach/iram.h>.
Those were responsible for the dependency in the first place.

> --
> 
> >  	select VIDEOBUF2_DMA_CONTIG
> >  	select V4L2_MEM2MEM_DEV
> > -	select IRAM_ALLOC if SOC_IMX53
> >  	---help---
> >  	   Coda is a range of video codec IPs that supports
> >  	   H.264, MPEG-4, and other video formats.
> > diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> > index cd04ae2..f17b659 100644
> > --- a/drivers/media/platform/coda.c
> > +++ b/drivers/media/platform/coda.c
> > @@ -14,6 +14,7 @@
> >  #include <linux/clk.h>
> >  #include <linux/delay.h>
> >  #include <linux/firmware.h>
> > +#include <linux/genalloc.h>
> >  #include <linux/interrupt.h>
> >  #include <linux/io.h>
> >  #include <linux/irq.h>
> > @@ -24,7 +25,6 @@
> >  #include <linux/videodev2.h>
> >  #include <linux/of.h>
> >  
> > -#include <mach/iram.h>
[...]

After dropping the #include <mach/iram.h>, there is no need
to depend on ARCH_MXC anymore.

regards
Philipp

