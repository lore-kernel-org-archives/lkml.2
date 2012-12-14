Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889Ab2LNKxc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 05:53:32 -0500
Received: from mail.skyhub.de ([78.46.96.112]:37428 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754138Ab2LNKxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 05:53:30 -0500
Date: Fri, 14 Dec 2012 11:53:27 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 01/27] x86, mm: Fix page table early allocation offset
 checking
Message-ID: <20121214105327.GA4966@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Yinghai Lu <yinghai@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
 <1355436141-8668-2-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1355436141-8668-2-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 02:01:55PM -0800, Yinghai Lu wrote:
> During debug load kernel above 4G, found one page if is not used in BRK
> and it should be with early page allocation.

What does that mean?

I see that this patch adds a change to not use the page at pgt_buf_top
anymore but why? Is pgt_buf_top the first invalid address we cannot
reserve anymore?

Generally, can we get this whole deal described in a bit more detail for
the mere mortals among us, maybe a short ascii art thing showing what
all those pgt_buf_{start,end,top} mean.

> Fix that checking and also add print out for every allocation from BRK
> page table allocation.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/mm/init.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index 6f85de8..c4293cf 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -47,7 +47,7 @@ __ref void *alloc_low_pages(unsigned int num)
>  						__GFP_ZERO, order);
>  	}
>  
> -	if ((pgt_buf_end + num) >= pgt_buf_top) {
> +	if ((pgt_buf_end + num) > pgt_buf_top) {
>  		unsigned long ret;
>  		if (min_pfn_mapped >= max_pfn_mapped)
>  			panic("alloc_low_page: ran out of memory");
> @@ -61,6 +61,8 @@ __ref void *alloc_low_pages(unsigned int num)
>  	} else {
>  		pfn = pgt_buf_end;
>  		pgt_buf_end += num;
> +		printk(KERN_DEBUG "BRK [%#010lx, %#010lx] PGTABLE\n",

		pr_debug

> +			pfn << PAGE_SHIFT, (pgt_buf_end << PAGE_SHIFT) - 1);
>  	}
>  
>  	for (i = 0; i < num; i++) {
> -- 
> 1.7.10.4

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
