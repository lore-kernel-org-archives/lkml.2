Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab0KEKJJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 06:09:09 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:41763 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab0KEKJG convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:4:1>);
	Fri, 5 Nov 2010 06:09:06 -0400
Message-Id: <4CD3E5CB0200007800020B4E@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 05 Nov 2010 10:08:59 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Yinghai Lu" <yinghai@kernel.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        <linux-kernel@vger.kernel.org>, <jbarnes@virtuousgeek.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: your patch "x86/PCI: host mmconfig detect clean up"
References: <4CD15538020000780002060B@vpn.id2.novell.com>
 <4CD3160D.7010902@kernel.org>
In-Reply-To: <4CD3160D.7010902@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 04.11.10 at 21:22, Yinghai Lu <yinghai@kernel.org> wrote:
> Subject: [PATCH] x86/pci: Add mmconf range into e820 for when it is from MSR 
> with amd faml0h
> 
> for AMD Fam10h, it we read mmconf from MSR early, we should just trust it
> because we check it and correct it already.
> 
> so add it to e820
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/kernel/mmconf-fam10h_64.c |   40 +++++++++++++++++++++----------------
>  1 file changed, 23 insertions(+), 17 deletions(-)
> 
> Index: linux-2.6/arch/x86/kernel/mmconf-fam10h_64.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/mmconf-fam10h_64.c
> +++ linux-2.6/arch/x86/kernel/mmconf-fam10h_64.c
> @@ -16,6 +16,7 @@
>  #include <asm/acpi.h>
>  #include <asm/mmconfig.h>
>  #include <asm/pci_x86.h>
> +#include <asm/e820.h>
>  
>  struct pci_hostbridge_probe {
>  	u32 bus;
> @@ -27,23 +28,26 @@ struct pci_hostbridge_probe {
>  static u64 __cpuinitdata fam10h_pci_mmconf_base;
>  static int __cpuinitdata fam10h_pci_mmconf_base_status;
>  
> +/* only on BSP */
> +static void __init_refok e820_add_mmconf_range(int busnbits)
> +{
> +	u64 end;
> +
> +	end = fam10h_pci_mmconf_base + (1ULL<<(busnbits + 20)) - 1;
> +	if (!e820_all_mapped(fam10h_pci_mmconf_base, end+1, E820_RESERVED)) {
> +		printk(KERN_DEBUG "Fam 10h mmconf [%llx, %llx]\n",
> +				 fam10h_pci_mmconf_base, end);
> +		e820_add_region(fam10h_pci_mmconf_base, 1ULL<<(busnbits + 20),
> +				 E820_RESERVED);
> +		sanitize_e820_map();

This needs parameters passed, at least up to .37-rc1.

But it's pointless anyway - eventual overlaps won't matter
anymore since memory got passed to the page allocator
already. Consequently you really need to make sure there's
no overlap *before* assigning the region, or (given that the
range is being placed above TOM2 anyway), you may simply
ignore the potential for overlaps here.

> +	}
> +}
> +
>  static struct pci_hostbridge_probe pci_probes[] __cpuinitdata = {
>  	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1200 },
>  	{ 0xff, 0, PCI_VENDOR_ID_AMD, 0x1200 },
>  };
>  
> -static int __cpuinit cmp_range(const void *x1, const void *x2)
> -{
> -	const struct range *r1 = x1;
> -	const struct range *r2 = x2;
> -	int start1, start2;
> -
> -	start1 = r1->start >> 32;
> -	start2 = r2->start >> 32;
> -
> -	return start1 - start2;
> -}
> -

This (and related changes further down) doesn't seem to be
related to addressing the problem at hand.

> @@ -191,10 +195,12 @@ void __cpuinit fam10h_check_enable_mmcfg
>  		/* only trust the one handle 256 buses, if acpi=off */
>  		if (!acpi_pci_disabled || busnbits >= 8) {
>  			u64 base;
> -			base = val & (0xffffULL << 32);
> +			base = val & (FAM10H_MMIO_CONF_BASE_MASK <<
> +					FAM10H_MMIO_CONF_BASE_SHIFT);


Neither is this. I sent a fix for this (and other problems in this file)
yesterday, and I'm afraid there's another problem here yielding
the variant you propose incorrect: FAM10H_MMIO_CONF_BASE_MASK
is being defined as 0xfffffff, thus shifting it by 20 bits will produce
0xfffffffffff00000 (sign extended from 0xfff00000) instead of the
expected 0xfffffff00000. This is also affecting the other two uses of
this constant (though I admit that it is only a theoretical problem as
the upper bits are defined as read-as-zero). I'll soon send a fix for
this and some other problem I found in this code just now.

Jan

