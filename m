Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab0DFJYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 05:24:39 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:53903 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385Ab0DFJYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 05:24:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=w32hLveWjJLvtk7iMCvkzbmXpzKhz41Vqg35fOnWSOdKdpI7Tk1Fmx3ELlngtn0ans
         gw+hZfATtpJPscpGWdP4bed8ua/9G123/naUHI7GGGIpRet+yzYVmLBJImDnnFVQG6cD
         QQKfnlv2S081yE9NrPRkAeFqPC1so1CFYzVUQ=
Date: Tue, 6 Apr 2010 11:24:26 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] lockdep: Make lockstats counting per cpu
Message-ID: <20100406092422.GA5147@nowhere>
References: <1269736197-10958-1-git-send-regression-fweisbec@gmail.com> <1270505417-8144-1-git-send-regression-fweisbec@gmail.com> <1270543587.1597.742.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270543587.1597.742.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 10:46:27AM +0200, Peter Zijlstra wrote:
> On Tue, 2010-04-06 at 00:10 +0200, Frederic Weisbecker wrote:
> > Locking statistics are implemented using global atomic variables.
> > This is usually fine unless some path write them very often.
> > 
> > This is the case for the function and function graph tracers
> > that disable irqs for each entry saved (except if the function
> > tracer is in preempt disabled only mode).
> > And calls to local_irq_save/restore() increment hardirqs_on_events
> > and hardirqs_off_events stats (or similar stats for redundant
> > versions).
> > 
> > Incrementing these global vars for each function ends up in too
> > much cache bouncing if lockstats are enabled.
> > 
> > To solve this, implement the debug_atomic_*() operations using
> > per cpu vars.
> > 
> > 
> 
> So I really have to ask, why?
> 
> This is CONFIG_DEBUG_LOCKDEP code, so its default off, and used to debug
> lockdep. Debug code should be as simple as possible, and preferably
> should not care about performance where possible.
> 
> So why complicate this?


Because when people report softlockups or big slowdowns with the function
(graph) tracers, I want to avoid asking them each time if they have
CONFIG_DEBUG_LOCKDEP enabled.

We call local_irq_disabled/enabled for each functions with these tracers.
And now that trace_clock() does that too, we do it twice.

I agree with you that simplicity must be a primary rule for debugging code,
but this role should be reconsidered when it roughly slows down the system.

This is also the responsibility of debugging code to ensure it doesn't break
things, except for corner cases hard to work around the natural starvation
they cause, like soft branch tracer or so.

