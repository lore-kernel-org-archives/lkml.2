Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467Ab2LWWzZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 17:55:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245Ab2LWWzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 17:55:22 -0500
Date: Sun, 23 Dec 2012 20:55:08 -0200
From: Rafael Aquini <aquini@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, walken@google.com, lwoodman@redhat.com,
        jeremy@goop.org, Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 2/3] x86,smp: proportional backoff for ticket
 spinlocks
Message-ID: <20121223225507.GB4186@x61.redhat.com>
References: <20121221184940.103c31ad@annuminas.surriel.com>
 <20121221185115.1858ffc5@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121221185115.1858ffc5@annuminas.surriel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 06:51:15PM -0500, Rik van Riel wrote:
> Subject: x86,smp: proportional backoff for ticket spinlocks
> 
> Simple fixed value proportional backoff for ticket spinlocks.
> By pounding on the cacheline with the spin lock less often,
> bus traffic is reduced. In cases of a data structure with
> embedded spinlock, the lock holder has a better chance of
> making progress.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> ---

Reviewed-by: Rafael Aquini <aquini@redhat.com>

>  arch/x86/kernel/smp.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
> index 20da354..4e44840 100644
> --- a/arch/x86/kernel/smp.c
> +++ b/arch/x86/kernel/smp.c
> @@ -118,9 +118,11 @@ static bool smp_no_nmi_ipi = false;
>  void ticket_spin_lock_wait(arch_spinlock_t *lock, struct __raw_tickets inc)
>  {
>  	for (;;) {
> -		cpu_relax();
> -		inc.head = ACCESS_ONCE(lock->tickets.head);
> +		int loops = 50 * (__ticket_t)(inc.tail - inc.head);
> +		while (loops--)
> +			cpu_relax();
>  
> +		inc.head = ACCESS_ONCE(lock->tickets.head);
>  		if (inc.head == inc.tail)
>  			break;
>  	}
> 
