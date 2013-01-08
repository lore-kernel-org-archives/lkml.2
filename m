Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063Ab3AHWue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 17:50:34 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:43555 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467Ab3AHWud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 17:50:33 -0500
Subject: Re: [PATCH 2/5] x86,smp: proportional backoff for ticket spinlocks
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, aquini@redhat.com, walken@google.com,
        lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>, knoel@redhat.com,
        chegu_vinod@hp.com, raghavendra.kt@linux.vnet.ibm.com,
        mingo@redhat.com
In-Reply-To: <20130108173241.3e1b1d2d@annuminas.surriel.com>
References: <20130108172632.1126898a@annuminas.surriel.com>
	 <20130108173241.3e1b1d2d@annuminas.surriel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Jan 2013 14:50:30 -0800
Message-ID: <1357685430.18156.776.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-08 at 17:32 -0500, Rik van Riel wrote:
> Subject: x86,smp: proportional backoff for ticket spinlocks
> 
> Simple fixed value proportional backoff for ticket spinlocks.
> By pounding on the cacheline with the spin lock less often,
> bus traffic is reduced. In cases of a data structure with
> embedded spinlock, the lock holder has a better chance of
> making progress.
> 
> If we are next in line behind the current holder of the
> lock, we do a fast spin, so as not to waste any time when
> the lock is released.
> 
> The number 50 is likely to be wrong for many setups, and
> this patch is mostly to illustrate the concept of proportional
> backup. The next patch automatically tunes the delay value.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Signed-off-by: Michel Lespinasse <walken@google.com>
> ---
>  arch/x86/kernel/smp.c |   23 ++++++++++++++++++++---
>  1 files changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
> index 20da354..aa743e9 100644
> --- a/arch/x86/kernel/smp.c
> +++ b/arch/x86/kernel/smp.c
> @@ -117,11 +117,28 @@ static bool smp_no_nmi_ipi = false;
>   */
>  void ticket_spin_lock_wait(arch_spinlock_t *lock, struct __raw_tickets inc)
>  {
> +	__ticket_t head = inc.head, ticket = inc.tail;
> +	__ticket_t waiters_ahead;
> +	unsigned loops;
> +
>  	for (;;) {
> -		cpu_relax();
> -		inc.head = ACCESS_ONCE(lock->tickets.head);
> +		waiters_ahead = ticket - head - 1;
> +		/*
> +		 * We are next after the current lock holder. Check often
> +		 * to avoid wasting time when the lock is released.
> +		 */
> +		if (!waiters_ahead) {
> +			do {
> +				cpu_relax();
> +			} while (ACCESS_ONCE(lock->tickets.head) != ticket);
> +			break;
> +		}
> +		loops = 50 * waiters_ahead;
> +		while (loops--)
> +			cpu_relax();
>  
> -		if (inc.head == inc.tail)
> +		head = ACCESS_ONCE(lock->tickets.head);
> +		if (head == ticket)
>  			break;
>  	}
>  }
> 

Reviewed-by: Eric Dumazet <edumazet@google.com>

In my tests, I used the following formula :

loops = 50 * ((ticket - head) - 1/2);

or :

delta = ticket - head;
loops = delay * delta - (delay >> 1);

(And I didnt use the special :

	if (!waiters_ahead) {
		do {
			cpu_relax();
		} while (ACCESS_ONCE(lock->tickets.head) != ticket);
		break;
	}

Because it means this wont help machines with 2 cpus.

(or more generally if there _is_ contention, but with
one lock holder and one lock waiter)



