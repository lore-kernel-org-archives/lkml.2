Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab2HAUIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 16:08:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755501Ab2HAUIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 16:08:13 -0400
Date: Wed, 1 Aug 2012 16:07:57 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Jens Axboe <axboe@kernel.dk>, Andrea Arcangeli <aarcange@redhat.com>,
        Jan Kara <jack@suse.cz>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        kosaki.motohiro@jp.fujitsu.com, linux-fsdevel@vger.kernel.org,
        lwoodman@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 2/3] Introduce percpu rw semaphores
In-Reply-To: <1343586962.2626.13266.camel@edumazet-glaptop>
Message-ID: <Pine.LNX.4.64.1208011605430.21832@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1206272226050.22857@file.rdu.redhat.com> 
 <20120628111541.GB17515@quack.suse.cz>  <Pine.LNX.4.64.1207152051490.4240@file.rdu.redhat.com>
  <x49ipdmyz4q.fsf@segfault.boston.devel.redhat.com> 
 <Pine.LNX.4.64.1207181512530.10923@file.rdu.redhat.com> 
 <x49k3xzq3jc.fsf@segfault.boston.devel.redhat.com> 
 <Pine.LNX.4.64.1207281236230.30415@file.rdu.redhat.com> 
 <Pine.LNX.4.64.1207281240270.30415@file.rdu.redhat.com> 
 <1343508252.2626.13184.camel@edumazet-glaptop> 
 <Pine.LNX.4.64.1207290107460.29910@file.rdu.redhat.com> 
 <1343556630.2626.13257.camel@edumazet-glaptop> <1343586962.2626.13266.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 29 Jul 2012, Eric Dumazet wrote:

> On Sun, 2012-07-29 at 12:10 +0200, Eric Dumazet wrote:
> 
> > You can probably design something needing no more than 4 bytes per cpu,
> > and this thing could use non locked operations as bonus.
> > 
> > like the following ...
> 
> Coming back from my bike ride, here is a more polished version with
> proper synchronization/ barriers.
> 
> struct percpu_rw_semaphore {
> 	/* percpu_sem_down_read() use the following in fast path */
> 	unsigned int __percpu *active_counters;
> 
> 	unsigned int __percpu *counters;
> 	struct rw_semaphore	sem; /* used in slow path and by writers */
> };
> 
> static inline int percpu_sem_init(struct percpu_rw_semaphore *p)
> {
> 	p->counters = alloc_percpu(unsigned int);
> 	if (!p->counters)
> 		return -ENOMEM;
> 	init_rwsem(&p->sem);
> 	rcu_assign_pointer(p->active_counters, p->counters);
> 	return 0;
> }
> 
> 
> static inline bool percpu_sem_down_read(struct percpu_rw_semaphore *p)
> {
> 	unsigned int __percpu *counters;
> 
> 	rcu_read_lock();
> 	counters = rcu_dereference(p->active_counters);
> 	if (counters) {
> 		this_cpu_inc(*counters);
> 		smp_wmb(); /* paired with smp_rmb() in percpu_count() */

Why is this barrier needed? RCU works as a barrier doesn't it?
RCU is unlocked when the cpu passes a quiescent state, and I suppose that 
entering the quiescent state works as a barrier. Or doesn't it?

> 		rcu_read_unlock();
> 		return true;
> 	}
> 	rcu_read_unlock();
> 	down_read(&p->sem);
> 	return false;
> }
> 
> static inline void percpu_sem_up_read(struct percpu_rw_semaphore *p, bool fastpath)
> {
> 	if (fastpath)
> 		this_cpu_dec(*p->counters);
> 	else
> 		up_read(&p->sem);
> }
> 
> static inline unsigned int percpu_count(unsigned int __percpu *counters)
> {
> 	unsigned int total = 0;
> 	int cpu;
> 
> 	for_each_possible_cpu(cpu)
> 		total += *per_cpu_ptr(counters, cpu);
> 
> 	return total;
> }
> 
> static inline void percpu_sem_down_write(struct percpu_rw_semaphore *p)
> {
> 	down_write(&p->sem);
> 	p->active_counters = NULL;
> 	synchronize_rcu();
> 	smp_rmb(); /* paired with smp_wmb() in percpu_sem_down_read() */

Why barrier here? Synchronize_rcu() doesn't work as a barrier?

Mikulas

> 	while (percpu_count(p->counters))
> 		schedule();
> }
> 
> static inline void percpu_sem_up_write(struct percpu_rw_semaphore *p)
> {
> 	rcu_assign_pointer(p->active_counters, p->counters);
> 	up_write(&p->sem);
> }
> 
> 
