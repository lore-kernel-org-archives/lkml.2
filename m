Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734Ab2BVAzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 19:55:35 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61559 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab2BVAze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 19:55:34 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of fweisbec@gmail.com designates 10.42.142.7 as permitted sender) smtp.mail=fweisbec@gmail.com; dkim=pass header.i=fweisbec@gmail.com
Date: Wed, 22 Feb 2012 01:55:28 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mandeep Singh Baines <msb@chromium.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] cgroup: Walk task list under tasklist_lock in
 cgroup_enable_task_cg_list
Message-ID: <20120222005525.GC13403@somewhere.redhat.com>
References: <1328668647-24125-1-git-send-email-fweisbec@gmail.com>
 <1328668647-24125-3-git-send-email-fweisbec@gmail.com>
 <20120221222343.GU3090@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120221222343.GU3090@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 02:23:43PM -0800, Mandeep Singh Baines wrote:
> Frederic Weisbecker (fweisbec@gmail.com) wrote:
> > Walking through the tasklist in cgroup_enable_task_cg_list() inside
> > an RCU read side critical section is not enough because:
> > 
> > - RCU is not (yet) safe against while_each_thread()
> > 
> > - If we use only RCU, a forking task that has passed cgroup_post_fork()
> >   without seeing use_task_css_set_links == 1 is not guaranteed to have
> >   its child immediately visible in the tasklist if we walk through it
> >   remotely with RCU. In this case it will be missing in its css_set's
> >   task list.
> > 
> > Thus we need to traverse the list (unfortunately) under the
> > tasklist_lock. It makes us safe against while_each_thread() and also
> > make sure we see all forked task that have been added to the tasklist.
> > 
> > As a secondary effect, reading and writing use_task_css_set_links are
> > now well ordered against tasklist traversing and modification. The new
> > layout is:
> > 
> > CPU 0                                      CPU 1
> > 
> > use_task_css_set_links = 1                write_lock(tasklist_lock)
> > read_lock(tasklist_lock)                  add task to tasklist
> > do_each_thread() {                        write_unlock(tasklist_lock)
> > 	add thread to css set links       if (use_task_css_set_links)
> > } while_each_thread()                         add thread to css set links
> > read_unlock(tasklist_lock)
> > 
> > If CPU 0 traverse the list after the task has been added to the tasklist
> > then it is correctly added to the css set links. OTOH if CPU 0 traverse
> > the tasklist before the new task had the opportunity to be added to the
> > tasklist because it was too early in the fork process, then CPU 1
> > catches up and add the task to the css set links after it added the task
> > to the tasklist. The right value of use_task_css_set_links is guaranteed
> > to be visible from CPU 1 due to the LOCK/UNLOCK implicit barrier properties:
> > the read_unlock on CPU 0 makes the write on use_task_css_set_links happening
> > and the write_lock on CPU 1 make the read of use_task_css_set_links that comes
> > afterward to return the correct value.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Tejun Heo <tj@kernel.org>
> > Cc: Li Zefan <lizf@cn.fujitsu.com>
> > Cc: Mandeep Singh Baines <msb@chromium.org>
> 
> Reviewed-by: Mandeep Singh Baines <msb@chromium.org>
> 
> Sorry for being late. My feedback is really just comments.
> 
> > Cc: Oleg Nesterov <oleg@redhat.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  kernel/cgroup.c |   20 ++++++++++++++++++++
> >  1 files changed, 20 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> > index 6e4eb43..c6877fe 100644
> > --- a/kernel/cgroup.c
> > +++ b/kernel/cgroup.c
> > @@ -2707,6 +2707,14 @@ static void cgroup_enable_task_cg_lists(void)
> >  	struct task_struct *p, *g;
> >  	write_lock(&css_set_lock);
> 
> You might want to re-test use_task_css_set_links once you have the lock
> in order to avoid an unnecessary do_each_thread()/while_each_thread() in
> case you race between reading the value and entering the loop. This is
> a potential optimization in a rare case so maybe not worth the LOC.

Makes sense. I'll do that in a seperate patch.

> 
> >  	use_task_css_set_links = 1;
> > +	/*
> > +	 * We need tasklist_lock because RCU is not safe against
> > +	 * while_each_thread(). Besides, a forking task that has passed
> > +	 * cgroup_post_fork() without seeing use_task_css_set_links = 1
> > +	 * is not guaranteed to have its child immediately visible in the
> > +	 * tasklist if we walk through it with RCU.
> > +	 */
> 
> Maybe add TODO to remove the lock once do_each_thread()/while_each_thread()
> is made rcu safe. On a large system, it could take a while to iterate
> over every thread in the system. Thats a long time to hold a spinlock.
> But it only happens once so probably not that big a deal.

I think that even if while_each_thread() was RCU safe, that wouldn't
work here.

Unless I'm mistaken, we have no guarantee that a remote list_add_rcu()
is immediately visible by the local CPU if it walks the list under
rcu_read_lock() only.

Consider that ordering scenario:

CPU 0                                      CPU 1
---------------                        --------------

fork() {
	write_lock(tasklist_lock);
        add child to tasklist
	write_unlock(tasklist_lock);
        cgroup_post_fork()
}

                                         cgroup_enable_task_cg_lists() {
                                                rcu_read_lock();
                                                do_each_thread() {
                                                        ..... <-- find child ?
                                                } while_each_thread()
                                                rcu_read_unlock()


We have no guarantee here that the write on CPU 0 will be visible
in time to CPU 1.

But may be I misunderstood the ordering and committing guarantees with RCU.
Perhaps Paul can confirm or correct me.

Paul?
