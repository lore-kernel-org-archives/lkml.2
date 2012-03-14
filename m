Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759441Ab2CNIWJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 04:22:09 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:28694
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751804Ab2CNIWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 04:22:04 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275dhz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 14 Mar 2012 16:23:52 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Huang Shijie-B32955 <B32955@freescale.com>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "vinod.koul@linux.intel.com" <vinod.koul@linux.intel.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        Guo Shawn-R65073 <r65073@freescale.com>
Subject: Re: [PATCH v1 4/5] dma: mxs-dma: add dt probe support
Message-ID: <20120314082352.GC1180@shlinux2.ap.freescale.net>
References: <1331628428-24017-1-git-send-email-b29396@freescale.com>
 <1331628428-24017-5-git-send-email-b29396@freescale.com>
 <4F604EBD.7060400@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4F604EBD.7060400@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 03:54:37PM +0800, Huang Shijie-B32955 wrote:
> Hi Aisheng:
> > From: Dong Aisheng<dong.aisheng@linaro.org>
> >
> > Signed-off-by: Dong Aisheng<dong.aisheng@linaro.org>
> > ---
> >   .../devicetree/bindings/dma/fsl-mxs-dma.txt        |   17 ++++++++
> >   drivers/dma/mxs-dma.c                              |   44 +++++++++++++------
> >   2 files changed, 47 insertions(+), 14 deletions(-)
> >
> > diff --git a/Documentation/devicetree/bindings/dma/fsl-mxs-dma.txt b/Documentation/devicetree/bindings/dma/fsl-mxs-dma.txt
> > new file mode 100644
> > index 0000000..cfa1730
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/dma/fsl-mxs-dma.txt
> > @@ -0,0 +1,17 @@
> > +* Freescale MXS DMA
> > +
> > +Required properties:
> > +- compatible : Should be "fsl,mxs-dma-apbh" or "fsl,mxs-dma-apbx"
> > +- reg : Should contain registers location and length
> > +
> > +Examples:
> > +
> > +dma-apbh@80004000 {
> > +	compatible = "fsl,mxs-dma-apbh";
> > +	reg =<0x80004000 2000>;
> > +};
> > +
> > +dma-apbx@80024000 {
> > +	compatible = "fsl,mxs-dma-apbx";
> > +	reg =<0x80024000 2000>;
> > +};
> > diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
> > index b06cd4c..45e8d46 100644
> > --- a/drivers/dma/mxs-dma.c
> > +++ b/drivers/dma/mxs-dma.c
> > @@ -22,6 +22,9 @@
> >   #include<linux/platform_device.h>
> >   #include<linux/dmaengine.h>
> >   #include<linux/delay.h>
> > +#include<linux/module.h>
> > +#include<linux/of.h>
> > +#include<linux/of_device.h>
> >
> >   #include<asm/irq.h>
> >   #include<mach/mxs.h>
> > @@ -130,6 +133,25 @@ struct mxs_dma_engine {
> >   	struct mxs_dma_chan		mxs_chans[MXS_DMA_CHANNELS];
> >   };
> >
> > +static struct platform_device_id mxs_dma_type[] = {
> > +	{
> > +		.name = "mxs-dma-apbh",
> > +		.driver_data = MXS_DMA_APBH,
> > +	}, {
> > +		.name = "mxs-dma-apbx",
> > +		.driver_data = MXS_DMA_APBX,
> > +	}, {
> > +		/* end of list */
> > +	}
> > +};
> > +
> I think you should use the platform_device_id to distinguish different 
> archs.
> In the mx6q,  you will meet some compiler error for the macro cpu_is_mx23().
> 
Yes, i will remove cpu_is_*() in mxs-mmc driver by using device id.

Regards
Dong Aisheng

