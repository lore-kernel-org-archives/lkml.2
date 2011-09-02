Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933515Ab1IBLVj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 07:21:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56789 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933452Ab1IBLVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 07:21:36 -0400
Date: Fri, 2 Sep 2011 13:21:33 +0200
From: Jan Kara <jack@suse.cz>
To: "kautuk.c @samsung.com" <consul.kautuk@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <jaxboe@fusionio.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Dave Chinner <dchinner@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mm/backing-dev.c: Call del_timer_sync instead of
 del_timer
Message-ID: <20110902112133.GD12182@quack.suse.cz>
References: <1314892622-18267-1-git-send-email-consul.kautuk@gmail.com>
 <20110901143333.51baf4ae.akpm@linux-foundation.org>
 <CAFPAmTQbdhNgFNoP0RyS0E9Gm4djA-W_4JWwpWZ7U=XnTKR+cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFPAmTQbdhNgFNoP0RyS0E9Gm4djA-W_4JWwpWZ7U=XnTKR+cg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

On Fri 02-09-11 10:47:03, kautuk.c @samsung.com wrote:
> On Fri, Sep 2, 2011 at 3:03 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Thu,  1 Sep 2011 21:27:02 +0530
> > Kautuk Consul <consul.kautuk@gmail.com> wrote:
> >
> >> This is important for SMP scenario, to check whether the timer
> >> callback is executing on another CPU when we are deleting the
> >> timer.
> >>
> >
> > I don't see why?
> >
> >> index d6edf8d..754b35a 100644
> >> --- a/mm/backing-dev.c
> >> +++ b/mm/backing-dev.c
> >> @@ -385,7 +385,7 @@ static int bdi_forker_thread(void *ptr)
> >>                * dirty data on the default backing_dev_info
> >>                */
> >>               if (wb_has_dirty_io(me) || !list_empty(&me->bdi->work_list)) {
> >> -                     del_timer(&me->wakeup_timer);
> >> +                     del_timer_sync(&me->wakeup_timer);
> >>                       wb_do_writeback(me, 0);
> >>               }
> >
> > It isn't a use-after-free fix: bdi_unregister() safely shoots down any
> > running timer.
> >
> 
> In the situation that we do a del_timer at the same time that the
> wakeup_timer_fn is
> executing on another CPU, there is one tiny possible problem:
> 1)  The wakeup_timer_fn will call wake_up_process on the bdi-default thread.
>       This will set the bdi-default thread's state to TASK_RUNNING.
> 2)  However, the code in bdi_writeback_thread() sets the state of the
> bdi-default process
>     to TASK_INTERRUPTIBLE as it intends to sleep later.
> 
> If 2) happens before 1), then the bdi_forker_thread will not sleep
> inside schedule as is the intention of the bdi_forker_thread() code.
  OK, I agree the code in bdi_forker_thread() might use some straightening
up wrt. task state handling but is what you decribe really an issue? Sure
the task won't go to sleep but the whole effect is that it will just loop
once more to find out there's nothing to do and then go to sleep - not a
bug deal... Or am I missing something?

> This protection is not achieved even by acquiring spinlocks before
> setting the task->state
> as the spinlock used in wakeup_timer_fn is &bdi->wb_lock whereas the code in
> bdi_forker_thread acquires &bdi_lock which is a different spin_lock.
> 
> Am I correct in concluding this ?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
