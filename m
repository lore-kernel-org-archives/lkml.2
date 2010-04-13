Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397Ab0DMEWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 00:22:41 -0400
Received: from gate.crashing.org ([63.228.1.57]:47931 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733Ab0DMEWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 00:22:39 -0400
Subject: Re: [PATCH 18/39] lmb: Add lmb_reserve_area_overlap_ok()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
In-Reply-To: <1270793048-23796-19-git-send-email-yinghai@kernel.org>
References: <1270793048-23796-1-git-send-email-yinghai@kernel.org>
	 <1270793048-23796-19-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Apr 2010 14:21:16 +1000
Message-ID: <1271132476.13059.66.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-08 at 23:03 -0700, Yinghai Lu wrote:
> Some areas from firmware could be reserved several times from different callers.
> 
> If these area are overlapped, We may have overlapped entries in lmb.reserved.
> 
> Try to free the area at first, before rerserve them again.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---

> +
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
> +	__lmb_reserve_area(start, end, name);
>  }

That is going to only work with one overlap. IE. lmb_free() will not do
very well unless it's a one and only match.

You should modify it to work in a loop.

Besides, lmb_reserve_area_overlap_ok() sucks as a name :-)

Cheers,
Ben.




