Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab2JCDoM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 23:44:12 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:43412 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab2JCDoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 23:44:10 -0400
Date: Tue, 2 Oct 2012 20:44:05 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Jiri Kosina <jkosina@suse.cz>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org
Subject: Re: Lockdep complains about commit 1331e7a1bb ("rcu: Remove
 _rcu_barrier() dependency on __stop_machine()")
Message-ID: <20121003034405.GB13192@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LNX.2.00.1210021810350.23544@pobox.suse.cz>
 <506B50F1.8070907@linux.vnet.ibm.com>
 <alpine.LNX.2.00.1210030008590.23544@pobox.suse.cz>
 <506BB283.4010800@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506BB283.4010800@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12100303-2398-0000-0000-00000BCB65ED
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000294; HX=3.00000196; KW=3.00000007;
 PH=3.00000001; SC=3.00000008; SDB=6.00179343; UDB=6.00040616; UTC=2012-10-03
 03:44:09
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 09:05:31AM +0530, Srivatsa S. Bhat wrote:
> On 10/03/2012 03:47 AM, Jiri Kosina wrote:
> > On Wed, 3 Oct 2012, Srivatsa S. Bhat wrote:
> > 
> >> I don't see how this circular locking dependency can occur.. If you are using SLUB,
> >> kmem_cache_destroy() releases slab_mutex before it calls rcu_barrier(). If you are
> >> using SLAB, kmem_cache_destroy() wraps its whole operation inside get/put_online_cpus(),
> >> which means, it cannot run concurrently with a hotplug operation such as cpu_up(). So, I'm
> >> rather puzzled at this lockdep splat..
> > 
> > I am using SLAB here.
> > 
> > The scenario I think is very well possible:
> > 
> > 
> > 	CPU 0				CPU 1
> > 	kmem_cache_destroy()
> 
> What about the get_online_cpus() right here at CPU0 before
> calling mutex_lock(slab_mutex)? How can the cpu_up() proceed
> on CPU1?? I still don't get it... :(
> 
> (kmem_cache_destroy() uses get/put_online_cpus() around acquiring
> and releasing slab_mutex).

The problem is that there is a CPU-hotplug notifier for slab, which
establishes hotplug->slab.  Then having kmem_cache_destroy() call
rcu_barrier() under the lock establishes slab->hotplug, which results
in deadlock.  Jiri really did explain this in an earlier email
message, but both of us managed to miss it.  ;-)

							Thanx, Paul

> Regards,
> Srivatsa S. Bhat
> 
> > 	mutex_lock(slab_mutex)
> > 	 				_cpu_up()
> > 					cpu_hotplug_begin()
> > 					mutex_lock(cpu_hotplug.lock)
> > 	rcu_barrier()
> > 	_rcu_barrier()
> > 	get_online_cpus()
> > 	mutex_lock(cpu_hotplug.lock)
> > 	 (blocks, CPU 1 has the mutex)
> > 					__cpu_notify()
> > 					mutex_lock(slab_mutex)
> > 
> > Deadlock.
> > 
> > Right?
> > 
> 
> 

