Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784Ab1BBJzW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 04:55:22 -0500
Received: from www.tglx.de ([62.245.132.106]:48123 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752617Ab1BBJzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 04:55:20 -0500
Date: Wed, 2 Feb 2011 10:55:06 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Richard Cochran <richardcochran@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 12/28] posix-timers: Convert clock_gettime() to
 clockid_to_kclock()
In-Reply-To: <20110202090922.GD2747@riccoc20.at.omicron.at>
Message-ID: <alpine.LFD.2.00.1102021054190.31804@localhost6.localdomain6>
References: <20110201134320.688829863@linutronix.de> <20110201134418.611097203@linutronix.de> <20110202090922.GD2747@riccoc20.at.omicron.at>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Feb 2011, Richard Cochran wrote:

> On Tue, Feb 01, 2011 at 01:51:50PM -0000, Thomas Gleixner wrote:
> > --- linux-2.6-tip.orig/kernel/posix-timers.c
> > +++ linux-2.6-tip/kernel/posix-timers.c
> 
> > @@ -956,18 +955,21 @@ SYSCALL_DEFINE2(clock_settime, const clo
> >  SYSCALL_DEFINE2(clock_gettime, const clockid_t, which_clock,
> >  		struct timespec __user *,tp)
> >  {
> > +	struct k_clock *kc = clockid_to_kclock(which_clock);
> >  	struct timespec kernel_tp;
> >  	int error;
> >  
> > -	if (invalid_clockid(which_clock))
> > +	if (!kc)
> >  		return -EINVAL;
> > -	error = CLOCK_DISPATCH(which_clock, clock_get,
> > -			       (which_clock, &kernel_tp));
> > +	if (!kc->clock_get)
> > +		return -EOPNOTSUPP;
> 
> An unreadable clock?
> 
> I would think that we can require k_clocks to provide the read
> function. This could be checked and enforced in register_posix_clock().

Fair enough. Though, we should do that in a separate step.

Thanks,

	tglx
