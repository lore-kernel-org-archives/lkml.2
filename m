Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039Ab2BUWX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 17:23:59 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53149 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816Ab2BUWX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 17:23:58 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of msb@google.com designates 10.68.217.42 as permitted sender) smtp.mail=msb@google.com; dkim=pass header.i=msb@google.com
Date: Tue, 21 Feb 2012 14:23:43 -0800
From: Mandeep Singh Baines <msb@chromium.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Mandeep Singh Baines <msb@chromium.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] cgroup: Walk task list under tasklist_lock in
 cgroup_enable_task_cg_list
Message-ID: <20120221222343.GU3090@google.com>
References: <1328668647-24125-1-git-send-email-fweisbec@gmail.com>
 <1328668647-24125-3-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328668647-24125-3-git-send-email-fweisbec@gmail.com>
X-Operating-System: Linux/2.6.38.8-gg683 (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker (fweisbec@gmail.com) wrote:
> Walking through the tasklist in cgroup_enable_task_cg_list() inside
> an RCU read side critical section is not enough because:
> 
> - RCU is not (yet) safe against while_each_thread()
> 
> - If we use only RCU, a forking task that has passed cgroup_post_fork()
>   without seeing use_task_css_set_links == 1 is not guaranteed to have
>   its child immediately visible in the tasklist if we walk through it
>   remotely with RCU. In this case it will be missing in its css_set's
>   task list.
> 
> Thus we need to traverse the list (unfortunately) under the
> tasklist_lock. It makes us safe against while_each_thread() and also
> make sure we see all forked task that have been added to the tasklist.
> 
> As a secondary effect, reading and writing use_task_css_set_links are
> now well ordered against tasklist traversing and modification. The new
> layout is:
> 
> CPU 0                                      CPU 1
> 
> use_task_css_set_links = 1                write_lock(tasklist_lock)
> read_lock(tasklist_lock)                  add task to tasklist
> do_each_thread() {                        write_unlock(tasklist_lock)
> 	add thread to css set links       if (use_task_css_set_links)
> } while_each_thread()                         add thread to css set links
> read_unlock(tasklist_lock)
> 
> If CPU 0 traverse the list after the task has been added to the tasklist
> then it is correctly added to the css set links. OTOH if CPU 0 traverse
> the tasklist before the new task had the opportunity to be added to the
> tasklist because it was too early in the fork process, then CPU 1
> catches up and add the task to the css set links after it added the task
> to the tasklist. The right value of use_task_css_set_links is guaranteed
> to be visible from CPU 1 due to the LOCK/UNLOCK implicit barrier properties:
> the read_unlock on CPU 0 makes the write on use_task_css_set_links happening
> and the write_lock on CPU 1 make the read of use_task_css_set_links that comes
> afterward to return the correct value.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Mandeep Singh Baines <msb@chromium.org>

Reviewed-by: Mandeep Singh Baines <msb@chromium.org>

Sorry for being late. My feedback is really just comments.

> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  kernel/cgroup.c |   20 ++++++++++++++++++++
>  1 files changed, 20 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 6e4eb43..c6877fe 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -2707,6 +2707,14 @@ static void cgroup_enable_task_cg_lists(void)
>  	struct task_struct *p, *g;
>  	write_lock(&css_set_lock);

You might want to re-test use_task_css_set_links once you have the lock
in order to avoid an unnecessary do_each_thread()/while_each_thread() in
case you race between reading the value and entering the loop. This is
a potential optimization in a rare case so maybe not worth the LOC.

>  	use_task_css_set_links = 1;
> +	/*
> +	 * We need tasklist_lock because RCU is not safe against
> +	 * while_each_thread(). Besides, a forking task that has passed
> +	 * cgroup_post_fork() without seeing use_task_css_set_links = 1
> +	 * is not guaranteed to have its child immediately visible in the
> +	 * tasklist if we walk through it with RCU.
> +	 */

Maybe add TODO to remove the lock once do_each_thread()/while_each_thread()
is made rcu safe. On a large system, it could take a while to iterate
over every thread in the system. Thats a long time to hold a spinlock.
But it only happens once so probably not that big a deal.

> +	read_lock(&tasklist_lock);
>  	do_each_thread(g, p) {
>  		task_lock(p);
>  		/*
> @@ -2718,6 +2726,7 @@ static void cgroup_enable_task_cg_lists(void)
>  			list_add(&p->cg_list, &p->cgroups->tasks);
>  		task_unlock(p);
>  	} while_each_thread(g, p);
> +	read_unlock(&tasklist_lock);
>  	write_unlock(&css_set_lock);
>  }
>  
> @@ -4522,6 +4531,17 @@ void cgroup_fork_callbacks(struct task_struct *child)
>   */
>  void cgroup_post_fork(struct task_struct *child)
>  {
> +	/*
> +	 * use_task_css_set_links is set to 1 before we walk the tasklist
> +	 * under the tasklist_lock and we read it here after we added the child
> +	 * to the tasklist under the tasklist_lock as well. If the child wasn't
> +	 * yet in the tasklist when we walked through it from
> +	 * cgroup_enable_task_cg_lists(), then use_task_css_set_links value
> +	 * should be visible now due to the paired locking and barriers implied
> +	 * by LOCK/UNLOCK: it is written before the tasklist_lock unlock
> +	 * in cgroup_enable_task_cg_lists() and read here after the tasklist_lock
> +	 * lock on fork.
> +	 */
>  	if (use_task_css_set_links) {
>  		write_lock(&css_set_lock);
>  		if (list_empty(&child->cg_list)) {
> -- 
> 1.7.5.4
> 
