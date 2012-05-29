Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067Ab2E2XyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 19:54:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755910Ab2E2XyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 19:54:22 -0400
Date: Tue, 29 May 2012 19:54:07 -0400
From: Don Zickus <dzickus@redhat.com>
To: Russ Anderson <rja@sgi.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rja@americas.sgi.com
Subject: Re: [PATCH] x86: Avoid intermixing cpu dump_stack output on
 multi-processor systems
Message-ID: <20120529235407.GH32472@redhat.com>
References: <20120524144229.GA27713@sgi.com>
 <20120529175352.GA31524@redhat.com>
 <20120529191935.GB29726@sgi.com>
 <20120529223923.GF32472@redhat.com>
 <20120529231135.GD4592@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120529231135.GD4592@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 06:11:35PM -0500, Russ Anderson wrote:
> > > In this case, I am just using the hardware NMI, which sends the NMI
> > > signal to each logical cpu.  Since each cpu receives the NMI at nearly
> > > the exact same time, they end up in dump_stack() at the same time.
> > > Without some form of locking, trace lines from different cpus end
> > > up intermixed, making it impossible to tell what any individual 
> > > cpu was doing.
> > 
> > I forgot the original reasons for having the NMI go to each CPU instead of
> > just the boot CPU (commit 78c06176), but it seems like if you revert that
> > patch and have the nmi handler just call trigger_all_cpu_backtrace()
> > instead (which does stack trace locking for pretty output), that would
> > solve your problem, no?  That locking is safe because it is only called in
> > the NMI context.
> 
> We want NMI to hit all the cpus at the same time to get a coherent
> snapshot of what is happening in the system at one point in time.
> Sending an IPI one cpu at a time skews the results, and doesn't 

Oh, I thought it was broadcasting, but I see the apic_uv code serializes
it.  Though getting all those hardware locks in the nmi handler has to be
time consuming?  But I know you guys did some tricks to speed that up.

> really solve the problem of multiple cpus going into dump_stack()
> at the same time.  NMI isn't the only possible caller of dump_stack().

I am curious, your NMI handler has locking wrapped around dump_stack,
shouldn't that serialize the output the way you want it?  Why isn't that
working?

> 
> FWIW, "Wait for up to 10 seconds for all CPUs to do the backtrace" on
> a 4096 cpu system isn't long enough.  :-)

Good point. :-)

> 
> > Whereas the lock you are proposing can be called in a mixture of NMI and
> > IRQ which could cause deadlocks I believe.
> 
> Since this is a lock just around the dump_stack printk, would 
> checking for forward progress and a timeout to catch any possible
> deadlock be sufficient?  In the unlikely case of a deadlock the
> lock gets broken and some of the cpu backtraces get intermixed.
> That is still a huge improvement over the current case where 
> all of the backtraces get intermixed.

I saw your new patch based on Frederick's input.  It seems to take care of
deadlock situations though you run into the starving lock problem that
ticketed spinlocks solved.  Which is why I am curious why moving the
locking one layer up to the NMI handler (which is where it is currently),
didn't fix your problem.

Cheers,
Don
