Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab1G1BIl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 21:08:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36793 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863Ab1G1BIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 21:08:35 -0400
Date: Thu, 28 Jul 2011 11:08:13 +1000
From: NeilBrown <neilb@suse.de>
To: paulmck@linux.vnet.ibm.com
Cc: Ben Blum <bblum@andrew.cmu.edu>, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Oleg Nesterov <oleg@tv-sign.ru>,
        containers@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Possible race between cgroup_attach_proc and de_thread, and
 questionable code in de_thread.
Message-ID: <20110728110813.7ff84b13@notabene.brown>
In-Reply-To: <20110727234235.GA2318@linux.vnet.ibm.com>
References: <20110727171101.5e32d8eb@notabene.brown>
	<20110727150710.GB5242@unix33.andrew.cmu.edu>
	<20110727234235.GA2318@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jul 2011 16:42:35 -0700 "Paul E. McKenney"
<paulmck@linux.vnet.ibm.com> wrote:

> On Wed, Jul 27, 2011 at 11:07:10AM -0400, Ben Blum wrote:
> > On Wed, Jul 27, 2011 at 05:11:01PM +1000, NeilBrown wrote:
> 
> [ . . . ]
> 
> > >  The race as I understand it is with this code:
> > > 
> > > 
> > > 		list_replace_rcu(&leader->tasks, &tsk->tasks);
> > > 		list_replace_init(&leader->sibling, &tsk->sibling);
> > > 
> > > 		tsk->group_leader = tsk;
> > > 		leader->group_leader = tsk;
> > > 
> > > 
> > >  which seems to be called with only tasklist_lock held, which doesn't seem to
> > >  be held in the cgroup code.
> > > 
> > >  If the "thread_group_leader(leader)" call in cgroup_attach_proc() runs before
> > >  this chunk is run with the same value for 'leader', but the
> > >  while_each_thread is run after, then the while_read_thread() might loop
> > >  forever.  rcu_read_lock doesn't prevent this from happening.
> > 
> > Somehow I was under the impression that holding tasklist_lock (for
> > writing) provided exclusion from code that holds rcu_read_lock -
> > probably because there are other points in the kernel which do
> > while_each_thread with only RCU-read held (and not tasklist):
> > 
> > - kernel/hung_task.c, check_hung_uninterruptible_tasks()
> 
> This one looks OK to me.  The code is just referencing fields in each
> of the task structures, and appears to be making proper use of
> rcu_dereference().  All this code requires is that the task structures
> remain in existence through the full lifetime of the RCU read-side
> critical section, which is guaranteed because of the way the task_struct
> is freed.

I disagree.  It also requires - by virtue of the use of while_each_thread() -
that 'g' remains on the list that 't' is walking along.

Now for a normal list, the head always stays on the list and is accessible
even from an rcu-removed entry.  But the thread_group list isn't a normal
list.  It doesn't have a distinct head.  It is a loop of all of the
'task_structs' in a thread group.  One of them is designated the 'leader' but
de_thread() can change the 'leader' - though it doesn't remove the old leader.

__unhash_process in mm/exit.c looks like it could remove the leader from the
list and definitely could remove a non-leader.

So if a non-leader calls 'exec' and the leader calls 'exit', then a
task_struct that was the leader could become a non-leader and then be removed
from the list that kernel/hung_task could be walking along.

So I don't think that while_each_thread() is currently safe.  It depends on
the thread leader not disappearing and I think it can.

So I'm imagining a patch like this to ensure that while_each_thread() is
actually safe.  If it is always safe you can remove that extra check in
cgroup_attach_proc() which looked wrong.

I just hope someone who understands the process tree is listening..
The change in exit.c is the most uncertain part.

NeilBrown

diff --git a/fs/exec.c b/fs/exec.c
index 6075a1e..c9ea5f0 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -960,6 +960,9 @@ static int de_thread(struct task_struct *tsk)
 		list_replace_init(&leader->sibling, &tsk->sibling);
 
 		tsk->group_leader = tsk;
+		smp_mb(); /* ensure that any reader will always be able to see
+			   * a task that claims to be the group leader
+			   */
 		leader->group_leader = tsk;
 
 		tsk->exit_signal = SIGCHLD;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 14a6c7b..13e0192 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2267,8 +2267,10 @@ extern bool current_is_single_threaded(void);
 #define do_each_thread(g, t) \
 	for (g = t = &init_task ; (g = t = next_task(g)) != &init_task ; ) do
 
+/* Thread group leader can change, so stop loop when we see one
+ * even if it isn't 'g' */
 #define while_each_thread(g, t) \
-	while ((t = next_thread(t)) != g)
+	while ((t = next_thread(t)) != g && !thread_group_leader(t))
 
 static inline int get_nr_threads(struct task_struct *tsk)
 {
diff --git a/kernel/exit.c b/kernel/exit.c
index f2b321b..d6cef25 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -70,8 +70,13 @@ static void __unhash_process(struct task_struct *p, bool group_dead)
 		list_del_rcu(&p->tasks);
 		list_del_init(&p->sibling);
 		__this_cpu_dec(process_counts);
-	}
-	list_del_rcu(&p->thread_group);
+	} else
+		/* only remove members from the thread group.
+		 * The thread group leader must stay so that
+		 * while_each_thread() uses can see the end of
+		 * the list and stop.
+		 */
+		list_del_rcu(&p->thread_group);
 }
 
 /*

