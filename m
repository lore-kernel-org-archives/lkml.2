Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab2I0Fru (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 01:47:50 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:60548 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639Ab2I0Frs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 01:47:48 -0400
Date: Thu, 27 Sep 2012 07:47:42 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Nikolay Ulyanitsky <lystor@gmail.com>, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
Message-ID: <20120927054742.GA4370@gmail.com>
References: <1348538258.7100.23.camel@marge.simpson.net>
 <CA+55aFxw5yab4f=+KwB59RjRNXEhQZ==QEvQeLhEczKCTQK9wg@mail.gmail.com>
 <1348574286.3881.40.camel@twins>
 <20120925131736.GA30652@x1.osrc.amd.com>
 <20120925170058.GC30158@x1.osrc.amd.com>
 <CA+55aFzf=CApkYn+m5omwg+9-9i=11vj=7OMxKrCKb0qc-oBgg@mail.gmail.com>
 <20120926163233.GA5339@x1.osrc.amd.com>
 <CA+55aFzC1GZG8+Gv9KmAcV=RGU+hw39hwC9AjfYVqiJ84qAYkw@mail.gmail.com>
 <20120926213723.GA27692@liondog.tnic>
 <1348722568.7059.115.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348722568.7059.115.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> I think the pgbench problem is more about latency for the 1 in 
> 1:N than spinlocks.

So my understanding of the psql workload is that basically we've 
got a central psql proxy process that is distributing work to 
worker psql processes. If a freshly woken worker process ever 
preempts the central proxy process then it is preventing a lot 
of new work from getting distributed.

Correct?

So the central proxy psql process is 'much more important' to 
run than any of the worker processes - an importance that is not 
(currently) visible from the behavioral statistics the scheduler 
keeps on tasks.

So the scheduler has the following problem here: a new wakee 
might be starved enough and the proxy might have run long enough 
to really justify the preemption here and now. The buddy 
statistics help avoid some of these cases - but not all and the 
difference is measurable.

Yet the 'best' way for psql to run is for this proxy process to 
never be preempted. Your SCHED_BATCH experiments confirmed that.

The way remote CPU selection affects it is that if we ever get 
more aggressive in selecting a remote CPU then we, as a side 
effect, also reduce the chance of harmful preemption of the 
central proxy psql process.

So in that sense sibling selection is somewhat of an indirect 
red herring: it really only helps psql indirectly by preventing 
the harmful preemption. It also, somewhat paradoxially argues 
for suboptimal code: for example tearing apart buddies is 
beneficial in the psql workload, because it also allows the more 
important part of the buddy to run more (the proxy).

In that sense the *real* problem isnt even parallelism (although 
we obviously should improve the decisions there - and the logic 
has suffered in the past from the psql dilemma outlined above), 
but whether the scheduler can (and should) identify the central 
proxy and keep it running as much as possible, deprioritizing 
fairness, wakeup buddies, runtime overlap and cache affinity 
considerations.

There's two broad solutions that I can see:

 - Add a kernel solution to somehow identify 'central' processes
   and bias them. Xorg is a similar kind of process, so it would
   help other workloads as well. That way lie dragons, but might
   be worth an attempt or two. We already try to do a couple of
   robust metrics, like overlap statistics to identify buddies. 

 - Let user-space occasionally identify its important (and less
   important) tasks - say psql could mark it worker processes as
   SCHED_BATCH and keep its central process(es) higher prio. A
   single line of obvious code in 100 KLOCs of user-space code.

Just to confirm, if you turn off all preemption via a hack 
(basically if you turn SCHED_OTHER into SCHED_BATCH), does psql 
perform and scale much better, with the quality of sibling 
selection and spreading of processes only being a secondary 
effect?

Thanks,

	Ingo
