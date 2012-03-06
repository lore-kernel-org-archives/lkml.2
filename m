Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758325Ab2CFEyK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 23:54:10 -0500
Received: from mail4.comsite.net ([205.238.176.238]:5810 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758294Ab2CFEyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 23:54:08 -0500
X-Greylist: delayed 1010 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Mar 2012 23:54:08 EST
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
To: Mai La <mla@apm.com>
Subject: Re: [1/2] powerpc/44x: Fix PCI MSI support for APM821xx SoC and Bluestone board
From: Milton Miller <miltonm@bga.com>
Message-Id: <bluehawk-msi-use-upper-lower-32@mdm.bga.com>
In-Reply-To: <1331004581-23795-1-git-send-email-mla@apm.com>
References: <1331004581-23795-1-git-send-email-mla@apm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Josh Boyer <jwboyer@linux.vnet.ibm.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Tirumala R Marri <tmarri@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Michael Neuling <mikey@neuling.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Anton Blanchard <anton@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, open-source-review@apm.com
Date: Mon, 05 Mar 2012 22:37:13 -0600
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Mar 2012 about 17:29:41 -0000, Mai La wrote:
>  
> @@ -43,7 +43,12 @@
>  #define PEIH_FLUSH0	0x30
>  #define PEIH_FLUSH1	0x38
>  #define PEIH_CNTRST	0x48
> +
> +#ifdef CONFIG_APM821xx
> +#define NR_MSI_IRQS	8
> +#else
>  #define NR_MSI_IRQS	4
> +#endif
>  

does this need to go into the dts binding?

>  struct ppc4xx_msi {
>  	u32 msi_addr_lo;
> @@ -150,12 +155,11 @@ static int ppc4xx_setup_pcieh_hw(struct platform_device *dev,
>  	if (!sdr_addr)
>  		return -1;
>  
> -	SDR0_WRITE(sdr_addr, (u64)res.start >> 32);	 /*HIGH addr */
> -	SDR0_WRITE(sdr_addr + 1, res.start & 0xFFFFFFFF); /* Low addr */
> -
> +	mtdcri(SDR0, *sdr_addr, (u64)res.start >> 32);	/*HIGH addr */
> +	mtdcri(SDR0, *sdr_addr + 1, res.start & 0xFFFFFFFF);/* Low addr */

Please use upper_32_bits and lower_32_bits from linux/kernel.h

>  	msi->msi_dev = of_find_node_by_name(NULL, "ppc4xx-msi");
> -	if (msi->msi_dev)
> +	if (!msi->msi_dev)
>  		return -ENODEV;
>  
>  	msi->msi_regs = of_iomap(msi->msi_dev, 0);
> @@ -167,9 +171,12 @@ static int ppc4xx_setup_pcieh_hw(struct platform_device *dev,
>  		(u32) (msi->msi_regs + PEIH_TERMADH), (u32) (msi->msi_regs));
>  
>  	msi_virt = dma_alloc_coherent(&dev->dev, 64, &msi_phys, GFP_KERNEL);
> -	msi->msi_addr_hi = 0x0;
> -	msi->msi_addr_lo = (u32) msi_phys;
> -	dev_dbg(&dev->dev, "PCIE-MSI: msi address 0x%x\n", msi->msi_addr_lo);
> +	if (!msi_virt)
> +		return -ENOMEM;
> +	msi->msi_addr_hi = (u32)(msi_phys >> 32);
> +	msi->msi_addr_lo = (u32)(msi_phys & 0xffffffff);

ditto


milton
