Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089Ab0ENCdo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 22:33:44 -0400
Received: from gate.crashing.org ([63.228.1.57]:35466 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756816Ab0ENCdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 22:33:40 -0400
Subject: Re: [PATCH 15/35] x86, lmb: Add lmb_reserve_area_overlap_ok()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <1273796396-29649-16-git-send-email-yinghai@kernel.org>
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>
	 <1273796396-29649-16-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 May 2010 12:32:17 +1000
Message-ID: <1273804337.21352.396.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 17:19 -0700, Yinghai Lu wrote:
> Some areas from firmware could be reserved several times from different callers.
> 
> If these area are overlapped, We may have overlapped entries in lmb.reserved.
> 
> Try to free the area at first, before rerserve them again.

I have already told you to make this a property of lmb_reserve() instead
of adding that function with a terrible name.

Cheers,
Ben.

> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/include/asm/lmb.h |    1 +
>  arch/x86/mm/lmb.c          |   18 ++++++++++++++++++
>  2 files changed, 19 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/asm/lmb.h b/arch/x86/include/asm/lmb.h
> index dd42ac1..9329e09 100644
> --- a/arch/x86/include/asm/lmb.h
> +++ b/arch/x86/include/asm/lmb.h
> @@ -7,6 +7,7 @@ u64 lmb_find_area_size(u64 start, u64 *sizep, u64 align);
>  void lmb_to_bootmem(u64 start, u64 end);
>  
>  void lmb_reserve_area(u64 start, u64 end, char *name);
> +void lmb_reserve_area_overlap_ok(u64 start, u64 end, char *name);
>  void lmb_free_area(u64 start, u64 end);
>  void lmb_add_memory(u64 start, u64 end);
>  struct range;
> diff --git a/arch/x86/mm/lmb.c b/arch/x86/mm/lmb.c
> index 19a5f49..1100c18 100644
> --- a/arch/x86/mm/lmb.c
> +++ b/arch/x86/mm/lmb.c
> @@ -309,6 +309,24 @@ void __init lmb_reserve_area(u64 start, u64 end, char *name)
>  	lmb_add_region(&lmb.reserved, start, end - start);
>  }
>  
> +/*
> + * Could be used to avoid having overlap entries in lmb.reserved.region.
> + *  Don't need to use it with area that is from lmb_find_area()
> + *  Only use it for the area that fw hidden area.
> + */
> +void __init lmb_reserve_area_overlap_ok(u64 start, u64 end, char *name)
> +{
> +	if (start == end)
> +		return;
> +
> +	if (WARN_ONCE(start > end, "lmb_reserve_area_overlap_ok: wrong range [%#llx, %#llx]\n", start, end))
> +		return;
> +
> +	/* Free that region at first */
> +	lmb_free(start, end - start);
> +	lmb_add_region(&lmb.reserved, start, end - start);
> +}
> +
>  void __init lmb_free_area(u64 start, u64 end)
>  {
>  	if (start == end)


