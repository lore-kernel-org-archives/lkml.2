Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab0CZXzI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 19:55:08 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:42756 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217Ab0CZXzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 19:55:06 -0400
Date: Sat, 27 Mar 2010 00:54:51 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Ian Campbell <ian.campbell@citrix.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 03/24] x86: Do not free zero sized per cpu areas
Message-ID: <20100326235451.GE29222@cmpxchg.org>
References: <1269642114-16588-1-git-send-email-yinghai@kernel.org> <1269642114-16588-4-git-send-email-yinghai@kernel.org> <20100326234203.GD29222@cmpxchg.org> <4BAD47F6.3000003@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BAD47F6.3000003@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 04:49:10PM -0700, Yinghai Lu wrote:
> On 03/26/2010 04:42 PM, Johannes Weiner wrote:
> > On Fri, Mar 26, 2010 at 03:21:33PM -0700, Yinghai Lu wrote:
> >> From: Ian Campbell <ian.campbell@citrix.com>
> >>
> >> This avoids an infinite loop in free_early_partial().
> >>
> >> Add a warning to free_early_partial to catch future problems.
> >>
> >> -v5: put back start > end back into WARN_ONCE()
> >> -v6: use one line for warning according to linus
> >> -v7: more test by
> >>
> >> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> >> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >> Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> >> Tested-by: Joel Becker <joel.becker@oracle.com>
> >> Tested-by: Stanislaw Gruszka <sgruszka@redhat.com>
> >> Cc: Peter Zijlstra <peterz@infradead.org>
> >> Cc: Ingo Molnar <mingo@elte.hu>
> >> ---
> >>  kernel/early_res.c |    6 ++++++
> >>  1 files changed, 6 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/kernel/early_res.c b/kernel/early_res.c
> >> index 3cb2c66..69bed5b 100644
> >> --- a/kernel/early_res.c
> >> +++ b/kernel/early_res.c
> >> @@ -333,6 +333,12 @@ void __init free_early_partial(u64 start, u64 end)
> >>  	struct early_res *r;
> >>  	int i;
> >>  
> >> +	if (start == end)
> >> +		return;
> >> +
> >> +	if (WARN_ONCE(start > end, "free_early_partial: wrong range [%#llx, %#llx]\n", start, end))
> >> +		return;
> > 
> > I think you can drop the function name, it will be in the stack dump
> > anyway.  And that would get the line back into bounds :)
> > 
> > Other than that,
> > Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> Thanks.
> 
> is there any chance that dump stack only print out address instead of function name ?

I suppose so, lacking frame pointers, but you still have
filename + linenumber + 'wrong range'.
