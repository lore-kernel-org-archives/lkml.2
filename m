Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab1EKQVG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:21:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34993 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753569Ab1EKQVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:21:01 -0400
Date: Wed, 11 May 2011 18:20:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephan =?iso-8859-1?Q?B=E4rwolf?= 
	<stephan.baerwolf@tu-ilmenau.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Nikhil Rao <ncrao@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: fix/optimise calculation of weight-inverse
Message-ID: <20110511162030.GA2638@elte.hu>
References: <4DCAB351.4010204@tu-ilmenau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4DCAB351.4010204@tu-ilmenau.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephan Bärwolf <stephan.baerwolf@tu-ilmenau.de> wrote:

> If the inverse loadweight should be zero, function "calc_delta_mine"
> calculates the inverse of "lw->weight" (in 32bit integer ops).
> 
> This calculation is actually a little bit impure (because it is
> inverting something around "lw-weight"+1), especially when
> "lw->weight" becomes smaller. (This could explain some aritmetical
> issues for small shares...)
> 
> The correct inverse would be 1/lw->weight multiplied by
> "WMULT_CONST" for fixcomma-scaling it into integers.
> (So WMULT_CONST/lw->weight ...)
> 
> For safety it is also important to check if division by zero
> could happen...
> 
> The old, impure algorithm took two divisions for inverting lw->weight,
> the new, more exact one only takes one and an additional unlikely-if.
> 
> Signed-off-by: Stephan Baerwolf <stephan.baerwolf@tu-ilmenau.de>
> ---
>  kernel/sched.c |   12 +++++++++---
>  1 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 312f8b9..bb55996 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -1307,15 +1307,21 @@ calc_delta_mine(unsigned long delta_exec,
> unsigned long weight,
>  {
>      u64 tmp;
>  
> +    tmp = (u64)delta_exec * weight;
> +
> +    // actually we would have to trap - division by zero - but we stay
> and pretend the limit of the operation...
> +    if (unlikely(lw->weight == 0)) {
> +        if (unlikely(tmp == ((u64)0))) return (unsigned long)0;
> +        else return (unsigned long)LONG_MAX;

Can lw->weight ever be zero here? I dont think so - and if it is then getting a 
kernel crash there is preferred to hiding it.

Once we do that your patch becomes a lot simpler.

> +    }
> +
>      if (!lw->inv_weight) {
>          if (BITS_PER_LONG > 32 && unlikely(lw->weight >= WMULT_CONST))
>              lw->inv_weight = 1;
>          else
> -            lw->inv_weight = 1 + (WMULT_CONST-lw->weight/2)
> -                / (lw->weight+1);
> +            lw->inv_weight = WMULT_CONST / lw->weight;

hm, i definitely think there was a rounding reason for that - but apparently 
i'm an idiot who does not add comments to non-obvious code! :-)

Peter, do you remember this?

>      }
>  
> -    tmp = (u64)delta_exec * weight;

I agree that moving this multiplication early in the sequence is better for 
micro-performance regardless of the lw->weight optimization you do: it can be 
executed in parallel.

Thanks,

	Ingo
