Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab2FWTpQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 15:45:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46356 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755775Ab2FWTpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 15:45:14 -0400
Date: Sat, 23 Jun 2012 20:45:05 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        ". James Morris" <jmorris@namei.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: deferring __fput()
Message-ID: <20120623194505.GI14083@ZenIV.linux.org.uk>
References: <1340369098.2464.20.camel@falcor>
 <20120623092049.GH14083@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120623092049.GH14083@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2012 at 10:20:49AM +0100, Al Viro wrote:

> What I have in mind is something like
> 	if (unlikely(in_atomic() || current->flags & PF_KTHREAD))
> 		move file to global list, use schedul_work() to have it dealt with
> 	else
> 		move to per-task list, do task_work_add() if it was empty (i.e.
> 		if we hadn't scheduled its emptying already).
> The latter is completely thread-synchronous, so we shouldn't need any locking
> whatsoever.  The former... I'd probably go for a single list, protected by
> spin_lock_irq(), keeping the possibility to switch to per-CPU lists if we
> find a load that gets serious contention on that list.  In any case, worker will
> start with taking the list contents, emptying the list and then killing the
> suckers off one by one.

BTW, I really wonder why do we need to have that void *data in task_work; we can
always embed the sucker into a bigger struct (if nothing else, task_work +
void *data) and get to it via container_of().  And in quite a few cases we don't
want that data thing at all.  Moreover, the reasons to use hlist_head instead of
a single forward pointer are very thin on the ground:
	* task_work_add() adds to the beginning of the list
	* task_work_cancel() walks the list to find the entry to remove
	* trask_work_run() takes the list out, walks it to the end,
then walks it backwards via pprev.  Could as well reverse the pointers
while walking forward...

Oleg, do you see any reasons why trimming it down to forward pointer + callback
pointer wouldn't work?  Matter of fact, it would become identical to struct rcu_head
after that...
