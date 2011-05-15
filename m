Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab1EOGfY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 02:35:24 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:49504 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753847Ab1EOGfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 02:35:22 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18IAyI+cusIOzD2izkLN7FJEAwP2WMoZwAw8iOkGH
	zmmodCusT69ij9
Subject: Re: [PATCH] sched: avoid overpull when pulling RT task
From: Mike Galbraith <efault@gmx.de>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <BANLkTi=_gfo4bZjkoBsxspLxxWSPy=7J+Q@mail.gmail.com>
References: <BANLkTi=_gfo4bZjkoBsxspLxxWSPy=7J+Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 15 May 2011 08:35:16 +0200
Message-ID: <1305441316.7460.40.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-05-15 at 12:35 +0800, Hillf Danton wrote:
> When pulling RT task for a given runqueue, pulling is continued even
> after certain RT tasks get pulled, in case there are still higher
> priority tasks on other runqueues, though it is low likelihood as the
> comment says. The load of of this runqueue, on other hand, should also
> be concerned. If it is overloaded, the low likelihood should be
> abandoned to avoid overpull.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
>  kernel/sched_rt.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index 14c764b..b425ca1 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -1508,6 +1508,11 @@ static int pull_rt_task(struct rq *this_rq)
>  		}
>  skip:
>  		double_unlock_balance(this_rq, src_rq);
> +
> +		/* if pulled we have to also avoid overpull */
> +		if (ret == 1)
> +			if (likely(rt_overloaded(this_rq)))
> +				break;
>  	}
> 
>  	return ret;

Hm.

It looks to me like you should remove the rt_overloaded() test (and
function) entirely instead.  If you look at pull usage, the intent is
that system wide, higher priority tasks run before lower.

I don't think it matters much if we pull too much, since what we pull
while traversing is ever increasing in priority _and waiting_ anyway.
We may do a bit more work than strictly necessary on the way to the
highest priority runnable task, but what matters most is that highest
priority gets to the CPU first, which testing for overload can stymie.

(seems pulling more than one could turn out either good or bad for any
but the highest priority task though, lacking crystal ball)

	-Mike

