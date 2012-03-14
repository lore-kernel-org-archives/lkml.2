Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030695Ab2CNIIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 04:08:17 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:18252
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758956Ab2CNIHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 04:07:49 -0400
X-SpamScore: -15
X-BigFish: VS-15(zz179dN1432N98dKzz1202hzz8275ch8275dhz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 14 Mar 2012 16:09:40 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
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
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>
Subject: Re: [PATCH v1 2/5] mmc: mxs-mmc: add dt probe support
Message-ID: <20120314080939.GA1180@shlinux2.ap.freescale.net>
References: <1331628428-24017-1-git-send-email-b29396@freescale.com>
 <1331628428-24017-3-git-send-email-b29396@freescale.com>
 <20120314072343.GG18320@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120314072343.GG18320@game.jcrosoft.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 03:23:43PM +0800, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 16:47 Tue 13 Mar     , Dong Aisheng wrote:
> > From: Dong Aisheng <dong.aisheng@linaro.org>
> > 
> > Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> > 
> > ---
> > The patch is still using a private way for dma part binding
> > since the common dma binding is still under discussion.
> > http://www.spinics.net/lists/linux-omap/msg65528.html
> > 
> > Will update to use common dma binding when it hits mainline.
> > ---
> >  .../devicetree/bindings/mmc/fsl-mxs-mmc.txt        |   23 ++++++
> >  drivers/mmc/host/mxs-mmc.c                         |   82 +++++++++++++++++++-
> >  2 files changed, 102 insertions(+), 3 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/mmc/fsl-mxs-mmc.txt b/Documentation/devicetree/bindings/mmc/fsl-mxs-mmc.txt
> > new file mode 100644
> > index 0000000..adc1142
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/mmc/fsl-mxs-mmc.txt
> > @@ -0,0 +1,23 @@
> > +* FREESCALE MXS MMC peripheral
> > +
> > +Required properties:
> > +- compatible : Should be "fsl,<chip>-mmc"
> > +- reg : Should contain registers location and length
> > +- interrupts : Should contain interrupt.
> > +  The format is <irq_err irq_dma>.
> > +- dma_channel: Should contain the dma channel it uses
> > +
> > +Optional properties:
> > +- wp-gpios : Specify GPIOs for write protection
> > +- slot-4bit: Specify 4 bit mode support
> > +- slot-8bit: Specify 8 bit and 4 bit mode support
> > +
> > +Examples:
> > +mmc1: ssp@80010000 {
> > +	compatible = "fsl,imx28-mmc";
> > +	reg = <0x80010000 2000>;
> > +	/* <irq_err irq_dma> */
> > +	interrupts = <96 82>;
> > +	dma_channel = <0>;
> > +	slot-8bit;
> > +};
> > diff --git a/drivers/mmc/host/mxs-mmc.c b/drivers/mmc/host/mxs-mmc.c
> > index 382c835..6cf2d17 100644
> > --- a/drivers/mmc/host/mxs-mmc.c
> > +++ b/drivers/mmc/host/mxs-mmc.c
> > @@ -38,6 +38,10 @@
> >  #include <linux/gpio.h>
> >  #include <linux/regulator/consumer.h>
> >  #include <linux/module.h>
> > +#include <linux/of.h>
> > +#include <linux/of_device.h>
> > +#include <linux/of_gpio.h>
> > +#include <linux/slab.h>
> >  
> >  #include <mach/mxs.h>
> >  #include <mach/common.h>
> > @@ -673,17 +677,79 @@ static bool mxs_mmc_dma_filter(struct dma_chan *chan, void *param)
> >  	return true;
> >  }
> >  
> > +#ifdef CONFIG_OF
> > +static struct resource * __devinit mxs_mmc_get_of_dmares(
> > +				struct platform_device *pdev)
> > +{
> > +	struct device_node *np = pdev->dev.of_node;
> > +	struct resource *dmares;
> > +	int ret;
> > +
> > +	if (!np)
> > +		return NULL;
> > +
> > +	dmares = kzalloc(sizeof(*dmares), GFP_KERNEL);
> > +	dmares->flags = IORESOURCE_DMA;
> > +	ret = of_property_read_u32(np, "dma_channel", &dmares->start);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "unable to get dmares from dt\n");
> > +		return NULL;
> > +	}
> > +	dmares->end = dmares->start;
> > +
> > +	return dmares;
> > +}
> > +
> > +static int __devinit mxs_mmc_get_of_property(struct platform_device *pdev,
> > +				struct mxs_mmc_platform_data **ppdata)
> > +{
> > +	struct device_node *np = pdev->dev.of_node;
> > +	struct mxs_mmc_platform_data *pdata = *ppdata;
> > +
> > +	if (!np)
> > +		return -ENODEV;
> > +
> > +	pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
> > +
> > +	if (of_get_property(np, "slot-8bit", NULL))
> > +		pdata->flags |= SLOTF_8_BIT_CAPABLE;
> > +
> > +	if (of_get_property(np, "slot-4bit", NULL))
> > +		pdata->flags |= SLOTF_4_BIT_CAPABLE;
> it will conflit if both binding are set use a number instead
> 
Hmm, i did not see conflict, can you explain more?
The "slot-8bit" includes the support for 4bit.(see binding doc)
Even user define them two property in dt by mistake, it does not cause conflict.
See:
if (pdata) {
	if (pdata->flags & SLOTF_8_BIT_CAPABLE)
		mmc->caps |= MMC_CAP_4_BIT_DATA | MMC_CAP_8_BIT_DATA;
	if (pdata->flags & SLOTF_4_BIT_CAPABLE)
		mmc->caps |= MMC_CAP_4_BIT_DATA;
}

Regards
Dong Aisheng

