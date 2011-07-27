Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab1G0Pb6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 11:31:58 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.96]:55764 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab1G0Pbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 11:31:55 -0400
X-Greylist: delayed 1427 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Jul 2011 11:31:55 EDT
Date: Wed, 27 Jul 2011 11:07:10 -0400
From: Ben Blum <bblum@andrew.cmu.edu>
To: NeilBrown <neilb@suse.de>
Cc: Paul Menage <menage@google.com>, Ben Blum <bblum@andrew.cmu.edu>,
        Li Zefan <lizf@cn.fujitsu.com>, Oleg Nesterov <oleg@tv-sign.ru>,
        containers@lists.linux-foundation.org,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Possible race between cgroup_attach_proc and de_thread, and
 questionable code in de_thread.
Message-ID: <20110727150710.GB5242@unix33.andrew.cmu.edu>
References: <20110727171101.5e32d8eb@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110727171101.5e32d8eb@notabene.brown>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.4.9.4220
X-SMTP-Spam-Clean: 8% (
 BODY_SIZE_4000_4999 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CD 0, __CT 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 05:11:01PM +1000, NeilBrown wrote:
> 
> Hi,
>   I've been exploring the use of RCU in the kernel, particularly looking for
>   things that don't quite look right.  I found cgroup_attach_proc which was
>   added a few months ago.

Awesome, thanks! :)

> 
>  It contains:
> 
> 	rcu_read_lock();
> 	if (!thread_group_leader(leader)) {
> 		/*
> 		 * a race with de_thread from another thread's exec() may strip
> 		 * us of our leadership, making while_each_thread unsafe to use
> 		 * on this task. if this happens, there is no choice but to
> 		 * throw this task away and try again (from cgroup_procs_write);
> 		 * this is "double-double-toil-and-trouble-check locking".
> 		 */
> 		rcu_read_unlock();
> 		retval = -EAGAIN;
> 		goto out_free_group_list;
> 	}
> 
>  (and having the comment helps a lot!)
> 
>  The comment acknowledges a race with de_thread but seems to assume that
>  rcu_read_lock() will protect against that race.  It won't.
>  It could possibly protect if the racy code in de_thread() contained a call
>  to synchronize_rcu(), but it doesn't so there is no obvious exclusion
>  between the two.
>  I note that some other locks are held and maybe some other lock provides
>  the required exclusion - I haven't explored that too deeply - but if that is
>  the case, then the use of rcu_read_lock() here is pointless - it isn't
>  needed just to call thread_group_leader().

I wrote this code, and I admit to not having a full understanding of RCU
myself. The code was once more complicated (before the patches went in,
mind you), and had a series of checks like that leading up to a
list_for_each_entry over the ->thread_group list (in "step 3", instead
of iterating over the flex_array), and had read_lock(&tasklist_lock)
around it. (...)

(The other locks held are just cgroup_mutex and threadgroup_fork_lock,
which wouldn't provide the exclusion.)

> 
>  The race as I understand it is with this code:
> 
> 
> 		list_replace_rcu(&leader->tasks, &tsk->tasks);
> 		list_replace_init(&leader->sibling, &tsk->sibling);
> 
> 		tsk->group_leader = tsk;
> 		leader->group_leader = tsk;
> 
> 
>  which seems to be called with only tasklist_lock held, which doesn't seem to
>  be held in the cgroup code.
> 
>  If the "thread_group_leader(leader)" call in cgroup_attach_proc() runs before
>  this chunk is run with the same value for 'leader', but the
>  while_each_thread is run after, then the while_read_thread() might loop
>  forever.  rcu_read_lock doesn't prevent this from happening.

Somehow I was under the impression that holding tasklist_lock (for
writing) provided exclusion from code that holds rcu_read_lock -
probably because there are other points in the kernel which do
while_each_thread with only RCU-read held (and not tasklist):

- kernel/hung_task.c, check_hung_uninterruptible_tasks()
- kernel/posix-cpu-timers.c, thread_group_cputime()
- fs/ioprio.c, ioprio_set() and ioprio_get()

(There are also places, like kernel/signal.c, where code does
while_each_thread with only sighand->siglock held. this also seems
sketchy, since de_thread only takes that lock after the code quoted
above. there's a big comment in fs/exec.c where this is also done, but I
don't quite understand it.)

You seem to imply that rcu_read_lock() doesn't exclude against
write_lock(&tasklist_lock). If that's true, then we can fix the cgroup
code simply by replacing rcu_read_lock/rcu_read_unlock with
read_lock and read_unlocck on tasklist_lock. (I can hurry a bugfix patch
for this together if so.)

Wouldn't this mean that the three places listed above are also wrong?

> 
>  The code in de_thread() is actually questionable by itself.
>  "list_replace_rcu" cannot really be used on the head of a list - it is only
>  meant to be used on a member of a list.
>  To move a list from one head to another you should be using
>  list_splice_init_rcu().
>  The ->tasks list doesn't seem to have a clearly distinguished 'head' but
>  whatever is passed as 'g' to while_each_thread() is effectively a head and
>  removing it from a list can cause a loop using while_each_thread() can not
>  find the head and so never complete.
> 
>  I' not sure how best to fix this, though possibly changing
>  while_each_thead to:
> 
>    while ((t = next_task(t)) != g && !thread_group_leader(t))
> 
>  might be part of it.  We would also need to move 
>     tsk->group_leader = tsk;
>  in the above up to the top, and probably add some memory barrier.
>  However I don't know enough about how the list is used to be sure.
> 
> Comments?
> 
> Thanks,
> NeilBrown
> 
> 

I barely understand de_thread() from the reader's perspective, let alone
from the author's perspective, so I can't speak for that one.

Thanks for pointing this out!

-- Ben
