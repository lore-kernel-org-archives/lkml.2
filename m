Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647Ab1DAGI7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 02:08:59 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:17289
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752274Ab1DAGI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 02:08:57 -0400
X-SpamScore: -19
X-BigFish: VS-19(zz1432N98dK1447Rzz1202hzz8275bh8275dhz2dh2a8h637h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 1 Apr 2011 14:10:21 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: Shawn Guo <shawn.guo@linaro.org>, <linaro-dev@lists.linaro.org>,
        <sameo@linux.intel.com>, <patches@linaro.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] mmc: sdhci: make sdhci-pltfm device drivers self
 registered
Message-ID: <20110401061020.GF25866@S2100-06.ap.freescale.net>
References: <1301042931-4869-1-git-send-email-shawn.guo@linaro.org>
 <1301042931-4869-2-git-send-email-shawn.guo@linaro.org>
 <20110331153322.GA26612@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110331153322.GA26612@ponder.secretlab.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 09:33:22AM -0600, Grant Likely wrote:
> On Fri, Mar 25, 2011 at 04:48:47PM +0800, Shawn Guo wrote:
> > The patch turns the common stuff in sdhci-pltfm.c into functions, and
> > add device drivers their own .probe and .remove which in turn call
> > into the common functions, so that those sdhci-pltfm device drivers
> > register itself and keep all device specific things away from common
> > sdhci-pltfm file.
> > 
> > Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> 
> Looks really good.  Relatively minor comments below, but you can add
> this to the next version:
> 
> Reviewed-by: Grant Likely <grant.likely@secretlab.ca>
> 
Thanks for the review.

[...]
> > +
> > +static int __devinit sdhci_cns3xxx_probe(struct platform_device *pdev)
> > +{
> > +	struct sdhci_host *host;
> > +	int ret;
> > +
> > +	host = sdhci_pltfm_init(pdev, &sdhci_cns3xxx_pdata);
> > +	if (!host)
> > +		return -ENOMEM;
> > +
> > +	ret = sdhci_add_host(host);
> > +	if (ret)
> > +		goto err_add_host;
> > +
> > +	return 0;
> > +
> > +err_add_host:
> > +	sdhci_pltfm_free(pdev);
> > +	return ret;
> > +}
> 
> This pattern in this function is used by 2 drivers in this patch, and
> 2 more users (with the addition of an sdhci_get_of_property() call) in
> the 3rd patch.  An sdchi_pltfm_register(pdev, &pdata) that does the
> whole sequence would probably be valuable.  Same for the _remove hook.
> 
OK, one more pair of helper function will be added.

> Drivers that still need 2 stage registration, like the tegra driver,
> would still be able to call sdhci_pltfm_init() and sdhci_add_host()
> directly.
> 
> > +
> > +static int __devexit sdhci_cns3xxx_remove(struct platform_device *pdev)
> > +{
> > +	struct sdhci_host *host = platform_get_drvdata(pdev);
> > +	int dead = 0;
> > +	u32 scratch;
> > +
> > +	scratch = readl(host->ioaddr + SDHCI_INT_STATUS);
> > +	if (scratch == (u32)-1)
> > +		dead = 1;
> > +
> > +	sdhci_remove_host(host, dead);
> 
> The following would be equivalent to the above three lines:
> 
> 	sdhci_remove_host(host, scratch == (u32)-1);
> 
OK.

[...]
> > @@ -3,7 +3,7 @@
> >   *
> >   * Author: Saeed Bishara <saeed@marvell.com>
> >   *	   Mike Rapoport <mike@compulab.co.il>
> > - * Based on sdhci-cns3xxx.c
> > + * Based on sdhci-dove.c
> 
> This file *is* sdhci-dove.c.  Did you intend this change?  :-)
> 
My bad.

[...]
> > +#ifdef CONFIG_OF
> > +	plat = kzalloc(sizeof(*plat), GFP_KERNEL);
> > +	if (!plat) {
> > +		rc = -ENOMEM;
> > +		goto err_no_plat;
> > +	}
> > +	pdev->dev.platform_data = plat;
> > +
> > +	plat->cd_gpio = of_get_gpio(pdev->dev.of_node, 0);
> > +	plat->wp_gpio = of_get_gpio(pdev->dev.of_node, 1);
> > +	plat->power_gpio = of_get_gpio(pdev->dev.of_node, 2);
> > +
> > +	dev_info(&pdev->dev, "using gpios cd=%i, wp=%i power=%i\n",
> > +		plat->cd_gpio, plat->wp_gpio, plat->power_gpio);
> > +#endif
> 
> This will need to be reworked for mainline since the Tegra device tree
> support only exists in my git tree.  Basing it on devicetree/arm would
> work.
> 
OK. Will against mmc-next and test esdhc dt changes on devicetree/arm.

-- 
Regards,
Shawn

