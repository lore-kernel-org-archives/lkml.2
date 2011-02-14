Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab1BNQ1X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 11:27:23 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:47775 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755940Ab1BNQ1U (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 14 Feb 2011 11:27:20 -0500
Date: Mon, 14 Feb 2011 11:26:02 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>, Jan Beulich <JBeulich@novell.com>
Subject: Re: [PATCH] x86/mm/init: respect memblock reserved regions when
 destroying mappings
Message-ID: <20110214162602.GB11290@dumpdata.com>
References: <4D50343E.1020906@kernel.org>
 <alpine.DEB.2.00.1102071839060.7277@kaball-desktop>
 <4D504161.2060900@kernel.org>
 <4D506A85.9030802@goop.org>
 <4D50B4B5.4050505@kernel.org>
 <4D519AAA.8070309@zytor.com>
 <4D547962.8040403@goop.org>
 <4D547B74.1030302@kernel.org>
 <4D54844B.4010007@zytor.com>
 <4D5488D5.2020607@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5488D5.2020607@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4D5957B0.00AD:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> BTW: Do we really need to cleanup initial mapping between _brk_end to _end?

Did you try to revert the patch and run it under your setup?
> 
> origin patch from jan:
> 
> commit 498343967613183611ac37dccb2846496d954c06
> Author: Jan Beulich <jbeulich@novell.com>
> Date:   Wed May 6 13:06:47 2009 +0100
> 
>     x86-64: finish cleanup_highmaps()'s job wrt. _brk_end
>     
>     With the introduction of the .brk section, special care must be taken
>     that no unused page table entries remain if _brk_end and _end are
>     separated by a 2M page boundary. cleanup_highmap() runs very early and
>     hence cannot take care of that, hence potential entries needing to be
>     removed past _brk_end must be cleared once the brk allocator has done
>     its job.
>     
>     [ Impact: avoids undesirable TLB aliases ]
>     
>     Signed-off-by: Jan Beulich <jbeulich@novell.com>
>     Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> 
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index fd3da1d..ae4f7b5 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -7,6 +7,7 @@
>  #include <asm/page.h>
>  #include <asm/page_types.h>
>  #include <asm/sections.h>
> +#include <asm/setup.h>
>  #include <asm/system.h>
>  #include <asm/tlbflush.h>
>  
> @@ -304,8 +305,23 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
>  #endif
>  
>  #ifdef CONFIG_X86_64
> -       if (!after_bootmem)
> +       if (!after_bootmem && !start) {
> +               pud_t *pud;
> +               pmd_t *pmd;
> +
>                 mmu_cr4_features = read_cr4();
> +
> +               /*
> +                * _brk_end cannot change anymore, but it and _end may be
> +                * located on different 2M pages. cleanup_highmap(), however,
> +                * can only consider _end when it runs, so destroy any
> +                * mappings beyond _brk_end here.
> +                */
> +               pud = pud_offset(pgd_offset_k(_brk_end), _brk_end);
> +               pmd = pmd_offset(pud, _brk_end - 1);
> +               while (++pmd <= pmd_offset(pud, (unsigned long)_end - 1))
> +                       pmd_clear(pmd);
> +       }
>  #endif
>         __flush_tlb_all();
>  
