Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab2C0QU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 12:20:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:53549 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333Ab2C0QUZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 12:20:25 -0400
Message-ID: <1332865192.16159.243.camel@twins>
Subject: Re: [PATCH 07/39] autonuma: introduce kthread_bind_node()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrea Arcangeli <aarcange@redhat.com>
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
Date: Tue, 27 Mar 2012 18:19:52 +0200
In-Reply-To: <20120327160422.GR5906@redhat.com>
References: <1332783986-24195-1-git-send-email-aarcange@redhat.com>
	 <1332783986-24195-8-git-send-email-aarcange@redhat.com>
	 <1332786755.16159.174.camel@twins> <20120327152209.GL5906@redhat.com>
	 <1332863135.16159.239.camel@twins> <20120327160422.GR5906@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-27 at 18:04 +0200, Andrea Arcangeli wrote:
> On Tue, Mar 27, 2012 at 05:45:35PM +0200, Peter Zijlstra wrote:
> > On Tue, 2012-03-27 at 17:22 +0200, Andrea Arcangeli wrote:
> > > I don't see what's wrong with more than 1 CPU in the hard bind
> > > cpumask.
> > 
> > Because its currently broken, but we're trying to restore its pure
> > semantic so that we can use it in more places again, like
> > debug_smp_processor_id(). Testing a single process flag is _much_
> > cheaper than testing ->cpus_allowed.
> > 
> > Adding more broken isn't an option.
> 
> I would suggest you to use a new bitflag for that _future_
> optimization that you plan to do without altering the way the current
> bitflag works.
> 
> I doubt knuma_migrated will ever be the only kernel thread that wants
> to run with a NUMA NODE-wide CPU binding (instead of single-CPU
> binding).
> 
> Being able to keep using this bitflag for NUMA-wide bindings too in
> the future as well (after you do the optimization you planned), is
> going to reduce the chances of the root user shooting himself in the
> foot for both the kernel thread node-BIND and the single-cpu-BIND.

But then the current flag is a mis-nomer. Also, there's no correctness
issue with the per-node threads, its perfectly fine if they run some
place else so I don't think we should restrict userspace to force them
away from their preferred node.

So even if you were to introduce a new flag, I'd still object.

The only reason to ever refuse userspace moving a task around is if it
will break stuff. Worst that can happen with a node affine thread is
that it'll incur remote memory penalties, that's not fatal.
