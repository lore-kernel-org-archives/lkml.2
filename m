Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab2KJUXt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 15:23:49 -0500
Received: from shrek-modem2.podlesie.net ([83.13.132.46]:59254 "EHLO
	shrek.podlesie.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752383Ab2KJUXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 15:23:45 -0500
Date: Sat, 10 Nov 2012 21:23:39 +0100
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: David Woodhouse <dwmw2@infradead.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chas Williams - CONTRACTOR <chas@cmf.nrl.navy.mil>,
        davem@davemloft.net
Subject: Re: [PATCH v3 8/7] pppoatm: fix missing wakeup in pppoatm_send()
Message-ID: <20121110202338.GA1749@shrek.podlesie.net>
References: <1352240222-363-1-git-send-email-krzysiek@podlesie.net>
 <1352292734.7340.35.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352292734.7340.35.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2012 at 12:52:14PM +0000, David Woodhouse wrote:
> 
> diff --git a/net/atm/pppoatm.c b/net/atm/pppoatm.c
> index 7507c20..56ad541 100644
> --- a/net/atm/pppoatm.c
> +++ b/net/atm/pppoatm.c
> @@ -283,11 +283,11 @@ static int pppoatm_send(struct ppp_channel *chan, struct sk_buff *skb)
>  	vcc = ATM_SKB(skb)->vcc;
>  	bh_lock_sock(sk_atm(vcc));
>  	if (sock_owned_by_user(sk_atm(vcc)))
> -		goto nospace;
> +		goto nospace_sched_wakeup;
>  	if (test_bit(ATM_VF_RELEASED, &vcc->flags)
> -			|| test_bit(ATM_VF_CLOSE, &vcc->flags)
> -			|| !test_bit(ATM_VF_READY, &vcc->flags))
> -		goto nospace;
> +	    || test_bit(ATM_VF_CLOSE, &vcc->flags)
> +	    || !test_bit(ATM_VF_READY, &vcc->flags))
> +		goto nospace_sched_wakeup;
>  
>  	switch (pvcc->encaps) {		/* LLC encapsulation needed */
>  	case e_llc:
> @@ -328,7 +328,17 @@ static int pppoatm_send(struct ppp_channel *chan, struct sk_buff *skb)
>  	    ? DROP_PACKET : 1;
>  	bh_unlock_sock(sk_atm(vcc));
>  	return ret;
> -nospace:
> + nospace_sched_wakeup:
> +	/* If we're returning zero for reasons *other* than the queue
> +	 * being full, then we need to ensure that a wakeup will
> +	 * happen and not just leave the channel stalled for ever.
> +	 * Just schedule the wakeup tasklet directly. As observed in
> +	 * pppoatm_pop(), it'll take the channel's ->downl lock which
> +	 * is also held by our caller, so it can't happen "too soon"
> +	 * and cause us to effectively miss a wakeup.
> +	 */
> +	tasklet_schedule(&pvcc->wakeup_tasklet);

With this tasklet_schedule() we implement a "spin_lock" here, but in
this case both conditions (vcc not ready and socket locked) can be true
for a long time and we can spin here for a long time. I confirmed it by
reverting patch 1 (atm: detach protocol before closing vcc) and now
I have 50% of CPU used by ksoftirqd and 50% by pppd (UP system).

Krzysiek
