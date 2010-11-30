Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab0K3JL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 04:11:57 -0500
Received: from mail4.comsite.net ([205.238.176.238]:48050 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab0K3JLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 04:11:54 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
From: Milton Miller <miltonm@bga.com>
Subject: Re: [v4] ppc44x:PHY fixup for USB on canyonlands board
Message-Id: <mdm-canyonlands-reply2@mdm.bga.com>
In-Reply-To: <201011291313.oATDD1AF028975@amcc.com>
References: <201011291313.oATDD1AF028975@amcc.com>
To: Rupjyoti Sarmah <rsarmah@amcc.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, rsarmah@apm.com,
        Josh Boyer <jwboyer@linux.vnet.ibm.com>
Date: Tue, 30 Nov 2010 03:11:27 -0600
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I prepared these comments for v1, but aparently forgot to send them,
so I'll do so now.


On Mon, 29 Nov 2010 about 03:13:01 -0000, Rupjyoti Sarmah wrote:
> This fix is a reset for USB PHY that requires some amount of time for power to be stable on Canyonlands.
> 
> Signed-off-by: Rupjyoti Sarmah <rsarmah@apm.com>
> 
> ---
> index a303703..3c5d63c 100644
> --- a/arch/powerpc/boot/dts/canyonlands.dts
> +++ b/arch/powerpc/boot/dts/canyonlands.dts
> @@ -224,6 +224,13 @@
>  					};
>  				};
>  
> +				cpld@2,0 {
> +					#address-cells = <1>;
> +					#size-cells = <1>;

why does this node have #address-cells and #size-cells but no children? 

> +					compatible = "amcc,ppc460ex-bcsr";
> +					reg = <2 0x0 0x9>;
> +				};
> +
>  				ndfc@3,0 {
>  					compatible = "ibm,ndfc";
>  					reg = <0x00000003 0x00000000 0x00002000>;
..
> diff --git a/arch/powerpc/platforms/44x/canyonlands.c b/arch/powerpc/platforms/44x/canyonlands.c
> new file mode 100644
> index 0000000..4917c31
> --- /dev/null
> +++ b/arch/powerpc/platforms/44x/canyonlands.c
> @@ -0,0 +1,120 @@
> +

> +static __initdata struct of_device_id ppc44x_of_bus[] = {
..
> +static int __init ppc44x_device_probe(void)
> +{
> +	of_platform_bus_probe(NULL, ppc44x_of_bus, NULL);
> +
> +	return 0;
> +}
> +machine_device_initcall(canyonlands, ppc44x_device_probe);
> +
> +/* Using this code only for the Canyonlands board.  */
> +
> +static int __init ppc44x_probe(void)
> +{
> +	unsigned long root = of_get_flat_dt_root();
> +	if (of_flat_dt_is_compatible(root, "amcc,canyonlands")) {
> +		ppc_pci_set_flags(PPC_PCI_REASSIGN_ALL_RSRC);
> +		return 1;
> +		}
> +	return 0;
> +}
> +
> +/* USB PHY fixup code on Canyonlands kit. */

All of the above have ppc44x prefix, but have been copied to this
canyonlands file.   While there is no build error because they
are all static it will be less confusing if they had a canyonlands
prefix instead.

> +
> +static int __init ppc460ex_canyonlands_fixup(void)
> +{
> +	u8 __iomem *bcsr ;
> +	void __iomem *vaddr;
> +	struct device_node *np;
> +
> +	np = of_find_compatible_node(NULL, NULL, "amcc,ppc460ex-bcsr");
> +	if (!np) {
> +		printk(KERN_ERR "failed did not find amcc, ppc460ex bcsr node\n");
> +		return -ENODEV;
> +	}
> +
> +	bcsr = of_iomap(np, 0);
> +	of_node_put(np);
> +
> +	if (!bcsr) {
> +		printk(KERN_CRIT "Could not remap bcsr\n");
> +		return -ENODEV;
> +	}
> +
> +	np = of_find_compatible_node(NULL, NULL, "ibm,ppc4xx-gpio");
> +	vaddr = of_iomap(np, 0);
> +	if (!vaddr) {
> +		printk(KERN_CRIT "Could not get gpio node address\n");
> +		return -ENODEV;
> +	}
> +	/* Disable USB, through the BCSR7 bits */
> +	setbits8(&bcsr[7], BCSR_USB_EN);
> +
> +	/* Wait for a while after reset */
> +	msleep(100);
> +
> +	/* Enable USB here */
> +	clrbits8(&bcsr[7], BCSR_USB_EN);
> +
> +	/*
> +	 * Configure multiplexed gpio16 and gpio19 as alternate1 output
> +	 * source after USB reset.This configuration is done through GPIO0_TSRH
> +	 * and GPIO0_OSRH bits 0:1 and 6:7.

Missing spaces before the second sentence.

Rather then telling us which bits are being set, which is fairly
obvoius from the code, it would be more helpful to say what
alternate1 output source means.

I'm curious why you set these after the reset when they were not
set before.  Should they be set to something else temporarly during
the reset?

> +	 */
> +	setbits32((vaddr + GPIO0_OSRH), 0x42000000);
> +	setbits32((vaddr + GPIO0_TSRH), 0x42000000);
> +	of_node_put(np);
> +	return 0;

The error paths in this function leave incorrect refcounts on the
nodes, and no path does of_unmap of the regions even though the
variables with the address goes out of scope.

> +}
> +machine_device_initcall(canyonlands, ppc460ex_canyonlands_fixup);
> +define_machine(canyonlands) {
> +	.name = "Canyonlands",
> +	.probe = ppc44x_probe,
> +	.progress = udbg_progress,
> +	.init_IRQ = uic_init_tree,
> +	.get_irq = uic_get_irq,
> +	.restart = ppc4xx_reset_system,
> +	.calibrate_decr = generic_calibrate_decr,
> +};


Also, you shouldn't need the select PPC44x_SIMPLE in the CANYONLANDS
stanza in arch/powerpc/platforms/44x/Kconfig.

milton
