Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab1BBU5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 15:57:37 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:44053 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab1BBU5g (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 2 Feb 2011 15:57:36 -0500
Date: Wed, 2 Feb 2011 15:55:04 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: hpa@zytor.com, tglx@linutronix.de, x86@kernel.org
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, linux-security-module@vger.kernel.org,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        Kees Cook <kees.cook@canonical.com>,
        matthieu castet <castet.matthieu@free.fr>
Subject: for tip-bugfix? Re: [PATCH] NX protection for kernel data : fix
 xen boot
Message-ID: <20110202205504.GA6936@dumpdata.com>
References: <4D41ED13.5020105@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D41ED13.5020105@free.fr>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D49C4F5.00DE:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 27, 2011 at 11:09:23PM +0100, matthieu castet wrote:
> I think it should be applied before 2.6.38 release, because without
> this patch xen doesn't boot on x86_32 with CONFIG_DEBUG_RODATA.
> 
Hey tglx + hpa,

The title is a bit wrong, the issue here is not with the NX bit
but with setting RW on RO areas in the .bss area.

I was wondering if you guys would be OK picking this up in your
"tip-2.6.38-rc4-bug-fix" branch for Linus? I've done the baremetal tests
on this patch (x86, x86_64) and have not found any regressions with it.


> >From 08f54ec4007ab0df231d81ed436632aa7f605feb Mon Sep 17 00:00:00 2001
> From: Matthieu CASTET <castet.matthieu@free.fr>
> Date: Thu, 20 Jan 2011 21:11:45 +0100
> Subject: [PATCH] NX protection for kernel data : fix xen boot
> 
> Xen want page table pages read only.
> 
> But the initial page table (from head_*.S) live in .data or .bss.
> 
> That was broken by 64edc8ed5ffae999d8d413ba006850e9e34166cb.
> Revert the problematic part as it is only a protection and
> not really needed.
> 
> Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
> Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/mm/pageattr.c |    8 --------
>  1 files changed, 0 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
> index 2ad6c48..951eb4a 100644
> --- a/arch/x86/mm/pageattr.c
> +++ b/arch/x86/mm/pageattr.c
> @@ -256,7 +256,6 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
>  				   unsigned long pfn)
>  {
>  	pgprot_t forbidden = __pgprot(0);
> -	pgprot_t required = __pgprot(0);
>  
>  	/*
>  	 * The BIOS area between 640k and 1Mb needs to be executable for
> @@ -286,12 +285,6 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
>  	if (within(pfn, __pa((unsigned long)__start_rodata) >> PAGE_SHIFT,
>  		   __pa((unsigned long)__end_rodata) >> PAGE_SHIFT))
>  		pgprot_val(forbidden) |= _PAGE_RW;
> -	/*
> -	 * .data and .bss should always be writable.
> -	 */
> -	if (within(address, (unsigned long)_sdata, (unsigned long)_edata) ||
> -	    within(address, (unsigned long)__bss_start, (unsigned long)__bss_stop))
> -		pgprot_val(required) |= _PAGE_RW;
>  
>  #if defined(CONFIG_X86_64) && defined(CONFIG_DEBUG_RODATA)
>  	/*
> @@ -331,7 +324,6 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
>  #endif
>  
>  	prot = __pgprot(pgprot_val(prot) & ~pgprot_val(forbidden));
> -	prot = __pgprot(pgprot_val(prot) | pgprot_val(required));
>  
>  	return prot;
>  }
> -- 
> 1.7.2.3
> 

