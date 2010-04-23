Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab0DWXbN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 19:31:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36164 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab0DWXbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 19:31:11 -0400
Message-ID: <4BD22D99.5000603@zytor.com>
Date: Fri, 23 Apr 2010 16:30:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Yinghai <yinghai.lu@oracle.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andy Isaacson <adi@hexapodia.org>, guenter.roeck@ericsson.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH -v3 1/3] x86: Reserve [0xa0000, 0x100000] in e820 map
References: <20100409223532.GC11130@hexapodia.org>	 <4BBFB1D8.6090802@oracle.com> <20100410000030.GE11130@hexapodia.org>	 <4BBFD019.9040405@oracle.com> <20100410014308.GG11130@hexapodia.org>	 <4BBFD8EF.6020108@oracle.com> <20100410015711.GH11130@hexapodia.org>	 <4BBFE66C.2040603@oracle.com> <20100412185416.GA19959@hexapodia.org>	 <4BC375D9.4040503@oracle.com> <20100412200224.GO11130@hexapodia.org>	 <4BC39F67.4090407@oracle.com> <1271192527.6035.44.camel@dc7800.home> <4BC4DD85.5030203@zytor.com> <4BC4DDEA.60202@oracle.com> <4BC4DFAD.9020600@zytor.com> <4BC4E09F.9000608@oracle.com>
In-Reply-To: <4BC4E09F.9000608@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesse,

I am considering putting this patch plus the two followup patches in my
next set of fixes to Linus.  However, the two followup patches are
really more PCI-related than x86-related, so I would appreciate your OK.

I'm using this version (-v3) because the latter cleanup (removing
probe_rom_32.c for example) do not seem to be .34 material.

For the followup patches:

http://marc.info/?i=4BC4E0E9.7000203@oracle.com
http://marc.info/?i=4BC4E115.90805@oracle.com

	-hpa

On 04/13/2010 02:22 PM, Yinghai wrote:
> 
> 
> Update e820 at first, and later put them resource tree.
> 
> Reserved that early, will not be allocated to unassigned PCI BAR
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Guenter Roeck <guenter.roeck@ericsson.com>
> Cc: Andy Isaacson <adi@hexapodia.org>
> Tested-by: Andy Isaacson <adi@hexapodia.org>
> Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
> Acked-by: H. Peter Anvin <hpa@zytor.com>
> 
> ---
>  arch/x86/include/asm/setup.h |    1 -
>  arch/x86/kernel/head32.c     |    1 -
>  arch/x86/kernel/setup.c      |   19 +------------------
>  3 files changed, 1 insertion(+), 20 deletions(-)
> 
> Index: linux-2.6/arch/x86/include/asm/setup.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/setup.h
> +++ linux-2.6/arch/x86/include/asm/setup.h
> @@ -44,7 +44,6 @@ static inline void visws_early_detect(vo
>  extern unsigned long saved_video_mode;
>  
>  extern void reserve_standard_io_resources(void);
> -extern void i386_reserve_resources(void);
>  extern void setup_default_timer_irq(void);
>  
>  #ifdef CONFIG_X86_MRST
> Index: linux-2.6/arch/x86/kernel/head32.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/head32.c
> +++ linux-2.6/arch/x86/kernel/head32.c
> @@ -22,7 +22,6 @@ static void __init i386_default_early_se
>  {
>  	/* Initilize 32bit specific setup functions */
>  	x86_init.resources.probe_roms = probe_roms;
> -	x86_init.resources.reserve_resources = i386_reserve_resources;
>  	x86_init.mpparse.setup_ioapic_ids = setup_ioapic_ids_from_mpc;
>  
>  	reserve_ebda_region();
> Index: linux-2.6/arch/x86/kernel/setup.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/setup.c
> +++ linux-2.6/arch/x86/kernel/setup.c
> @@ -693,7 +693,7 @@ static void __init trim_bios_range(void)
>  	 * area (640->1Mb) as ram even though it is not.
>  	 * take them out.
>  	 */
> -	e820_remove_range(BIOS_BEGIN, BIOS_END - BIOS_BEGIN, E820_RAM, 1);
> +	e820_add_region(BIOS_BEGIN, BIOS_END - BIOS_BEGIN, E820_RESERVED);
>  	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
>  }
>  
> @@ -1052,20 +1052,3 @@ void __init setup_arch(char **cmdline_p)
>  
>  	mcheck_init();
>  }
> -
> -#ifdef CONFIG_X86_32
> -
> -static struct resource video_ram_resource = {
> -	.name	= "Video RAM area",
> -	.start	= 0xa0000,
> -	.end	= 0xbffff,
> -	.flags	= IORESOURCE_BUSY | IORESOURCE_MEM
> -};
> -
> -void __init i386_reserve_resources(void)
> -{
> -	request_resource(&iomem_resource, &video_ram_resource);
> -	reserve_standard_io_resources();
> -}
> -
> -#endif /* CONFIG_X86_32 */

