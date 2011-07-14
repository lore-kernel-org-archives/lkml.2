Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039Ab1GNBQ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 21:16:29 -0400
Received: from ozlabs.org ([203.10.76.45]:52521 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997Ab1GNBQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 21:16:28 -0400
Date: Thu, 14 Jul 2011 11:16:27 +1000
From: Tony Breeds <tony@bakeyournoodle.com>
To: Ayman El-Khashab <ayman@elkhashab.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] powerpc/4xx: enable and fix pcie gen1/gen2 on the
 460sx
Message-ID: <20110714011627.GJ20597@ozlabs.org>
Mail-Followup-To: Ayman El-Khashab <ayman@elkhashab.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
References: <y>
 <1310603611-8960-1-git-send-email-ayman@elkhashab.com>
 <1310603611-8960-2-git-send-email-ayman@elkhashab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1310603611-8960-2-git-send-email-ayman@elkhashab.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 13, 2011 at 07:33:31PM -0500, Ayman El-Khashab wrote:
> Adds a register to the config space for the 460sx.  Changes the vc0
> detect to a pll detect.  maps configuration space to test the link
> status.  changes the setup to enable gen2 devices to operate at gen2
> speeds.  fixes mapping that was not correct for the 460sx.
> 
> tested on the 460sx eiger and custom board

Hi Ayman.
	Just a few comments.
 
<snip>

> +static void __init ppc460sx_pciex_check_link(struct ppc4xx_pciex_port *port)
> +{
> +	void __iomem *mbase;
> +	int attempt = 50;
> +
> +	port->link = 0;
> +
> +	mbase = ioremap(port->cfg_space.start + 0x00000000, 0x1000);

Why + 0x00000000 ? ppc4xx_pciex_port_setup_hose() does:
mbase = ioremap(port->cfg_space.start + 0x10000000, 0x1000);
so isn't one of these statements is wrong?

> +	if (mbase == NULL) {
> +		printk(KERN_ERR "%s: Can't map internal config space !",
> +			port->node->full_name);
> +		goto done;
> +	}
> +
> +	while (attempt && (0 == (in_le32(mbase + PECFG_460SX_DLLSTA)
> +			& 0x00000010))) {

Nitpicking, I think it'd be nice if there was #define for 0x00000010
perhaps: #define PECFG_460SX_DLLSTA_LINKUP 0x00000010

> +		attempt--;
> +		mdelay(10);
> +	}
> +	if (attempt)
> +		port->link = 1;
> +done:
> +	iounmap(mbase);
> +
> +}
> +
>  static struct ppc4xx_pciex_hwops ppc460sx_pcie_hwops __initdata = {
>  	.core_init	= ppc460sx_pciex_core_init,
>  	.port_init_hw	= ppc460sx_pciex_init_port_hw,
>  	.setup_utl	= ppc460sx_pciex_init_utl,
> -	.check_link	= ppc4xx_pciex_check_link_sdr,
> +	.check_link	= ppc460sx_pciex_check_link,
>  };
>  
>  #endif /* CONFIG_44x */
> @@ -1338,15 +1367,15 @@ static int __init ppc4xx_pciex_port_init(struct ppc4xx_pciex_port *port)
>  	if (rc != 0)
>  		return rc;
>  
> -	if (ppc4xx_pciex_hwops->check_link)
> -		ppc4xx_pciex_hwops->check_link(port);
> -
>  	/*
>  	 * Initialize mapping: disable all regions and configure
>  	 * CFG and REG regions based on resources in the device tree
>  	 */
>  	ppc4xx_pciex_port_init_mapping(port);
>  
> +	if (ppc4xx_pciex_hwops->check_link)
> +		ppc4xx_pciex_hwops->check_link(port);
> +

Why move this?  You already iorempat the cfg space.
>  	/*
>  	 * Map UTL
>  	 */
> @@ -1360,13 +1389,23 @@ static int __init ppc4xx_pciex_port_init(struct ppc4xx_pciex_port *port)
>  		ppc4xx_pciex_hwops->setup_utl(port);
>  
>  	/*
> -	 * Check for VC0 active and assert RDY.
> +	 * Check for VC0 active or PLL Locked and assert RDY.
>  	 */
>  	if (port->sdr_base) {
> -		if (port->link &&
> -		    ppc4xx_pciex_wait_on_sdr(port, PESDRn_RCSSTS,
> -					     1 << 16, 1 << 16, 5000)) {
> -			printk(KERN_INFO "PCIE%d: VC0 not active\n", port->index);
> +		if (of_device_is_compatible(port->node,
> +				"ibm,plb-pciex-460sx")){
> +			if (port->link && ppc4xx_pciex_wait_on_sdr(port,
> +					PESDRn_RCSSTS,
> +					1 << 12, 1 << 12, 5000)) {
> +				printk(KERN_INFO "PCIE%d: PLL not locked\n",
> +						port->index);
> +				port->link = 0;
> +			}
> +		} else if (port->link &&
> +			ppc4xx_pciex_wait_on_sdr(port, PESDRn_RCSSTS,
> +				1 << 16, 1 << 16, 5000)) {
> +			printk(KERN_INFO "PCIE%d: VC0 not active\n",
> +					port->index);
>  			port->link = 0;
>  		}
>  
> @@ -1565,6 +1604,10 @@ static int __init ppc4xx_setup_one_pciex_POM(struct ppc4xx_pciex_port	*port,
>  	pcial = RES_TO_U32_LOW(pci_addr);
>  	sa = (0xffffffffu << ilog2(size)) | 0x1;
>  
> +	/* Enabled and single region */
> +	sa |= (of_device_is_compatible(port->node, "ibm,plb-pciex-460sx")) ?
> +			0x5 : 0x3;
> +
>  	/* Program register values */
>  	switch (index) {
>  	case 0:
> @@ -1573,8 +1616,7 @@ static int __init ppc4xx_setup_one_pciex_POM(struct ppc4xx_pciex_port	*port,
>  		dcr_write(port->dcrs, DCRO_PEGPL_OMR1BAH, lah);
>  		dcr_write(port->dcrs, DCRO_PEGPL_OMR1BAL, lal);
>  		dcr_write(port->dcrs, DCRO_PEGPL_OMR1MSKH, 0x7fffffff);
> -		/* Note that 3 here means enabled | single region */
> -		dcr_write(port->dcrs, DCRO_PEGPL_OMR1MSKL, sa | 3);
> +		dcr_write(port->dcrs, DCRO_PEGPL_OMR1MSKL, sa);
>  		break;
>  	case 1:
>  		out_le32(mbase + PECFG_POM1LAH, pciah);
> @@ -1582,8 +1624,7 @@ static int __init ppc4xx_setup_one_pciex_POM(struct ppc4xx_pciex_port	*port,
>  		dcr_write(port->dcrs, DCRO_PEGPL_OMR2BAH, lah);
>  		dcr_write(port->dcrs, DCRO_PEGPL_OMR2BAL, lal);
>  		dcr_write(port->dcrs, DCRO_PEGPL_OMR2MSKH, 0x7fffffff);
> -		/* Note that 3 here means enabled | single region */
> -		dcr_write(port->dcrs, DCRO_PEGPL_OMR2MSKL, sa | 3);
> +		dcr_write(port->dcrs, DCRO_PEGPL_OMR2MSKL, sa);
>  		break;
>  	case 2:
>  		out_le32(mbase + PECFG_POM2LAH, pciah);
> @@ -1591,8 +1632,7 @@ static int __init ppc4xx_setup_one_pciex_POM(struct ppc4xx_pciex_port	*port,
>  		dcr_write(port->dcrs, DCRO_PEGPL_OMR3BAH, lah);
>  		dcr_write(port->dcrs, DCRO_PEGPL_OMR3BAL, lal);
>  		dcr_write(port->dcrs, DCRO_PEGPL_OMR3MSKH, 0x7fffffff);
> -		/* Note that 3 here means enabled | IO space !!! */
> -		dcr_write(port->dcrs, DCRO_PEGPL_OMR3MSKL, sa | 3);
> +		dcr_write(port->dcrs, DCRO_PEGPL_OMR3MSKL, sa);
>  		break;
>  	}

I think you really want to check the definitions for OMRs 2 and 3 to verify that this is right.
  
Yours Tony
