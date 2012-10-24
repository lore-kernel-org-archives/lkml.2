Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161072Ab2JXSUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 14:20:45 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:53935 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756505Ab2JXSUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 14:20:44 -0400
Date: Wed, 24 Oct 2012 11:20:05 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] percpu-rw-semaphores: use rcu_read_lock_sched
Message-ID: <20121024182005.GF2465@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20121017224430.GC2518@linux.vnet.ibm.com>
 <20121018162409.GA28504@redhat.com>
 <20121018163833.GK2518@linux.vnet.ibm.com>
 <20121018175747.GA30691@redhat.com>
 <20121019192838.GM2518@linux.vnet.ibm.com>
 <Pine.LNX.4.64.1210221910150.25995@file.rdu.redhat.com>
 <Pine.LNX.4.64.1210221936570.25995@file.rdu.redhat.com>
 <Pine.LNX.4.64.1210221937550.25995@file.rdu.redhat.com>
 <20121024161638.GA2465@linux.vnet.ibm.com>
 <20121024171855.GA22371@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121024171855.GA22371@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12102418-5518-0000-0000-000008B24D89
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 07:18:55PM +0200, Oleg Nesterov wrote:
> On 10/24, Paul E. McKenney wrote:
> >
> > static inline void percpu_up_read(struct percpu_rw_semaphore *p)
> > {
> > 	/*
> > 	 * Decrement our count, but protected by RCU-sched so that
> > 	 * the writer can force proper serialization.
> > 	 */
> > 	rcu_read_lock_sched();
> > 	this_cpu_dec(*p->counters);
> > 	rcu_read_unlock_sched();
> > }
> 
> Yes, the explicit lock/unlock makes the new assumptions about
> synchronize_sched && barriers unnecessary. And iiuc this could
> even written as
> 
> 	rcu_read_lock_sched();
> 	rcu_read_unlock_sched();
> 
> 	this_cpu_dec(*p->counters);

But this would lose the memory barrier that is inserted by
synchronize_sched() after the CPU's last RCU-sched read-side critical
section.

> > Of course, it would be nice to get rid of the extra synchronize_sched().
> > One way to do this is to use SRCU, which allows blocking operations in
> > its read-side critical sections (though also increasing read-side overhead
> > a bit, and also untested):
> >
> > ------------------------------------------------------------------------
> >
> > struct percpu_rw_semaphore {
> > 	bool locked;
> > 	struct mutex mtx; /* Could also be rw_semaphore. */
> > 	struct srcu_struct s;
> > 	wait_queue_head_t wq;
> > };
> 
> but in this case I don't understand
> 
> > static inline void percpu_up_write(struct percpu_rw_semaphore *p)
> > {
> > 	/* Allow others to proceed, but not yet locklessly. */
> > 	mutex_unlock(&p->mtx);
> >
> > 	/*
> > 	 * Ensure that all calls to percpu_down_read() that did not
> > 	 * start unambiguously after the above mutex_unlock() still
> > 	 * acquire the lock, forcing their critical sections to be
> > 	 * serialized with the one terminated by this call to
> > 	 * percpu_up_write().
> > 	 */
> > 	synchronize_sched();
> 
> how this synchronize_sched() can help...

Indeed it cannot!  It should instead be synchronize_srcu(&p->s).  I guess that
I really meant it when I said it was untested.  ;-)

							Thanx, Paul

