Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078Ab2JRPdh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 11:33:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756738Ab2JRPde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 11:33:34 -0400
Date: Thu, 18 Oct 2012 11:32:30 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Lai Jiangshan <laijs@cn.fujitsu.com>
cc: Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] percpu-rwsem: use barrier in unlock path
In-Reply-To: <507F66F6.20704@cn.fujitsu.com>
Message-ID: <Pine.LNX.4.64.1210181127460.22996@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1210151716310.10685@file.rdu.redhat.com>
 <Pine.LNX.4.64.1210161924350.20581@file.rdu.redhat.com>
 <CA+55aFyZ9uq_yfHn9PwpmM77X3xVd+xseEbjJmeCCqbFddtjWA@mail.gmail.com>
 <507E48ED.8060809@cn.fujitsu.com> <Pine.LNX.4.64.1210171046130.26481@file.rdu.redhat.com>
 <20121017202806.GA7282@home.goodmis.org> <507F66F6.20704@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 18 Oct 2012, Lai Jiangshan wrote:

> On 10/18/2012 04:28 AM, Steven Rostedt wrote:
> > On Wed, Oct 17, 2012 at 11:07:21AM -0400, Mikulas Patocka wrote:
> >>>
> >>> Even the previous patch is applied, percpu_down_read() still
> >>> needs mb() to pair with it.
> >>
> >> percpu_down_read uses rcu_read_lock which should guarantee that memory 
> >> accesses don't escape in front of a rcu-protected section.
> > 
> > You do realize that rcu_read_lock() does nothing more that a barrier(),
> > right?
> > 
> > Paul worked really hard to get rcu_read_locks() to not call HW barriers.
> > 
> >>
> >> If rcu_read_unlock has only an unlock barrier and not a full barrier, 
> >> memory accesses could be moved in front of rcu_read_unlock and reordered 
> >> with this_cpu_inc(*p->counters), but it doesn't matter because 
> >> percpu_down_write does synchronize_rcu(), so it never sees these accesses 
> >> halfway through.
> > 
> > Looking at the patch, you are correct. The read side doesn't need the
> > memory barrier as the worse thing that will happen is that it sees the
> > locked = false, and will just grab the mutex unnecessarily.
> 
> ---------------------
> A memory barrier can be added iff these two things are known:
> 	1) it disables the disordering between what and what.
> 	2) what is the corresponding mb() that it pairs with.
> 
> You tried to add a mb() in percpu_up_write(), OK, I know it disables the disordering
> between the writes to the protected data and the statement "p->locked = false",
> But I can't find out the corresponding mb() that it pairs with.

Or alternativelly, instead of barrier, we can do this.

Mikulas

---

percpu-rwsem: use barrier in unlock path

The lock is considered unlocked when p->locked is set to false.
Use barrier prevent reordering of operations around p->locked.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 include/linux/percpu-rwsem.h |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-3.6.2-fast/include/linux/percpu-rwsem.h
===================================================================
--- linux-3.6.2-fast.orig/include/linux/percpu-rwsem.h	2012-10-17 20:48:40.000000000 +0200
+++ linux-3.6.2-fast/include/linux/percpu-rwsem.h	2012-10-18 17:19:24.000000000 +0200
@@ -66,6 +66,12 @@ static inline void percpu_down_write(str
 
 static inline void percpu_up_write(struct percpu_rw_semaphore *p)
 {
+	/*
+	 * Make sure that other processes that are in rcu section and that
+	 * may have seen partially modified state exit the rcu section and
+	 * try to grab the mutex.
+	 */
+	synchronize_rcu();
 	p->locked = false;
 	mutex_unlock(&p->mtx);
 }
