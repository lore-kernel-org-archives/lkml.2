Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971Ab1KWOCW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 09:02:22 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53915 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755937Ab1KWOCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 09:02:19 -0500
Date: Wed, 23 Nov 2011 15:02:05 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: paul@paulmenage.org, rjw@sisk.pl, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, matthltc@us.ibm.com,
        akpm@linux-foundation.org, oleg@redhat.com,
        kamezawa.hiroyu@Jp.fujitsu.com
Subject: Re: [PATCH 03/10] threadgroup: extend threadgroup_lock() to cover
 exit and exec
Message-ID: <20111123140139.GB10669@somewhere.redhat.com>
References: <1320191193-8110-1-git-send-email-tj@kernel.org>
 <1320191193-8110-4-git-send-email-tj@kernel.org>
 <20111113164426.GB9446@somewhere>
 <20111121215839.GL25776@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111121215839.GL25776@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 01:58:39PM -0800, Tejun Heo wrote:
> > but IMHO the races involved in exit and exec
> > are too different, specific and complicated on their own to be solved in a
> > single one patch. This should be split in two things.
> > 
> > The specific problems and their fix need to be described more in detail
> > in the changelog because the issues are very tricky.
> > 
> > The exec case:
> > 
> > IIUC, the race in exec is about the group leader that can be changed
> > to become the exec'ing thread, making while_each_thread() unsafe.
> 
> Not only that, pid changes, sighand struct may get swapped, and other
> weird things which aren't usually expected for a live task happen.
> It's basically semi-killed and then resurrected.

Right. I've no problem with the fact you want to make the threadgroup
more stable against subsystem attachment. Just please put more
detailed comments about what you are protecting. It took me quite
some time to precisely identify the race involved in that game in
order to consciously review your patches. And I'm thinking about
the next people who will work on this piece of code.

This:

 static inline void threadgroup_lock(struct task_struct *tsk)                                                                
 {                                                                                                                           
+       /* exec uses exit for de-threading, grab cred_guard_mutex first */                                                   
+       mutex_lock(&tsk->signal->cred_guard_mutex);                                                                          
        down_write(&tsk->signal->group_rwsem);

is really not obvious.

Just point out we want to synchronize against the leader, pid and the sighand
that may change concurrently.

> > We also have other things happening there like all the other threads
> > in the group that get killed, but that should be handled by the threadgroup_change_begin()
> > you put in the exit path.
> > The old leader is also killed but release_task() -> __unhash_process() is called
> > for it manually from the exec path. However this thread too should be covered by your
> > synchronisation in exit().
> > 
> > So after your protection in the exit path, the only thing to protect against in exec
> > is that group_leader that can change concurrently. But I may be missing something in the picture.
> 
> Hmm... an exec'ing task goes through transitions which usually aren't
> allowed to happen.  It assumes exclusive access to group-shared data
> structures and may ditch the current one and create a new one.
> 
> Sure, it's possible to make every cgroup method correct w.r.t. all
> those via explicit locking or by being more careful but I don't see
> much point in such excercise.  If the code is sitting in some hot path
> and the added exclusion is gonna add significant amount of contention,
> sure, we should trade off easiness for better performance /
> scalability but this is for cgroup modifications, a fundamentally cold
> path, and the added locking is per-task or per-threadgroup.  I don't
> see any reason not to be easy here.

Sure. I have no problem with that. I just wish we can precisely identify
what we are protecting against, and not have a foggy locking. Especially
when it's about such a very core issue.

> Please read on.
> 
> > Also note this is currently protected by the tasklist readlock. Cred
> > guard mutex is certainly better, I just don't remember if you remove
> > the tasklist lock in a further patch.
> 
> I don't remove tasklist_lock.

I believe you can do it after using the cred guard mutex. That needs to
be double checked though. I think it was mostly there to keep while_each_thread()
stable non-racy against leader change. cred_guard_mutex should handle that
now.

> 
> > The exit case:
> > 
> > There the issue is about racing against cgroup_exit() where the task can be
> > assigned to the root cgroup. Is this really a problem in fact? I don't know
> > if subsystems care about that. Perhaps some of them are buggy in that
> > regard. At least the task counter handles that and it needs a
> > ->cancel_attach_task() for this purpose in the case the migration fails due to exit.
> > Not sure about others. A real synchronization against exit is less error prone for sure.
> > In the end that's probably a win.
> 
> This is the same story.  Yes, we can narrow the locking and try to
> make sure everyone handles partially destroyed tasks properly in all
> methods, but for what?  If we can give stable threadgroups to all
> cgroup methods without introducing performance or scalability
> bottleneck, that's the right thing to do.  Please also note that bugs
> stemming from failure to handle those corner cases properly will be
> subtle, difficult to reproduce and track down.

Agreed.

> In general, for any subsystem with pluggable interface, I think it's
> best to put as much complexity as possible into the core layer to make
> things eaiser for its customers.  It becomes excruciatingly painful if
> the API invites subtle corner case bugs and the subsystem grows
> several dozen clients down the road.

Sure.

> 
> So, to me, what seems more important is how to make it easier for each
> cgroup client instead of what's the minimal that's necessary right
> now.
> 
> Heh, did I make any sense? :)

Yep, fine for me :)
Just wanted to ensure I (and others) understood and identified well the issues
and the fixes.
