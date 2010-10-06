Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933290Ab0JFW67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 18:58:59 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:27851 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932904Ab0JFW66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 18:58:58 -0400
Message-ID: <4CACFECD.3090304@kernel.org>
Date: Wed, 06 Oct 2010 15:57:17 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 0/4] memblock related fixes for -tip
References: <4CAA4DC1.6000104@kernel.org> <4CACFDAD.3090900@goop.org>
In-Reply-To: <4CACFDAD.3090900@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2010 03:52 PM, Jeremy Fitzhardinge wrote:
>  On 10/04/2010 02:57 PM, Yinghai Lu wrote:
>> Please check memblock related patches
>>
>> [PATCH 1/4] memblock: Fix big size with find_region()
>> [PATCH -v5 2/4] x86, memblock: Fix crashkernel allocation
>> [PATCH 3/4] x86, memblock: Remove __memblock_x86_find_in_range_size()
>> [PATCH 4/4] x86, mm, memblock, 32bit: Make add_highpages honor early reserved ranges
>>
>> first one should get into core/memblock branch, and others should be in x86/mm/memeblock branch
> 
> I also need this to avoid an early crash under Xen.  The Xen init code
> ends up calling memblock_x86_reserve_range() before
> x86_64_start_reservations().
> 
> Also in git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git
> memblock
> 
>     J
> 
> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Date: Tue, 21 Sep 2010 17:05:35 -0700
> Subject: [PATCH] memblock: allow memblock_init to be called early
> 
> The Xen setup code needs to call memblock_x86_reserve_range() very early,
> so allow it to initialize the memblock subsystem before doing so.  The
> second memblock_init() is ignored.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index 7d46c84..63b83ce 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -30,6 +30,7 @@
>  #include <linux/console.h>
>  #include <linux/pci.h>
>  #include <linux/gfp.h>
> +#include <linux/memblock.h>
>  
>  #include <xen/xen.h>
>  #include <xen/interface/xen.h>
> @@ -1183,6 +1184,8 @@ asmlinkage void __init xen_start_kernel(void)
>  	local_irq_disable();
>  	early_boot_irqs_off();
>  
> +	memblock_init();
> +
>  	xen_raw_console_write("mapping kernel into physical memory\n");
>  	pgd = xen_setup_kernel_pagetable(pgd, xen_start_info->nr_pages);
>  
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 9ad3969..ae8b06c 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -752,6 +752,12 @@ void __init memblock_analyze(void)
>  
>  void __init memblock_init(void)
>  {
> +	static int init_done __initdata = 0;
> +
> +	if (init_done)
> +		return;
> +	init_done = 1;
> +

How about
+	if (memblock.memory.regions)
+		return;	

>  	/* Hookup the initial arrays */
>  	memblock.memory.regions	= memblock_memory_init_regions;
>  	memblock.memory.max		= INIT_MEMBLOCK_REGIONS;
> 

