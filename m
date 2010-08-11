Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426Ab0HKLPe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 07:15:34 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:23166 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab0HKLPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 07:15:33 -0400
X-SpamScore: 4
X-BigFish: VPS4(z3cfcs329eqz1432N98dN936eMzz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L6ZJ1X-02-9U1-02
X-M-MSG: 
Date: Wed, 11 Aug 2010 13:10:46 +0200
From: Robert Richter <robert.richter@amd.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Don Zickus <dzickus@redhat.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] perf, x86: try to handle unknown nmis with running
 perfctrs
Message-ID: <20100811111046.GQ26154@erda.amd.com>
References: <20100804161046.GC5130@lenovo>
 <20100804162026.GU3353@redhat.com>
 <20100804163930.GE5130@lenovo>
 <20100804184806.GL26154@erda.amd.com>
 <20100804192634.GG5130@lenovo>
 <20100806065203.GR26154@erda.amd.com>
 <20100806142131.GA1874@redhat.com>
 <20100809194829.GB26154@erda.amd.com>
 <20100810204856.GA16571@redhat.com>
 <20100811024451.GA26835@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100811024451.GA26835@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.08.10 22:44:55, Frederic Weisbecker wrote:
> On Tue, Aug 10, 2010 at 04:48:56PM -0400, Don Zickus wrote:
> > @@ -1200,7 +1200,7 @@ void perf_events_lapic_init(void)
> >  	apic_write(APIC_LVTPC, APIC_DM_NMI);
> >  }
> >  
> > -static DEFINE_PER_CPU(unsigned int, perfctr_handled);
> > +static DEFINE_PER_CPU(unsigned int, perfctr_skip);

Yes, using perfctr_skip is better to understand ...

> > @@ -1229,14 +1228,11 @@ perf_event_nmi_handler(struct notifier_block *self,
> >  		 * was handling a perfctr. Otherwise we pass it and
> >  		 * let the kernel handle the unknown nmi.
> >  		 *
> > -		 * Note: this could be improved if we drop unknown
> > -		 * NMIs only if we handled more than one perfctr in
> > -		 * the previous NMI.
> >  		 */
> > -		this_nmi = percpu_read(irq_stat.__nmi_count);
> > -		prev_nmi = __get_cpu_var(perfctr_handled);
> > -		if (this_nmi == prev_nmi + 1)
> > +		if (__get_cpu_var(perfctr_skip)){
> > +			__get_cpu_var(perfctr_skip) -=1;
> >  			return NOTIFY_STOP;
> > +		}
> >  		return NOTIFY_DONE;
> >  	default:
> >  		return NOTIFY_DONE;
> > @@ -1246,11 +1242,21 @@ perf_event_nmi_handler(struct notifier_block *self,
> >  
> >  	apic_write(APIC_LVTPC, APIC_DM_NMI);
> >  
> > -	if (!x86_pmu.handle_irq(regs))
> > +	handled = x86_pmu.handle_irq(regs);
> > +	if (!handled)
> > +		/* not our NMI */
> >  		return NOTIFY_DONE;
> > -
> > -	/* handled */
> > -	__get_cpu_var(perfctr_handled) = percpu_read(irq_stat.__nmi_count);
> > +	else if (handled > 1)
> > +		/*
> > +		 * More than one perfctr triggered.  This could have
> > +		 * caused a second NMI that we must now skip because
> > +		 * we have already handled it.  Remember it.
> > +		 *
> > +		 * NOTE: We have no way of knowing if a second NMI was
> > +		 * actually triggered, so we may accidentally skip a valid
> > +		 * unknown nmi later.
> > +		 */
> > +		__get_cpu_var(perfctr_skip) +=1;

... but this will not work. You have to mark the *absolute* nmi number
here. If you only raise a flag, the next unknown nmi will be dropped,
every. Because, in between there could have been other nmis that
stopped the chain and thus the 'unknown' path is not executed. The
trick in my patch is that you *know*, which nmi you want to skip.

I will send an updated version of my patch.

-Robert

> 
> 
> 
> May be make it just a pending bit. I mean not something that can
> go further 1, because you can't have more than 1 pending anyway. I don't
> know how that could happen you get accidental perctr_skip > 1, may be
> expected pending NMIs that don't happen somehow, but better be paranoid with
> that, as it's about trying not to miss hardware errors.
> 
> Thanks.
> 
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

