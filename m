Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808Ab0CRXSe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 19:18:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171Ab0CRXSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 19:18:33 -0400
Date: Fri, 19 Mar 2010 00:16:32 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@linux.intel.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] move tty_kref_put() outside of __cleanup_signal()
Message-ID: <20100318231632.GA13591@redhat.com>
References: <20100318223736.GA12944@redhat.com> <20100318225102.6a5578d9@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100318225102.6a5578d9@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18, Alan Cox wrote:
>
> > -			tty_kref_put(p->signal->tty);
> >  			p->signal->tty = tty_kref_get(current->signal->tty);
>
> That bit needs commenting clearly or a WARN_ON() that p->signal->tty is
> NULL before the get otherwise when the assumption is broken the flaw will
> be subtle and hard to find.

Well. It must be NULL. This tty_kref_get() was added by
9c9f4ded90a59eee84e15f5fd38c03d60184e112, and the same commit also added
sig->tty = NULL into copy_signal(). With the recent changes in copy_signal()
it must be NULL due to zalloc().

But this doesn't matter. We should not do tty_kref_put() even if it is not
NULL. If we do "put", we need the balancing "get" which we do not have.
That is why this "get" is not only unneeded, but wrong imho.

Probably the little comment makes sense, but I don't really understand what
it should explain. To me, this is like list_add_tail(&init_task.tasks) few
lines below. We do not have the comment to explain the "missing" list_del().
This task is new, nobody can see/use it before we drop the locks. NULL or not,
its signal->tty is just uninitialized yet.

> > --- 34-rc1/kernel/exit.c~7_TTY_PUT	2010-03-17 20:05:38.000000000 +0100
> > +++ 34-rc1/kernel/exit.c	2010-03-18 22:46:41.000000000 +0100
> > @@ -150,6 +150,7 @@ static void __exit_signal(struct task_st
> >  		 * see account_group_exec_runtime().
> >  		 */
> >  		task_rq_unlock_wait(tsk);
> > +		tty_kref_put(sig->tty);
>
> and a sig->tty = NULL assignment to trap races might not go amiss here
> perhaps ?

Indeed ;)

The subsequent patches will do this, we need more changes anyway. Currently
this doesn't matter because we are going to kfree() this memory unconditionally.
But when we pin ->signal to task_struct, we should clear ->signal->tty before
we drop ->siglock, then tty_kref_put().

Oleg.

