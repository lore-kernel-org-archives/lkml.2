Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab2JBXsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 19:48:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51914 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756730Ab2JBXsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 19:48:31 -0400
Date: Wed, 3 Oct 2012 01:48:21 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: Lockdep complains about commit 1331e7a1bb ("rcu: Remove
 _rcu_barrier() dependency on __stop_machine()")
In-Reply-To: <20121002233138.GD2465@linux.vnet.ibm.com>
Message-ID: <alpine.LNX.2.00.1210030142570.23544@pobox.suse.cz>
References: <alpine.LNX.2.00.1210021810350.23544@pobox.suse.cz> <20121002170149.GC2465@linux.vnet.ibm.com> <alpine.LNX.2.00.1210022324050.23544@pobox.suse.cz> <alpine.LNX.2.00.1210022331130.23544@pobox.suse.cz> <alpine.LNX.2.00.1210022356370.23544@pobox.suse.cz>
 <20121002233138.GD2465@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2012, Paul E. McKenney wrote:

> Indeed.  Slab seems to be doing an rcu_barrier() in a CPU hotplug 
> notifier, which doesn't sit so well with rcu_barrier() trying to exclude 
> CPU hotplug events.  I could go back to the old approach, but it is 
> significantly more complex.  I cannot say that I am all that happy about 
> anyone calling rcu_barrier() from a CPU hotplug notifier because it 
> doesn't help CPU hotplug latency, but that is a separate issue.
> 
> But the thing is that rcu_barrier()'s assumptions work just fine if either
> (1) it excludes hotplug operations or (2) if it is called from a hotplug
> notifier.  You see, either way, the CPU cannot go away while rcu_barrier()
> is executing.  So the right way to resolve this seems to be to do the
> get_online_cpus() only if rcu_barrier() is -not- executing in the context
> of a hotplug notifier.  Should be fixable without too much hassle...

Sorry, I don't think I understand what you are proposing just yet.

If I understand it correctly, you are proposing to introduce some magic 
into _rcu_barrier() such as (pseudocode of course):

	if (!being_called_from_hotplug_notifier_callback)
		get_online_cpus()

How does that protect from the scenario I've outlined before though?

	CPU 0                           CPU 1
	kmem_cache_destroy()
	mutex_lock(slab_mutex)
					_cpu_up()
					cpu_hotplug_begin()
					mutex_lock(cpu_hotplug.lock)
	rcu_barrier()
	_rcu_barrier()
	get_online_cpus()
	mutex_lock(cpu_hotplug.lock)
	 (blocks, CPU 1 has the mutex)
					__cpu_notify()
					mutex_lock(slab_mutex)	

CPU 0 grabs both locks anyway (it's not running from notifier callback). 
CPU 1 grabs both locks as well, as there is no _rcu_barrier() being called 
from notifier callback either.

What did I miss?

Thanks,

-- 
Jiri Kosina
SUSE Labs
