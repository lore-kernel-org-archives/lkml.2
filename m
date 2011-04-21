Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab1DUH72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 03:59:28 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:23721 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab1DUH70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 03:59:26 -0400
X-SpamScore: -12
X-BigFish: VS-12(zz3b49K1432N98dKzz1202hzz8275dhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Thu, 21 Apr 2011 16:03:22 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Wolfram Sang <w.sang@pengutronix.de>
CC: Shawn Guo <shawn.guo@linaro.org>, <linaro-dev@lists.linaro.org>,
        <sameo@linux.intel.com>, <patches@linaro.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] mmc: sdhci: make sdhci-pltfm device drivers self
 registered
Message-ID: <20110421080322.GD4024@S2100-06.ap.freescale.net>
References: <1301042931-4869-1-git-send-email-shawn.guo@linaro.org>
 <1301042931-4869-2-git-send-email-shawn.guo@linaro.org>
 <20110419102042.GB4164@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110419102042.GB4164@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 12:20:42PM +0200, Wolfram Sang wrote:
> 
> On Fri, Mar 25, 2011 at 04:48:47PM +0800, Shawn Guo wrote:
> > The patch turns the common stuff in sdhci-pltfm.c into functions, and
> > add device drivers their own .probe and .remove which in turn call
> > into the common functions, so that those sdhci-pltfm device drivers
> > register itself and keep all device specific things away from common
> > sdhci-pltfm file.
> > 
> > Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> > ---
> 
> I'll second the comments from Grant (with one slight exception which is
> noted below)
> 
> > +static int __devexit sdhci_dove_remove(struct platform_device *pdev)
> > +{
> > +	struct sdhci_host *host = platform_get_drvdata(pdev);
> > +	int dead = 0;
> > +	u32 scratch;
> > +
> > +	scratch = readl(host->ioaddr + SDHCI_INT_STATUS);
> > +	if (scratch == (u32)-1)
> > +		dead = 1;
> 
> I'd prefer
> 
> 	dead = (readl() == 0xffffffff);
> 
> (or (u32)-1 if you prefer). But keeping a variable 'dead' is more
> descriptive than keeping 'scratch'.
> 
Ok.

> > +MODULE_LICENSE("GPL v2");
> 
> Just to be sure: Did you double-check if the original licenses were v2
> or v2+?
> 
It seems to me that sdhci-cns3xxx.c, sdhci-dove.c, sdhci-esdhc-imx.c
and sdhci-tegra.c all use v2.

Actually I do not even know how v2+ is stated.  Do you have an example
for me to refer?

> > --- a/drivers/mmc/host/sdhci-pltfm.c
> > +++ b/drivers/mmc/host/sdhci-pltfm.c
> 
> [...]
> 
> > -err_add_host:
> > -	if (pdata && pdata->exit)
> > -		pdata->exit(host);
> > -err_plat_init:
> > -	iounmap(host->ioaddr);
> >  err_remap:
> >  	release_mem_region(iomem->start, resource_size(iomem));
> >  err_request:
> >  	sdhci_free_host(host);
> >  err:
> > -	printk(KERN_ERR"Probing of sdhci-pltfm failed: %d\n", ret);
> > -	return ret;
> > +	pr_err("%s failed %d\n", __func__, ret);
> 
> dev_err?
> 
Good catch.

> > +	return NULL;
> >  }
> >  
> 
> I didn't pay much attention to the OF version of the tegra driver, since
> it still is not upstream yet, right?
> 
Do not worry about that.  You will not see that in the next version,
which will be based on mmc-next.  And tegra OF support should be in
another patch.

-- 
Regards,
Shawn

