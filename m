Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379Ab2FDUBH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 16:01:07 -0400
Received: from www.linutronix.de ([62.245.132.108]:42964 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab2FDUBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 16:01:03 -0400
Date: Mon, 4 Jun 2012 22:01:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chen Gong <gong.chen@linux.intel.com>
cc: LKML <linux-kernel@vger.kernel.org>, tony.luck@intel.com, bp@amd64.org,
        x86@kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 2/2] x86: mce: Implement cmci poll mode for intel
 machines
In-Reply-To: <4FCC1F7C.5000008@linux.intel.com>
Message-ID: <alpine.LFD.2.02.1206042158200.3086@ionos>
References: <20120524174943.989990966@linutronix.de> <20120524175056.478167482@linutronix.de> <4FCC1F7C.5000008@linux.intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2012, Chen Gong wrote:
> > +/*
> > + * Ensure that the timer is firing in @interval from now.
> > + */
> > +void mce_timer_kick(unsigned long interval)
> > +{
> > +	struct timer_list *t = &__get_cpu_var(mce_timer);
> > +	unsigned long when = jiffies + interval;
> > +	unsigned long iv = __this_cpu_read(mce_next_interval);
> > +
> > +	if (time_before(when, t->expires) && timer_pending(t)) {
> > +		mod_timer(t, when);
> > +	} else if (!mce_next_interval) {
> 
> Why using mce_next_interval, it is a per_cpu var, should be non-NULL
> definitely, right? How about using *iv* here?

iv is the thing to use. No idea why I typoed mce_next_interval into
that.
 
> > +		t->expires = round_jiffies(jiffies + iv);
> > +		add_timer_on(t, smp_processor_id());
> > +	}
> > +	if (interval < iv)
> > +		__this_cpu_write(mce_next_interval, iv);
> >  }
> 
> This code should be __this_cpu_write(mce_next_interval, interval);?

Duh, yes.

Thanks,

	tglx
