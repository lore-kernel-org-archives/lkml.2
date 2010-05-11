Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab0EKTmz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 15:42:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:62214 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676Ab0EKTmw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 15:42:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,209,1272870000"; 
   d="scan'208";a="517041073"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
       Jacob Pan <jacob.jun.pan@linux.intel.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       "Du, Alek" <alek.du@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "Tang, Feng" <feng.tang@intel.com>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 11 May 2010 12:42:51 -0700
Subject: RE: [PATCH 3/8] x86/apic: allow use of lapic timer early
 calibration result
Thread-Topic: [PATCH 3/8] x86/apic: allow use of lapic timer early
 calibration result
Thread-Index: AcrxEGPaZ+K/RjRJTL27ELvCfu02RQALUVag
Message-ID: <43F901BD926A4E43B106BF17856F0755A74B2827@orsmsx508.amr.corp.intel.com>
References: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1273254108-3234-4-git-send-email-jacob.jun.pan@linux.intel.com>
 <alpine.LFD.2.00.1005111514471.3401@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1005111514471.3401@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the review.

> >
> > lapic timer calibration can be combined with tsc in platform specific
> > calibration functions. if such calibration result is obtained early,
> > we can skip the redundent calibration loops.
> 
> I'd rather move lapic calibration into TSC calibration in general as
> we do the same thing twice for no good reason.
> 
> That needs some code restructuring, but that's worth it.
> 
I am trying to avoid the risks of completely remove the current lapic 
calibration code since there are so many platforms with different timer
options. And I don't understand things like why pm timer is preferred.
Why not use the rating in clocksource?

> > Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
> > Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> 
> Hehe. So you handed the patch to yourself :)
> 
> > ---
> >  arch/x86/kernel/apic/apic.c |   21 ++++++++++++++++++++-
> >  1 files changed, 20 insertions(+), 1 deletions(-)
> >
> > diff --git a/arch/x86/kernel/apic/apic.c
> b/arch/x86/kernel/apic/apic.c
> > index e5a4a1e..8ef56ac 100644
> > --- a/arch/x86/kernel/apic/apic.c
> > +++ b/arch/x86/kernel/apic/apic.c
> > @@ -175,7 +175,7 @@ static struct resource lapic_resource = {
> >  	.flags = IORESOURCE_MEM | IORESOURCE_BUSY,
> >  };
> >
> > -static unsigned int calibration_result;
> > +unsigned int calibration_result;
> 
> Aside of my general objection it'd be not a good idea to make this
> global w/o renaming it to something sensible like
> lapic_timer_frequency.
> 
perhaps, the calibration data can directly be assigned to lapic timer
clock_event_device.mult? There is no need for the device specific result
scale (e.g. bus clocks per tick)

> >  static int lapic_next_event(unsigned long delta,
> >  			    struct clock_event_device *evt);
> > @@ -597,6 +597,25 @@ static int __init calibrate_APIC_clock(void)
> >  	long delta, deltatsc;
> >  	int pm_referenced = 0;
> >
> > +	/**
> > +	 * check if lapic timer has already been calibrated by platform
> > +	 * specific routine, such as tsc calibration code. if so, we just
> fill
> > +	 * in the clockevent structure and return.
> > +	 */
> > +	if (calibration_result) {
> > +		apic_printk(APIC_VERBOSE, "lapic timer already calibrated
> %d\n",
> > +				calibration_result);
> > +		lapic_clockevent.mult =
> div_sc(calibration_result/APIC_DIVISOR,
> > +					TICK_NSEC, lapic_clockevent.shift);
> > +		lapic_clockevent.max_delta_ns =
> > +			clockevent_delta2ns(0x7FFFFF, &lapic_clockevent);
> > +		lapic_clockevent.min_delta_ns =
> > +			clockevent_delta2ns(0xF, &lapic_clockevent);
> > +		lapic_clockevent.features &= ~CLOCK_EVT_FEAT_DUMMY;
> > +		return 0;
> 
>   Grr. I hate duplicated code.
> 
> > +	}
> > +
> >  	local_irq_disable();
> >
> >  	/* Replace the global interrupt handler */
> > --
> > 1.6.3.3
> >
