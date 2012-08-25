Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282Ab2HYBZl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 21:25:41 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:38563 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755775Ab2HYBZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 21:25:39 -0400
MIME-Version: 1.0
In-Reply-To: <1345852516-3125-2-git-send-email-jacob.shin@amd.com>
References: <1345852516-3125-1-git-send-email-jacob.shin@amd.com>
	<1345852516-3125-2-git-send-email-jacob.shin@amd.com>
Date: Fri, 24 Aug 2012 18:25:38 -0700
X-Google-Sender-Auth: 7QHMTH19sYP6Sj_GhZlCSW8wdZM
Message-ID: <CAE9FiQVugSnpVjbYLScXUNfXqmUBD54FkAuvm7TWThGYrSVLMA@mail.gmail.com>
Subject: Re: [PATCH 1/5] x86: Move enabling of PSE and PGE out of init_memory_mapping
From: Yinghai Lu <yinghai@kernel.org>
To: Jacob Shin <jacob.shin@amd.com>
Cc: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        Dave Young <dyoung@redhat.com>, Chao Wang <chaowang@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 4:55 PM, Jacob Shin <jacob.shin@amd.com> wrote:
> Depending on the platform, init_memory_mapping() may be called multiple
> times. Move it out to setup_arch() to avoid writing to cr4 on every call.
>
> Signed-off-by: Jacob Shin <jacob.shin@amd.com>
> ---
>  arch/x86/kernel/setup.c |   10 ++++++++++
>  arch/x86/mm/init.c      |   10 ----------
>  2 files changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index f4b9b80..751e020 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -913,6 +913,16 @@ void __init setup_arch(char **cmdline_p)
>
>         init_gbpages();
>
> +       /* Enable PSE if available */
> +       if (cpu_has_pse)
> +               set_in_cr4(X86_CR4_PSE);
> +
> +       /* Enable PGE if available */
> +       if (cpu_has_pge) {
> +               set_in_cr4(X86_CR4_PGE);
> +               __supported_pte_mask |= _PAGE_GLOBAL;
> +       }
> +

please don't put it directly in setup_arch().

and another function.

Thanks

Yinghai

>         /* max_pfn_mapped is updated here */
>         max_low_pfn_mapped = init_memory_mapping(0, max_low_pfn<<PAGE_SHIFT);
>         max_pfn_mapped = max_low_pfn_mapped;
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index e0e6990..2f07e09 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -149,16 +149,6 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
>         use_gbpages = direct_gbpages;
>  #endif
>
> -       /* Enable PSE if available */
> -       if (cpu_has_pse)
> -               set_in_cr4(X86_CR4_PSE);
> -
> -       /* Enable PGE if available */
> -       if (cpu_has_pge) {
> -               set_in_cr4(X86_CR4_PGE);
> -               __supported_pte_mask |= _PAGE_GLOBAL;
> -       }
> -
>         if (use_gbpages)
>                 page_size_mask |= 1 << PG_LEVEL_1G;
>         if (use_pse)
> --
> 1.7.9.5
>
>
