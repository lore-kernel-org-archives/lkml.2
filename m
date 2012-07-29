Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534Ab2G2KKj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 06:10:39 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60246 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286Ab2G2KKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 06:10:35 -0400
Subject: Re: [dm-devel] [PATCH 2/3] Introduce percpu rw semaphores
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Andrea Arcangeli <aarcange@redhat.com>,
        Jan Kara <jack@suse.cz>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        kosaki.motohiro@jp.fujitsu.com, linux-fsdevel@vger.kernel.org,
        lwoodman@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1207290107460.29910@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1206272226050.22857@file.rdu.redhat.com>
	 <20120628111541.GB17515@quack.suse.cz>
	 <Pine.LNX.4.64.1207152051490.4240@file.rdu.redhat.com>
	 <x49ipdmyz4q.fsf@segfault.boston.devel.redhat.com>
	 <Pine.LNX.4.64.1207181512530.10923@file.rdu.redhat.com>
	 <x49k3xzq3jc.fsf@segfault.boston.devel.redhat.com>
	 <Pine.LNX.4.64.1207281236230.30415@file.rdu.redhat.com>
	 <Pine.LNX.4.64.1207281240270.30415@file.rdu.redhat.com>
	 <1343508252.2626.13184.camel@edumazet-glaptop>
	 <Pine.LNX.4.64.1207290107460.29910@file.rdu.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 29 Jul 2012 12:10:30 +0200
Message-ID: <1343556630.2626.13257.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-07-29 at 01:13 -0400, Mikulas Patocka wrote:

> Each cpu should have its own rw semaphore in its cache, so I don't see a 
> problem there.
> 
> When you change block size, all 4096 rw semaphores are locked for write, 
> but changing block size is not a performance sensitive operation.
> 
> > Really you shouldnt use rwlock in a path if this might hurt performance.
> > 
> > RCU is probably a better answer.
> 
> RCU is meaningless here. RCU allows lockless dereference of a pointer. 
> Here the problem is not pointer dereference, the problem is that integer 
> bd_block_size may change.

So add a pointer if you need to. Thats the point.

> 
> > (bdev->bd_block_size should be read exactly once )
> 
> Rewrite all direct and non-direct io code so that it reads block size just 
> once ...


You introduced percpu rw semaphores, thats only incentive for people to
use that infrastructure elsewhere.

And its a big hammer :

sizeof(struct rw_semaphore)=0x70 

You can probably design something needing no more than 4 bytes per cpu,
and this thing could use non locked operations as bonus.

like the following ...

struct percpu_rw_semaphore {
	/* percpu_sem_down_read() use the following in fast path */
	unsigned int __percpu *active_counters;

	unsigned int __percpu *counters;
	struct rw_semaphore	sem; /* used in slow path and by writers */
};

static inline int percpu_sem_init(struct percpu_rw_semaphore *p)
{
	p->counters = alloc_percpu(unsigned int);
	if (!p->counters)
		return -ENOMEM;
	init_rwsem(&p->sem);
	p->active_counters = p->counters;
	return 0;
}


static inline bool percpu_sem_down_read(struct percpu_rw_semaphore *p)
{
	unsigned int __percpu *counters = ACCESS_ONCE(p->active_counters);

	if (counters) {
		this_cpu_inc(*counters);
		return true;
	}
	down_read(&p->sem);
	return false;
}

static inline void percpu_sem_up_read(struct percpu_rw_semaphore *p, bool fastpath)
{
	if (fastpath)
		this_cpu_dec(*p->counters);
	else
		up_read(&p->sem);
}

static inline unsigned int percpu_count(unsigned int *counters)
{
	unsigned int total = 0;
	int cpu;

	for_each_possible_cpu(cpu)
		total += *per_cpu_ptr(counters, cpu);

	return total;
}

static inline void percpu_sem_down_write(struct percpu_rw_semaphore *p)
{
	down_write(&p->sem);
	p->active_counters = NULL;

	while (percpu_count(p->counters))
		schedule();
}

static inline void percpu_sem_up_write(struct percpu_rw_semaphore *p)
{
	p->active_counters = p->counters;
	up_write(&p->sem);
}




