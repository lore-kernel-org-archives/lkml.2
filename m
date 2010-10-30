Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592Ab0J3VCt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 17:02:49 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:37494 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414Ab0J3VCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 17:02:46 -0400
Date: Sat, 30 Oct 2010 14:02:44 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: sergey.senozhatsky@gmail.com, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH] rcu_read_lock/unlock protect find_task_by_vpid call
Message-ID: <20101030210244.GE2664@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20101029125550.GA3932@swordfish.minsk.epam.com>
 <20101029201648.GK2367@linux.vnet.ibm.com>
 <20101030093234.GK3932@swordfish.minsk.epam.com>
 <201010302214.DDF98906.MSFJOFtFHOLQVO@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010302214.DDF98906.MSFJOFtFHOLQVO@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 30, 2010 at 10:14:23PM +0900, Tetsuo Handa wrote:
> Sergey Senozhatsky wrote:
> > On (10/29/10 13:16), Paul E. McKenney wrote:
> > > Interesting...
> > > 
> > > The task-list lock is read-held at this point, which should mean that
> > > the PID mapping cannot change.  The lockdep_tasklist_lock_is_held()
> > > function does lockdep_is_held(&tasklist_lock), which must therefore
> > > only be checking for write-holding the lock.  The fix would be to
> > > make lockdep_tasklist_lock_is_held() check for either read-holding or
> > > write-holding tasklist lock.
> > > 
> > > Or is there some subtle reason that read-holding the tasklist lock is
> > > not sufficient?
> 
> This was discussed in the thread at http://kerneltrap.org/mailarchive/linux-kernel/2009/12/10/4517520 .
> Quoting from one of posts in that thead http://kerneltrap.org/mailarchive/linux-kernel/2010/2/8/4536388
> 
> | Usually tasklist gives enough protection, but if copy_process() fails
> | it calls free_pid() lockless and does call_rcu(delayed_put_pid().
> | This means, without rcu lock find_pid_ns() can't scan the hash table
> | safely.
> 
> And now the patch that adds
> 
> 	rcu_lockdep_assert(rcu_read_lock_held());
> 
> was merged in accordance with that comment.
> Therefore, I thing below change is not good.
> 
> > Should it be changed to (let's say)
> > 
> > struct task_struct *find_task_by_pid_ns(pid_t nr, struct pid_namespace *ns)
> > {
> > -	rcu_lockdep_assert(rcu_read_lock_held());
> > +	rcu_lockdep_assert(rcu_read_lock_held() || lockdep_tasklist_lock_is_held());
> > 	return pid_task(find_pid_ns(nr, ns), PIDTYPE_PID);
> > }

So we should remove the lockdep_tasklist_lock_is_held() and then
apply Sergey's patch, correct?

							Thanx, Paul
