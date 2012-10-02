Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650Ab2JBWRL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 18:17:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49118 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755121Ab2JBWRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 18:17:09 -0400
Date: Wed, 3 Oct 2012 00:17:00 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: Lockdep complains about commit 1331e7a1bb ("rcu: Remove
 _rcu_barrier() dependency on __stop_machine()")
In-Reply-To: <506B50F1.8070907@linux.vnet.ibm.com>
Message-ID: <alpine.LNX.2.00.1210030008590.23544@pobox.suse.cz>
References: <alpine.LNX.2.00.1210021810350.23544@pobox.suse.cz> <506B50F1.8070907@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Oct 2012, Srivatsa S. Bhat wrote:

> I don't see how this circular locking dependency can occur.. If you are using SLUB,
> kmem_cache_destroy() releases slab_mutex before it calls rcu_barrier(). If you are
> using SLAB, kmem_cache_destroy() wraps its whole operation inside get/put_online_cpus(),
> which means, it cannot run concurrently with a hotplug operation such as cpu_up(). So, I'm
> rather puzzled at this lockdep splat..

I am using SLAB here.

The scenario I think is very well possible:


	CPU 0				CPU 1
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

Deadlock.

Right?

-- 
Jiri Kosina
SUSE Labs
