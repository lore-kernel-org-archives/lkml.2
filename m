Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab0CWUaT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 16:30:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:44171 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab0CWUaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 16:30:17 -0400
Subject: Re: [PATCH 0/3] sched: use EDF to throttle RT task groups v2
From: Peter Zijlstra <peterz@infradead.org>
To: Fabio Checconi <fchecconi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Paul Turner <pjt@google.com>,
       Dario Faggioli <faggioli@gandalf.sssup.it>,
       Michael Trimarchi <michael@evidence.eu.com>,
       Dhaval Giani <dhaval@retis.sssup.it>,
       Tommaso Cucinotta <t.cucinotta@sssup.it>, linux-kernel@vger.kernel.org
In-Reply-To: <20100303170110.GS2490@gandalf.sssup.it>
References: <cover.1266931410.git.fabio@helm.retis>
	 <1267273991.22519.744.camel@laptop>
	 <20100303170110.GS2490@gandalf.sssup.it>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Mar 2010 21:30:07 +0100
Message-ID: <1269376207.5283.5.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-03 at 18:01 +0100, Fabio Checconi wrote: 
> > From: Peter Zijlstra <peterz@infradead.org>
> > Date: Sat, Feb 27, 2010 01:33:11PM +0100
> >
> > On Tue, 2010-02-23 at 19:56 +0100, Fabio Checconi wrote:
> > >   - Since it is not easy to mix tasks and groups on the same scheduler
> > >     queue (tasks have no deadlines), the bandwidth reserved to the tasks
> > >     in a group is controlled with two additional cgroup attributes:
> > >     rt_task_runtime_us and rt_task_period_us.  These attributes control,
> > >     within a cgroup, how much bandwidth is reserved to the tasks it
> > >     contains.  The old attributes, rt_runtime_us and rt_period_us, are
> > >     still there, and control the bandwidth assigned to the cgroup.  They
> > >     are used only for admission control. 
> > 
> > We could do this implicitly by simply setting the task_bandwidth to the
> > cgroup bandwidth - \Sum_children bandwidth.
> > 
> > Having it explicit gives the administrator slightly more control at the
> > cost of a more complex interface.
> > 
> > Just wondering if you thought about this trade-off?
> 
> I started with it, because I didn't like changing the interface and
> because four files to manage the bandwidth *are* a nightmare from the
> user perspective...  The problem with using only two files and assign
> the residual bandwidth to the tasks in the group is that it makes really
> hard to find out how much bw is allocated to the tasks, esp. when
> the child groups have different periods.  In practice we would be
> guaranteeing something but the user would have a hard time finding
> out what...

Right, we could do both, by allowing the task files to have -1 values,
effectively disabling their reservation and thus ending up with whatever
remains or so.

> The biggest problem with the four files used in the current implementation
> is that bandwidth assignments should be atomic (because setting all the
> parameters independently can force the system to go through non-feasible
> assignments, and the order to use when assigning runtime and period
> changes depending on the direction of the change).  I know this is a
> dangerous question, but I'll try it anyway: are we ready for multi-valued
> cgroup parameters?

Right, I don't know about multi-valued files, that sounds like its going
to confuse people too.

Another option might be some transactional interface, but not sure how
that would work out either.. maybe by toggling the system wide bandwidth
control off and on, not sure who's in charge of cgroupfs anyway. 

