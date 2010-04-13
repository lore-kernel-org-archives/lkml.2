Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464Ab0DMEYf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 00:24:35 -0400
Received: from gate.crashing.org ([63.228.1.57]:47953 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727Ab0DMEYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 00:24:33 -0400
Subject: Re: [PATCH 26/39] nobootmem: use lmb.default_alloc_limit in
 alloc_bootmem path
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <1270793048-23796-27-git-send-email-yinghai@kernel.org>
References: <1270793048-23796-1-git-send-email-yinghai@kernel.org>
	 <1270793048-23796-27-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Apr 2010 14:23:09 +1000
Message-ID: <1271132589.13059.67.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-08 at 23:03 -0700, Yinghai Lu wrote:
> Generic version __lmb_find_area() is going from high to low, and for 32bit
> active_region for 32bit does include high pages
> 
> need to replace the limit with lmb.default_alloc_limit, aka get_max_mapped()
> 
> with this patch, x86 32bit could use generic version of __lmb_find_area()

So you unconditionally add access to some lmb specific data structure to
generic code ? That isn't going to work very well on archs that don't
use lmb.

Also, those things should be local to lmb_* anyways.

Cheers,
Ben.

> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  mm/page_alloc.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 79bd44b..256aed0 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3445,6 +3445,9 @@ void * __init __alloc_memory_core_early(int nid, u64 size, u64 align,
>  
>  	u64 addr;
>  
> +	if (limit > lmb.default_alloc_limit)
> +		limit = lmb.default_alloc_limit;
> +
>  	addr = find_memory_core_early(nid, size, align, goal, limit);
>  
>  	if (addr == -1ULL)


