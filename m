Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751252Ab0F2NHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 09:07:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412Ab0F2NHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 09:07:31 -0400
Date: Tue, 29 Jun 2010 15:05:03 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Don Zickus <dzickus@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jerome Marchand <jmarchan@redhat.com>,
       Mandeep Singh Baines <msb@google.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: while_each_thread() under rcu_read_lock() is broken?
Message-ID: <20100629130503.GA5237@redhat.com>
References: <20100621170919.GA13826@redhat.com> <20100621205128.GI2354@linux.vnet.ibm.com> <20100622212357.GA19670@redhat.com> <20100622221226.GP2290@linux.vnet.ibm.com> <20100623152421.GA8445@redhat.com> <20100624180726.GK2373@linux.vnet.ibm.com> <20100624215702.GA21360@redhat.com> <20100625034105.GD2391@linux.vnet.ibm.com> <20100625095548.GA6292@redhat.com> <20100628234358.GJ2357@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100628234358.GJ2357@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28, Paul E. McKenney wrote:
>
> On Fri, Jun 25, 2010 at 11:55:48AM +0200, Oleg Nesterov wrote:
> > On 06/24, Paul E. McKenney wrote:
> > >
> > > So it is OK to skip some of the other threads in this case, even
> > > though they were present throughout the whole procedure?
> >
> > I think, yes. We can miss them in any case, they can go away before
> > while_each_thread(g, t) starts the scan.
> >
> > If g == group_leader (old or new), then we should notice this thread
> > at least.
> >
> > Otherwise we can miss them all, with or without next_thread_careful().
>
> Just to be sure that we are actually talking about the same scenario...
>
> Suppose that a task group is lead by 2908 and has member 2909, 2910,
> 2911, and 2912.  Suppose that 2910 does pthread_exit() just as some
> other task is "ls"ing the relevant /proc entry.  Is it really OK for
> "ls" to show 2909 but not 2911 and 2912, even though 2911 and 2912
> were alive and kicking the entire time?

Confused.

Let's return to

	do
		printk("%d\n", t->pid);
	while_each_thread(g, t);

for the moment.

In that case, if g != 2910 (the exiting thread) we will print all pids,
except we can miss 2910. With or without next_thread_careful().

Only if we start at g == 2910, then

	current code:		print 2910, then spin forever printing
				other pids

	next_thread_careful:	stop printing when we notice that 2910
				was unhashed.

				So, yes, in this case we can miss all
				other threads.

As for "ls"ing the relevant /proc entry. proc_task_readdir() is complicated,
it can drop rcu lock, sleep, etc. But basically it mimics while_each_thread()
logic. Let's assume that proc_task_fill_cache() never fails.

proc_task_readdir() always starts at the group_leader, 2908. So, with or
without next_thread_careful() we can only miss the exiting 2910.

But (again, unless I missed something) the current code can race with exec,
and s/next_thread/next_thread_careful/ in first_tid() can fix the race.
(just in case, we can fix it differently).

But, of course, if you do "ls /proc/2910/task" instead of "ls /proc/2908/task"
you can miss _all_ threads if 2910 exits before proc_task_readdir() finds
its leader, 2908. Again, this is with or without next_thread_careful().


Paul, please let me know if I misunderstood your concerns, or if I missed
something.

Oleg.

