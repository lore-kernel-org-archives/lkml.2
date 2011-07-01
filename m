Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab1GADLr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 23:11:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:40560 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850Ab1GADLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 23:11:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,456,1304319600"; 
   d="scan'208";a="22202193"
Subject: Re: [PATCH 0/4] perf: Intel uncore pmu counting support
From: Lin Ming <ming.m.lin@intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <CABPqkBRZf41wbJKq2PCdMzDhgNMn0VYkVsaZToS34AXpRzTGLw@mail.gmail.com>
References: <1309421396-17438-1-git-send-email-ming.m.lin@intel.com>
	 <CABPqkBRs1nd7KptkVCg5QeG0AJJck=VHAgCpSOJKpOgdDuN-6A@mail.gmail.com>
	 <CABPqkBRZf41wbJKq2PCdMzDhgNMn0VYkVsaZToS34AXpRzTGLw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Jul 2011 11:17:10 +0800
Message-ID: <1309490230.24590.93.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-01 at 00:27 +0800, Stephane Eranian wrote:
> On Thu, Jun 30, 2011 at 2:10 PM, Stephane Eranian <eranian@google.com> wrote:
> > On Thu, Jun 30, 2011 at 10:09 AM, Lin Ming <ming.m.lin@intel.com> wrote:
> >> Hi, all
> >>
> >> I posted uncore patches months ago, but it was pended due to an uncore
> >> interrupt problem.
> >>
> >> This series are cut to support uncore pmu counting only.
> >> So uncore interrupt handling is not needed.
> >>
> > You're making the assumption that when counting, you can never construct
> > a measurement that will cause a counter to overflow the 39 bits. If not, then
> > you need interrupt handling even when counting.
> >
> The actual counter width is 48. But wrmsrl() can only write the bottom 32 bits
> of a register. I think Intel fixed that only with SandyBridge (see Vol3b). Thus,
> the risk of 'silent' wrap around is much higher now as you have only 31 bits
> to play with.

I just tested wrmsrl on uncore counters and it's surprised to me that it
supports full write.

	val64.low  = 0xFFFFEEEE;
	val64.high = 0x12345678;

On Nehalem/Westmere:

	msr = 0x3b0; //NHM_MSR_UNCORE_PMC0
	wrmsrl(msr, val64.full & 0xfffffffffff); //48 bits counter
	rdmsrl(msr, val64.full);
        printfk("counter value: 0x%llx\n", val64.full);

I got:
	counter value: 0x5678ffffeeee

On SandyBridge:

	msr = 0x716; //SNB_MSR_UNC_CBO_1_PER_CTR0
	wrmsrl(msr, val64.full & 0xfffffffffff); //44 bits counter
	rdmsrl(msr, val64.full);
        printfk("counter value: 0x%llx\n", val64.full);

I got:
	counter value: 0x678ffffeeee

> 
> But if I read your patch correctly, it seems you are avoiding wrmsrl() on the
> counter. Instead, you are reading it when you start (prev_count) and using
> that value to compute the delta on stop.
> 
> Am I understanding your workaround correctly?

Yes, but I didn't realize that it's a workaround.

Lin Ming

> 
> 
> >
> >> The uncore pmu type is allocated dynamically and exported via sysfs.
> >> $ cat /sys/bus/event_source/devices/uncore/type
> >> 6
> >>
> >> You can count uncore raw events as below,
> >> $ perf stat -e uncore:r0101 ls
> >>
> >> It reads uncore pmu type id from sysfs to setup perf_event_attr::type.
> >>
> >> Comments are appreciated.
> >>
> >> Thanks,
> >> Lin Ming
> >>
> >>
> >


