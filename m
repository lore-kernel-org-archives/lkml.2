Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab0JGXXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 19:23:47 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:33282 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab0JGXXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 19:23:46 -0400
Date: Thu, 7 Oct 2010 17:23:42 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Ian Munsie <imunsie@au1.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        benh@kernel.crashing.org, paulus@samba.org,
        Stefan Weil <weil@mail.berlios.de>, Jiri Kosina <jkosina@suse.cz>,
        Sean MacLennan <smaclennan@pikatech.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Michal Simek <monstr@monstr.eu>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 14/18] powerpc, of_serial: Endianness issues setting up
 the serial ports
Message-ID: <20101007232342.GB4213@angua.secretlab.ca>
References: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
 <1285916771-18033-15-git-send-email-imunsie@au1.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285916771-18033-15-git-send-email-imunsie@au1.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 01, 2010 at 05:06:07PM +1000, Ian Munsie wrote:
> From: Ian Munsie <imunsie@au1.ibm.com>
> 
> The speed and clock of the serial ports is retrieved from the device
> tree in both the PowerPC legacy serial code and the Open Firmware serial
> driver, therefore they need to handle the fact that the device tree is
> always big endian, while the CPU may not be.
> 
> Also fix other device tree references in the legacy serial code.
> 
> Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>

Applied, thanks.

I'm picking up this one because it is also needed by Microblaze.
Michal Simek also posted a patch that does the same thing, but this
one is better so I'm dropping his in favour of this one.

As for the other patches, they all look good to me (at least for the
bits that I care about), but I'll leave them for Ben to pick up so the
series doesn't get too fragmented.

g.

> ---
>  arch/powerpc/kernel/legacy_serial.c |   22 +++++++++++-----------
>  drivers/serial/of_serial.c          |   12 ++++++------
>  2 files changed, 17 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/legacy_serial.c b/arch/powerpc/kernel/legacy_serial.c
> index c1fd0f9..c834757 100644
> --- a/arch/powerpc/kernel/legacy_serial.c
> +++ b/arch/powerpc/kernel/legacy_serial.c
> @@ -52,14 +52,14 @@ static int __init add_legacy_port(struct device_node *np, int want_index,
>  				  phys_addr_t taddr, unsigned long irq,
>  				  upf_t flags, int irq_check_parent)
>  {
> -	const u32 *clk, *spd;
> +	const __be32 *clk, *spd;
>  	u32 clock = BASE_BAUD * 16;
>  	int index;
>  
>  	/* get clock freq. if present */
>  	clk = of_get_property(np, "clock-frequency", NULL);
>  	if (clk && *clk)
> -		clock = *clk;
> +		clock = be32_to_cpup(clk);
>  
>  	/* get default speed if present */
>  	spd = of_get_property(np, "current-speed", NULL);
> @@ -109,7 +109,7 @@ static int __init add_legacy_port(struct device_node *np, int want_index,
>  	legacy_serial_infos[index].taddr = taddr;
>  	legacy_serial_infos[index].np = of_node_get(np);
>  	legacy_serial_infos[index].clock = clock;
> -	legacy_serial_infos[index].speed = spd ? *spd : 0;
> +	legacy_serial_infos[index].speed = spd ? be32_to_cpup(spd) : 0;
>  	legacy_serial_infos[index].irq_check_parent = irq_check_parent;
>  
>  	printk(KERN_DEBUG "Found legacy serial port %d for %s\n",
> @@ -168,7 +168,7 @@ static int __init add_legacy_soc_port(struct device_node *np,
>  static int __init add_legacy_isa_port(struct device_node *np,
>  				      struct device_node *isa_brg)
>  {
> -	const u32 *reg;
> +	const __be32 *reg;
>  	const char *typep;
>  	int index = -1;
>  	u64 taddr;
> @@ -181,7 +181,7 @@ static int __init add_legacy_isa_port(struct device_node *np,
>  		return -1;
>  
>  	/* Verify it's an IO port, we don't support anything else */
> -	if (!(reg[0] & 0x00000001))
> +	if (!(be32_to_cpu(reg[0]) & 0x00000001))
>  		return -1;
>  
>  	/* Now look for an "ibm,aix-loc" property that gives us ordering
> @@ -202,7 +202,7 @@ static int __init add_legacy_isa_port(struct device_node *np,
>  		taddr = 0;
>  
>  	/* Add port, irq will be dealt with later */
> -	return add_legacy_port(np, index, UPIO_PORT, reg[1], taddr,
> +	return add_legacy_port(np, index, UPIO_PORT, be32_to_cpu(reg[1]), taddr,
>  			       NO_IRQ, UPF_BOOT_AUTOCONF, 0);
>  
>  }
> @@ -251,9 +251,9 @@ static int __init add_legacy_pci_port(struct device_node *np,
>  	 * we get to their "reg" property
>  	 */
>  	if (np != pci_dev) {
> -		const u32 *reg = of_get_property(np, "reg", NULL);
> -		if (reg && (*reg < 4))
> -			index = lindex = *reg;
> +		const __be32 *reg = of_get_property(np, "reg", NULL);
> +		if (reg && (be32_to_cpup(reg) < 4))
> +			index = lindex = be32_to_cpup(reg);
>  	}
>  
>  	/* Local index means it's the Nth port in the PCI chip. Unfortunately
> @@ -507,7 +507,7 @@ static int __init check_legacy_serial_console(void)
>  	struct device_node *prom_stdout = NULL;
>  	int i, speed = 0, offset = 0;
>  	const char *name;
> -	const u32 *spd;
> +	const __be32 *spd;
>  
>  	DBG(" -> check_legacy_serial_console()\n");
>  
> @@ -547,7 +547,7 @@ static int __init check_legacy_serial_console(void)
>  	}
>  	spd = of_get_property(prom_stdout, "current-speed", NULL);
>  	if (spd)
> -		speed = *spd;
> +		speed = be32_to_cpup(spd);
>  
>  	if (strcmp(name, "serial") != 0)
>  		goto not_found;
> diff --git a/drivers/serial/of_serial.c b/drivers/serial/of_serial.c
> index 2af8fd1..17849dc 100644
> --- a/drivers/serial/of_serial.c
> +++ b/drivers/serial/of_serial.c
> @@ -31,8 +31,8 @@ static int __devinit of_platform_serial_setup(struct platform_device *ofdev,
>  {
>  	struct resource resource;
>  	struct device_node *np = ofdev->dev.of_node;
> -	const unsigned int *clk, *spd;
> -	const u32 *prop;
> +	const __be32 *clk, *spd;
> +	const __be32 *prop;
>  	int ret, prop_size;
>  
>  	memset(port, 0, sizeof *port);
> @@ -55,23 +55,23 @@ static int __devinit of_platform_serial_setup(struct platform_device *ofdev,
>  	/* Check for shifted address mapping */
>  	prop = of_get_property(np, "reg-offset", &prop_size);
>  	if (prop && (prop_size == sizeof(u32)))
> -		port->mapbase += *prop;
> +		port->mapbase += be32_to_cpup(prop);
>  
>  	/* Check for registers offset within the devices address range */
>  	prop = of_get_property(np, "reg-shift", &prop_size);
>  	if (prop && (prop_size == sizeof(u32)))
> -		port->regshift = *prop;
> +		port->regshift = be32_to_cpup(prop);
>  
>  	port->irq = irq_of_parse_and_map(np, 0);
>  	port->iotype = UPIO_MEM;
>  	port->type = type;
> -	port->uartclk = *clk;
> +	port->uartclk = be32_to_cpup(clk);
>  	port->flags = UPF_SHARE_IRQ | UPF_BOOT_AUTOCONF | UPF_IOREMAP
>  		| UPF_FIXED_PORT | UPF_FIXED_TYPE;
>  	port->dev = &ofdev->dev;
>  	/* If current-speed was set, then try not to change it. */
>  	if (spd)
> -		port->custom_divisor = *clk / (16 * (*spd));
> +		port->custom_divisor = be32_to_cpup(clk) / (16 * (be32_to_cpup(spd)));
>  
>  	return 0;
>  }
> -- 
> 1.7.1
> 
