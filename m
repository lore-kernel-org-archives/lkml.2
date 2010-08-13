Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814Ab0HMEhx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 00:37:53 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57166 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab0HMEhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 00:37:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pPLerycg23/u5+I1vU3dPqbXOou4MFGHF2iNaAPfdm45o8kTJcYySgLQvdsBRtjQ6e
         TCvClxrzibEyprnTkFSJqNSEAbminmEkgnD0YpP8jQ/rW2WOET7taez6s5XTIGV2AwH5
         X1nx8vL7P5PQP/SSDlG+tNNhamit/VPv6a8EM=
Date: Fri, 13 Aug 2010 06:37:48 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Don Zickus <dzickus@redhat.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] perf, x86: try to handle unknown nmis with running
	perfctrs
Message-ID: <20100813043746.GB9669@nowhere>
References: <20100804162026.GU3353@redhat.com> <20100804163930.GE5130@lenovo> <20100804184806.GL26154@erda.amd.com> <20100804192634.GG5130@lenovo> <20100806065203.GR26154@erda.amd.com> <20100806142131.GA1874@redhat.com> <20100809194829.GB26154@erda.amd.com> <20100810204856.GA16571@redhat.com> <20100811024451.GA26835@nowhere> <20100811111046.GQ26154@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100811111046.GQ26154@erda.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 01:10:46PM +0200, Robert Richter wrote:
> On 10.08.10 22:44:55, Frederic Weisbecker wrote:
> > On Tue, Aug 10, 2010 at 04:48:56PM -0400, Don Zickus wrote:
> > > @@ -1200,7 +1200,7 @@ void perf_events_lapic_init(void)
> > >  	apic_write(APIC_LVTPC, APIC_DM_NMI);
> > >  }
> > >  
> > > -static DEFINE_PER_CPU(unsigned int, perfctr_handled);
> > > +static DEFINE_PER_CPU(unsigned int, perfctr_skip);
> 
> Yes, using perfctr_skip is better to understand ...
> 
> > > @@ -1229,14 +1228,11 @@ perf_event_nmi_handler(struct notifier_block *self,
> > >  		 * was handling a perfctr. Otherwise we pass it and
> > >  		 * let the kernel handle the unknown nmi.
> > >  		 *
> > > -		 * Note: this could be improved if we drop unknown
> > > -		 * NMIs only if we handled more than one perfctr in
> > > -		 * the previous NMI.
> > >  		 */
> > > -		this_nmi = percpu_read(irq_stat.__nmi_count);
> > > -		prev_nmi = __get_cpu_var(perfctr_handled);
> > > -		if (this_nmi == prev_nmi + 1)
> > > +		if (__get_cpu_var(perfctr_skip)){
> > > +			__get_cpu_var(perfctr_skip) -=1;
> > >  			return NOTIFY_STOP;
> > > +		}
> > >  		return NOTIFY_DONE;
> > >  	default:
> > >  		return NOTIFY_DONE;
> > > @@ -1246,11 +1242,21 @@ perf_event_nmi_handler(struct notifier_block *self,
> > >  
> > >  	apic_write(APIC_LVTPC, APIC_DM_NMI);
> > >  
> > > -	if (!x86_pmu.handle_irq(regs))
> > > +	handled = x86_pmu.handle_irq(regs);
> > > +	if (!handled)
> > > +		/* not our NMI */
> > >  		return NOTIFY_DONE;
> > > -
> > > -	/* handled */
> > > -	__get_cpu_var(perfctr_handled) = percpu_read(irq_stat.__nmi_count);
> > > +	else if (handled > 1)
> > > +		/*
> > > +		 * More than one perfctr triggered.  This could have
> > > +		 * caused a second NMI that we must now skip because
> > > +		 * we have already handled it.  Remember it.
> > > +		 *
> > > +		 * NOTE: We have no way of knowing if a second NMI was
> > > +		 * actually triggered, so we may accidentally skip a valid
> > > +		 * unknown nmi later.
> > > +		 */
> > > +		__get_cpu_var(perfctr_skip) +=1;
> 
> ... but this will not work. You have to mark the *absolute* nmi number
> here. If you only raise a flag, the next unknown nmi will be dropped,
> every.



Isn't it what we want? Only the next unknown nmi gets dropped.




> Because, in between there could have been other nmis that
> stopped the chain and thus the 'unknown' path is not executed.



I'm not sure what you mean here. Are you thinking about a third
NMI source that triggers while we are still handling the first
NMI in the back to back sequence?



> The trick in my patch is that you *know*, which nmi you want to skip.


Well with the flag you also know which nmi you want to skip.

