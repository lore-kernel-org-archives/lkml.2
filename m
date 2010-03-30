Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab0C3WNF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 18:13:05 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:46289 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822Ab0C3WNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 18:13:01 -0400
Message-ID: <4BB27764.2060802@linux.vnet.ibm.com>
Date: Tue, 30 Mar 2010 15:12:52 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
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
References: <4B560ACD.4040206@linux.vnet.ibm.com> <d3f22a1003290213x7d7904an59d50eb6a8616133@mail.gmail.com> <1269934931.8575.6.camel@minggr.sh.intel.com> <4BB22BB0.8030208@linux.vnet.ibm.com> <1269969305.5258.479.camel@laptop>
In-Reply-To: <1269969305.5258.479.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/30/2010 10:15 AM, Peter Zijlstra wrote:
-- my comments snipped --
>
> Right, I've got some definite ideas on how to go here, just need some
> time to implement them.
>
> The first thing that needs to be done is get rid of all the __weak
> functions (with exception of perf_callchain*, since that really is arch
> specific).
>
> For hw_perf_event_init() we need to create a pmu registration facility
> and lookup a pmu_id, either passed as an actual id found in sysfs or an
> open file handle from sysfs (the cpu pmu would be pmu_id 0 for backwards
> compat).
>
> hw_perf_disable/enable() would become struct pmu functions and
> perf_disable/enable need to become per-pmu, most functions operate on a
> specific event, for those we know the pmu and hence can call the per-pmu
> version. (XXX find those sites where this is not true).

This sounds like a good idea.  Right now for the Wire-Speed processor, we have a 
loop that goes through all of the nest PMU's and calls their respective per-pmu 
functions.

>
> Then we can move to context, yes I think we want new context for new
> PMUs, otherwise we get very funny RR interleaving problems. My idea was
> to move find_get_context() into struct pmu as well, this allows you to
> have per-pmu contexts.

Yes, I think it makes a lot of sense, so that there's not some sort of fixed 
association of pmu contexts to cpu contexts, for example.

> Initially I'd not allow per-pmu-per-task contexts
> because then things like perf_event_task_sched_out() would get rather
> complex.

Definitely.  I don't think it makes sense to have per-task context on 
nest/uncore PMUs.  At least we haven't found any justification for it.

>
> For RR we can move away from perf_event_task_tick and let the pmu
> install a (hr)timer for this on their own.

This is necessary I think, because of the access time for some of the PMU's.  I 
wonder though if it should, perhaps optionally, be off-loaded to a high-priority 
task to do the switching so that access latency to the PMU can be controlled.

As I mentioned when we met, some of the Wire-Speed processor nest PMU control 
registers are accessed via SCOM, which is an internal, 200 MHz serial bus.  We 
are being quoted ~525 SCOM bus ticks to do a PMU control register access, which 
comes out to about 2.5 microseconds.  If you figure 5 accesses to rotate the 
events on a PMU, that's a minimum of 12.5 microseconds.

>
> I've been planning to implement this for more than a week now, its just
> that other stuff keeps getting in the way.
>

Well, it's not as if this is a trivial task either :)

- Corey

