Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab1BAVIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 16:08:50 -0500
Received: from www.tglx.de ([62.245.132.106]:49028 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633Ab1BAVIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 16:08:49 -0500
Date: Tue, 1 Feb 2011 22:08:40 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <john.stultz@linaro.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 07/28] posix-timers: Convert clock_nanosleep_restart to
 clockid_to_kclock()
In-Reply-To: <alpine.LFD.2.00.1102012145500.31804@localhost6.localdomain6>
Message-ID: <alpine.LFD.2.00.1102012207130.31804@localhost6.localdomain6>
References: <20110201134320.688829863@linutronix.de>  <20110201134418.131263211@linutronix.de> <1296592977.3336.25.camel@work-vm> <alpine.LFD.2.00.1102012145500.31804@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Feb 2011, Thomas Gleixner wrote:
> On Tue, 1 Feb 2011, John Stultz wrote:
> 
> > On Tue, 2011-02-01 at 13:51 +0000, Thomas Gleixner wrote:
> > > plain text document attachment
> > > (posix-timers-convert-nanosleep-restart.patch)
> > > Use the new kclock decoding function in clock_nanosleep_restart. No
> > > need to check kclock here as the restart block always contains a valid
> > > clockid. If not, we are in serious trouble anyway.
> > > 
> > > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > > Cc: John Stultz <john.stultz@linaro.org>
> > > Cc: Richard Cochran <richard.cochran@omicron.at>
> > 
> > One nit.
> > 
> > > -long
> > > -clock_nanosleep_restart(struct restart_block *restart_block)
> > > +long clock_nanosleep_restart(struct restart_block *restart_block)
> > >  {
> > >  	clockid_t which_clock = restart_block->arg0;
> > > +	struct k_clock *kc = clockid_to_kclock(which_clock);
> > > 
> > > -	return CLOCK_DISPATCH(which_clock, nsleep_restart,
> > > -			      (restart_block));
> > > +	return kc->nsleep_restart(restart_block);
> > >  }
> > 
> > 
> > Should you be checking if kc is null before dereferencing? Or am I being
> > overly paranoid?
> 
> See changelog. If we get a corrupted restart_block then checking kc is
> probably the least of our worries.

Ok, I'll add the checks for nsleep_restart and timer_get/set/del, but
I make them a WARN_ON_ONCE() as this is serious data corruption in the
kernel.

Thanks,

	tglx
