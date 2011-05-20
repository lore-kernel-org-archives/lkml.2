Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935077Ab1ETIhG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 04:37:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39071 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934634Ab1ETIhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 04:37:02 -0400
Date: Fri, 20 May 2011 10:36:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Stable <stable@kernel.org>
Subject: Re: [PATCH] rcu: Fix unpaired rcu_irq_enter() from locking selftests
Message-ID: <20110520083648.GC22802@elte.hu>
References: <4DD58F90.4090506@kernel.org>
 <1305850194-8229-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305850194-8229-1-git-send-email-fweisbec@gmail.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> HARDIRQ_ENTER() maps to irq_enter() which calls rcu_irq_enter().
> But HARDIRQ_EXIT() maps to __irq_exit() which doesn't call
> rcu_irq_exit().
> 
> So for every locking selftest that simulates hardirq disabled,
> we create an imbalance in the rcu extended quiescent state
> internal state.
> 
> As a result, after the first missing rcu_irq_exit(), subsequent
> irqs won't exit any extended quiescent state the time of the
> interrupt servicing. Rcu read side critical section inside irqs
> on that CPU won't be guaranteed anymore.
> 
> To fix this, just use __irq_enter() to simulate the hardirq
> context. This is sufficient for the locking selftests as we
> don't need to exit any extended quiescent state or perform
> any check that irqs normally do when they wake up from idle.
> 
> As a side effect, this patch should make it possible to
> restore
> "rcu: Decrease memory-barrier usage based on semi-formal proof",
> which eventually helped finding this bug.
> 
> Reported-and-tested-by: Yinghai Lu <yinghai@kernel.org>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Stable <stable@kernel.org>
> ---
>  lib/locking-selftest.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/lib/locking-selftest.c b/lib/locking-selftest.c
> index 619313e..507a22f 100644
> --- a/lib/locking-selftest.c
> +++ b/lib/locking-selftest.c
> @@ -144,7 +144,7 @@ static void init_shared_classes(void)
>  
>  #define HARDIRQ_ENTER()				\
>  	local_irq_disable();			\
> -	irq_enter();				\
> +	__irq_enter();				\
>  	WARN_ON(!in_irq());
>  
>  #define HARDIRQ_EXIT()				\

Very nice!

Note that a cherry-picked version of the manual revert from Paul is upstream 
now with the main body of RCU changes, so we can do the finegrained split-up 
queue approach for this one problematic commit (that is no longer problematic).

I think it can still go in for v2.6.40. Paul, what do you think?

Thanks,

	Ingo
