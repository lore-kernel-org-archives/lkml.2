Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab2BQOvr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 09:51:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056Ab2BQOvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 09:51:46 -0500
Date: Fri, 17 Feb 2012 15:44:58 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: apw@canonical.com, arjan@linux.intel.com, fhrbata@redhat.com,
        john.johansen@canonical.com, penguin-kernel@I-love.SAKURA.ne.jp,
        rientjes@google.com, rusty@rustcorp.com.au, tj@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] vfork: make it killable
Message-ID: <20120217144458.GB22440@redhat.com>
References: <20120214164709.GA21178@redhat.com> <20120214164914.GF21185@redhat.com> <20120215123049.6e938eed.akpm@linux-foundation.org> <20120216150429.GB11953@redhat.com> <20120216172626.GA30393@redhat.com> <20120216172706.GC30393@redhat.com> <20120216163948.f2989a2b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120216163948.f2989a2b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16, Andrew Morton wrote:
>
> On Thu, 16 Feb 2012 18:27:06 +0100
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -669,10 +669,34 @@ struct mm_struct *mm_access(struct task_struct *task, unsigned int mode)
> >
> >  void complete_vfork_done(struct task_struct *tsk)
> >  {
> > -	struct completion *vfork_done = tsk->vfork_done;
> > +	struct completion *vfork;
> >
> > -	tsk->vfork_done = NULL;
> > -	complete(vfork_done);
> > +	task_lock(tsk);
> > +	vfork = tsk->vfork_done;
> > +	if (likely(vfork)) {
> > +		tsk->vfork_done = NULL;
> > +		complete(vfork);
> > +	}
> > +	task_unlock(tsk);
> > +}
>
> OK, so now we don't need to test tsk->vfork_done in callers.  But
> mm_release() still does this, and it does it outside locks.

Yes, complete_vfork_done() can be called unconditionally,

> Mistake,
> or micro-optimisation?

micro-optimisation to avoid the unnecessary task_lock().

> If the latter, why is the lockless peek
> race-free?

If ->vfork_done != NULL, the child can never miss it. The parent
sets this pointer before the first wakeup.

However. The killed parent can clear ->vfork_done, see "if (killed)"
int wait_for_vfork_done(). That is why complete_vfork_done() should
re-check under task_lock().

Oleg.

