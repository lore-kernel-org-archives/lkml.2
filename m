Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab2JCHnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 03:43:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33681 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335Ab2JCHnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 03:43:50 -0400
Date: Wed, 3 Oct 2012 09:43:41 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: paulmck@linux.vnet.ibm.com, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org
Subject: Re: Lockdep complains about commit 1331e7a1bb ("rcu: Remove
 _rcu_barrier() dependency on __stop_machine()")
In-Reply-To: <506BB950.3000102@linux.vnet.ibm.com>
Message-ID: <alpine.LNX.2.00.1210030937490.23544@pobox.suse.cz>
References: <alpine.LNX.2.00.1210021810350.23544@pobox.suse.cz> <506B50F1.8070907@linux.vnet.ibm.com> <alpine.LNX.2.00.1210030008590.23544@pobox.suse.cz> <506BB283.4010800@linux.vnet.ibm.com> <20121003034405.GB13192@linux.vnet.ibm.com>
 <506BB950.3000102@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Oct 2012, Srivatsa S. Bhat wrote:

> >>> 	CPU 0				CPU 1
> >>> 	kmem_cache_destroy()
> >>
> >> What about the get_online_cpus() right here at CPU0 before
> >> calling mutex_lock(slab_mutex)? How can the cpu_up() proceed
> >> on CPU1?? I still don't get it... :(
> >>
> >> (kmem_cache_destroy() uses get/put_online_cpus() around acquiring
> >> and releasing slab_mutex).
> > 
> > The problem is that there is a CPU-hotplug notifier for slab, which
> > establishes hotplug->slab.
> 
> Agreed.
> 
> >  Then having kmem_cache_destroy() call
> > rcu_barrier() under the lock
> 
> Ah, that's where I disagree. kmem_cache_destroy() *cannot* proceed at
> this point in time, because it has invoked get_online_cpus()! It simply
> cannot be running past that point in the presence of a running hotplug
> notifier! So, kmem_cache_destroy() should have been sleeping on the
> hotplug lock, waiting for the notifier to release it, no?

Please look carefully at the scenario again. kmem_cache_destroy() calls 
get_online_cpus() before the hotplug notifier even starts. Hence it has no 
reason to block there (noone is holding hotplug lock).

*Then* hotplug notifier fires up, succeeds obtaining hotplug lock, 
kmem_cache_destroy() calls rcu_barrier in the meantime, and blocks itself 
on the hotplug lock there.

Please note that the get_online_cpus() call in kmem_cache_destroy() 
doesn't play *any* role in this scenario.

-- 
Jiri Kosina
SUSE Labs
