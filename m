Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab2FWJU7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 05:20:59 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56188 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab2FWJUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 05:20:55 -0400
Date: Sat, 23 Jun 2012 10:20:49 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        ". James Morris" <jmorris@namei.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: deferring __fput()
Message-ID: <20120623092049.GH14083@ZenIV.linux.org.uk>
References: <1340369098.2464.20.camel@falcor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340369098.2464.20.camel@falcor>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 08:44:58AM -0400, Mimi Zohar wrote:
> Al,
> 
> I really appreciate all of the work that has gone into making __fput()
> lockless - making the syscalls use get/put_light(), signal changes, and
> using Oleg's task_work_add() to defer processes. 
> 
> Currently, when unmapping a file after closing it, I'm not getting the
> mmap_sem/i_mutex lockdep any more.  This seems due to Tyler Hick's
> commit 978d6d8 "vfs: Correctly set the dir i_mutex lockdep class",
> rather than the above changes.
> 
> Although the mmap_sem/i_mutex lockdep doesn't exist anymore, before
> upstreaming IMA-appraisal, the issue with __fput() should probably be
> resolved. :)   What else needs to be done to make __fput() lockless?
> How can I help?

Deadlock is still there.  I'll resurrect the patch switching the final fput()
to task_work_add() and throw it into #for-next tomorrow; the main question is
what to do with fput() from kernel threads and whether we want to allow it
from interrupts - solution for the former (definitely needed) would cover
the latter as well.  I suspect that we want to go for "just use
schedule_work()" for these cases; among other things, that would allow
to simplify aio.c quite a bit.

Somewhat curious part is what to do with daemonize() - by the time we do
(potentially) piles of fput() in there, we *are* a kernel thread.  We won't
be doing any task_work() handling anymore.  So it's "do the final fput()
ourselves" or "have them done asynchronously".  OTOH, daemonize()
probably needs to be killed anyway - it had all callers in mainline
removed, only to get one more in drivers/staging.  Which caller looks like
it ought to be switched to kthread_create(), along with other callers
of kernel_thread() in there...

What I have in mind is something like
	if (unlikely(in_atomic() || current->flags & PF_KTHREAD))
		move file to global list, use schedul_work() to have it dealt with
	else
		move to per-task list, do task_work_add() if it was empty (i.e.
		if we hadn't scheduled its emptying already).
The latter is completely thread-synchronous, so we shouldn't need any locking
whatsoever.  The former... I'd probably go for a single list, protected by
spin_lock_irq(), keeping the possibility to switch to per-CPU lists if we
find a load that gets serious contention on that list.  In any case, worker will
start with taking the list contents, emptying the list and then killing the
suckers off one by one.
