Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab2F0Fx0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 01:53:26 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:64338 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab2F0FxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 01:53:25 -0400
X-AuditID: 9c930197-b7b43ae00000668c-f1-4fea9fd35d7b
Message-ID: <4FEA9FDD.6030102@kernel.org>
Date: Wed, 27 Jun 2012 14:53:33 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>, Alex Shi <alex.shi@intel.com>
Subject: Re: [PATCH 3/3] x86: add local_tlb_flush_kernel_range()
References: <1340640878-27536-1-git-send-email-sjenning@linux.vnet.ibm.com> <1340640878-27536-4-git-send-email-sjenning@linux.vnet.ibm.com>
In-Reply-To: <1340640878-27536-4-git-send-email-sjenning@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2012 01:14 AM, Seth Jennings wrote:

> This patch adds support for a local_tlb_flush_kernel_range()
> function for the x86 arch.  This function allows for CPU-local
> TLB flushing, potentially using invlpg for single entry flushing,
> using an arch independent function name.
> 
> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>


Anyway, we don't matter INVLPG_BREAK_EVEN_PAGES's optimization point is 8 or something.
We do care only it works without big problem.
I believe after Alex's patch is settle down, we can fix it if it's wrong.
But it shouldn't prevent merging this patch.

Acked-by: Minchan Kim <minchan@kernel.org>

Nitpick: I expect you change __HAVE_LOCAL_XXX to __HAVE_ARCH_LOCAL_XXX in next spin. :)


> ---
>  arch/x86/include/asm/tlbflush.h |   21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
> index 36a1a2a..92a280b 100644
> --- a/arch/x86/include/asm/tlbflush.h
> +++ b/arch/x86/include/asm/tlbflush.h
> @@ -168,4 +168,25 @@ static inline void flush_tlb_kernel_range(unsigned long start,
>  	flush_tlb_all();
>  }
>  
> +#define __HAVE_LOCAL_FLUSH_TLB_KERNEL_RANGE
> +/*
> + * INVLPG_BREAK_EVEN_PAGES is the number of pages after which single tlb
> + * flushing becomes more costly than just doing a complete tlb flush.
> + * While this break even point varies among x86 hardware, tests have shown
> + * that 8 is a good generic value.
> +*/
> +#define INVLPG_BREAK_EVEN_PAGES 8
> +static inline void local_flush_tlb_kernel_range(unsigned long start,
> +		unsigned long end)
> +{
> +	if (cpu_has_invlpg &&
> +		(end - start)/PAGE_SIZE <= INVLPG_BREAK_EVEN_PAGES) {
> +		while (start < end) {
> +			__flush_tlb_single(start);
> +			start += PAGE_SIZE;
> +		}
> +	} else
> +		local_flush_tlb();
> +}
> +
>  #endif /* _ASM_X86_TLBFLUSH_H */



-- 
Kind regards,
Minchan Kim
