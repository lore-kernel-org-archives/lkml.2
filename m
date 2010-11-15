Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757673Ab0KOOwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 09:52:18 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58962 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435Ab0KOOwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 09:52:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Rub5cbeJ/5rbf3FF70MCLI3lUmKGATO2u/pcWq6NsppdGsyDTa4koUn8XIvSbLrRYD
         Zy/IwtZblmBKAAjblZZBfZla8HMKSvtBlFLgnmyg1wpOADEjFOojJcPfsJnjSiTSTgG4
         m1gQkR0bOzFcWm4Get+QSlp+YZQJGMZFQSWWI=
Subject: Re: [PATCH] arch/tile: fix rwlock so would-be write lockers don't
 block new readers
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        netdev <netdev@vger.kernel.org>, Cypher Wu <cypher.w@gmail.com>
In-Reply-To: <201011151425.oAFEPU3W005682@farm-0010.internal.tilera.com>
References: <AANLkTikvT=x9eBovn2-m6HLqk7wyXSAR3sc9jCQ0C6mL@mail.gmail.com>
	 <1289489007.17691.1310.camel@edumazet-laptop>
	 <AANLkTik93QUQxSDmwd4Qj-gXQiWWPzd68JPAYAHBAsHR@mail.gmail.com>
	 <ZXmP8hjgLHA.4648@exchange1.tad.internal.tilera.com>
	 <4CDF1945.8090101@tilera.com>
	 <AANLkTind92uwcigzmDn8yn9a22exDy7zcreGQ5-6NLV-@mail.gmail.com>
	 <201011151425.oAFEPU3W005682@farm-0010.internal.tilera.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Nov 2010 15:52:10 +0100
Message-ID: <1289832730.2607.87.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 15 novembre 2010 à 09:18 -0500, Chris Metcalf a écrit :
> This avoids a deadlock in the IGMP code where one core gets a read
> lock, another core starts trying to get a write lock (thus blocking
> new readers), and then the first core tries to recursively re-acquire
> the read lock.
> 
> We still try to preserve some degree of balance by giving priority
> to additional write lockers that come along while the lock is held
> for write, so they can all complete quickly and return the lock to
> the readers.
> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> ---
> This should apply relatively cleanly to 2.6.26.7 source code too.
> 
>  arch/tile/lib/spinlock_32.c |   29 ++++++++++++++++++-----------
>  1 files changed, 18 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/tile/lib/spinlock_32.c b/arch/tile/lib/spinlock_32.c
> index 485e24d..5cd1c40 100644
> --- a/arch/tile/lib/spinlock_32.c
> +++ b/arch/tile/lib/spinlock_32.c
> @@ -167,23 +167,30 @@ void arch_write_lock_slow(arch_rwlock_t *rwlock, u32 val)
>  	 * when we compare them.
>  	 */
>  	u32 my_ticket_;
> +	u32 iterations = 0;
>  
> -	/* Take out the next ticket; this will also stop would-be readers. */
> -	if (val & 1)
> -		val = get_rwlock(rwlock);
> -	rwlock->lock = __insn_addb(val, 1 << WR_NEXT_SHIFT);
> +	/*
> +	 * Wait until there are no readers, then bump up the next
> +	 * field and capture the ticket value.
> +	 */
> +	for (;;) {
> +		if (!(val & 1)) {
> +			if ((val >> RD_COUNT_SHIFT) == 0)
> +				break;
> +			rwlock->lock = val;
> +		}
> +		delay_backoff(iterations++);

Are you sure a writer should have a growing delay_backoff() ?

It seems to me this only allow new readers to come (so adding more
unfairness to the rwlock, that already favor readers against writer[s])

Maybe allow one cpu to spin, and eventually other 'writers' be queued ?

> +		val = __insn_tns((int *)&rwlock->lock);
> +	}
>  
> -	/* Extract my ticket value from the original word. */
> +	/* Take out the next ticket and extract my ticket value. */
> +	rwlock->lock = __insn_addb(val, 1 << WR_NEXT_SHIFT);
>  	my_ticket_ = val >> WR_NEXT_SHIFT;
>  
> -	/*
> -	 * Wait until the "current" field matches our ticket, and
> -	 * there are no remaining readers.
> -	 */
> +	/* Wait until the "current" field matches our ticket. */
>  	for (;;) {
>  		u32 curr_ = val >> WR_CURR_SHIFT;
> -		u32 readers = val >> RD_COUNT_SHIFT;
> -		u32 delta = ((my_ticket_ - curr_) & WR_MASK) + !!readers;
> +		u32 delta = ((my_ticket_ - curr_) & WR_MASK);
>  		if (likely(delta == 0))
>  			break;
>  


