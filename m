Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935534Ab2JXToW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 15:44:22 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:49668 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934318Ab2JXToS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 15:44:18 -0400
Date: Wed, 24 Oct 2012 12:43:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] percpu-rw-semaphores: use rcu_read_lock_sched
Message-ID: <20121024194311.GH2465@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20121018163833.GK2518@linux.vnet.ibm.com>
 <20121018175747.GA30691@redhat.com>
 <20121019192838.GM2518@linux.vnet.ibm.com>
 <Pine.LNX.4.64.1210221910150.25995@file.rdu.redhat.com>
 <Pine.LNX.4.64.1210221936570.25995@file.rdu.redhat.com>
 <Pine.LNX.4.64.1210221937550.25995@file.rdu.redhat.com>
 <20121024161638.GA2465@linux.vnet.ibm.com>
 <20121024171855.GA22371@redhat.com>
 <20121024182005.GF2465@linux.vnet.ibm.com>
 <20121024184311.GA5025@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121024184311.GA5025@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12102419-6078-0000-0000-000011134F78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 08:43:11PM +0200, Oleg Nesterov wrote:
> On 10/24, Paul E. McKenney wrote:
> >
> > On Wed, Oct 24, 2012 at 07:18:55PM +0200, Oleg Nesterov wrote:
> > > On 10/24, Paul E. McKenney wrote:
> > > >
> > > > static inline void percpu_up_read(struct percpu_rw_semaphore *p)
> > > > {
> > > > 	/*
> > > > 	 * Decrement our count, but protected by RCU-sched so that
> > > > 	 * the writer can force proper serialization.
> > > > 	 */
> > > > 	rcu_read_lock_sched();
> > > > 	this_cpu_dec(*p->counters);
> > > > 	rcu_read_unlock_sched();
> > > > }
> > >
> > > Yes, the explicit lock/unlock makes the new assumptions about
> > > synchronize_sched && barriers unnecessary. And iiuc this could
> > > even written as
> > >
> > > 	rcu_read_lock_sched();
> > > 	rcu_read_unlock_sched();
> > >
> > > 	this_cpu_dec(*p->counters);
> >
> > But this would lose the memory barrier that is inserted by
> > synchronize_sched() after the CPU's last RCU-sched read-side critical
> > section.
> 
> How? Afaics there is no need to synchronize with this_cpu_dec(), its
> result was already seen before the 2nd synchronize_sched() was called
> in percpu_down_write().
> 
> IOW, this memory barrier is only needed to synchronize with memory
> changes inside down_read/up_read.
> 
> To clarify, of course I do not suggest to write is this way. I am just
> trying to check my understanding.

You are quite correct -- once the writer has seen the change in the
counter, it knows that the reader's empty RCU-sched read must have
at least started, and thus can rely on the following memory barrier
to guarantee that it sees the reader's critical section.

But that code really does look strange, I will grant you that!  ;-)

							Thanx, Paul

