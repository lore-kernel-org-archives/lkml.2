Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430Ab0KVOWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 09:22:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302Ab0KVOWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 09:22:41 -0500
Date: Mon, 22 Nov 2010 09:22:12 -0500
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [V2 PATCH 0/6] x86, NMI: give NMI handler a face-lift
Message-ID: <20101122142212.GS18100@redhat.com>
References: <4CE52048.5080802@windriver.com>
 <1290086232.2109.1507.camel@laptop>
 <20101118193247.GF18100@redhat.com>
 <4CE583D0.8050407@windriver.com>
 <20101118200807.GC8131@redhat.com>
 <1290112234.2109.1534.camel@laptop>
 <20101119165952.GJ18100@redhat.com>
 <1290191158.2109.1614.camel@laptop>
 <20101119225902.GQ18100@redhat.com>
 <1290208179.2114.13.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290208179.2114.13.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 20, 2010 at 12:09:39AM +0100, Peter Zijlstra wrote:
> On Fri, 2010-11-19 at 17:59 -0500, Don Zickus wrote:
> > +++ b/arch/x86/kernel/cpu/perf_event.c
> > @@ -381,6 +381,19 @@ static void release_pmc_hardware(void) {}
> >  
> >  #endif
> >  
> > +static bool check_hw_exists(void)
> > +{
> > +       u64 val, val_new;
> > +
> > +       val = 0xabcdUL;
> > +       (void) checking_wrmsrl(x86_pmu.perfctr, val);
> > +       rdmsrl(x86_pmu.perfctr, val_new);
> 
> 
> Yeah, this looks about right, although for extreme prudence I'd also use
> a checking_rdmsrl().

I didn't realize such a function existed, I'll look into it.

> 
> 
> > +       if (val != val_new)
> > +               return false;
> > +
> > +       return true;
> > +}
> > +
> >  static void reserve_ds_buffers(void);
> >  static void release_ds_buffers(void);
> >  
> > @@ -1371,6 +1385,12 @@ void __init init_hw_perf_events(void)
> >  
> >         pmu_check_apic();
> >  
> > +       /* sanity check that the hardware exists or is emulated */
> > +       if (!check_hw_exists()) {
> > +               pr_cont("no PMU driver, software events only.\n");
> > +               return;
> > +       } 
> 
> Maybe report something like this: 
>   "Broken PMU hardware detected, software events only."
> 
> Because this is really not something that's supposed to happen.

Ok.  Thanks.  I'll respin a cleaner patch today.

Thanks,
Don

