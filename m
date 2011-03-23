Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab1CWRxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 13:53:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755241Ab1CWRxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 13:53:45 -0400
Date: Wed, 23 Mar 2011 13:53:20 -0400
From: Don Zickus <dzickus@redhat.com>
To: Jack Steiner <steiner@sgi.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86, UV: Fix NMI handler for UV platforms
Message-ID: <20110323175320.GB9413@redhat.com>
References: <20110321161425.GC23614@elte.hu>
 <4D877C4B.9090602@gmail.com>
 <20110321175110.GL1239@redhat.com>
 <20110321182235.GA14562@sgi.com>
 <20110321193740.GN1239@redhat.com>
 <20110322171118.GA6294@sgi.com>
 <20110322184450.GU1239@redhat.com>
 <20110322212519.GA12076@sgi.com>
 <20110322220505.GB13453@redhat.com>
 <20110323163255.GA17178@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110323163255.GA17178@sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 11:32:55AM -0500, Jack Steiner wrote:
> > The first thing is in 'uv_handle_nmi' can you change that from
> > DIE_NMIUNKNOWN back to DIE_NMI.  Originally I set it to DIE_NMIUNKNOWN
> > because I didn't think you guys had the ability to determine if your BMC
> > generated the NMI or not.  Recently George B. said you guys add a register
> > bit to determine this, so I am wondering if by promoting this would fix
> > the missed UV NMI.  I am speculating this is being swallowed by the
> > hw_perf DIE_NMIUNKNOWN exception path.
> 
> Correct. I recently added a register that indicates the BMC sent an NMI.
> 
> Hmmm. Looks like I have been running with DIE_NMI. I think that came
> from porting the patch from RHEL6 to upstream.
> 
> However, neither DIE_NMIUNKNOWN  or DIE_NMI gives the desired behavior (2.6.38+).
> 
> 	- Using DIE_NMIUNKNOWN, I see many more "dazed" messages but no
> 	  perf top lockup. I see ~3 "dazed" messages per minute. UV NMIs are
> 	  being sent at a rate of 30/min, ie. ~10% failure rate.
> 
> 	- Using DIE_NMI, no "dazed" messages but perf top hangs about once a
> 	  minute (rough estimate).
> 
> 
> I wonder if we need a different approach to handling NMIs. Instead of using
> the die_notifier list, introduce a new notifier list reserved exclusively
> for NMIs. When an NMI occurs, all registered functions are unconditionally called.
> If any function accepts the NMI, the remaining functions are still called but
> the NMI is considered to have been valid (handled) & the "dazed" message
> is suppressed.
> 
> This is more-or-less functionally equivalent to the last patch I posted but
> may be cleaner. At a minimum, it is easier to understand the interactions
> between the various handlers.

This is the same approach I was realizing last night when I went to bed.
I think the more concurrent NMIs we have, the more tricky things get.  

I hacked up an ugly patch that might fix the 'dazed' message you are
seeing.  The original skip logic assumed the back-to-back nmis would stop
after 3 nmis.  Under load, those nmis could go on forever if the time it
takes to handle the nmi matches the period in which the nmi is being
generated (I assume all the stack dumping from the BMC nmi probably
lengthens the time it takes to handle the nmi?).

For example,  the first NMI might notice two perf counters triggered.  But
it doesn't know if it triggered under one or two NMIs, so it marks the
next NMI as a possible candidate to 'swallow' if no one claims it.

Once it is finished, it notices the next nmi came from perf too (reading
the status register).  Again we don't know if this is from the second NMI
that we have not 'swallowed' yet or from the third event (because the
second NMI was never generated).

Once that finishes, another nmi comes along.  The current code says that
one has to be the one we 'swallow' or if perf 'handles' it then assume
there are no 'extra' NMIs waiting to be swallowed.

This is where the problem is, as I have seen on my machine.  The
back-to-back nmis have gone up to 4 in-a-row before spitting out the extra
nmi the code was hoping to 'swallow'.

Let me know if the patch fixes that problem.  Then it will be one less
thing to worry about. :-)

Cheers,
Don


diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 19fbcad..f9dcd81 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1327,7 +1327,7 @@ perf_event_nmi_handler(struct notifier_block *self,
 	if ((handled > 1) ||
 		/* the next nmi could be a back-to-back nmi */
 	    ((__get_cpu_var(pmu_nmi).marked == this_nmi) &&
-	     (__get_cpu_var(pmu_nmi).handled > 1))) {
+	     (__get_cpu_var(pmu_nmi).handled > 0) && handled && this_nmi)) {
 		/*
 		 * We could have two subsequent back-to-back nmis: The
 		 * first handles more than one counter, the 2nd
@@ -1338,6 +1338,8 @@ perf_event_nmi_handler(struct notifier_block *self,
 		 * handling more than one counter. We will mark the
 		 * next (3rd) and then drop it if unhandled.
 		 */
+		//if ((__get_cpu_var(pmu_nmi).handled == 1) && (handled == 1))
+		//	trace_printk("!! fixed?\n");
 		__get_cpu_var(pmu_nmi).marked	= this_nmi + 1;
 		__get_cpu_var(pmu_nmi).handled	= handled;
 	}
