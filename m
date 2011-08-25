Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab1HYP2n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:28:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753697Ab1HYP2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:28:42 -0400
Date: Thu, 25 Aug 2011 17:25:33 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Tejun Heo <tj@kernel.org>, rjw@sisk.pl, menage@google.com,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH 06/16] freezer: make exiting tasks properly unfreezable
Message-ID: <20110825152533.GA4221@redhat.com>
References: <1313763382-12341-1-git-send-email-tj@kernel.org> <1313763382-12341-7-git-send-email-tj@kernel.org> <20110824223412.GG28444@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110824223412.GG28444@count0.beaverton.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24, Matt Helsley wrote:
>
> On Fri, Aug 19, 2011 at 04:16:12PM +0200, Tejun Heo wrote:
> > There's no point in freezing an exiting task.  The current code
> > seemingly tries that by calling clear_freeze_flag() from exit_mm() but
> > it's racy as freeze might happen afterwards.
> >
> > This patch removes the racy clear_freeze_flag() makes do_exit() set
> > PF_NOFREEZE after PTRACE_EVENT_EXIT, after which freezing doesn't make
> > sense.
> >
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > ---
> >  kernel/exit.c          |    8 ++++++--
> >  kernel/power/process.c |    3 +--
> >  2 files changed, 7 insertions(+), 4 deletions(-)
> >
> > diff --git a/kernel/exit.c b/kernel/exit.c
> > index 2913b35..ac58259 100644
> > --- a/kernel/exit.c
> > +++ b/kernel/exit.c
> > @@ -679,8 +679,6 @@ static void exit_mm(struct task_struct * tsk)
> >  	tsk->mm = NULL;
> >  	up_read(&mm->mmap_sem);
> >  	enter_lazy_tlb(mm, current);
> > -	/* We don't want this task to be frozen prematurely */
> > -	clear_freeze_flag(tsk);
>
> This patch doesn't look quite right. Perhaps that's because I'm
> unclear why any of the freezer flags matter in the do_exit() path. How
> can the task enter the refrigerator in do_exit()?

it can't.

> If we can't enter the refrigerator then why fiddle with these flags
> here at all? That might explain why this race never introduced
> problems.

One problem is, try_to_freeze_tasks() shouldn't fail if we have a zombie.

> Couldn't TIF_FREEZE already be set?

Yes,

> Setting PF_NOFREEZE only ensures
> the flag won't get set "after" this point. To fix this I think we'd need
> something more like:
>
> 	current->flags |= PF_NOFREEZE;
> 	smp_wmb();
> 	clear_freeze_flag(tsk);

We don't really need this, we are not going to freeze.




However. I thought about this too. In the long term I think we do need
some cleanups to avoid the wrong TIF_SIGPENDING... but currently this
is off-topic.

Oleg.

