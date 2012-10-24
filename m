Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935234Ab2JXRSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 13:18:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54159 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758654Ab2JXRSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 13:18:16 -0400
Date: Wed, 24 Oct 2012 19:18:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] percpu-rw-semaphores: use rcu_read_lock_sched
Message-ID: <20121024171855.GA22371@redhat.com>
References: <20121017165902.GB9872@redhat.com> <20121017224430.GC2518@linux.vnet.ibm.com> <20121018162409.GA28504@redhat.com> <20121018163833.GK2518@linux.vnet.ibm.com> <20121018175747.GA30691@redhat.com> <20121019192838.GM2518@linux.vnet.ibm.com> <Pine.LNX.4.64.1210221910150.25995@file.rdu.redhat.com> <Pine.LNX.4.64.1210221936570.25995@file.rdu.redhat.com> <Pine.LNX.4.64.1210221937550.25995@file.rdu.redhat.com> <20121024161638.GA2465@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121024161638.GA2465@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24, Paul E. McKenney wrote:
>
> static inline void percpu_up_read(struct percpu_rw_semaphore *p)
> {
> 	/*
> 	 * Decrement our count, but protected by RCU-sched so that
> 	 * the writer can force proper serialization.
> 	 */
> 	rcu_read_lock_sched();
> 	this_cpu_dec(*p->counters);
> 	rcu_read_unlock_sched();
> }

Yes, the explicit lock/unlock makes the new assumptions about
synchronize_sched && barriers unnecessary. And iiuc this could
even written as

	rcu_read_lock_sched();
	rcu_read_unlock_sched();

	this_cpu_dec(*p->counters);


> Of course, it would be nice to get rid of the extra synchronize_sched().
> One way to do this is to use SRCU, which allows blocking operations in
> its read-side critical sections (though also increasing read-side overhead
> a bit, and also untested):
>
> ------------------------------------------------------------------------
>
> struct percpu_rw_semaphore {
> 	bool locked;
> 	struct mutex mtx; /* Could also be rw_semaphore. */
> 	struct srcu_struct s;
> 	wait_queue_head_t wq;
> };

but in this case I don't understand

> static inline void percpu_up_write(struct percpu_rw_semaphore *p)
> {
> 	/* Allow others to proceed, but not yet locklessly. */
> 	mutex_unlock(&p->mtx);
>
> 	/*
> 	 * Ensure that all calls to percpu_down_read() that did not
> 	 * start unambiguously after the above mutex_unlock() still
> 	 * acquire the lock, forcing their critical sections to be
> 	 * serialized with the one terminated by this call to
> 	 * percpu_up_write().
> 	 */
> 	synchronize_sched();

how this synchronize_sched() can help...

Oleg.

