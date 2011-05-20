Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933468Ab1ETPLt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 11:11:49 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:34308 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933183Ab1ETPLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 11:11:48 -0400
Date: Fri, 20 May 2011 08:11:44 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Stable <stable@kernel.org>
Subject: Re: [PATCH] rcu: Fix unpaired rcu_irq_enter() from locking
 selftests
Message-ID: <20110520151144.GA2366@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4DD58F90.4090506@kernel.org>
 <1305850194-8229-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305850194-8229-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 02:09:54AM +0200, Frederic Weisbecker wrote:
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

You know, I looked at this code, but failed to see __irq_exit() vs
irq_enter()...

Good catch, Frederic, and thanks to Yinghai and Ingo for all the
testing!

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

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
> -- 
> 1.7.3.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
