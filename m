Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab1HAXde (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:33:34 -0400
Received: from smtp-out.google.com ([74.125.121.67]:41517 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080Ab1HAXdW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:33:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=LoGxXMo8wFMtHGgSOSuTEpdyRQBf61r4ArHMUkZ0qdNsDHvQ8Iy2rcC1Rp7S2gOcD
	bxi07uLeUl7z9qnSIJGKw==
MIME-Version: 1.0
In-Reply-To: <20110801094611.AAF738A95F@mx2.suse.de>
References: <20110801094611.AAF738A95F@mx2.suse.de>
Date: Mon, 1 Aug 2011 16:33:18 -0700
Message-ID: <CABeCy1Y6ZO3igfRhdDQTSS0i2w9k2WTtJYwWUxuRT56UG9Zd8Q@mail.gmail.com>
Subject: Re: [PATCH resend] x86, PAT: honor CONFIG_STRICT_DEVMEM if pat is disabled
From: Venki Pallipadi <venki@google.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 2:01 AM, Michal Hocko <mhocko@suse.cz> wrote:
>
> since 0124cecf (x86, PAT: disable /dev/mem mmap RAM with PAT) we are
> disabling access to the system RAM as if STRICT_DEVMEM was enabled by
> default. If we, however, disable pat by nopat kernel parameter we can
> access that memory without considering CONFIG_STRICT_DEVMEM.

Looking at the code, I don't think this problem exists. Code in pat.c
disables /dev/mem mmap only when !CONFIG_STRICT_DEVMEM.

When CONFIG_STRICT_DEVMEM, irrespective of pat or nopat, code in mem.c
disables mmap access. The code in pat.c has no effect on whether mmap
is allowed or not.

When !CONFIG_STRICT_DEVMEM, mmap is disabled with pat. And on nopat
mmap is allowed with the check in pat.c:range_is_allowed() with the
change from commit 9e41bff2.

Thanks,
Venki

>
> Let's make the code to honor STRICT_DEVMEM while we still preserve
> disabled by default behavior. This means that the access to the system
> memory is granted only if nopat is provided and STRICT_DEVMEM is
> disabled.
>
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> ---
>  arch/x86/mm/pat.c |   10 ++--------
>  1 files changed, 2 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
> index f6ff57b..fbaf3fc 100644
> --- a/arch/x86/mm/pat.c
> +++ b/arch/x86/mm/pat.c
> @@ -472,13 +472,6 @@ pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
>        return vma_prot;
>  }
>
> -#ifdef CONFIG_STRICT_DEVMEM
> -/* This check is done in drivers/char/mem.c in case of STRICT_DEVMEM*/
> -static inline int range_is_allowed(unsigned long pfn, unsigned long size)
> -{
> -       return 1;
> -}
> -#else
>  /* This check is needed to avoid cache aliasing when PAT is enabled */
>  static inline int range_is_allowed(unsigned long pfn, unsigned long size)
>  {
> @@ -486,8 +479,10 @@ static inline int range_is_allowed(unsigned long pfn, unsigned long size)
>        u64 to = from + size;
>        u64 cursor = from;
>
> +#ifndef CONFIG_STRICT_DEVMEM
>        if (!pat_enabled)
>                return 1;
> +#endif
>
>        while (cursor < to) {
>                if (!devmem_is_allowed(pfn)) {
> @@ -501,7 +496,6 @@ static inline int range_is_allowed(unsigned long pfn, unsigned long size)
>        }
>        return 1;
>  }
> -#endif /* CONFIG_STRICT_DEVMEM */
>
>  int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
>                                unsigned long size, pgprot_t *vma_prot)
> --
> 1.7.5.4
>
