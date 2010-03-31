Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933435Ab0CaOCL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 10:02:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:43806 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933284Ab0CaOCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 10:02:09 -0400
Subject: Re: [RFC] perf_events: support for uncore a.k.a. nest units
From: Peter Zijlstra <peterz@infradead.org>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
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
In-Reply-To: <4BB27764.2060802@linux.vnet.ibm.com>
References: <4B560ACD.4040206@linux.vnet.ibm.com>
	 <d3f22a1003290213x7d7904an59d50eb6a8616133@mail.gmail.com>
	 <1269934931.8575.6.camel@minggr.sh.intel.com>
	 <4BB22BB0.8030208@linux.vnet.ibm.com> <1269969305.5258.479.camel@laptop>
	 <4BB27764.2060802@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Mar 2010 16:01:56 +0200
Message-ID: <1270044116.1616.26.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-30 at 15:12 -0700, Corey Ashford wrote:
> 
> > Initially I'd not allow per-pmu-per-task contexts
> > because then things like perf_event_task_sched_out() would get rather
> > complex.
> 
> Definitely.  I don't think it makes sense to have per-task context on 
> nest/uncore PMUs.  At least we haven't found any justification for it.

For uncore no, but there is also the hw-breakpoint stuff that is being
presented as a pmu, for those it would make sense to have a separate
per-task context.

But doing multiple per-task contexts is something for a next step
indeed.

> > For RR we can move away from perf_event_task_tick and let the pmu
> > install a (hr)timer for this on their own.
> 
> This is necessary I think, because of the access time for some of the PMU's.  I 
> wonder though if it should, perhaps optionally, be off-loaded to a high-priority 
> task to do the switching so that access latency to the PMU can be controlled.
> 
> As I mentioned when we met, some of the Wire-Speed processor nest PMU control 
> registers are accessed via SCOM, which is an internal, 200 MHz serial bus.  We 
> are being quoted ~525 SCOM bus ticks to do a PMU control register access, which 
> comes out to about 2.5 microseconds.  If you figure 5 accesses to rotate the 
> events on a PMU, that's a minimum of 12.5 microseconds. 

Yeah, you mentioned that.. for those things we need some changes anyway,
since currently we install per-cpu counters using IPIs and expect the
pmu::enable() method to be synchronous (it has a return value). It would
be totally unacceptable to do 2.5ms pokes with IRQs disabled.

The RR thing would be the easiest to solve, just let the timer wake up a
thread instead of doing the work itself, that's fully isolated to how
the pmu chooses to implement that. The above mentioned issue however
would be much more challenging to fix nicely.



