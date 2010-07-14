Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab0GNAsu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 20:48:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:20348 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576Ab0GNAst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 20:48:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,198,1278313200"; 
   d="scan'208";a="535283187"
Subject: Re: perf failed with kernel 2.6.35-rc
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
In-Reply-To: <20100713085019.GB7984@elte.hu>
References: <1279008849.2096.913.camel@ymzhang.sh.intel.com>
	 <20100713085019.GB7984@elte.hu>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 14 Jul 2010 08:49:52 +0800
Message-Id: <1279068592.2096.924.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-13 at 10:50 +0200, Ingo Molnar wrote:
> * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> 
> > Peter,
> > 
> > perf doesn't work on my Nehalem EX machine.
> > 1) The 1st start of 'perf top' is ok;
> > 2) Kill the 1st perf and restart it. It doesn't work. No data is showed.
> > 
> > I located below commit:
> > commit 1ac62cfff252fb668405ef3398a1fa7f4a0d6d15
> > Author: Peter Zijlstra <peterz@infradead.org>
> > Date:   Fri Mar 26 14:08:44 2010 +0100
> > 
> >     perf, x86: Add Nehelem PMU programming errata workaround
> >     
> >     workaround From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >     Date: Fri Mar 26 13:59:41 CET 2010
> >     
> >     Implement the workaround for Intel Errata AAK100 and AAP53.
> >     
> >     Also, remove the Core-i7 name for Nehalem events since there are
> >     also Westmere based i7 chips.
> > 
> > 
> > If I comment out the workaround in function intel_pmu_nhm_enable_all,
> > perf could work.
> > 
> > A quick glance shows:
> > wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x3);
> > should be:
> > wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x7);
> 
> > I triggered sysrq to dump PMU registers and found the last bit of
> > global status register is 1. I added a status reset operation like below patch:
> > 
> > --- linux-2.6.35-rc5/arch/x86/kernel/cpu/perf_event_intel.c	2010-07-14 09:38:11.000000000 +0800
> > +++ linux-2.6.35-rc5_fork/arch/x86/kernel/cpu/perf_event_intel.c	2010-07-14 14:41:42.000000000 +0800
> > @@ -505,8 +505,13 @@ static void intel_pmu_nhm_enable_all(int
> >  		wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + 1, 0x4300B1);
> >  		wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + 2, 0x4300B5);
> >  
> > -		wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x3);
> > +		wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x7);
> >  		wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x0);
> > +		/*
> > +		 * Reset the last 3 bits of global status register in case
> > +		 * previous enabling causes overflows.
> > +		 */
> > +		wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, 0x7);
> >  
> >  		for (i = 0; i < 3; i++) {
> >  			struct perf_event *event = cpuc->events[i];
> >
> > 
> > However, it still doesn't work. Current right way is to comment out
> > the workaround.
> 
> Well, how about doing it like this:
> 
> 		wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x7);
> 		/*
> 		 * Reset the last 3 bits of global status register in case
> 		 * previous enabling causes overflows.
> 		 */
> 		wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, 0x7);
>   
>  		for (i = 0; i < 3; i++) {
>   			struct perf_event *event = cpuc->events[i];
> 			...
> 		}
> 
>   		wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x0);
> 

> I.e. global-mask, overflow-clear, explicit-enable, then global-enable?
Ingo,

wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x7) is global enable. So it's
global-enable, overflow-clear, explicit-enable, then global-disable?

Yanmin


