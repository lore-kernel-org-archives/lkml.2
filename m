Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab1CYJgD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 05:36:03 -0400
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:20444
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756640Ab1CYJgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 05:36:00 -0400
X-SpamScore: -15
X-BigFish: VS-15(zz1b0aL1432N98dNzz1202hzz8275dh1497iz2dh2a8h637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 25 Mar 2011 17:36:50 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: Shawn Guo <shawn.guo@linaro.org>, <linaro-dev@lists.linaro.org>,
        <sameo@linux.intel.com>, <patches@linaro.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] mmc: sdhci: make sdhci-esdhc-imx driver self
 registered
Message-ID: <20110325093649.GA17228@S2100-06.ap.freescale.net>
References: <1300694823-8300-1-git-send-email-shawn.guo@linaro.org>
 <1300694823-8300-2-git-send-email-shawn.guo@linaro.org>
 <20110324042858.GD27881@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110324042858.GD27881@ponder.secretlab.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 10:28:58PM -0600, Grant Likely wrote:
> On Mon, Mar 21, 2011 at 04:06:59PM +0800, Shawn Guo wrote:
> > The patch turns the common stuff to in sdhci-pltfm.c into functions,
> > and add sdhci-esdhc-imx its own .probe and .remove which in turn call
> > into the common functions, so that sdhci-esdhc-imx driver registers
> > itself and keep all sdhci-esdhc-imx specific things like
> > sdhci_esdhc_imx_pdata away from sdhci-pltfm.c which is common.
> > 
> > Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> 
> Hi Shawn,
> 
Hi Grant,

> Thanks for all this work, I think it is the right thing to do.  A few
> relatively minor comments below, but otherwise I like it.
> 
> g.
> 
> > ---
> >  drivers/mmc/host/sdhci-esdhc-imx.c |   98 +++++++++++++++++++++++++++++-------
> >  drivers/mmc/host/sdhci-pltfm.c     |   84 +++++++++++++++++++++++++++++--
> >  drivers/mmc/host/sdhci-pltfm.h     |   11 ++++-
> 
> I think this patch should be split in 2.  One patch to refactor
> edhci-pltfm* to create the common utility functions, and one patch to
> convert the imx driver.
> 
I squashed this whole series into one patch in a relevant patch set
I just posted out minutes ago, primarily to reduce the patch quantity
and ease the bisect, since it's logically integral.

[...]
> > +static int __init sdhci_esdhc_imx_init(void)
> > +{
> > +	return platform_driver_register(&sdhci_esdhc_imx_driver);
> > +}
> > +
> > +static void __exit sdhci_esdhc_imx_exit(void)
> > +{
> > +	platform_driver_unregister(&sdhci_esdhc_imx_driver);
> > +}
> > +
> > +module_init(sdhci_esdhc_imx_init);
> > +module_exit(sdhci_esdhc_imx_exit);
> 
> Typically, I like to see module_init() and module_exit() immediately
> adjacent to the functions they register.
> 
Incorporated in the new patch set just posted ...

> > +
> > +MODULE_DESCRIPTION("SDHCI driver for i.MX eSDHC");
> > +MODULE_AUTHOR("Wolfram Sang <w.sang@pengutronix.de>");
> > +MODULE_LICENSE("GPL v2");
> > diff --git a/drivers/mmc/host/sdhci-pltfm.c b/drivers/mmc/host/sdhci-pltfm.c
> > index ccc04ac..38b8cb4 100644
> > --- a/drivers/mmc/host/sdhci-pltfm.c
> > +++ b/drivers/mmc/host/sdhci-pltfm.c
> > @@ -44,6 +44,83 @@
> >  static struct sdhci_ops sdhci_pltfm_ops = {
> >  };
> >  
> > +struct sdhci_host *sdhci_pltfm_init(struct platform_device *pdev,
> > +				    struct sdhci_pltfm_data *pdata)
> 
> Since there is no chance of *pdata being passed via the
> pdev->dev.platform_data pointer (there aren't any users in mainline of
> that feature) then I would take the opportunity to rename this
> parameter and structure to eliminate any confusion.  'struct
> sdhci_pltfm' would be sufficient I think.
> 
The chance comes along with the new patch set (function
sdhci_esdhc_probe in sdhci-esdhc.c).  And I would not rename 'struct
sdhci_pltfmi_data' to 'struct sdhci_pltfm' in terms of that we have
another name of 'struct sdhci_pltfm_host'.  But yes, pdata does
confuse.  Any suggestion?  I can fix all of them with a follow-up
patch against the new series.

> > +{
> > +	struct sdhci_host *host;
> > +	struct sdhci_pltfm_host *pltfm_host;
> > +	struct resource *iomem;
> > +	int ret;
> > +
> > +	iomem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	if (!iomem) {
> > +		ret = -ENOMEM;
> > +		goto err;
> > +	}
> > +
> > +	if (resource_size(iomem) < 0x100)
> > +		dev_err(&pdev->dev, "Invalid iomem size!\n");
> > +
> > +	/* Some PCI-based MFD need the parent here */
> > +	if (pdev->dev.parent != &platform_bus)
> > +		host = sdhci_alloc_host(pdev->dev.parent, sizeof(*pltfm_host));
> > +	else
> > +		host = sdhci_alloc_host(&pdev->dev, sizeof(*pltfm_host));
> > +
> > +	if (IS_ERR(host)) {
> > +		ret = PTR_ERR(host);
> > +		goto err;
> > +	}
> > +
> > +	pltfm_host = sdhci_priv(host);
> > +
> > +	host->hw_name = "SDHCI";
> > +	if (pdata && pdata->ops)
> > +		host->ops = pdata->ops;
> > +	else
> > +		host->ops = &sdhci_pltfm_ops;
> > +	if (pdata)
> > +		host->quirks = pdata->quirks;
> > +	host->irq = platform_get_irq(pdev, 0);
> > +
> > +	if (!request_mem_region(iomem->start, resource_size(iomem),
> > +		mmc_hostname(host->mmc))) {
> > +		dev_err(&pdev->dev, "cannot request region\n");
> > +		ret = -EBUSY;
> > +		goto err_request;
> > +	}
> > +
> > +	host->ioaddr = ioremap(iomem->start, resource_size(iomem));
> > +	if (!host->ioaddr) {
> > +		dev_err(&pdev->dev, "failed to remap registers\n");
> > +		ret = -ENOMEM;
> > +		goto err_remap;
> > +	}
> > +
> > +	platform_set_drvdata(pdev, host);
> > +
> > +	return host;
> > +
> > +err_remap:
> > +	release_mem_region(iomem->start, resource_size(iomem));
> > +err_request:
> > +	sdhci_free_host(host);
> > +err:
> > +	pr_err("%s failed %d\n", __func__, ret);
> > +	return NULL;
> > +}
> 
> Since the bulk of this function is a direct clone of the
> body of sdhci_pltfm_probe(), this patch should also modify
> sdhci_pltfm_probe() to use the new utility function.  That will also
> make it clearer to readers that this new block is simply a refactor of
> the old.
> 
Good suggestion.  Will take it next time where applies ...

-- 
Regards,
Shawn

