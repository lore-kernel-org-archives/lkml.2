Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab0KER6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 13:58:16 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28444 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab0KER6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 13:58:14 -0400
Message-ID: <4CD44559.6070005@kernel.org>
Date: Fri, 05 Nov 2010 10:56:41 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.14) Gecko/20101013 SUSE/3.0.9 Thunderbird/3.0.9
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-64: fix and clean up AMD Fam10 MMCONF enabling
References: <4CD2DDC6020000780002098C@vpn.id2.novell.com>
In-Reply-To: <4CD2DDC6020000780002098C@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2010 08:22 AM, Jan Beulich wrote:
> Candidate memory ranges were not calculated properly (start addresses
> got needlessly rounded down, and end addresses didn't get rounded up
> at all), address comparison for secondary CPUs was done on only part
> of the address, and disabled status wasn't tracked properly.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/kernel/mmconf-fam10h_64.c |   54 +++++++++++++++++--------------------
>  1 file changed, 25 insertions(+), 29 deletions(-)
> 
> --- linux-2.6.37-rc1/arch/x86/kernel/mmconf-fam10h_64.c
> +++ 2.6.37-rc1-x86_64-mmconf-fam10h/arch/x86/kernel/mmconf-fam10h_64.c
> @@ -25,7 +25,6 @@ struct pci_hostbridge_probe {
>  };
>  
>  static u64 __cpuinitdata fam10h_pci_mmconf_base;
> -static int __cpuinitdata fam10h_pci_mmconf_base_status;
>  
>  static struct pci_hostbridge_probe pci_probes[] __cpuinitdata = {
>  	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1200 },
> @@ -44,7 +43,9 @@ static int __cpuinit cmp_range(const voi
>  	return start1 - start2;
>  }
>  
> -/*[47:0] */
> +#define UNIT (1ULL << (5 + 3 + 12))
> +#define MASK (~(UNIT - 1))
> +#define SIZE (UNIT << 8)

those MACRO seems too generic.

>  /* need to avoid (0xfd<<32) and (0xfe<<32), ht used space */
>  #define FAM10H_PCI_MMCONF_BASE (0xfcULL<<32)
>  #define BASE_VALID(b) ((b != (0xfdULL << 32)) && (b != (0xfeULL << 32)))
> @@ -64,12 +65,11 @@ static void __cpuinit get_fam10h_pci_mmc
>  	struct range range[8];
>  
>  	/* only try to get setting from BSP */
> -	/* -1 or 1 */
> -	if (fam10h_pci_mmconf_base_status)
> +	if (fam10h_pci_mmconf_base)
>  		return;
>  
>  	if (!early_pci_allowed())
> -		goto fail;
> +		return;
>  
>  	found = 0;
>  	for (i = 0; i < ARRAY_SIZE(pci_probes); i++) {
> @@ -91,7 +91,7 @@ static void __cpuinit get_fam10h_pci_mmc
>  	}
>  
>  	if (!found)
> -		goto fail;
> +		return;
>  
>  	/* SYS_CFG */
>  	address = MSR_K8_SYSCFG;
> @@ -104,11 +104,11 @@ static void __cpuinit get_fam10h_pci_mmc
>  		/* TOP_MEM2 */
>  		address = MSR_K8_TOP_MEM2;
>  		rdmsrl(address, val);
> -		tom2 = val & (0xffffULL<<32);
> +		tom2 = val & 0xffffff800000ULL;
>  	}
>  
>  	if (base <= tom2)
> -		base = tom2 + (1ULL<<32);
> +		base = (tom2 + 2 * UNIT - 1) & MASK;
>  
>  	/*
>  	 * need to check if the range is in the high mmio range that is
> @@ -123,9 +123,9 @@ static void __cpuinit get_fam10h_pci_mmc
>  		if (!(reg & 3))
>  			continue;
>  
> -		start = (((u64)reg) << 8) & (0xffULL << 32); /* 39:16 on 31:8*/
> +		start = (u64)(reg & 0xffffff00) << 8; /* 39:16 on 31:8*/
>  		reg = read_pci_config(bus, slot, 1, 0x84 + (i << 3));
> -		end = (((u64)reg) << 8) & (0xffULL << 32); /* 39:16 on 31:8*/
> +		end = ((u64)(reg & 0xffffff00) << 8) | 0xffff; /* 39:16 on 31:8*/
>  
>  		if (!end)
>  			continue;

if my memory is right, our range add/subtract is taking limit instead of limit - 1.

also reading out from those register is limit already.

Thanks

> @@ -143,32 +143,27 @@ static void __cpuinit get_fam10h_pci_mmc
>  
>  	if (range[hi_mmio_num - 1].end < base)
>  		goto out;
> -	if (range[0].start > base)
> +	if (range[0].start > base + SIZE)
>  		goto out;
>  
>  	/* need to find one window */
> -	base = range[0].start - (1ULL << 32);
> +	base = (range[0].start & MASK) - UNIT;
>  	if ((base > tom2) && BASE_VALID(base))
>  		goto out;
> -	base = range[hi_mmio_num - 1].end + (1ULL << 32);
> +	base = (range[hi_mmio_num - 1].end + UNIT) & MASK;
>  	if ((base > tom2) && BASE_VALID(base))
>  		goto out;
>  	/* need to find window between ranges */
> -	if (hi_mmio_num > 1)
> -	for (i = 0; i < hi_mmio_num - 1; i++) {
> -		if (range[i + 1].start > (range[i].end + (1ULL << 32))) {
> -			base = range[i].end + (1ULL << 32);
> -			if ((base > tom2) && BASE_VALID(base))
> -				goto out;
> -		}
> +	for (i = 1; i < hi_mmio_num; i++) {
> +		base = (range[i - 1].end + UNIT) & MASK;
> +		val = range[i].start & MASK;
> +		if (val >= base + SIZE && base > tom2 && BASE_VALID(base))
> +			goto out;
>  	}
> -
> -fail:
> -	fam10h_pci_mmconf_base_status = -1;
>  	return;
> +
>  out:
>  	fam10h_pci_mmconf_base = base;
> -	fam10h_pci_mmconf_base_status = 1;
>  }
>  
>  void __cpuinit fam10h_check_enable_mmcfg(void)
> @@ -190,11 +185,10 @@ void __cpuinit fam10h_check_enable_mmcfg
>  
>  		/* only trust the one handle 256 buses, if acpi=off */
>  		if (!acpi_pci_disabled || busnbits >= 8) {
> -			u64 base;
> -			base = val & (0xffffULL << 32);
> -			if (fam10h_pci_mmconf_base_status <= 0) {
> +			u64 base = val & MASK;
> +
> +			if (!fam10h_pci_mmconf_base) {
>  				fam10h_pci_mmconf_base = base;
> -				fam10h_pci_mmconf_base_status = 1;
>  				return;
>  			} else if (fam10h_pci_mmconf_base ==  base)
>  				return;
> @@ -206,8 +200,10 @@ void __cpuinit fam10h_check_enable_mmcfg
>  	 * with 256 buses
>  	 */
>  	get_fam10h_pci_mmconf_base();
> -	if (fam10h_pci_mmconf_base_status <= 0)
> +	if (!fam10h_pci_mmconf_base) {
> +		pci_probe &= ~PCI_CHECK_ENABLE_AMD_MMCONF;
>  		return;
> +	}
>  
>  	printk(KERN_INFO "Enable MMCONFIG on AMD Family 10h\n");
>  	val &= ~((FAM10H_MMIO_CONF_BASE_MASK<<FAM10H_MMIO_CONF_BASE_SHIFT) |
> 
> 

