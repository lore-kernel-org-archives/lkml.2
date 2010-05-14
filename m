Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344Ab0ENC13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 22:27:29 -0400
Received: from gate.crashing.org ([63.228.1.57]:54651 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753614Ab0ENC12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 22:27:28 -0400
Subject: Re: [PATCH 08/35] x86,lmb: Add lmb_reserve_area/lmb_free_area
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <1273796396-29649-9-git-send-email-yinghai@kernel.org>
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>
	 <1273796396-29649-9-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 May 2010 12:26:04 +1000
Message-ID: <1273803964.21352.380.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 17:19 -0700, Yinghai Lu wrote:

>  #endif
> diff --git a/arch/x86/mm/lmb.c b/arch/x86/mm/lmb.c
> index 37a05e2..0dbe05b 100644
> --- a/arch/x86/mm/lmb.c
> +++ b/arch/x86/mm/lmb.c
> @@ -117,3 +117,30 @@ void __init lmb_to_bootmem(u64 start, u64 end)
>  	lmb.reserved.cnt = 0;
>  }
>  #endif
> +
> +void __init lmb_add_memory(u64 start, u64 end)
> +{
> +	lmb_add_region(&lmb.memory, start, end - start);
> +}

I completely fail the point of doing such a minor argument conversion
as an exported function, with a naming that would cause certain
confusion with the existing lmb_add().

In any case, the above should be done at the call sites. Just call
lmb_add(start, end-start). You also aren't consistent since you do the
similar conversion using the _area suffix below, but not above.

> +void __init lmb_reserve_area(u64 start, u64 end, char *name)
> +{
> +	if (start == end)
> +		return;
> +
> +	if (WARN_ONCE(start > end, "lmb_reserve_area: wrong range [%#llx, %#llx]\n", start, end))
> +		return;
> +
> +	lmb_add_region(&lmb.reserved, start, end - start);
> +}

You seem to be fond of gratuituous bloat... 

> +void __init lmb_free_area(u64 start, u64 end)
> +{
> +	if (start == end)
> +		return;
> +
> +	if (WARN_ONCE(start > end, "lmb_free_area: wrong range [%#llx, %#llx]\n", start, end))
> +		return;
> +
> +	lmb_free(start, end - start);
> +}

And here again.

If you -really- think there's value in the prototype conversions, then
make those _area() variants static inlines, group the well together in
the .h with a clear explanation saying something like "it's more
practical for some arch to use start/end rather than start/size".

I personally don't see why you are doing that tho.

Cheers,
Ben.


