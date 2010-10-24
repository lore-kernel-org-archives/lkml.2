Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434Ab0JXKCx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 06:02:53 -0400
Received: from www.tglx.de ([62.245.132.106]:37871 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932418Ab0JXKCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 06:02:52 -0400
Date: Sun, 24 Oct 2010 12:01:29 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/15] x86: on !find_smp_config path use
 smp_register_lapic_address
In-Reply-To: <1287882149-29275-10-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.LFD.2.00.1010241201080.2466@localhost6.localdomain6>
References: <1287882149-29275-1-git-send-email-yinghai@kernel.org> <1287882149-29275-10-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 23 Oct 2010, Yinghai Lu wrote:

> So fixmap will be setup there.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/kernel/apic/apic.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index a5ce130..3a4e770 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -1527,7 +1527,7 @@ static int __init detect_init_APIC(void)
>  		return -1;
>  	}
>  
> -	mp_lapic_addr = APIC_DEFAULT_PHYS_BASE;
> +	smp_register_lapic_address(APIC_DEFAULT_PHYS_BASE);
>  	return 0;
>  }
>  #else
> @@ -1535,6 +1535,7 @@ static int __init detect_init_APIC(void)
>  static int apic_verify(void)
>  {
>  	u32 features, h, l;
> +	unsigned long lapic_addr;

Swap lines as we do anywhere else.
  
>  	/*
>  	 * The APIC feature bit should now be enabled
> @@ -1546,13 +1547,14 @@ static int apic_verify(void)
>  		return -1;
>  	}
>  	set_cpu_cap(&boot_cpu_data, X86_FEATURE_APIC);
> -	mp_lapic_addr = APIC_DEFAULT_PHYS_BASE;
> +	lapic_addr = APIC_DEFAULT_PHYS_BASE;
>  
>  	/* The BIOS may have set up the APIC at some other address */
>  	rdmsr(MSR_IA32_APICBASE, l, h);
>  	if (l & MSR_IA32_APICBASE_ENABLE)
> -		mp_lapic_addr = l & MSR_IA32_APICBASE_BASE;
> +		lapic_addr = l & MSR_IA32_APICBASE_BASE;
>  
> +	smp_register_lapic_address(lapic_addr);
>  	pr_info("Found and enabled local APIC!\n");
>  	return 0;
>  }
> -- 
> 1.7.1
> 
