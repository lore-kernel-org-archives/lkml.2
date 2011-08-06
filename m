Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab1HFAW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:22:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39941 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932161Ab1HFAKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:10:24 -0400
Message-ID: <4E3C8664.7050607@zytor.com>
Date: Fri, 05 Aug 2011 17:10:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, borislav.petkov@amd.com
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/cpu] x86, amd: Avoid cache aliasing penalties on AMD
 family 15h
References: <1312550110-24160-2-git-send-email-bp@amd64.org> <tip-dfb09f9b7ab03fd367740e541a5caf830ed56726@git.kernel.org>
In-Reply-To: <tip-dfb09f9b7ab03fd367740e541a5caf830ed56726@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2011 03:58 PM, tip-bot for Borislav Petkov wrote:
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index b13ed39..b0234bc 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -458,6 +458,19 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
>  					"with P0 frequency!\n");
>  		}
>  	}
> +
> +	if (c->x86 == 0x15) {
> +		unsigned long upperbit;
> +		u32 cpuid, assoc;
> +
> +		cpuid	 = cpuid_edx(0x80000005);
> +		assoc	 = cpuid >> 16 & 0xff;
> +		upperbit = ((cpuid >> 24) << 10) / assoc;
> +
> +		va_align.mask	  = (upperbit - 1) & PAGE_MASK;
> +		va_align.flags    = ALIGN_VA_32 | ALIGN_VA_64;
> +
> +	}
>  }
>  
>  static void __cpuinit init_amd(struct cpuinfo_x86 *c)

Breaks all i386 builds:

/home/hpa/kernel/linux-tip.cpu/arch/x86/kernel/cpu/amd.c:437: undefined
reference to `va_align'
/home/hpa/kernel/linux-tip.cpu/arch/x86/kernel/cpu/amd.c:436: undefined
reference to `va_align'

[the line numbers refer to the entire patchset]

	-hpa
