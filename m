Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759000Ab2JSRtN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 13:49:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758914Ab2JSRtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 13:49:11 -0400
Date: Fri, 19 Oct 2012 19:49:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] brw_mutex: big read-write mutex
Message-ID: <20121019174947.GA1206@redhat.com>
References: <20121015191018.GA4816@redhat.com> <CA+55aFwV-WOUx8MSr145f+HSrtmZ=nXHq0VLhtPyH=FNBFwmQg@mail.gmail.com> <20121017165902.GB9872@redhat.com> <20121017224430.GC2518@linux.vnet.ibm.com> <20121018162409.GA28504@redhat.com> <20121018163833.GK2518@linux.vnet.ibm.com> <20121018175747.GA30691@redhat.com> <Pine.LNX.4.64.1210181525010.32376@file.rdu.redhat.com> <1350650286.30157.28.camel@twins> <Pine.LNX.4.64.1210191058060.13298@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1210191058060.13298@file.rdu.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19, Mikulas Patocka wrote:
>
> synchronize_rcu() is way slower than msleep(1) -

This depends, I guess. but this doesn't mmatter,

> so I don't see a reason
> why should it be complicated to avoid msleep(1).

I don't think this really needs complications. Please look at this
patch for example. Or initial (single writer) version below. It is
not finished and lacks the barriers too, but I do not think it is
more complex.

Oleg.

struct brw_sem {
	long __percpu		*read_ctr;
	wait_queue_head_t	read_waitq;
	struct mutex		writer_mutex;
	struct task_struct	*writer;
};

int brw_init(struct brw_sem *brw)
{
	brw->writer = NULL;
	mutex_init(&brw->writer_mutex);
	init_waitqueue_head(&brw->read_waitq);
	brw->read_ctr = alloc_percpu(long);
	return brw->read_ctr ? 0 : -ENOMEM;
}

void brw_down_read(struct brw_sem *brw)
{
	for (;;) {
		bool done = false;

		preempt_disable();
		if (likely(!brw->writer)) {
			__this_cpu_inc(*brw->read_ctr);
			done = true;
		}
		preempt_enable();

		if (likely(done))
			break;

		__wait_event(brw->read_waitq, !brw->writer);
	}
}

void brw_up_read(struct brw_sem *brw)
{
	struct task_struct *writer;

	preempt_disable();
	__this_cpu_dec(*brw->read_ctr);
	writer = ACCESS_ONCE(brw->writer);
	if (unlikely(writer))
		wake_up_process(writer);
	preempt_enable();
}

static inline long brw_read_ctr(struct brw_sem *brw)
{
	long sum = 0;
	int cpu;

	for_each_possible_cpu(cpu)
		sum += per_cpu(*brw->read_ctr, cpu);

	return sum;
}

void brw_down_write(struct brw_sem *brw)
{
	mutex_lock(&brw->writer_mutex);
	brw->writer = current;
	synchronize_sched();
	/*
	 * Thereafter brw_*_read() must see ->writer != NULL,
	 * and we should see the result of __this_cpu_inc().
	 */
	for (;;) {
		set_current_state(TASK_UNINTERRUPTIBLE);
		if (brw_read_ctr(brw) == 0)
			break;
		schedule();
	}
	__set_current_state(TASK_RUNNING);
	/*
	 * We can add another synchronize_sched() to avoid the
	 * spurious wakeups from brw_up_read() after return.
	 */
}

void brw_up_write(struct brw_sem *brw)
{
	brw->writer = NULL;
	synchronize_sched();
	wake_up_all(&brw->read_waitq);
	mutex_unlock(&brw->writer_mutex);
}

