Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab0KHDBZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 22:01:25 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:37284 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948Ab0KHDBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 22:01:24 -0500
Date: Sun, 7 Nov 2010 19:01:16 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: sergey.senozhatsky@gmail.com, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH] rcu_read_lock/unlock protect find_task_by_vpid call
Message-ID: <20101108030116.GB2580@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20101030093234.GK3932@swordfish.minsk.epam.com>
 <201010302214.DDF98906.MSFJOFtFHOLQVO@I-love.SAKURA.ne.jp>
 <20101030210244.GE2664@linux.vnet.ibm.com>
 <201010310833.CCE89052.FtQFHSOFLOOJMV@I-love.SAKURA.ne.jp>
 <20101107194330.GE15561@linux.vnet.ibm.com>
 <201011080704.GIH17609.SFVQLtJOOHFFMO@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201011080704.GIH17609.SFVQLtJOOHFFMO@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 07:04:43AM +0900, Tetsuo Handa wrote:
> Hello.
> 
> Paul E. McKenney wrote:
> > > Users missing rcu_read_lock() when calling find_task_by_vpid():
> > > 
> > >   check_clock() in kernel/posix-cpu-timers.c
> > 
> > 	This one has read_lock(&tasklist_lock).
> > 
> Excuse me. Holding tasklist_lock lock does not help.
> We must call rcu_read_lock() explicitly.
> That's why 9728e5d6 "kernel/pid.c: update comment on find_task_by_pid_ns" was made.

OK, good point, there are a few more kernels of unpopped corn here.

> I think there are users who needlessly call read_lock(&tasklist_lock)
> when they can use rcu_read_lock() instead.
> But I don't know when to use read_lock(&tasklist_lock).
> 
> If read_lock(&tasklist_lock) is needed only when we want to access
> the "struct task_struct" after rcu_read_unlock(), maybe it is cleaner to
> use a helper like
> 
> struct task_struct *find_task_and_get(pid_t pid)
> {
> 	struct task_struct *task;
> 	read_lock(&tasklist_lock);
> 	rcu_read_lock();
> 	task = find_task_by_vpid(pid);
> 	rcu_read_unlock();
> 	if (task)
> 		get_task_struct(task);
> 	read_unlock(&tasklist_lock);
> 	return task;
> }
> 
> and hide tasklist_lock.

This makes a lot of sense to me!  That said, most of the current
open-coded variants of your find_task_and_get() seem to have the
rcu_read_unlock() after the get_task_struct() rather than before.  But I
don't claim to understand the locking design of this part of the kernel
well enough to say which is the best approach.

So, either way, will you be submitting the patches for this?

							Thanx, Paul
