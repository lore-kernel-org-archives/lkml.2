Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab2BQOnz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 09:43:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327Ab2BQOny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 09:43:54 -0500
Date: Fri, 17 Feb 2012 15:37:06 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: apw@canonical.com, arjan@linux.intel.com, fhrbata@redhat.com,
        john.johansen@canonical.com, penguin-kernel@I-love.SAKURA.ne.jp,
        rientjes@google.com, rusty@rustcorp.com.au, tj@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] introduce complete_vfork_done()
Message-ID: <20120217143706.GA22440@redhat.com>
References: <20120214164709.GA21178@redhat.com> <20120214164914.GF21185@redhat.com> <20120215123049.6e938eed.akpm@linux-foundation.org> <20120216150429.GB11953@redhat.com> <20120216172626.GA30393@redhat.com> <20120216172647.GB30393@redhat.com> <20120216163544.4e41e5a5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120216163544.4e41e5a5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16, Andrew Morton wrote:
>
> On Thu, 16 Feb 2012 18:26:47 +0100
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > ...
> > +void complete_vfork_done(struct task_struct *tsk)
> > +{
> > +	struct completion *vfork_done = tsk->vfork_done;
> > +
> > +	tsk->vfork_done = NULL;
> > +	complete(vfork_done);
> > +}
> > +
> >  /* Please note the differences between mmput and mm_release.
> >   * mmput is called whenever we stop holding onto a mm_struct,
> >   * error success whatever.
> > @@ -682,8 +690,6 @@ struct mm_struct *mm_access(struct task_struct *task, unsigned int mode)
> >   */
> >  void mm_release(struct task_struct *tsk, struct mm_struct *mm)
> >  {
> > -	struct completion *vfork_done = tsk->vfork_done;
> > -
> >  	/* Get rid of any futexes when releasing the mm */
> >  #ifdef CONFIG_FUTEX
> >  	if (unlikely(tsk->robust_list)) {
> > @@ -703,11 +709,8 @@ void mm_release(struct task_struct *tsk, struct mm_struct *mm)
> >  	/* Get rid of any cached register state */
> >  	deactivate_mm(tsk, mm);
> >
> > -	/* notify parent sleeping on vfork() */
> > -	if (vfork_done) {
> > -		tsk->vfork_done = NULL;
> > -		complete(vfork_done);
> > -	}
> > +	if (tsk->vfork_done)
> > +		complete_vfork_done(tsk);
>
> This all looks somewhat smelly.

First of all, let me repeat that this patch changes nothing, justs
move this code into the new helper.


> - Why do we zero tsk->vfork_done in this manner?  It *looks* like
>   it's done to prevent the kernel from running complete() twice against
>   a single task

Yes,

> in a race situation.

No. More precisely, not before/after this patch.

"if (vfork_done) complete_vfork_done()" is called twice very often.
A vforked child does exec and notifies its parent. It should clear
->vfork_done, otherwise it will do complete_vfork_done() again on
exit when ->vfork_done points to nowhere.

The caller can never race with another user of ->vfork_done. It
is the parent sleeping in do_fork(CLONE_VFORK). (I am ignoring
the kernel threads created by kthread_create).

>   We'd need external locking to firm that up
>   and I'm not seeing it.

After the next patch, parent/child can race with each other, that
is why the next patch moves complete() under task_lock(). I'll write
another email in reply to 2/4.

> - Moving the test for non-null tsk->vfork_done into
>   complete_vfork_done() would simplify things a bit?

Yes, perhaps this makes sense. After 3/4 mm_release() becomes the
only caller and this microoptimization buys nothing, this helper
will be static.

I like the explicit test a bit more, just because it looks more
clear to me. But this is subjective, I can redo.

> - The complete_vfork_done() interface isn't wonderful.  What prevents
>   tsk from getting freed?  Presumably the caller must have pinned it in
>   some fashion?  Or must hold some lock?  Or it's always run against
>   `current',

Yes, it is always current,

> in which case it would be clearer to not pass the
>   task_struct arg at all?

Well, may be... But mm_release() already has the 'tsk' argument which
is always current. It would be strange to not use it.

Oleg.

