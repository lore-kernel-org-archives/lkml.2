Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759977Ab2CUTAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 15:00:16 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48673 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445Ab2CUTAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 15:00:10 -0400
Date: Wed, 21 Mar 2012 11:59:55 -0700
From: Mandeep Singh Baines <msb@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Mandeep Singh Baines <msb@chromium.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Paul Menage <paul@paulmenage.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: Q: cgroup: Questions about possible issues in cgroup locking
Message-ID: <20120321185955.GK27051@google.com>
References: <20120111160730.GA24556@redhat.com>
 <20120112003102.GB9511@google.com>
 <20120112170728.GA25717@redhat.com>
 <20120112175725.GD9511@google.com>
 <20120113152010.GA19215@redhat.com>
 <20120113182750.GD18166@google.com>
 <20120114173648.GA32543@redhat.com>
 <20120118231742.GS18166@google.com>
 <20120119154522.GA14058@redhat.com>
 <20120320193414.GA21277@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120320193414.GA21277@redhat.com>
X-Operating-System: Linux/2.6.38.8-gg683 (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov (oleg@redhat.com) wrote:
> OK, finally we should do something with this problem ;)
> 
> On 01/19, Oleg Nesterov wrote:
> >
> > I'll try to investigate if we can remove
> >
> > 	leader->group_leader = tsk;
> >
> > from de_thread(). In fact I already thought about this change a long
> > ago without any connection to while_each_thread(). This assignment
> > looks "assymetrical" compared to other threads we kill. But we did
> > have a reason (reasons?). Hopefully, the only really important reason
> > was already removed by 087806b1.
> 
> On the second thought, I think we should not do this.
> 
> For example, do_prlimit() assumes that tsk->group_leader is correct
> under tasklist_lock.
> 
> OK, lets return to the thread_group_leader() check. To ensure we do
> not visit the same thread twice we can check 'g', not 't'.
> 
> This is what I am going to send, after I re-check once again...
> 
> I have the problem with the changelog ;) Somehow it should explain
> that while_each_thread_rcu(g, t) can't race with do_group_exit().
> I think it can't, list_del_rcu(leader->thread_group) happens when
> this entry is already "empty", it should be the last thread in group.
> If the non-leader thread goes away from the least, we still have
> the "path" to reach the leader. But this is not easy to explain.
> 
> As for the barrier. If de_thread() changes the leader it drops
> and re-acquires tasklist_lock (this implies mb) after it changes
> old_leader->exit_signal (used in thread_group_leader) and before
> __unhash_process() which does list_del_rcu().
> 
> This means that if while_each_thread() sees the result of
> list_del_rcu(old_leader) it must also see that
> thread_group_leader(old_leader) != T.
> 
> What do you think? Do you see any problems?
> 
> Oleg.
> ---
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 7d379a6..f169bfd 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -2323,9 +2323,24 @@ extern bool current_is_single_threaded(void);
>  #define do_each_thread(g, t) \
>  	for (g = t = &init_task ; (g = t = next_task(g)) != &init_task ; ) do
>  
> +/*
> + * needs tasklist_lock or ->siglock, or rcu if the caller ensures
> + * that 'g' can't exit or exec.
> + */
>  #define while_each_thread(g, t) \
>  	while ((t = next_thread(t)) != g)
>  
> +/*
> + * rcu-safe, but should start at ->group_leader.
> + * thread_group_leader(g) protects against the race with exec which
> + * removes the leader from list.
> + * smp_rmb() pairs with implicit mb() implied by unlock + lock in
> + * de_thread()->release_task() path.
> + */
> +#define while_each_thread_rcu(g, t)				\
> +	while ((t = next_thread(t)) != g &&			\
> +		({ smp_rmb(); thread_group_leader(g); }))
> +

Couldn't you miss the exec_thread if:

t = exec_thread && !thread_group_leader(g)

i.e. if you just passed (leader->group_leader = tsk;) in de_thread().

Could we change do_prlimit()? Especially since its slow path.

I really like you're earlier solution (ignoring barrier):

#define while_each_thread(g, t) \
	while (t->group_leader == g->group_leader && (t = next_thread(t)) != g)

Regards,
Mandeep

>  static inline int get_nr_threads(struct task_struct *tsk)
>  {
>  	return tsk->signal->nr_threads;
> 
