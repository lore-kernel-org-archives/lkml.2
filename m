Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434Ab0FRTgJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 15:36:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2294 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333Ab0FRTgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 15:36:07 -0400
Date: Fri, 18 Jun 2010 21:34:03 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Don Zickus <dzickus@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Jerome Marchand <jmarchan@redhat.com>,
       Mandeep Singh Baines <msb@google.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: while_each_thread() under rcu_read_lock() is broken?
Message-ID: <20100618193403.GA17314@redhat.com>
References: <20100618190251.GA17297@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100618190251.GA17297@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(add cc's)

Hmm. Once I sent this patch, I suddenly realized with horror that
while_each_thread() is NOT safe under rcu_read_lock(). Both
do_each_thread/while_each_thread or do/while_each_thread() can
race with exec().

Yes, it is safe to do next_thread() or next_task(). But:

	#define while_each_thread(g, t) \
		while ((t = next_thread(t)) != g)

suppose that t is not the group leader, and it does de_thread() and then
release_task(g). After that next_thread(t) returns t, not g, and the loop
will never stop.

I _really_ hope I missed something, will recheck tomorrow with the fresh
head. Still I'd like to share my concerns...

If I am right, probably we can fix this, something like

	#define while_each_thread(g, t) \
		while ((t = next_thread(t)) != g && pid_alive(g))

[we can't do while (!thread_group_leadr(t = next_thread(t)))].
but this needs barrires, and we should validate the callers anyway.

Or, perhaps,

	#define XXX(t)	({
		struct task_struct *__prev = t;
		t = next_thread(t);
		t != g && t != __prev;
	})

	#define while_each_thread(g, t) \
		while (XXX(t))

Please tell me I am wrong!

Oleg.

On 06/18, Oleg Nesterov wrote:
>
> check_hung_uninterruptible_tasks()->rcu_lock_break() introduced by
> "softlockup: check all tasks in hung_task" commit ce9dbe24 looks
> absolutely wrong.
>
> 	- rcu_lock_break() does put_task_struct(). If the task has exited
> 	  it is not safe to even read its ->state, nothing protects this
> 	  task_struct.
>
> 	- The TASK_DEAD checks are wrong too. Contrary to the comment, we
> 	  can't use it to check if the task was unhashed. It can be unhashed
> 	  without TASK_DEAD, or it can be valid with TASK_DEAD.
>
> 	  For example, an autoreaping task can do release_task(current)
> 	  long before it sets TASK_DEAD in do_exit().
>
> 	  Or, a zombie task can have ->state == TASK_DEAD but release_task()
> 	  was not called, and in this case we must not break the loop.
>
> Change this code to check pid_alive() instead, and do this before we
> drop the reference to the task_struct.
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>
>  kernel/hung_task.c |   11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>
> --- 35-rc2/kernel/hung_task.c~CHT_FIX_RCU_LOCK_BREAK	2009-12-18 19:05:38.000000000 +0100
> +++ 35-rc2/kernel/hung_task.c	2010-06-18 20:06:11.000000000 +0200
> @@ -113,15 +113,20 @@ static void check_hung_task(struct task_
>   * For preemptible RCU it is sufficient to call rcu_read_unlock in order
>   * exit the grace period. For classic RCU, a reschedule is required.
>   */
> -static void rcu_lock_break(struct task_struct *g, struct task_struct *t)
> +static bool rcu_lock_break(struct task_struct *g, struct task_struct *t)
>  {
> +	bool can_cont;
> +
>  	get_task_struct(g);
>  	get_task_struct(t);
>  	rcu_read_unlock();
>  	cond_resched();
>  	rcu_read_lock();
> +	can_cont = pid_alive(g) && pid_alive(t);
>  	put_task_struct(t);
>  	put_task_struct(g);
> +
> +	return can_cont;
>  }
>
>  /*
> @@ -148,9 +153,7 @@ static void check_hung_uninterruptible_t
>  			goto unlock;
>  		if (!--batch_count) {
>  			batch_count = HUNG_TASK_BATCHING;
> -			rcu_lock_break(g, t);
> -			/* Exit if t or g was unhashed during refresh. */
> -			if (t->state == TASK_DEAD || g->state == TASK_DEAD)
> +			if (!rcu_lock_break(g, t))
>  				goto unlock;
>  		}
>  		/* use "==" to skip the TASK_KILLABLE tasks waiting on NFS */

