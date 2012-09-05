Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab2IEICi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 04:02:38 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59538 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab2IEICe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 04:02:34 -0400
MIME-Version: 1.0
In-Reply-To: <1346823991-22911-15-git-send-email-yinghai@kernel.org>
References: <1346823991-22911-1-git-send-email-yinghai@kernel.org>
	<1346823991-22911-15-git-send-email-yinghai@kernel.org>
Date: Wed, 5 Sep 2012 11:02:33 +0300
X-Google-Sender-Auth: 1gYf3kF2ud05dpO79SvvwUmj1A4
Message-ID: <CAOJsxLGXQ9+5uEvq-Pfxt=zZLWR3ZmR1WPeN=pzdzQVjHWrd0g@mail.gmail.com>
Subject: Re: [PATCH -v3 14/14] x86, mm: Map ISA area with connected ram range
 at the same time
From: Pekka Enberg <penberg@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 5, 2012 at 8:46 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> so could reduce one loop.
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

How significant is the speed gain? The "isa_done" flag makes code flow
more difficult to follow.

> ---
>  arch/x86/mm/init.c |   21 ++++++++++++++-------
>  1 files changed, 14 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index 6663f61..e69f832 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -248,20 +248,27 @@ static void __init walk_ram_ranges(
>                         void *data)
>  {
>         unsigned long start_pfn, end_pfn;
> +       bool isa_done = false;
>         int i;
>
> -       /* the ISA range is always mapped regardless of memory holes */
> -       work_fn(0, ISA_END_ADDRESS, data);
> -
>         for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, NULL) {
>                 u64 start = start_pfn << PAGE_SHIFT;
>                 u64 end = end_pfn << PAGE_SHIFT;
>
> -               if (end <= ISA_END_ADDRESS)
> -                       continue;
> +               if (!isa_done && start > ISA_END_ADDRESS) {
> +                       work_fn(0, ISA_END_ADDRESS, data);
> +                       isa_done = true;
> +               } else {
> +                       if (end < ISA_END_ADDRESS)
> +                               continue;
> +
> +                       if (start <= ISA_END_ADDRESS &&
> +                           end >= ISA_END_ADDRESS) {
> +                               start = 0;
> +                               isa_done = true;
> +                       }
> +               }
>
> -               if (start < ISA_END_ADDRESS)
> -                       start = ISA_END_ADDRESS;
>  #ifdef CONFIG_X86_32
>                 /* on 32 bit, we only map up to max_low_pfn */
>                 if ((start >> PAGE_SHIFT) >= max_low_pfn)
> --
> 1.7.7
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
