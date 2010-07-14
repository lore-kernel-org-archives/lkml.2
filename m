Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab0GNCV4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 22:21:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:63724 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754665Ab0GNCVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 22:21:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,199,1278313200"; 
   d="scan'208";a="638284140"
Subject: Re: perf failed with kernel 2.6.35-rc
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTilk4JHmS8BoNcI1Cfa59wX6_qUkyoQD540ic_Zl@mail.gmail.com>
References: <1279008849.2096.913.camel@ymzhang.sh.intel.com>
	 <AANLkTilu4fi68DQpbzsKJrrAVUq_ZFbm2AVNvaPK7VKu@mail.gmail.com>
	 <1279066421.2096.920.camel@ymzhang.sh.intel.com>
	 <AANLkTilk4JHmS8BoNcI1Cfa59wX6_qUkyoQD540ic_Zl@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 14 Jul 2010 10:22:58 +0800
Message-Id: <1279074178.2096.933.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-14 at 02:36 +0200, Stephane Eranian wrote:
> What about running simpler commands like perf stat?
'perf stat ls' seems ok.
I compare the PMU register dumping info before and after 'perf stat ls'.
Some processors' bit0 of status registers become 0 from 1.

I can't guarantee all 'perf stat' is ok because it seems some processors
wouldn't collect perf statistics correctly while others seem ok.

'gdb perf' could work because one processor seems ok while others couldn't.
So 'gdb perf' actually miss some data.

> 
> 
> On Wed, Jul 14, 2010 at 2:13 AM, Zhang, Yanmin
> <yanmin_zhang@linux.intel.com> wrote:
> > On Tue, 2010-07-13 at 17:16 +0200, Stephane Eranian wrote:
> >> On Tue, Jul 13, 2010 at 10:14 AM, Zhang, Yanmin
> >> <yanmin_zhang@linux.intel.com> wrote:
> >> > Peter,
> >> >
> >> > perf doesn't work on my Nehalem EX machine.
> >> > 1) The 1st start of 'perf top' is ok;
> >> > 2) Kill the 1st perf and restart it. It doesn't work. No data is showed.
> >> >
> >> > I located below commit:
> >> > commit 1ac62cfff252fb668405ef3398a1fa7f4a0d6d15
> >> > Author: Peter Zijlstra <peterz@infradead.org>
> >> > Date:   Fri Mar 26 14:08:44 2010 +0100
> >> >
> >> >    perf, x86: Add Nehelem PMU programming errata workaround
> >> >
> >> >    workaround From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >> >    Date: Fri Mar 26 13:59:41 CET 2010
> >> >
> >> >    Implement the workaround for Intel Errata AAK100 and AAP53.
> >> >
> >> >    Also, remove the Core-i7 name for Nehalem events since there are
> >> >    also Westmere based i7 chips.
> >> >
> >> >
> >> > If I comment out the workaround in function intel_pmu_nhm_enable_all,
> >> > perf could work.
> >> >
> >> > A quick glance shows:
> >> > wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x3);
> >> > should be:
> >> > wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x7);
> >> >
> >> >
> >> > I triggered sysrq to dump PMU registers and found the last bit of
> >> > global status register is 1. I added a status reset operation like below patch:
> >> >
> >> What do you call the last bit? bit0 or bit63?
> > Sorry for confusing you. It's bit0, mapping to PERFMON_EVENTSEL0.
> >
> >>
> >> > --- linux-2.6.35-rc5/arch/x86/kernel/cpu/perf_event_intel.c     2010-07-14 09:38:11.000000000 +0800
> >> > +++ linux-2.6.35-rc5_fork/arch/x86/kernel/cpu/perf_event_intel.c        2010-07-14 14:41:42.000000000 +0800
> >> > @@ -505,8 +505,13 @@ static void intel_pmu_nhm_enable_all(int
> >> >                wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + 1, 0x4300B1);
> >> >                wrmsrl(MSR_ARCH_PERFMON_EVENTSEL0 + 2, 0x4300B5);
> >> >
> >> > -               wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x3);
> >> > +               wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x7);
> >> >                wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0x0);
> >> > +               /*
> >> > +                * Reset the last 3 bits of global status register in case
> >> > +                * previous enabling causes overflows.
> >> > +                */
> >>
> >> The workaround cannot cause on overflow because the associated counters
> >> won't count anything given their umask value is 0 (which does not correspond
> >> to anything for event 0xB1, event 0xB5 is undocumented). This is for the events
> >> described in table A.2. If NHM-EX has a different definition for 0xB1, 0xB5,
> >> then that's another story.
> > I found the status bit is set by triggering sysrq to dump PMU registers.
> >
> > If I start perf by gdb, sometimes, perf could work. I found one processor's 1st status
> > register is equal to 0 while other processors' are 1. If just starting perf, all 1st
> > status registers are equal to 1.
> >
> >>
> >>
> >> > +               wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, 0x7);
> >> >
> >> >                for (i = 0; i < 3; i++) {
> >> >                        struct perf_event *event = cpuc->events[i];
> >> >
> >> >
> >> >
> >> > However, it still doesn't work. Current right way is to comment out
> >> > the workaround.


