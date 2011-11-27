Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab1K0TWF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 14:22:05 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57553 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab1K0TWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 14:22:03 -0500
Date: Sun, 27 Nov 2011 11:21:55 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: paul@paulmenage.org, rjw@sisk.pl, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, fweisbec@gmail.com,
        matthltc@us.ibm.com, akpm@linux-foundation.org, oleg@redhat.com,
        kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH UPDATED 03/10] threadgroup: extend threadgroup_lock()
 to cover exit and exec
Message-ID: <20111127192155.GB4266@google.com>
References: <1320191193-8110-1-git-send-email-tj@kernel.org>
 <1320191193-8110-4-git-send-email-tj@kernel.org>
 <20111124225054.GA14828@google.com>
 <CA+55aFxq1wztMzYhKaY5RHazLBDz4pSXUgiGzTj2wA6EJcDbAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxq1wztMzYhKaY5RHazLBDz4pSXUgiGzTj2wA6EJcDbAw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

On Thu, Nov 24, 2011 at 08:02:18PM -0800, Linus Torvalds wrote:
>  - do you even *need* two separate locks at all? If you extend the
> threadgroup_fork_lock to cover exec/exit too (and rename it), then why
> does that separate cred_guard_mutex make sense at all?

That was mostly choosing the path of least resistance as both locks
already existed and exec exclusion was added later on, but yeah there
isn't much to lose by merging those two locks (do_exit nesting inside
exec will need some care tho).  I'll try to unify the two locks.

>   Taking two locks for the common exit case seems disgusting. What do
> the separate locks buy us?

A bit confused.  threadgroup_change_begin() only locks
signal->group_rwsem.  ie. fork/exit is protected by
signal->group_rwsem.  exec is protected by signal->cred_guard_mutex.
Grabbing both locks gives stable thread group.

>  - could we possible avoid the lock(s) entirely for the
> single-threaded case? The fact that ptrace wants to serialize makes me
> say "maybe we can't avoid it", but I thought I'd ask. Even if we do
> need/want two separate locks, do we really want to take them both for
> the case that shouldn't really need even a single one?

Maybe we can avoid grabbing a lock on exec and exit if the task
belongs to single task process but optimizations like that can be very
fragile.  I think it would be better to merge the two locks and keep
the locking unconditional.

> Hmm? Simplifying the locking rules is always a good idea, and I think
> this seems to make some of it more straightforward, but at the same
> time I shudder when I look at some of the patches in the series that
> nest locking three locks deep. Ugh.

cgroup_root_mutex separation is to avoid lock recursion via
cgroup_show_options and can probably be done in lighter handed way.
As I'm still getting used to cgroup code, I wanted to resolve the
locking order without changing much else.

Anyways, I'll send separated patch series dealing with fork/exec/exit
synchronization.

Thank you.

-- 
tejun
