Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab1GTC00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 22:26:26 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:41731 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752770Ab1GTC0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 22:26:25 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/IdZw+OirILWF0SnZRGqgqhv4xYazZv55tERr1Kk
	9TTDbM9Jm/AE5i
Subject: Re: [PATCH 1/2] sched: Fix "divide error: 0000" in
 find_busiest_group
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Terry Loftin <terry.loftin@hp.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Bob Montgomery <bob.montgomery@hp.com>
In-Reply-To: <1311110224.2617.1.camel@laptop>
References: <4E25F006.2010205@hp.com>  <1311110224.2617.1.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jul 2011 04:26:20 +0200
Message-ID: <1311128780.7789.12.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-19 at 23:17 +0200, Peter Zijlstra wrote:
> On Tue, 2011-07-19 at 14:58 -0600, Terry Loftin wrote:
> > Correct the protection expression in update_cpu_power() to avoid setting
> > rq->cpu_power to zero.
> 
> Firstly you fail to mention what kernel this is again, secondly this
> should never happen in the first place, so this fix is wrong. At best it
> papers over another bug.
> 
> > Signed-off-by: Terry Loftin <terry.loftin@hp.com>
> > Signed-off-by: Bob Montgomery <bob.montgomery@hp.com>
> > ---
> > diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> > index 0c26e2d..9c50020 100644
> > --- a/kernel/sched_fair.c
> > +++ b/kernel/sched_fair.c
> > @@ -2549,7 +2549,7 @@ static void update_cpu_power(struct sched_domain *sd, int cpu)
> >  	power *= scale_rt_power(cpu);
> >  	power >>= SCHED_LOAD_SHIFT;
> > 
> > -	if (!power)
> > +	if ((u32)power == 0)
> >  		power = 1;
> > 
> >  	cpu_rq(cpu)->cpu_power = power;

I put that (and a bunch more protection+warnings) in an enterprise
kernel so it would not explode, but would gather some data.  The entire
world has been utterly silent, except for a gaggle of POWER7 boxen,
which manage to convince scale_rt_power() to return negative values.

Turning on PRINTK_TIME made these boxen go silent.  A printk with
timestamps, which doesn't happen, hides the problem.  Tilt.

	-Mike

