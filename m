Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab0J3NOa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 09:14:30 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:53555 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975Ab0J3NO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 09:14:28 -0400
To: paulmck@linux.vnet.ibm.com, sergey.senozhatsky@gmail.com
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH] rcu_read_lock/unlock protect find_task_by_vpid call
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20101029125550.GA3932@swordfish.minsk.epam.com>
	<20101029201648.GK2367@linux.vnet.ibm.com>
	<20101030093234.GK3932@swordfish.minsk.epam.com>
In-Reply-To: <20101030093234.GK3932@swordfish.minsk.epam.com>
Message-Id: <201010302214.DDF98906.MSFJOFtFHOLQVO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 30 Oct 2010 22:14:23 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergey Senozhatsky wrote:
> On (10/29/10 13:16), Paul E. McKenney wrote:
> > Interesting...
> > 
> > The task-list lock is read-held at this point, which should mean that
> > the PID mapping cannot change.  The lockdep_tasklist_lock_is_held()
> > function does lockdep_is_held(&tasklist_lock), which must therefore
> > only be checking for write-holding the lock.  The fix would be to
> > make lockdep_tasklist_lock_is_held() check for either read-holding or
> > write-holding tasklist lock.
> > 
> > Or is there some subtle reason that read-holding the tasklist lock is
> > not sufficient?

This was discussed in the thread at http://kerneltrap.org/mailarchive/linux-kernel/2009/12/10/4517520 .
Quoting from one of posts in that thead http://kerneltrap.org/mailarchive/linux-kernel/2010/2/8/4536388

| Usually tasklist gives enough protection, but if copy_process() fails
| it calls free_pid() lockless and does call_rcu(delayed_put_pid().
| This means, without rcu lock find_pid_ns() can't scan the hash table
| safely.

And now the patch that adds

	rcu_lockdep_assert(rcu_read_lock_held());

was merged in accordance with that comment.
Therefore, I thing below change is not good.

> Should it be changed to (let's say)
> 
> struct task_struct *find_task_by_pid_ns(pid_t nr, struct pid_namespace *ns)
> {
> -	rcu_lockdep_assert(rcu_read_lock_held());
> +	rcu_lockdep_assert(rcu_read_lock_held() || lockdep_tasklist_lock_is_held());
> 	return pid_task(find_pid_ns(nr, ns), PIDTYPE_PID);
> }

Regards.
