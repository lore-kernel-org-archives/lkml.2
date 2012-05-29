Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab2E2Gmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 02:42:35 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:41830 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab2E2Gmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 02:42:33 -0400
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [patch 2/4] timers: Consolidate base->next_timer update
In-Reply-To: <20120525214819.189946224@linutronix.de>
References: <20120525214617.051888729@linutronix.de> <20120525214819.189946224@linutronix.de>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/24.0.95.1 (x86_64-unknown-linux-gnu)
Date: Tue, 29 May 2012 12:04:01 +0530
Message-ID: <87likbxzqe.fsf@abhimanyu.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
x-cbid: 12052906-3864-0000-0000-00000317790D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> -static void internal_add_timer(struct tvec_base *base, struct timer_list *timer)
> +static void
> +__internal_add_timer(struct tvec_base *base, struct timer_list *timer)
>  {
>  	unsigned long expires = timer->expires;
>  	unsigned long idx = expires - base->timer_jiffies;
> @@ -372,6 +373,17 @@ static void internal_add_timer(struct tv
>  	list_add_tail(&timer->entry, vec);
>  }
> 
> +static void internal_add_timer(struct tvec_base *base, struct timer_list *timer)
> +{
> +	__internal_add_timer(base, timer);
> +	/*
> +	 * Update base->next_timer if this is the earliest one.
> +	 */
> +	if (time_before(timer->expires, base->next_timer) &&
> +	    !tbase_get_deferrable(timer->base))
> +		base->next_timer = timer->expires;
> +}
> +
>
Shouldn't this be like this?

+	/*
+	 * Update base->next_timer if this is the earliest one.
+	 */
+	if (time_before(timer->expires, base->next_timer) &&
+	    !tbase_get_deferrable(timer->base))
+		base->next_timer = timer->expires;
+	__internal_add_timer(base, timer);

As per the below code?

>  #ifdef CONFIG_TIMER_STATS
>  void __timer_stats_timer_set_start_info(struct timer_list *timer, void *addr)
>  {
> @@ -757,9 +769,6 @@ __mod_timer(struct timer_list *timer, un
>  	}
> 
>  	timer->expires = expires;
> -	if (time_before(timer->expires, base->next_timer) &&
> -	    !tbase_get_deferrable(timer->base))
> -		base->next_timer = timer->expires;
>  	internal_add_timer(base, timer);
> 

