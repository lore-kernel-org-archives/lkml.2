Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946Ab0CaRvG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 13:51:06 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:41708 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920Ab0CaRvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 13:51:02 -0400
Message-ID: <4BB38B79.4040703@linux.vnet.ibm.com>
Date: Wed, 31 Mar 2010 10:50:49 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Dan Terpstra <terpstra@eecs.utk.edu>, Philip Mucci <mucci@eecs.utk.edu>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [RFC] perf_events: support for uncore a.k.a. nest units
References: <4B560ACD.4040206@linux.vnet.ibm.com> <d3f22a1003290213x7d7904an59d50eb6a8616133@mail.gmail.com> <1269934931.8575.6.camel@minggr.sh.intel.com> <4BB22BB0.8030208@linux.vnet.ibm.com> <1269969305.5258.479.camel@laptop> <4BB27764.2060802@linux.vnet.ibm.com> <1270044116.1616.26.camel@laptop>
In-Reply-To: <1270044116.1616.26.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2010 07:01 AM, Peter Zijlstra wrote:
> On Tue, 2010-03-30 at 15:12 -0700, Corey Ashford wrote:
>>
>>> Initially I'd not allow per-pmu-per-task contexts
>>> because then things like perf_event_task_sched_out() would get rather
>>> complex.
>>
>> Definitely.  I don't think it makes sense to have per-task context on
>> nest/uncore PMUs.  At least we haven't found any justification for it.
>
> For uncore no, but there is also the hw-breakpoint stuff that is being
> presented as a pmu, for those it would make sense to have a separate
> per-task context.
>
> But doing multiple per-task contexts is something for a next step
> indeed.
>
>>> For RR we can move away from perf_event_task_tick and let the pmu
>>> install a (hr)timer for this on their own.
>>
>> This is necessary I think, because of the access time for some of the PMU's.  I
>> wonder though if it should, perhaps optionally, be off-loaded to a high-priority
>> task to do the switching so that access latency to the PMU can be controlled.
>>
>> As I mentioned when we met, some of the Wire-Speed processor nest PMU control
>> registers are accessed via SCOM, which is an internal, 200 MHz serial bus.  We
>> are being quoted ~525 SCOM bus ticks to do a PMU control register access, which
>> comes out to about 2.5 microseconds.  If you figure 5 accesses to rotate the
>> events on a PMU, that's a minimum of 12.5 microseconds.
>
> Yeah, you mentioned that.. for those things we need some changes anyway,
> since currently we install per-cpu counters using IPIs and expect the
> pmu::enable() method to be synchronous (it has a return value).

That's a good point.  We hadn't considered this issue.

> It would
> be totally unacceptable to do 2.5ms pokes with IRQs disabled.

Just to be clear, it's 2.5us, not 2.5ms, but I think it's still bad... 
in our case, it's about 6600 processor clocks per access.

> The RR thing would be the easiest to solve, just let the timer wake up a
> thread instead of doing the work itself, that's fully isolated to how
> the pmu chooses to implement that. The above mentioned issue however
> would be much more challenging to fix nicely.

It seems like it might need to be done in two phases.  IPI request is 
sent, and then a thread is woken up on the other CPU, it does some work, 
and then sets a status variable and somehow notifies the caller that the 
operation has completed.  I don't know the kernel's communication 
mechanisms well enough to know which one is most appropriate - maybe rwsem?

- Corey
