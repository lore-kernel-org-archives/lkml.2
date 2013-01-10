Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494Ab3AJCbO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 21:31:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3862 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399Ab3AJCbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 21:31:13 -0500
Date: Thu, 10 Jan 2013 00:30:05 -0200
From: Rafael Aquini <aquini@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, walken@google.com, eric.dumazet@gmail.com,
        lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>, knoel@redhat.com,
        chegu_vinod@hp.com, raghavendra.kt@linux.vnet.ibm.com,
        mingo@redhat.com
Subject: Re: [PATCH 2/5] x86,smp: proportional backoff for ticket spinlocks
Message-ID: <20130110023004.GB1636@x61.redhat.com>
References: <20130108172632.1126898a@annuminas.surriel.com>
 <20130108173241.3e1b1d2d@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130108173241.3e1b1d2d@annuminas.surriel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2013 at 05:32:41PM -0500, Rik van Riel wrote:
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

Acked-by: Rafael Aquini <aquini@redhat.com>


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
