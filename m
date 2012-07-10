Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab2GJPYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 11:24:43 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33784 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857Ab2GJPYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 11:24:42 -0400
MIME-Version: 1.0
In-Reply-To: <20120710104722.GB14154@suse.de>
References: <1341588521-17744-1-git-send-email-js1304@gmail.com>
	<alpine.DEB.2.00.1207070139510.10445@chino.kir.corp.google.com>
	<CAAmzW4PXdpQ2zSnkx8sSScAt1OY0j4+HXVmf=COvP7eMLqrEvQ@mail.gmail.com>
	<20120710104722.GB14154@suse.de>
Date: Wed, 11 Jul 2012 00:24:41 +0900
Message-ID: <CAAmzW4NhRipDDqyNc3zYTx3fpsOVE6Cc6kc9X-L_p0iKZu7+jA@mail.gmail.com>
Subject: Re: [PATCH] mm: don't invoke __alloc_pages_direct_compact when order 0
From: JoonSoo Kim <js1304@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/7/10 Mel Gorman <mgorman@suse.de>:
> You say that invoking the function is very costly. I agree that a function
> call with that many parameters is hefty but it is also in the slow path of
> the allocator. For order-0 allocations we are about to enter direct reclaim
> where I would expect the cost far exceeds the cost of a function call.

Yes, I agree.

> If the cost is indeed high and you have seen this in profiles then I
> suggest you create a forced inline function alloc_pages_direct_compact
> that does this;
>
> if (order != 0)
>         __alloc_pages_direct_compact(...)
>
> and then call alloc_pages_direct_compact instead of
> __alloc_pages_direct_compact. After that, recheck the profiles (although I
> expect the difference to be marginal) and the size of vmlinux (if it gets
> bigger, it's probably not worth it).
> That would be functionally similar to your patch but it will preserve git
> blame, churn less code and be harder to make mistakes with in the unlikely
> event a third call to alloc_pages_direct_compact is ever added.

Your suggestion looks good.
But, the size of page_alloc.o is more than before.

I test 3 approaches, vanilla, always_inline and
wrapping(alloc_page_direct_compact which is your suggestion).
In my environment (v3.5-rc5, gcc 4.6.3, x86_64), page_alloc.o shows
below number.

                                         total, .text section, .text.unlikely
page_alloc_vanilla.o:     93432,   0x510a,        0x243
page_alloc_inline.o:       93336,   0x52ca,          0xa4
page_alloc_wrapping.o: 93528,   0x515a,        0x238

Andrew said that inlining add only 26 bytes to .text of page_alloc.o,
but in my system, need more bytes.
Currently, I think this patch doesn't have obvious benefit, so I want
to drop it.
Any objections?

Thanks for good comments.
