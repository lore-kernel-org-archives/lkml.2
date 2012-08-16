Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932703Ab2HPOcH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 10:32:07 -0400
Received: from service87.mimecast.com ([91.220.42.44]:40190 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932690Ab2HPOcD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 10:32:03 -0400
Date: Thu, 16 Aug 2012 15:31:45 +0100
From: Morten Rasmussen <Morten.Rasmussen@arm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Alex Shi <alex.shi@intel.com>, Suresh Siddha <suresh.b.siddha@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
Message-ID: <20120816143145.GI2213@e103687>
References: <5028F12C.7080405@intel.com>
 <1345028738.31459.82.camel@twins>
MIME-Version: 1.0
In-Reply-To: <1345028738.31459.82.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 16 Aug 2012 14:33:42.0928 (UTC) FILETIME=[22AA8100:01CD7BBC]
X-MC-Unique: 112081615315913701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On Wed, Aug 15, 2012 at 12:05:38PM +0100, Peter Zijlstra wrote:
> > 
> > sub proposal:
> > 1, If it's possible to balance task on idlest cpu not appointed 'balance
> > cpu'. If so, it may can reduce one more time balancing.
> > The idlest cpu can prefer the new idle cpu;  and is the least load cpu;
> > 2, se or task load is good for running time setting.
> > but it should the second basis in load balancing. The first basis of LB
> > is running tasks' number in group/cpu. Since whatever of the weight of
> > groups is, if the tasks number is less than cpu number, the group is
> > still has capacity to take more tasks. (will consider the SMT cpu power
> > or other big/little cpu capacity on ARM.)
> 
> Ah, no we shouldn't balance on nr_running, but on the amount of time
> consumed. Imagine two tasks being woken at the same time, both tasks
> will only run a fraction of the available time, you don't want this to
> exceed your capacity because ran back to back the one cpu will still be
> mostly idle.
> 
> What you want it to keep track of a per-cpu utilization level (inverse
> of idle-time) and using PJTs per-task runnable avg see if placing the
> new task on will exceed the utilization limit.
> 
> I think some of the Linaro people actually played around with this,
> Vincent?
>

I agree. A better measure of cpu load and task weight than nr_running
and the current task load weight are necessary to do proper task
packing.

I have used PJTs per-task load-tracking for scheduling experiments on
heterogeneous systems and my experience is that it works quite well for
determining the load of a specific task. Something like PJTs work
would be a good starting point for power aware scheduling and better
support for heterogeneous systems.

One of the biggest challenges here for load-balancing is translating
task load from one cpu to another as the task load is influenced by the
total load of its cpu. So a task that appears to be heavy on an
oversubscribed cpu might not be so heavy after all when it is moved to a
cpu with plenty cpu time to spare. This issue is likely to be more
pronounced on heterogeneous systems and system with aggressive frequency
scaling. It might be possible to avoid having to translate load or that
it doesn't really matter, but I haven't completely convinced myself yet.

My point is that getting the task load right or at least better is a
fundamental requirement for improving power aware scheduling.

Best regards,
Morten

