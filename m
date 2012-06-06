Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab2FFJS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 05:18:59 -0400
Received: from www.linutronix.de ([62.245.132.108]:49509 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273Ab2FFJS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 05:18:58 -0400
Date: Wed, 6 Jun 2012 11:18:53 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chen Gong <gong.chen@linux.intel.com>
cc: LKML <linux-kernel@vger.kernel.org>, tony.luck@intel.com, bp@amd64.org,
        x86@kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 2/2] x86: mce: Implement cmci poll mode for intel
 machines
In-Reply-To: <4FCF0500.9050704@linux.intel.com>
Message-ID: <alpine.LFD.2.02.1206061056520.3086@ionos>
References: <20120524174943.989990966@linutronix.de> <20120524175056.478167482@linutronix.de> <4FCC1F7C.5000008@linux.intel.com> <alpine.LFD.2.02.1206042158200.3086@ionos> <4FCDF1C8.9020007@linux.intel.com> <alpine.LFD.2.02.1206051503560.3086@ionos>
 <4FCF0500.9050704@linux.intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1860358884-1338974334=:3086"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1860358884-1338974334=:3086
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 6 Jun 2012, Chen Gong wrote:
> 于 2012/6/5 21:35, Thomas Gleixner 写道:
> I add some print in timer callback, it shows:
> 
> smp_processor_id() = 0, mce_timer_fn data(CPU id) = 10
> timer->function = ffffffff8102c200, timer pending = 1, CPU = 0
> (add_timer_on, BUG!!!)

Sure. That's not a surprise. The timer function for cpu 10 is called
on cpu 0. And the timer function does:

   struct timer_list *t = &__get_cpu_var(mce_timer);

which gets a pointer to the timer of cpu0. And that timer is
pending. So yes, it's exploding for a good reason.

Though, this does not tell us how the timer of cpu10 gets on cpu0.

Did you do any cpu hotplug operations ?

> > @@ -1305,13 +1305,14 @@ void mce_timer_kick(unsigned long interv
> >  	unsigned long when = jiffies + interval;
> >  	unsigned long iv = __this_cpu_read(mce_next_interval);
> >  
> > -	if (time_before(when, t->expires) && timer_pending(t)) {
> > -		mod_timer(t, when);
> > -	} else if (!mce_next_interval) {
> > -		t->expires = round_jiffies(jiffies + iv);
> > +	if (timer_pending(t)) {
> > +		if (time_before(when, t->expires))
> > +			mod_timer(t, when);
> > +	} else {
> > +		t->expires = round_jiffies(jiffies + when);
> 
> should be "t->expires = round_jiffies(when);"

True.

> >  		add_timer_on(t, smp_processor_id());
> >  	}
> > -	if (interval < iv)
> > +	if (interval > iv)
> >  		__this_cpu_write(mce_next_interval, iv);
> >  }
> >  
> Strange, anyway, mce_next_interval should be updated in proper way, but
> if using above logic, mce_next_interval doesn't make change. I prefer
> if (interval < iv)
>     __this_cpu_write(mce_next_interval, interval);

Grr. you are right. Stupid me.
 
> In fact, during my test, I wrote the similar codes to do the test, but
> it can't fix the bug. The logic here is not the key, no matter how you set
> timer, you can get a poll timer. The issue happens in the timer function
> itself. Once timer callback is entered, the issue happens every time.
 
--8323328-1860358884-1338974334=:3086--
