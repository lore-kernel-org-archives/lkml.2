Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933083Ab2EOPGb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:06:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37323 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933044Ab2EOPGa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:06:30 -0400
Message-ID: <1337094383.27694.62.camel@twins>
Subject: Re: [RFC][PATCH RT] rwsem_rt: Another (more sane) approach to mulit
 reader rt locks
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>
Date: Tue, 15 May 2012 17:06:23 +0200
In-Reply-To: <1337090625.14207.304.camel@gandalf.stny.rr.com>
References: <1337090625.14207.304.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-15 at 10:03 -0400, Steven Rostedt wrote:
> 
> where readers may nest (the same task may grab the same rwsem for
> read multiple times), but only one task may hold the rwsem at any
> given
> time (for read or write).

Humm, that sounds iffy, rwsem isn't a recursive read lock only rwlock_t
is.

> The idea here is to have an rwsem create a rt_mutex for each CPU.
> Actually, it creates a rwsem for each CPU that can only be acquired by
> one task at a time. This allows for readers on separate CPUs to take
> only the per cpu lock. When a writer needs to take a lock, it must
> grab
> all CPU locks before continuing. 

So you've turned it into a global/local or br or whatever that thing was
called lock.
> 
> Also, I don't use per_cpu sections for the locks, which means we have
> cache line collisions, but a normal (mainline) rwsem has that as well.
> 
Why not?

> Thoughts?

Ideally someone would try and get rid of mmap_sem itself.. but that's a
tough nut.



>  void  rt_down_write(struct rw_semaphore *rwsem)
>  {
> -       rwsem_acquire(&rwsem->dep_map, 0, 0, _RET_IP_);
> -       rt_mutex_lock(&rwsem->lock);
> +       int i;
> +       initialize_rwsem(rwsem);
> +       for_each_possible_cpu(i) {
> +               rwsem_acquire(&rwsem->lock[i].dep_map, 0, 0,
> _RET_IP_);
> +               rt_mutex_lock(&rwsem->lock[i].lock);
> +       }
>  }
>  EXPORT_SYMBOL(rt_down_write);
> 
That'll make lockdep explode.. you'll want to make the whole set a
single lock and not treat it as nr_cpus locks.
