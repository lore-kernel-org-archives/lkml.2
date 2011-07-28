Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab1G1G0p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 02:26:45 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.95]:41441 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814Ab1G1G0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 02:26:39 -0400
Date: Thu, 28 Jul 2011 02:26:16 -0400
From: Ben Blum <bblum@andrew.cmu.edu>
To: NeilBrown <neilb@suse.de>
Cc: paulmck@linux.vnet.ibm.com, Ben Blum <bblum@andrew.cmu.edu>,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Oleg Nesterov <oleg@tv-sign.ru>, containers@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Possible race between cgroup_attach_proc and de_thread, and
 questionable code in de_thread.
Message-ID: <20110728062616.GC15204@unix33.andrew.cmu.edu>
References: <20110727171101.5e32d8eb@notabene.brown>
 <20110727150710.GB5242@unix33.andrew.cmu.edu>
 <20110727234235.GA2318@linux.vnet.ibm.com>
 <20110728110813.7ff84b13@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110728110813.7ff84b13@notabene.brown>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2011.5.19.222118
X-SMTP-Spam-Clean: 8% (
 BODY_SIZE_4000_4999 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, __ANY_URI 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CD 0, __CT 0, __CT_TEXT_PLAIN 0, __FRAUD_REFNUM 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __URI_NS , __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 28, 2011 at 11:08:13AM +1000, NeilBrown wrote:
> On Wed, 27 Jul 2011 16:42:35 -0700 "Paul E. McKenney"
> <paulmck@linux.vnet.ibm.com> wrote:
> 
> > On Wed, Jul 27, 2011 at 11:07:10AM -0400, Ben Blum wrote:
> > > On Wed, Jul 27, 2011 at 05:11:01PM +1000, NeilBrown wrote:
> > 
> > [ . . . ]
> > 
> > > >  The race as I understand it is with this code:
> > > > 
> > > > 
> > > > 		list_replace_rcu(&leader->tasks, &tsk->tasks);
> > > > 		list_replace_init(&leader->sibling, &tsk->sibling);
> > > > 
> > > > 		tsk->group_leader = tsk;
> > > > 		leader->group_leader = tsk;
> > > > 
> > > > 
> > > >  which seems to be called with only tasklist_lock held, which doesn't seem to
> > > >  be held in the cgroup code.
> > > > 
> > > >  If the "thread_group_leader(leader)" call in cgroup_attach_proc() runs before
> > > >  this chunk is run with the same value for 'leader', but the
> > > >  while_each_thread is run after, then the while_read_thread() might loop
> > > >  forever.  rcu_read_lock doesn't prevent this from happening.
> > > 
> > > Somehow I was under the impression that holding tasklist_lock (for
> > > writing) provided exclusion from code that holds rcu_read_lock -
> > > probably because there are other points in the kernel which do
> > > while_each_thread with only RCU-read held (and not tasklist):
> > > 
> > > - kernel/hung_task.c, check_hung_uninterruptible_tasks()
> > 
> > This one looks OK to me.  The code is just referencing fields in each
> > of the task structures, and appears to be making proper use of
> > rcu_dereference().  All this code requires is that the task structures
> > remain in existence through the full lifetime of the RCU read-side
> > critical section, which is guaranteed because of the way the task_struct
> > is freed.
> 
> I disagree.  It also requires - by virtue of the use of while_each_thread() -
> that 'g' remains on the list that 't' is walking along.
> 
> Now for a normal list, the head always stays on the list and is accessible
> even from an rcu-removed entry.  But the thread_group list isn't a normal
> list.  It doesn't have a distinct head.  It is a loop of all of the
> 'task_structs' in a thread group.  One of them is designated the 'leader' but
> de_thread() can change the 'leader' - though it doesn't remove the old leader.
> 
> __unhash_process in mm/exit.c looks like it could remove the leader from the
> list and definitely could remove a non-leader.
> 
> So if a non-leader calls 'exec' and the leader calls 'exit', then a
> task_struct that was the leader could become a non-leader and then be removed
> from the list that kernel/hung_task could be walking along.

That agrees with my understanding.

> 
> So I don't think that while_each_thread() is currently safe.  It depends on
> the thread leader not disappearing and I think it can.

I think that while_each_thread is perfectly safe, it just needs to be
protected properly while used. it reads the tasklist, and both competing
paths (__unhash_process and de_thread) are done with tasklist_lock write
locked, so read-locking ought to suffice. all it needs is to be better
documented.

> [...]
> 
> +/* Thread group leader can change, so stop loop when we see one
> + * even if it isn't 'g' */
>  #define while_each_thread(g, t) \
> -	while ((t = next_thread(t)) != g)
> +	while ((t = next_thread(t)) != g && !thread_group_leader(t))

this is semantically wrong: it will stop as soon as it finds a thread
that has newly become the leader, and not run the loop body code in that
thread's case. so the thread that just execed would not get run on, and
in the case of my code, would "escape" the cgroup migration.

but I argue it is also organisationally wrong. while_each_thread's
purpose is just to worry about the structure of the process list, not to
account for behavioural details of de_thread. this check belongs outside
of the macro, and it should be protected by tasklist_lock in the same
critical section in which while_each_thread is used.

-- Ben

>  
>  static inline int get_nr_threads(struct task_struct *tsk)
>  {
> diff --git a/kernel/exit.c b/kernel/exit.c
> index f2b321b..d6cef25 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -70,8 +70,13 @@ static void __unhash_process(struct task_struct *p, bool group_dead)
>  		list_del_rcu(&p->tasks);
>  		list_del_init(&p->sibling);
>  		__this_cpu_dec(process_counts);
> -	}
> -	list_del_rcu(&p->thread_group);
> +	} else
> +		/* only remove members from the thread group.
> +		 * The thread group leader must stay so that
> +		 * while_each_thread() uses can see the end of
> +		 * the list and stop.
> +		 */
> +		list_del_rcu(&p->thread_group);
>  }
>  
>  /*
> 
> 
