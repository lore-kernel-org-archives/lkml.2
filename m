Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011Ab2FYXB3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 19:01:29 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53855 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268Ab2FYXB1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 19:01:27 -0400
MIME-Version: 1.0
Reply-To: konrad@darnok.org
In-Reply-To: <1340640878-27536-4-git-send-email-sjenning@linux.vnet.ibm.com>
References: <1340640878-27536-1-git-send-email-sjenning@linux.vnet.ibm.com>
	<1340640878-27536-4-git-send-email-sjenning@linux.vnet.ibm.com>
Date: Mon, 25 Jun 2012 19:01:26 -0400
X-Google-Sender-Auth: _mJ7VtKHSpDtAmFQ7Oa5uUciAeM
Message-ID: <CAPbh3rvkKZOuGh_Pn9WpeV5_=vA=k9=x17oa2GoT8fEgRMr+WQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] x86: add local_tlb_flush_kernel_range()
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 12:14 PM, Seth Jennings
<sjenning@linux.vnet.ibm.com> wrote:
> This patch adds support for a local_tlb_flush_kernel_range()
> function for the x86 arch.  This function allows for CPU-local
> TLB flushing, potentially using invlpg for single entry flushing,
> using an arch independent function name.

What x86 hardware did you use to figure the optimal number?

>
> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> ---
>  arch/x86/include/asm/tlbflush.h |   21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>
> diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
> index 36a1a2a..92a280b 100644
> --- a/arch/x86/include/asm/tlbflush.h
> +++ b/arch/x86/include/asm/tlbflush.h
> @@ -168,4 +168,25 @@ static inline void flush_tlb_kernel_range(unsigned long start,
>        flush_tlb_all();
>  }
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
> +               unsigned long end)
> +{
> +       if (cpu_has_invlpg &&
> +               (end - start)/PAGE_SIZE <= INVLPG_BREAK_EVEN_PAGES) {
> +               while (start < end) {
> +                       __flush_tlb_single(start);
> +                       start += PAGE_SIZE;
> +               }
> +       } else
> +               local_flush_tlb();
> +}
> +
>  #endif /* _ASM_X86_TLBFLUSH_H */
> --
> 1.7.9.5
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>
