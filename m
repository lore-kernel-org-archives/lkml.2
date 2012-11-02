Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399Ab2KBPKp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 11:10:45 -0400
Received: from mail1.windriver.com ([147.11.146.13]:34554 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483Ab2KBPKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 11:10:44 -0400
Date: Fri, 2 Nov 2012 11:08:59 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: "Zhang, Jun" <jun.zhang@intel.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] To crash dump, we need keep other memory type except
 E820_RAM, because other type come from BIOS or firmware is used by other
 code(for example: PCI_MMCONFIG).
Message-ID: <20121102150859.GG25658@windriver.com>
References: <88DC34334CA3444C85D647DBFA962C270FD7EAD3@SHSMSX102.ccr.corp.intel.com>
 <50909120.3040101@zytor.com>
 <88DC34334CA3444C85D647DBFA962C270FD7EB0B@SHSMSX102.ccr.corp.intel.com>
 <5090AB3C.5050405@zytor.com>
 <88DC34334CA3444C85D647DBFA962C270FD7EB3A@SHSMSX102.ccr.corp.intel.com>
 <5090B966.4040605@zytor.com>
 <88DC34334CA3444C85D647DBFA962C270FD7EF68@SHSMSX102.ccr.corp.intel.com>
 <c6a025f9-0ac5-45d7-bda9-7f9bc8eaf9ab@email.android.com>
 <88DC34334CA3444C85D647DBFA962C270FD7F039@SHSMSX102.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <88DC34334CA3444C85D647DBFA962C270FD7F039@SHSMSX102.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[RE: [PATCH] To crash dump, we need keep other memory type except E820_RAM, because other type come from BIOS or firmware is used by other code(for example: PCI_MMCONFIG).] On 01/11/2012 (Thu 08:49) Zhang, Jun wrote:

> Hello, Anvin
> 
> Thank for your advice.
> 
> Hello, All
> 
> the next patch is made by 2), please review it. Thanks!
> 
> Subject: [PATCH] When we are doing a crash dump, we still need non-E820_RAM
>  memory information in order to do I/O. So only remove all
>  RAM ranges which need to be dumped.

It is typical to do a "short log" in the subject, and then a "long log"
in what would be the following paragraph, i.e.

 ---------
 Subject: crash dump: don't delete non-E820_RAM during init

 Currently we delete the non-E820_RAM, which causes <describe the end
 user symptoms here -- i.e. how things visibly break>

 This happens because <describe the underlying technical reason
 that causes the problem>

 We can fix this by doing <describe the non-obvious aspects of your
 change and why it is the right way to fix the problem>
 ---------

This "rule of three" is a good way to write commit logs. Just remember
(1)symptoms, (2)underlying problem, (3)how best to fix it.

Also, ...

> 
> Signed-off-by: jzha144 <jun.zhang@intel.com>
> ---
>  arch/x86/kernel/e820.c  |    8 --------
>  arch/x86/kernel/setup.c |   22 ++++++++++++++++++++++
>  2 files changed, 22 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> index df06ade..0bc1687 100644
> --- a/arch/x86/kernel/e820.c
> +++ b/arch/x86/kernel/e820.c
> @@ -844,14 +844,6 @@ static int __init parse_memmap_opt(char *p)
>  		return -EINVAL;
>  
>  	if (!strncmp(p, "exactmap", 8)) {
> -#ifdef CONFIG_CRASH_DUMP
> -		/*
> -		 * If we are doing a crash dump, we still need to know
> -		 * the real mem size before original memory map is
> -		 * reset.
> -		 */
> -		saved_max_pfn = e820_end_of_ram_pfn();
> -#endif
>  		e820.nr_map = 0;
>  		userdef = 1;
>  		return 0;
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index ca45696..5eb178b 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -480,6 +480,25 @@ static void __init e820_reserve_setup_data(void)
>  	e820_print_map("reserve setup_data");
>  }
>  
> +#ifdef CONFIG_CRASH_DUMP
> +static void __init e820_crashdump_remove_ram(void)
> +{

... if you move this ifdef/endif within the { } of the function, then
we'll have one less ugly ifdef set below at the call site.

I'll leave the real technical review for Peter, who understands this
area better than I ever will.

Thanks,
Paul.
--

> +	/*
> +	 * We are doing a crash dump, so remove all RAM ranges
> +	 * as they are the ones that need to be dumped.
> +	 * We still need all non-RAM information in order to do I/O.
> +	 */
> +	/* NOTE: if you use old kexec, please remove memmap=exactmap
> +	 * which remove all ranges, not only RAM ranges.
> +	 */
> +	saved_max_pfn = e820_end_of_ram_pfn();
> +	e820_remove_range(0, ULLONG_MAX, E820_RAM, 1);
> +	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
> +	printk(KERN_INFO "crash dump non-RAM map:\n");
> +	e820_print_map("crash_dump");
> +}
> +#endif
> +
>  static void __init memblock_x86_reserve_range_setup_data(void)
>  {
>  	struct setup_data *data;
> @@ -751,6 +770,9 @@ void __init setup_arch(char **cmdline_p)
>  	parse_setup_data();
>  	/* update the e820_saved too */
>  	e820_reserve_setup_data();
> +#ifdef CONFIG_CRASH_DUMP
> +	e820_crashdump_remove_ram();
> +#endif
>  
>  	copy_edd();
>  
> -- 
> 1.7.6
> 
> Best Regards!
> 
> Jun Zhang
> Inet: 8821-4273
> Dir.Tel: 86-21-6116-4273
> Email: jun.zhang@intel.com
> 
> 
> -----Original Message-----
> From: H. Peter Anvin [mailto:hpa@zytor.com] 
> Sent: Thursday, November 01, 2012 12:20 PM
> To: Zhang, Jun
> Cc: Thomas Gleixner; Ingo Molnar; x86@kernel.org; Andrew Morton; Fleming, Matt; Paul Gortmaker; linux-kernel@vger.kernel.org
> Subject: RE: [PATCH] To crash dump, we need keep other memory type except E820_RAM, because other type come from BIOS or firmware is used by other code(for example: PCI_MMCONFIG).
> 
> 2) would make most sense to me, but I'd be okay with 3) as well.
> 
> "Zhang, Jun" <jun.zhang@intel.com> wrote:
> 
> >Hello, Anvin
> >
> >I want to explain why I modify in this place. In kexec, it pass three 
> >parameters, memmap=exactmap memmap=544K@64K memmap=64964K@32768K I 
> >think my patch modify the least code.
> >Actually, there are some choise to fix it. 
> >1)  my patch.
> >2)  modify kexec, only pass two parameters -- memmap=544K@64K 
> >memmap=64964K@32768K, in kernel setup_memory_map, we can remove RAM 
> >range.
> >3)  add extra optional, like memmap=REMOVERAM
> >
> >Which one do you like? Maybe you have better solution, please share it.
> >Thanks!
> >
> >Best Regards!
> >
> >Jun Zhang
> >Inet: 8821-4273
> >Dir.Tel: 86-21-6116-4273
> >Email: jun.zhang@intel.com
> >
> >-----Original Message-----
> >From: H. Peter Anvin [mailto:hpa@zytor.com]
> >Sent: Wednesday, October 31, 2012 1:39 PM
> >To: Zhang, Jun
> >Cc: Thomas Gleixner; Ingo Molnar; x86@kernel.org; Andrew Morton; 
> >Fleming, Matt; Paul Gortmaker; linux-kernel@vger.kernel.org
> >Subject: Re: [PATCH] To crash dump, we need keep other memory type 
> >except E820_RAM, because other type come from BIOS or firmware is used 
> >by other code(for example: PCI_MMCONFIG).
> >
> >On 10/30/2012 10:22 PM, Zhang, Jun wrote:
> >> Hello, Anvin
> >>    You are right. Thanks!
> >>
> >> Hello, All
> >>    Please review it again. Thanks!
> >>
> >>  From bf7506ac7e9ce0df0b915164dbb7a6d858ef2e40 Mon Sep 17 00:00:00
> >> 2001
> >> From: jzha144 <jun.zhang@intel.com>
> >> Date: Wed, 31 Oct 2012 08:51:18 +0800
> >> Subject: [PATCH] When we are doing a crash dump, we still need
> >non-E820_RAM
> >>   memory type address information in order to do I/O. so only
> >>   remove all RAM ranges which need to be dumped.
> >>
> >> Signed-off-by: jzha144 <jun.zhang@intel.com>
> >> ---
> >>   arch/x86/kernel/e820.c |    9 +++++++++
> >>   1 files changed, 9 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c index
> >> df06ade..77be839 100644
> >> --- a/arch/x86/kernel/e820.c
> >> +++ b/arch/x86/kernel/e820.c
> >> @@ -851,6 +851,15 @@ static int __init parse_memmap_opt(char *p)
> >>   		 * reset.
> >>   		 */
> >>   		saved_max_pfn = e820_end_of_ram_pfn();
> >> +
> >> +		/*
> >> +		 * We are doing a crash dump, so remove all RAM ranges
> >> +		 * as they are the ones that need to be dumped.
> >> +		 * We still need all non-RAM information in order to do I/O.
> >> +		 */
> >> +		e820_remove_range(0, ULLONG_MAX, E820_RAM, 1);
> >> +		userdef = 1;
> >> +		return 0;
> >>   #endif
> >>   		e820.nr_map = 0;
> >>   		userdef = 1;
> >>
> >
> >The code is still wrong...
> >
> >	-hpa
> >
> >
> >--
> >H. Peter Anvin, Intel Open Source Technology Center I work for Intel. 
> >I don't speak on their behalf.
> 
> --
> Sent from my mobile phone. Please excuse brevity and lack of formatting.
