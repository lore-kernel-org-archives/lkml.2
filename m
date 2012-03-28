Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021Ab2C1Nwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 09:52:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754854Ab2C1Nwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 09:52:33 -0400
Date: Wed, 28 Mar 2012 15:51:40 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 39/39] autonuma: NUMA scheduler SMT awareness
Message-ID: <20120328135140.GD5906@redhat.com>
References: <1332783986-24195-1-git-send-email-aarcange@redhat.com>
 <1332783986-24195-40-git-send-email-aarcange@redhat.com>
 <1332788223.16159.185.camel@twins>
 <20120327000012.GC5906@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120327000012.GC5906@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 02:00:12AM +0200, Andrea Arcangeli wrote:
> On Mon, Mar 26, 2012 at 08:57:03PM +0200, Peter Zijlstra wrote:
> > On Mon, 2012-03-26 at 19:46 +0200, Andrea Arcangeli wrote:
> > > Add SMT awareness to the NUMA scheduler so that it will not move load
> > > from fully idle SMT threads, to semi idle SMT threads.
> > 
> > This shows a complete fail in design, you're working around the regular
> > scheduler/load-balancer instead of with it and hence are duplicating all
> > kinds of stuff.
> > 
> > I'll not have that..
> 
> I think here you're misunderstanding implementation issues with
> design.
> 
> I already mentioned the need of closer integration in CFS as point 4
> of my TODO list in the first email of this thread. The current

I pushed an autonuma-alpha11 branch where I dropped the SMT logic
entirely from the AutoNUMA scheduler. The one you naked. Not just
that, I dropped the idle balancing as well.

It seems slower to react but its active idle balancing is smarter and
in average it's maxing out the memory channels bandwidth better now.

I hope I eliminated the code duplication. What remains AutoNUMA is the
NUMA load active balancing which CFS has zero clues about.

I did a full regression test and it passed it, and now multi instance
stream shall also run much faster with nr_process > 1 and nr_process <
nr_cpus/2.

About the need of closer integration with CFS, note also that your
kernel/sched/numa.c code was doing things like:

+       // XXX should be sched_domain aware
+       for_each_online_node(node) {

So I hope you will understand why I had to took a bit of shortcuts but
over time I'm fully committed to integrate numa.c better wherever
possible and especially remove the call at every schedule so it will
scale fine to thousand of CPUs. It's just not trivial to do it.

About your code, I've an hard time to believe that driving the
scheduler depending on an home node static placement decided at
exec/fork like your code does, could have a chance to compete with the
AutoNUMA math for workloads with very variable load and several
threads and processes going idle and loading the CPUs again. Real life
unfortunately isn't as trivial as a multi instance stream. I believe
you can handle multi instance streams ok though.
