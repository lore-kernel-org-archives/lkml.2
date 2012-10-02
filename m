Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672Ab2JBXby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 19:31:54 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:46098 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782Ab2JBXbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 19:31:53 -0400
Date: Tue, 2 Oct 2012 16:31:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: Lockdep complains about commit 1331e7a1bb ("rcu: Remove
 _rcu_barrier() dependency on __stop_machine()")
Message-ID: <20121002233138.GD2465@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LNX.2.00.1210021810350.23544@pobox.suse.cz>
 <20121002170149.GC2465@linux.vnet.ibm.com>
 <alpine.LNX.2.00.1210022324050.23544@pobox.suse.cz>
 <alpine.LNX.2.00.1210022331130.23544@pobox.suse.cz>
 <alpine.LNX.2.00.1210022356370.23544@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1210022356370.23544@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12100223-7282-0000-0000-00000D8E4ABB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 11:58:36PM +0200, Jiri Kosina wrote:
> On Tue, 2 Oct 2012, Jiri Kosina wrote:
> 
> > > > > 1331e7a1bbe1f11b19c4327ba0853bee2a606543 is the first bad commit
> > > > > commit 1331e7a1bbe1f11b19c4327ba0853bee2a606543
> > > > > Author: Paul E. McKenney <paul.mckenney@linaro.org>
> > > > > Date:   Thu Aug 2 17:43:50 2012 -0700
> > > > > 
> > > > >     rcu: Remove _rcu_barrier() dependency on __stop_machine()
> > > > >     
> > > > >     Currently, _rcu_barrier() relies on preempt_disable() to prevent
> > > > >     any CPU from going offline, which in turn depends on CPU hotplug's
> > > > >     use of __stop_machine().
> > > > >     
> > > > >     This patch therefore makes _rcu_barrier() use get_online_cpus() to
> > > > >     block CPU-hotplug operations.  This has the added benefit of removing
> > > > >     the need for _rcu_barrier() to adopt callbacks:  Because CPU-hotplug
> > > > >     operations are excluded, there can be no callbacks to adopt.  This
> > > > >     commit simplifies the code accordingly.
> > > > >     
> > > > >     Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > > > >     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > > >     Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> > > > > ==
> > > > > 
> > > > > is causing lockdep to complain (see the full trace below). I haven't yet 
> > > > > had time to analyze what exactly is happening, and probably will not have 
> > > > > time to do so until tomorrow, so just sending this as a heads-up in case 
> > > > > anyone sees the culprit immediately.
> > > > 
> > > > Hmmm...  Does the following patch help?  It swaps the order in which
> > > > rcu_barrier() acquires the hotplug and rcu_barrier locks.
> > > 
> > > It changed the report slightly (see for example the change in possible 
> > > unsafe locking scenario, rcu_sched_state.barrier_mutex vanished and it's 
> > > now directly about cpu_hotplug.lock). With the patch applied I get
> > > 
> > > 
> > > 
> > > ======================================================
> > > [ INFO: possible circular locking dependency detected ]
> > > 3.6.0-03888-g3f99f3b #145 Not tainted
> > 
> > And it really seems valid. 

Yep, it sure is.  I wasn't getting the full picture earlier, so please
accept my apologies for the bogus patch.

> > kmem_cache_destroy() calls rcu_barrier() with slab_mutex locked, which 
> > introduces slab_mutex -> cpu_hotplug.lock dependency (through 
> > rcu_barrier() -> _rcu_barrier() -> get_online_cpus()).
> > 
> > On the other hand, _cpu_up() acquires cpu_hotplug.lock through 
> > cpu_hotplug_begin(), and with this lock held cpuup_callback() notifier 
> > gets called, which acquires slab_mutex. This gives the reverse dependency, 
> > i.e. deadlock scenario is valid one.
> > 
> > 1331e7a1bbe1f11b19c4327ba0853bee2a606543 is triggering this, because 
> > before that, there was no slab_mutex -> cpu_hotplug.lock dependency.
> > 
> > Simply put, the commit causes get_online_cpus() to be called with 
> > slab_mutex held, which is invalid.
> 
> Oh, and it seems to be actually triggering in real.
> 
> With HEAD being 974a847e00c, machine suspends nicely. With 974a847e00c + 
> your patch, changing the order in which rcu_barrier() acquires hotplug and 
> rcu_barrier locks, the machine hangs 100% reliably during suspend, which 
> very likely actually is the deadlock described above.

Indeed.  Slab seems to be doing an rcu_barrier() in a CPU hotplug
notifier, which doesn't sit so well with rcu_barrier() trying to exclude
CPU hotplug events.  I could go back to the old approach, but it is
significantly more complex.  I cannot say that I am all that happy
about anyone calling rcu_barrier() from a CPU hotplug notifier because
it doesn't help CPU hotplug latency, but that is a separate issue.

But the thing is that rcu_barrier()'s assumptions work just fine if either
(1) it excludes hotplug operations or (2) if it is called from a hotplug
notifier.  You see, either way, the CPU cannot go away while rcu_barrier()
is executing.  So the right way to resolve this seems to be to do the
get_online_cpus() only if rcu_barrier() is -not- executing in the context
of a hotplug notifier.  Should be fixable without too much hassle...

							Thanx, Paul

