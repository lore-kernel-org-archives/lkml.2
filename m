Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965027Ab2CNW7B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 18:59:01 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46650 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756442Ab2CNW64 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 18:58:56 -0400
MIME-Version: 1.0
In-Reply-To: <tip-kq6a00qe33h7c7ais2xsywnh@git.kernel.org>
References: <tip-kq6a00qe33h7c7ais2xsywnh@git.kernel.org>
Date: Wed, 14 Mar 2012 15:58:55 -0700
X-Google-Sender-Auth: 7oWJxsuMvrEI4cBRPdirJ-XHC2M
Message-ID: <CAE9FiQUrFfUN4Zar6b3tbuhcWEdQfA1t5diozd_19tRJd7coGQ@mail.gmail.com>
Subject: Re: [tip:x86/mm] x86/mm: Fix the size calculation of mapping tables
From: Yinghai Lu <yinghai@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, xiyou.wangcong@gmail.com,
        akpm@linux-foundation.org, tj@kernel.org, tglx@linutronix.de,
        ianfang.cn@gmail.com, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 6, 2012 at 8:16 AM, tip-bot for WANG Cong
<xiyou.wangcong@gmail.com> wrote:
> Commit-ID:  722bc6b16771ed80871e1fd81c86d3627dda2ac8
> Gitweb:     http://git.kernel.org/tip/722bc6b16771ed80871e1fd81c86d3627dda2ac8
> Author:     WANG Cong <xiyou.wangcong@gmail.com>
> AuthorDate: Mon, 5 Mar 2012 15:05:13 -0800
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Tue, 6 Mar 2012 09:38:26 +0100
>
> x86/mm: Fix the size calculation of mapping tables
>
> For machines that enable PSE, the first 2/4M memory region still uses
> 4K pages, so needs more PTEs in this case, but
> find_early_table_space() doesn't count this.
>
> This patch fixes it.
>
> The bug was found via code review, no misbehavior of the kernel
> was observed.
>
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: <ianfang.cn@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Link: http://lkml.kernel.org/n/tip-kq6a00qe33h7c7ais2xsywnh@git.kernel.org
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/mm/init.c |   21 ++++++++++++---------
>  1 files changed, 12 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index 6cabf65..2e92fdc 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -30,8 +30,14 @@ int direct_gbpages
>  #endif
>  ;
>
> -static void __init find_early_table_space(unsigned long end, int use_pse,
> -                                         int use_gbpages)
> +struct map_range {
> +       unsigned long start;
> +       unsigned long end;
> +       unsigned page_size_mask;
> +};
> +
> +static void __init find_early_table_space(struct map_range *mr, unsigned long end,
> +                                         int use_pse, int use_gbpages)
>  {
>        unsigned long puds, pmds, ptes, tables, start = 0, good_end = end;
>        phys_addr_t base;
> @@ -56,6 +62,9 @@ static void __init find_early_table_space(unsigned long end, int use_pse,
>  #ifdef CONFIG_X86_32
>                extra += PMD_SIZE;
>  #endif
> +               /* The first 2/4M doesn't use large pages. */
> +               extra += mr->end - mr->start;
> +

Something wrong here, you need to check if this MR is really cover
first 2/4M ...
something like
Index: linux-2.6/arch/x86/mm/init.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init.c
+++ linux-2.6/arch/x86/mm/init.c
@@ -63,7 +63,8 @@ static void __init find_early_table_spac
 		extra += PMD_SIZE;
 #endif
 		/* The first 2/4M doesn't use large pages. */
-		extra += mr->end - mr->start;
+		if (mr->start < PMD_SIZE)
+			extra += mr->end - mr->start;

 		ptes = (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	} else

otherwise, for system with 512G or more. page table for [4G, 512g) may
have preallocate more
but only use little.

Yinghai
