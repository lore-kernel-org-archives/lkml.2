Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab1AQIoz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 03:44:55 -0500
Received: from smtp-out.google.com ([74.125.121.67]:5303 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab1AQIoy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 03:44:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=yIk+XpNZmzJiNM+zUbUWqsOohXFH0xJqcujPZXsuLrx84MZAYGfwJAHnSyIYS9zvXk
         L/N1uA/9LZ17ClFPQEhg==
MIME-Version: 1.0
In-Reply-To: <1295227769.28388.82.camel@minggr.sh.intel.com>
References: <1291267223.2405.314.camel@minggr.sh.intel.com>
	<AANLkTikZgmUQ2SHOL41_t-Vwss8T6tazTRJT2bVR+xRQ@mail.gmail.com>
	<1295227769.28388.82.camel@minggr.sh.intel.com>
Date: Mon, 17 Jan 2011 09:44:50 +0100
Message-ID: <AANLkTinGWPABoYszmbLcSRroFg74e6mpz=5FK7-C9cKK@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3 v3] perf: Implement Nehalem uncore pmu
From: Stephane Eranian <eranian@google.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Andi Kleen <andi@firstfloor.org>,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 17, 2011 at 2:29 AM, Lin Ming <ming.m.lin@intel.com> wrote:
> On Fri, 2011-01-14 at 01:14 +0800, Stephane Eranian wrote:
>> Lin,
>
> Hi, Stephane,
>
> Sorry for late response, I'm just back from vacation.
>
>>
>> On Thu, Dec 2, 2010 at 6:20 AM, Lin Ming <ming.m.lin@intel.com> wrote:
>> > +static void uncore_pmu_enable_all(int nmi_core)
>> > +{
>> > +       u64 ctrl;
>> > +
>> > +       ctrl = ((1 << UNCORE_NUM_GENERAL_COUNTERS) - 1) | MSR_UNCORE_PERF_GLOBAL_CTRL_EN_FC0;
>> > +
>> > +       /* Route all interrupts to the first core that accesses uncore */
>> > +       ctrl |= 1ULL << (48 + nmi_core);
>> > +
>> > +       wrmsrl(MSR_UNCORE_PERF_GLOBAL_CTRL, ctrl);
>> > +}
>>
>> Are you sure nmi_core is always between 0-3 on a 4-core system and 0-5
>> on a 6-core system?
>> In other words, is that what topology_core_id(raw_smp_processor_id()) returns?
>
> I just have a look at a 6-core system, the core id is not 0-5
>
> $ cat /proc/cpuinfo |grep "core id"
> core id         : 0
> core id         : 1
> core id         : 2
> core id         : 8
> core id         : 9
> core id         : 10
>
> So we'd better route all the interrupts to the first core of the socket.
>
I recently realized the issue with 0,1,2,8,9,10. At the time I wrote the perfmon
support for uncore, those systems did not exist. Sparse APIC id is a major pain
for uncore PMU interrupt routine given the way UNC_GLOBAL_CTRL works.

Unfortunately, routing to core 0 (core_cpu_id=0) won't be enough in the
presence of HOTPLUG CPU. Imagine I disable the first three 3 cores.
Now you the cpu you have to play with are 8,9,10. You need to remap
to a number between 0-5.


> Thanks for the catch.
> Lin Ming
>
>>
>> Note that, unfortunately, I have not seen documentation that says on
>> 6-core system
>> UNC_GLOBAL_CTRL has 6 interrupt target bits, but it would make sense.
>>
>>
>> Otherwise, you will get a kernel panic when you wrmsr UNC_GLOBAL_CTRL.
>>
>> > +
>> > +       if (uncore->n_events == 1) {
>> > +               nmi_core = topology_core_id(raw_smp_processor_id());
>> > +               uncore->nmi_core = nmi_core;
>> > +               uncore_pmu_enable_all(nmi_core);
>> > +       }
>
>
>
