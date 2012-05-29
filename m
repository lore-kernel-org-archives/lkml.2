Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab2E2Jie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 05:38:34 -0400
Received: from www.linutronix.de ([62.245.132.108]:47271 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082Ab2E2Jic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 05:38:32 -0400
Date: Tue, 29 May 2012 11:38:27 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [patch 2/4] timers: Consolidate base->next_timer update
In-Reply-To: <87likbxzqe.fsf@abhimanyu.in.ibm.com>
Message-ID: <alpine.LFD.2.02.1205291137580.3231@ionos>
References: <20120525214617.051888729@linutronix.de> <20120525214819.189946224@linutronix.de> <87likbxzqe.fsf@abhimanyu.in.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2012, Nikunj A Dadhania wrote:

> > 
> > -static void internal_add_timer(struct tvec_base *base, struct timer_list *timer)
> > +static void
> > +__internal_add_timer(struct tvec_base *base, struct timer_list *timer)
> >  {
> >  	unsigned long expires = timer->expires;
> >  	unsigned long idx = expires - base->timer_jiffies;
> > @@ -372,6 +373,17 @@ static void internal_add_timer(struct tv
> >  	list_add_tail(&timer->entry, vec);
> >  }
> > 
> > +static void internal_add_timer(struct tvec_base *base, struct timer_list *timer)
> > +{
> > +	__internal_add_timer(base, timer);
> > +	/*
> > +	 * Update base->next_timer if this is the earliest one.
> > +	 */
> > +	if (time_before(timer->expires, base->next_timer) &&
> > +	    !tbase_get_deferrable(timer->base))
> > +		base->next_timer = timer->expires;
> > +}
> > +
> >
> Shouldn't this be like this?
> 
> +	/*
> +	 * Update base->next_timer if this is the earliest one.
> +	 */
> +	if (time_before(timer->expires, base->next_timer) &&
> +	    !tbase_get_deferrable(timer->base))
> +		base->next_timer = timer->expires;
> +	__internal_add_timer(base, timer);
> 
> As per the below code?

And why should this matter?
