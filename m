Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab0C3RPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 13:15:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:36307 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab0C3RPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 13:15:11 -0400
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
In-Reply-To: <4BB22BB0.8030208@linux.vnet.ibm.com>
References: <4B560ACD.4040206@linux.vnet.ibm.com>
	 <d3f22a1003290213x7d7904an59d50eb6a8616133@mail.gmail.com>
	 <1269934931.8575.6.camel@minggr.sh.intel.com>
	 <4BB22BB0.8030208@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Mar 2010 19:15:05 +0200
Message-ID: <1269969305.5258.479.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-30 at 09:49 -0700, Corey Ashford wrote:
> On 03/30/2010 12:42 AM, Lin Ming wrote:
> > Hi, Corey
> >
> > How is this going now? Are you still working on this?
> > I'd like to help to add support for uncore, test, write code or anything
> > else.
> >
> > Thanks,
> > Lin Ming
> 
> I haven't been actively working on adding infrastructure for nest PMUs 
> yet.  At the moment we are working on supporting nest events for IBM's 
> Wire-Speed processor, using the current infrastructure, because of the 
> time limitations.  Using the existing infrastructure is definitely not 
> ideal, but for this processor, it's workable.
> 
> There are still a lot of issues to solve for adding this infrastructure:
> 
> 1) Does perf_events need a new context type (in addition to per-task and 
> per-cpu)?  This is partly because we don't want to be mixing the 
> rotation of CPU-events with nest events.  Each PMU really ought to have 
> its own event list.
> 
> 2) How do we deal with accessing PMU's which require slow access methods 
> (e.g. internal serial bus)?  The accesses may need to be placed on 
> worker threads so that they don't affect the performance of context 
> switches and system ticks.
> 
> 3) How exactly do we represent the PMU's in the pseudofs (/sys or 
> /proc)?  And how exactly does the user specify the PMU to perf_events?
> Peter Zijlstra and Stephane Eranian both recommended opening the PMU 
> with open() and then passing the resulting fd in through the 
> perf_event_attr struct.
> 
> 4) How do we choose a CPU to do the housekeeping work for a particular 
> nest PMU.  Peter thought that user space should still specify the it via 
> open_perf_event() cpu parameter, but there's also an argument to be made 
> for the kernel choosing the best CPU to handle the job, or at least make 
> it optional for the user to choose the CPU.
> 
> I'm sure there are other issues as well.  If you'd like to start working 
> on some (or all!) of these, you are more than welcome to.  I think we 
> need to toss around some more ideas before committing much to code at 
> this point.

Right, I've got some definite ideas on how to go here, just need some
time to implement them.

The first thing that needs to be done is get rid of all the __weak
functions (with exception of perf_callchain*, since that really is arch
specific).

For hw_perf_event_init() we need to create a pmu registration facility
and lookup a pmu_id, either passed as an actual id found in sysfs or an
open file handle from sysfs (the cpu pmu would be pmu_id 0 for backwards
compat).

hw_perf_disable/enable() would become struct pmu functions and
perf_disable/enable need to become per-pmu, most functions operate on a
specific event, for those we know the pmu and hence can call the per-pmu
version. (XXX find those sites where this is not true).

Then we can move to context, yes I think we want new context for new
PMUs, otherwise we get very funny RR interleaving problems. My idea was
to move find_get_context() into struct pmu as well, this allows you to
have per-pmu contexts. Initially I'd not allow per-pmu-per-task contexts
because then things like perf_event_task_sched_out() would get rather
complex.

For RR we can move away from perf_event_task_tick and let the pmu
install a (hr)timer for this on their own.

I've been planning to implement this for more than a week now, its just
that other stuff keeps getting in the way.

