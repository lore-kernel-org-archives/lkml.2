Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687Ab2JBV6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 17:58:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48694 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585Ab2JBV6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 17:58:45 -0400
Date: Tue, 2 Oct 2012 23:58:36 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: Lockdep complains about commit 1331e7a1bb ("rcu: Remove
 _rcu_barrier() dependency on __stop_machine()")
In-Reply-To: <alpine.LNX.2.00.1210022331130.23544@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1210022356370.23544@pobox.suse.cz>
References: <alpine.LNX.2.00.1210021810350.23544@pobox.suse.cz> <20121002170149.GC2465@linux.vnet.ibm.com> <alpine.LNX.2.00.1210022324050.23544@pobox.suse.cz> <alpine.LNX.2.00.1210022331130.23544@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2012, Jiri Kosina wrote:

> > > > 1331e7a1bbe1f11b19c4327ba0853bee2a606543 is the first bad commit
> > > > commit 1331e7a1bbe1f11b19c4327ba0853bee2a606543
> > > > Author: Paul E. McKenney <paul.mckenney@linaro.org>
> > > > Date:   Thu Aug 2 17:43:50 2012 -0700
> > > > 
> > > >     rcu: Remove _rcu_barrier() dependency on __stop_machine()
> > > >     
> > > >     Currently, _rcu_barrier() relies on preempt_disable() to prevent
> > > >     any CPU from going offline, which in turn depends on CPU hotplug's
> > > >     use of __stop_machine().
> > > >     
> > > >     This patch therefore makes _rcu_barrier() use get_online_cpus() to
> > > >     block CPU-hotplug operations.  This has the added benefit of removing
> > > >     the need for _rcu_barrier() to adopt callbacks:  Because CPU-hotplug
> > > >     operations are excluded, there can be no callbacks to adopt.  This
> > > >     commit simplifies the code accordingly.
> > > >     
> > > >     Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > > >     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > >     Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> > > > ==
> > > > 
> > > > is causing lockdep to complain (see the full trace below). I haven't yet 
> > > > had time to analyze what exactly is happening, and probably will not have 
> > > > time to do so until tomorrow, so just sending this as a heads-up in case 
> > > > anyone sees the culprit immediately.
> > > 
> > > Hmmm...  Does the following patch help?  It swaps the order in which
> > > rcu_barrier() acquires the hotplug and rcu_barrier locks.
> > 
> > It changed the report slightly (see for example the change in possible 
> > unsafe locking scenario, rcu_sched_state.barrier_mutex vanished and it's 
> > now directly about cpu_hotplug.lock). With the patch applied I get
> > 
> > 
> > 
> > ======================================================
> > [ INFO: possible circular locking dependency detected ]
> > 3.6.0-03888-g3f99f3b #145 Not tainted
> 
> And it really seems valid. 
> 
> kmem_cache_destroy() calls rcu_barrier() with slab_mutex locked, which 
> introduces slab_mutex -> cpu_hotplug.lock dependency (through 
> rcu_barrier() -> _rcu_barrier() -> get_online_cpus()).
> 
> On the other hand, _cpu_up() acquires cpu_hotplug.lock through 
> cpu_hotplug_begin(), and with this lock held cpuup_callback() notifier 
> gets called, which acquires slab_mutex. This gives the reverse dependency, 
> i.e. deadlock scenario is valid one.
> 
> 1331e7a1bbe1f11b19c4327ba0853bee2a606543 is triggering this, because 
> before that, there was no slab_mutex -> cpu_hotplug.lock dependency.
> 
> Simply put, the commit causes get_online_cpus() to be called with 
> slab_mutex held, which is invalid.

Oh, and it seems to be actually triggering in real.

With HEAD being 974a847e00c, machine suspends nicely. With 974a847e00c + 
your patch, changing the order in which rcu_barrier() acquires hotplug and 
rcu_barrier locks, the machine hangs 100% reliably during suspend, which 
very likely actually is the deadlock described above.

-- 
Jiri Kosina
SUSE Labs
