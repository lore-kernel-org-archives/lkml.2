Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab0KYLJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 06:09:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886Ab0KYLJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 06:09:17 -0500
Date: Thu, 25 Nov 2010 12:02:30 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, tglx <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: rcu_read_lock/unlock protect find_task_by_vpid call in
	posix_cpu_timer_create
Message-ID: <20101125110230.GB19031@redhat.com>
References: <20101125010948.GA1371@redhat.com> <1290674436.2072.562.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290674436.2072.562.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(another try, actually add Sergey)

On 11/25, Peter Zijlstra wrote:
>
> On Wed, 2010-11-24 at 20:09 -0500, Dave Jones wrote:
> > --- a/kernel/posix-cpu-timers.c
> > +++ b/kernel/posix-cpu-timers.c
> > @@ -391,6 +391,7 @@ int posix_cpu_timer_create(struct k_itimer *new_timer)
> >  	INIT_LIST_HEAD(&new_timer->it.cpu.entry);
> >
> >  	read_lock(&tasklist_lock);
> > +	rcu_read_lock();
> >  	if (CPUCLOCK_PERTHREAD(new_timer->it_clock)) {
> >  		if (pid == 0) {
> >  			p = current;
> > @@ -414,6 +415,7 @@ int posix_cpu_timer_create(struct k_itimer *new_timer)
> >  	} else {
> >  		ret = -EINVAL;
> >  	}
> > +	rcu_read_unlock();
> >  	read_unlock(&tasklist_lock);
> >
> >  	return ret;
>
> Do we still need the tasklist_lock in this case?

No. posix-cpu-timer.c shouldn't use tasklist at all. But it is not
completely trivial to remove it.

In particular, this patch is not exactly right, we can't trust
thread_group_leader() without tasklist.

Sergey already sent the patch which removes tasklist from
posix_cpu_timer_create() and posix_cpu_timer_create(), and iirc
Thomas queued it.

> Also, why is that think complaining, surely the tasklist_lock pins any
> and all PID objects?

The only problem is: if copy_process() fails, it does free_pid()
lockless. This means, without rcu lock it is not safe to scan the
rcu-protected lists.

We can change copy_process() (in fact I sent the patch several
years ago), but everybody think that find_pid/etc should always
take rcu_read_lock() instead. I tend to agree.

Oleg.

