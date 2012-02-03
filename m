Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790Ab2BCTg3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 14:36:29 -0500
Received: from claw.goop.org ([74.207.240.146]:41357 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755078Ab2BCTg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 14:36:28 -0500
Message-ID: <4F2C373B.1060508@goop.org>
Date: Fri, 03 Feb 2012 11:36:27 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: eliminate TICKET_MASK
References: <4F2C06020200007800071066@nat28.tlf.novell.com>
In-Reply-To: <4F2C06020200007800071066@nat28.tlf.novell.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2012 07:06 AM, Jan Beulich wrote:
> The definition of it being questionable already (unnecessarily
> including a cast), and it being used in a single place that can be
> written shorter without it, remove this #define.
>
> Along the same lines, simplify __ticket_spin_is_locked()'s main
> expression, which was the more convoluted way because of needs that
> went away with the recent type changes by Jeremy.
>
> This is pure cleanup, no functional change intended.

That looks reasonable to me.

> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
>
> ---
>  arch/x86/include/asm/spinlock.h       |    4 ++--
>  arch/x86/include/asm/spinlock_types.h |    1 -
>  2 files changed, 2 insertions(+), 3 deletions(-)
>
> --- 3.3-rc2/arch/x86/include/asm/spinlock.h
> +++ 3.3-rc2-x86-ticket-mask/arch/x86/include/asm/spinlock.h
> @@ -88,14 +88,14 @@ static inline int __ticket_spin_is_locke
>  {
>  	struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
>  
> -	return !!(tmp.tail ^ tmp.head);
> +	return tmp.tail != tmp.head;
>  }
>  
>  static inline int __ticket_spin_is_contended(arch_spinlock_t *lock)
>  {
>  	struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
>  
> -	return ((tmp.tail - tmp.head) & TICKET_MASK) > 1;
> +	return (__ticket_t)(tmp.tail - tmp.head) > 1;
>  }

Yes.  I only left these unchanged the first time around because I didn't
want to inadvertently change them, but my intent was to make them more
straightforward like this.

>  
>  #ifndef CONFIG_PARAVIRT_SPINLOCKS
> --- 3.3-rc2/arch/x86/include/asm/spinlock_types.h
> +++ 3.3-rc2-x86-ticket-mask/arch/x86/include/asm/spinlock_types.h
> @@ -16,7 +16,6 @@ typedef u32 __ticketpair_t;
>  #endif
>  
>  #define TICKET_SHIFT	(sizeof(__ticket_t) * 8)
> -#define TICKET_MASK	((__ticket_t)((1 << TICKET_SHIFT) - 1))
>  
>  typedef struct arch_spinlock {
>  	union {
>
>
>

Acked-by: Jeremy Fitzhardinge <jeremy@goop.org>

Thanks,
    J
