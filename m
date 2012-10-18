Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab2JRQGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 12:06:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290Ab2JRQGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 12:06:38 -0400
Date: Thu, 18 Oct 2012 12:05:19 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Steven Rostedt <rostedt@goodmis.org>
cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] percpu-rwsem: use barrier in unlock path
In-Reply-To: <20121017202806.GA7282@home.goodmis.org>
Message-ID: <Pine.LNX.4.64.1210181201490.22996@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1210151716310.10685@file.rdu.redhat.com>
 <Pine.LNX.4.64.1210161924350.20581@file.rdu.redhat.com>
 <CA+55aFyZ9uq_yfHn9PwpmM77X3xVd+xseEbjJmeCCqbFddtjWA@mail.gmail.com>
 <507E48ED.8060809@cn.fujitsu.com> <Pine.LNX.4.64.1210171046130.26481@file.rdu.redhat.com>
 <20121017202806.GA7282@home.goodmis.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Oct 2012, Steven Rostedt wrote:

> On Wed, Oct 17, 2012 at 11:07:21AM -0400, Mikulas Patocka wrote:
> > > 
> > > Even the previous patch is applied, percpu_down_read() still
> > > needs mb() to pair with it.
> > 
> > percpu_down_read uses rcu_read_lock which should guarantee that memory 
> > accesses don't escape in front of a rcu-protected section.
> 
> You do realize that rcu_read_lock() does nothing more that a barrier(),
> right?
> 
> Paul worked really hard to get rcu_read_locks() to not call HW barriers.
> 
> > 
> > If rcu_read_unlock has only an unlock barrier and not a full barrier, 
> > memory accesses could be moved in front of rcu_read_unlock and reordered 
> > with this_cpu_inc(*p->counters), but it doesn't matter because 
> > percpu_down_write does synchronize_rcu(), so it never sees these accesses 
> > halfway through.
> 
> Looking at the patch, you are correct. The read side doesn't need the
> memory barrier as the worse thing that will happen is that it sees the
> locked = false, and will just grab the mutex unnecessarily.

It wasn't correct.

CPU 1 is holding the write lock.

CPU 2 could get to percpu_down_read past rcu_read_lock and prefetch some 
data that are accessed after percpu_down_read.

CPU 1 goes into percpu_up_write(), calls a barrier, p->locked = false; and 
mutex_unlock(&p->mtx);

CPU 2 now sees p->locked == false, so it goes through percpu_down_read. It 
exists percpu_down_read and uses the invalid prefetched data.

It could be fixed by using synchronize_rcu(); in percpu_up_write, I sent a 
patch for that.

Mikulas
