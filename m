Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab2JCDgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 23:36:19 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:35277 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab2JCDgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 23:36:17 -0400
Message-ID: <506BB283.4010800@linux.vnet.ibm.com>
Date: Wed, 03 Oct 2012 09:05:31 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: Lockdep complains about commit 1331e7a1bb ("rcu: Remove _rcu_barrier()
 dependency on __stop_machine()")
References: <alpine.LNX.2.00.1210021810350.23544@pobox.suse.cz> <506B50F1.8070907@linux.vnet.ibm.com> <alpine.LNX.2.00.1210030008590.23544@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1210030008590.23544@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12100303-9574-0000-0000-000004AF6A70
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2012 03:47 AM, Jiri Kosina wrote:
> On Wed, 3 Oct 2012, Srivatsa S. Bhat wrote:
> 
>> I don't see how this circular locking dependency can occur.. If you are using SLUB,
>> kmem_cache_destroy() releases slab_mutex before it calls rcu_barrier(). If you are
>> using SLAB, kmem_cache_destroy() wraps its whole operation inside get/put_online_cpus(),
>> which means, it cannot run concurrently with a hotplug operation such as cpu_up(). So, I'm
>> rather puzzled at this lockdep splat..
> 
> I am using SLAB here.
> 
> The scenario I think is very well possible:
> 
> 
> 	CPU 0				CPU 1
> 	kmem_cache_destroy()

What about the get_online_cpus() right here at CPU0 before
calling mutex_lock(slab_mutex)? How can the cpu_up() proceed
on CPU1?? I still don't get it... :(

(kmem_cache_destroy() uses get/put_online_cpus() around acquiring
and releasing slab_mutex).

Regards,
Srivatsa S. Bhat

> 	mutex_lock(slab_mutex)
> 	 				_cpu_up()
> 					cpu_hotplug_begin()
> 					mutex_lock(cpu_hotplug.lock)
> 	rcu_barrier()
> 	_rcu_barrier()
> 	get_online_cpus()
> 	mutex_lock(cpu_hotplug.lock)
> 	 (blocks, CPU 1 has the mutex)
> 					__cpu_notify()
> 					mutex_lock(slab_mutex)
> 
> Deadlock.
> 
> Right?
> 


