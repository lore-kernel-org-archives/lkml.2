Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab2FWU6J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 16:58:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47015 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755906Ab2FWU6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 16:58:06 -0400
Date: Sat, 23 Jun 2012 21:57:55 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        ". James Morris" <jmorris@namei.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, David Miller <davem@davemloft.net>
Subject: Re: deferring __fput()
Message-ID: <20120623205755.GJ14083@ZenIV.linux.org.uk>
References: <1340369098.2464.20.camel@falcor>
 <20120623092049.GH14083@ZenIV.linux.org.uk>
 <20120623194505.GI14083@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120623194505.GI14083@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2012 at 08:45:05PM +0100, Al Viro wrote:
> BTW, I really wonder why do we need to have that void *data in task_work; we can
> always embed the sucker into a bigger struct (if nothing else, task_work +
> void *data) and get to it via container_of().  And in quite a few cases we don't
> want that data thing at all.  Moreover, the reasons to use hlist_head instead of
> a single forward pointer are very thin on the ground:
> 	* task_work_add() adds to the beginning of the list
> 	* task_work_cancel() walks the list to find the entry to remove
> 	* trask_work_run() takes the list out, walks it to the end,
> then walks it backwards via pprev.  Could as well reverse the pointers
> while walking forward...

You know what...  Let's dump that "reverse the list" thing completely.  What we ought to
do instead of that is honestly keeping both the head of the (single-linked) list and
pointer to pointer to its last element.  Sure, that'll eat one more word in task_struct.
And it doesn't matter, since we'll be able to kill something else in there - namely,
->scm_work_list.  The whole reason we have it is that we want to prevent recursion
in __scm_destroy(); with __fput() getting done via task_work_add() this recursion
will be gone automatically.

So here's what I want to do:

1) kill task_work->data; the only user that cares will allocate task_work + struct cred * and
use container_of() to get to it.

2) replace current->task_works with struct task_work *task_works, **last_work and replace
hlist_node in task_work with struct task_work *next; task_work_add() would add to the tail,
task_work_cancel() would do the obvious "scan the single-linked list, remove the element
found" wihtout bothering with hlist and task_work_run() would just walk the list in direct
order.

3) at that point task_work is equal in size (and layout, BTW) to rcu_head.  So we can add it
into the same union in struct file where we already have list_head and rcu_head.  No space
eaten up.  fput() would, once the counter reaches 0, remove the file from list (the only
place walking that list skips the ones with zero refcount anyway) and, if we are in a normal
process, use task_work_add() to have __fput() done to it.  If we are in kernel thread or
atomic context, just move the sucker to global list and use schedule_work() to have said
list emptied and everything in it fed to __fput().

4) kill ->scm_work_list, along with all contortions in __scm_destroy(); just have it do all
the fput() (if any) it wants to do for this cookie.

5) in fs/aio.c, replace
        if (unlikely(!fput_atomic(req->ki_filp))) {
                spin_lock(&fput_lock);
                list_add(&req->ki_list, &fput_head);
                spin_unlock(&fput_lock);
                schedule_work(&fput_work);
        } else {
                req->ki_filp = NULL;
                really_put_req(ctx, req);
        }
with
	fput(req->ki_filp);
	req->ki_filp = NULL;
	really_put_req(ctx, req);
Sure, we are not allowed to block there.  And we won't.  fput_head/fput_work/aio_fput_routine()
goes to hell, and so does the whole "called_fput" mess in kiocb_batch_refill() in there - retry
loop and all.

Objections, anyone?  Linus, Oleg, Dave?
