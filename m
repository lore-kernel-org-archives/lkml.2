Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab2HVLQi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 07:16:38 -0400
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:18813
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753098Ab2HVLQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 07:16:34 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zz98dI1432Izz1202h1082kzz8275dhz2dh2a8h668h839h944hd25hf0ah107ah1155h)
Date: Wed, 22 Aug 2012 18:57:30 +0800
From: Dong Aisheng <b29396@freescale.com>
To: Zhao Richard-B20223 <B20223@freescale.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "lrg@ti.com" <lrg@ti.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "paul.liu@linaro.org" <paul.liu@linaro.org>
Subject: Re: [PATCH 1/7] mfd: add imx syscon driver based on regmap
Message-ID: <20120822105729.GB10057@shlinux2.ap.freescale.net>
References: <1345619928-15446-1-git-send-email-b29396@freescale.com>
 <1345619928-15446-2-git-send-email-b29396@freescale.com>
 <20120822082940.GJ4011@b20223-02.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120822082940.GJ4011@b20223-02.ap.freescale.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 04:29:41PM +0800, Zhao Richard-B20223 wrote:
> On Wed, Aug 22, 2012 at 03:18:42PM +0800, Dong Aisheng wrote:
> > From: Dong Aisheng <dong.aisheng@linaro.org>
> > 
> > Add regmap based imx syscon driver.
> > This is usually used for access misc bits in registers which does not belong
> > to a specific module, for example, IOMUXC GPR and ANATOP.
> > With this driver, we provide a standard API for client driver to call to
> > access registers which are registered into syscon.
> > 
> > Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> > ---
> > Currently it's just simply for IMX, however the driver really is not too
> > much imx specific.
> > If people want, we probably could extend it to support other platforms too.
> > ---
> >  .../devicetree/bindings/mfd/imx-syscon.txt         |   11 +
> >  drivers/mfd/Kconfig                                |    8 +
> >  drivers/mfd/Makefile                               |    1 +
> >  drivers/mfd/imx-syscon.c                           |  193 ++++++++++++++++++++
> >  include/linux/mfd/imx-syscon.h                     |   22 +++
> >  5 files changed, 235 insertions(+), 0 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/mfd/imx-syscon.txt b/Documentation/devicetree/bindings/mfd/imx-syscon.txt
> > new file mode 100644
> > index 0000000..4a72994
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/mfd/imx-syscon.txt
> > @@ -0,0 +1,11 @@
> > +* Freescale IMX System Controller Registers R/W driver
> > +
> > +Required properties:
> > +- compatible: Should contain "fsl,imx-syscon".
> > +- reg: the register range can be access from imx-syscon
> > +
> > +Examples:
> > +gpr: iomuxc-gpr@020e0000 {
> > +	compatible = "fsl,imx6q-iomuxc", "fsl,imx-syscon";
> why is it compatible with iomuxc?
> 
The first one usually is describing the device itself,
the second one is the required compatible string for using imx-sycon.

btw, it looks i'd better change "fsl,imx6q-iomuxc" to "fsl,imx6q-iomuxc-gpr"
since the later is the real case for us which is in patch 2/7.

> > +static int imx_syscon_match(struct device *dev, void *data)
> > +{
> > +	struct imx_syscon *syscon = dev_get_drvdata(dev);
> > +	struct device_node *dn = data;
> > +
> > +	return (syscon->dev->of_node == dn) ? 1 : 0;
> > +}
> > +
> > +int imx_syscon_write(struct device_node *np, u32 reg, u32 val)
> For API function, is it better to use struct device rather not np?
>  - it won't need to search dev in below code every time it access
>    registers.
The purpose is not require client driver to know the implementation details
of imx_syscon_{read/write} API, it's more easy to use since client only
needs pass the device node to which it wants to read/write.

For search dev, it doesn't look like a big issue since it only search devices
attached on the driver which is very quick.
And hide it in common API does not require every client driver to write
duplicated codes.

> > +static int __devinit imx_syscon_probe(struct platform_device *pdev)
> > +{
> > +	struct device *dev = &pdev->dev;
> > +	struct device_node *np = dev->of_node;
> > +	struct imx_syscon *syscon;
> > +	struct resource res;
> > +	int ret;
> > +
> > +	if (!np)
> > +		return -ENOENT;
> > +
> > +	syscon = devm_kzalloc(&pdev->dev, sizeof(struct imx_syscon),
> > +			    GFP_KERNEL);
> > +	if (!syscon)
> > +		return -ENOMEM;
> > +
> > +	syscon->base = of_iomap(np, 0);
> no request? use devm_request_and_ioremap?
> 
The io space registered into imx-sycon may be overlapped with other device,
e.g. iomuxc gpr overlapped with iomuxc. So we do not request it here.
There are also some exist examples, imx28 pinctrl with gpio devices contained.

Regards
Dong Aisheng

