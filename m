Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab2JVFyV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 01:54:21 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44369 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821Ab2JVFyR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 01:54:17 -0400
From: "Bedia, Vaibhav" <vaibhav.bedia@ti.com>
To: "Porter, Matt" <mporter@ti.com>
CC: Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "Cousson, Benoit" <b-cousson@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Chris Ball <cjb@laptop.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: RE: [RFC PATCH v3 00/16] DMA Engine support for AM33XX
Thread-Topic: [RFC PATCH v3 00/16] DMA Engine support for AM33XX
Thread-Index: AQHNrTQZOLq9jfMJNk+iV4vTK/FhGJfAWwaQ///EmACAAGcAIP//9UiAgARXxzA=
Date: Mon, 22 Oct 2012 05:53:32 +0000
Message-ID: <B5906170F1614E41A8A28DE3B8D121433EBD580F@DBDE01.ent.ti.com>
References: <1350566815-409-1-git-send-email-mporter@ti.com>
 <B5906170F1614E41A8A28DE3B8D121433EBD29FC@DBDE01.ent.ti.com>
 <20121019111558.GD25164@beef>
 <B5906170F1614E41A8A28DE3B8D121433EBD2CE1@DBDE01.ent.ti.com>
 <20121019164615.GH25164@beef>
In-Reply-To: <20121019164615.GH25164@beef>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.133.70]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 22:16:15, Porter, Matt wrote:
> On Fri, Oct 19, 2012 at 12:02:42PM +0000, Bedia, Vaibhav wrote:
> > On Fri, Oct 19, 2012 at 16:45:58, Porter, Matt wrote:
> > > On Fri, Oct 19, 2012 at 10:26:20AM +0000, Bedia, Vaibhav wrote:
> > [...]
> > > > 
> > > > I didn't see all the patches that you posted on edma-dmaengine-v3
> > > > but I do seem them on edma-dmaengine-am33xx-v3 branch.
> > > 
> > > I see I referenced the wrong branch in the cover letter. Thanks for
> > > testing and noticing this. Sorry to make you hunt for the correct
> > > branch in that repo. ;) 
> > > 
> > 
> > No problem.
> > 
> > > https://github.com/ohporter/linux/tree/edma-dmaengine-am33xx-v3
> > > is indeed the correct branch for those wanting to pull this in or
> > > grab some of the not-to-be-merged drivers I used for testing.
> > > 
> > > > I added a couple of patches to enable earlyprintk and build the DTB
> > > > appended kernel image uImage-dtb.am335x-evm
> > > > 
> > > > Here's what i see
> > > > 
> > > > [...]
> > > 
> > > <snip>
> > > 
> > > > [    0.175354] edma: probe of 49000000.edma failed with error -16
> > > 
> > > I missed an uninitialized pdata case in the bug fixes mentioned in
> > > the changelog and the folks previously failing the same way didn't
> > > hit the case I suspect you are hitting. Can you try this and let me
> > > know how it works?
> > > 
> > 
> > That doesn't help :(
> 
> Ok, so I dumped my Linaro toolchain which was masking this issue that
> you got unlucky with on EVM, whereas I was lucky. Switching toolchains I
> was able to reproduce the problem. Pantelis Antoniou suggested some
> changes and the following fixes this issue for me...verified on both
> BeagleBone and EVM. Let me know if that works on your end and I'll
> incorporate some version of it in the next update.

Heh I would not have suspected the toolchain so early ;)

> 
> diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
> index b761b7a..6ed394f 100644
> --- a/arch/arm/common/edma.c
> +++ b/arch/arm/common/edma.c
> @@ -1598,6 +1598,8 @@ static struct of_dma_filter_info edma_filter_info = {
>  static int __init edma_probe(struct platform_device *pdev)
>  {
>  	struct edma_soc_info	**info = pdev->dev.platform_data;
> +	struct edma_soc_info	*ninfo[EDMA_MAX_CC] = {NULL, NULL};
> +	struct edma_soc_info	tmpinfo;
>  	s8			(*queue_priority_mapping)[2];
>  	s8			(*queue_tc_mapping)[2];
>  	int			i, j, off, ln, found = 0;
> @@ -1614,15 +1616,13 @@ static int __init edma_probe(struct platform_device *pdev)
>  	char			irq_name[10];
>  	struct device_node	*node = pdev->dev.of_node;
>  	struct device		*dev = &pdev->dev;
> -	struct edma_soc_info	*pdata;
>  	int			ret;
>  
>  	if (node) {
> -		pdata = devm_kzalloc(dev,
> -				     sizeof(struct edma_soc_info),
> -				     GFP_KERNEL);
> -		edma_of_parse_dt(dev, node, pdata);
> -		info = &pdata;
> +		info = ninfo;
> +		edma_of_parse_dt(dev, node, &tmpinfo);
> +		info[0] = &tmpinfo;
> +
>  		dma_cap_set(DMA_SLAVE, edma_filter_info.dma_cap);
>  		of_dma_controller_register(dev->of_node,
>  					   of_dma_simple_xlate,
> 

With the above diff, the kernel boots fine on the EVM.

> > Looking at the original crash log, I suspect something is not correct
> > with the irq portion, probably in the DT or the driver. 
> > 
> > "genirq: Flags mismatch irq 28. 00000000 (edma) vs. 00000000 (edma)"
> > 
> > The warning below that is coming due to fail case in edma_probe not tracking
> > the request_irq status properly and but IMO that's a separate issue.
> 
> It is a separate issue, indeed. My ideal goal was to avoid changing
> anything in this existing davinci dma implementation, that's why the
> error paths were unmodified. Since I'm having to rework a few more things
> I'll look at those and generate an improved version.
> 
> Russ Dill also made some good simplification/cleanup suggestions for the
> of parsing on irc which I'll incorporate in the next version.

Ok, sounds good.

Regards,
Vaibhav
