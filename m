Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388Ab0E0Pom (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 11:44:42 -0400
Received: from cantor.suse.de ([195.135.220.2]:59292 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932128Ab0E0Pok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 11:44:40 -0400
Date: Fri, 28 May 2010 01:44:36 +1000
From: Nick Piggin <npiggin@suse.de>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCHv4 17/17] writeback: lessen sync_supers wakeup count
Message-ID: <20100527154435.GS22536@laptop>
References: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
 <1274795352-3551-18-git-send-email-dedekind1@gmail.com>
 <20100527065041.GA31073@ZenIV.linux.org.uk>
 <20100527072240.GM22536@laptop>
 <1274957469.13159.20.camel@localhost>
 <20100527120737.GN22536@laptop>
 <1274973693.15516.67.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274973693.15516.67.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 06:21:33PM +0300, Artem Bityutskiy wrote:
> On Thu, 2010-05-27 at 22:07 +1000, Nick Piggin wrote:
> > 1. sb->s_dirty = 1; /* store */
> > 2. if (!supers_timer_armed) /* load */
> > 3.   supers_timer_armed = 1; /* store */
> > 
> > and
> > 
> > A. supers_timer_armed = 0; /* store */
> > B. if (sb->s_dirty) /* load */
> > C.   sb->s_dirty = 0 /* store */
> > 
> > If these two sequences are executed, it must result in
> > sb->s_dirty == 1 iff supers_timer_armed
> > 
> > * If 2 is executed before 1 is visible, then 2 may miss A before B sees 1.
> > * If B is executed before A is visible, then B may miss 1 before 2 sees A.
> > 
> > So we need smp_mb() between 1/2 and A/B (I missed the 2nd one).
> 
> Yes, thanks for elaboration.
> 
> > How about something like this?
> 
> It looks good, many thanks! But I have few small notes.
> 
> > Index: linux-2.6/mm/backing-dev.c
> > ===================================================================
> > --- linux-2.6.orig/mm/backing-dev.c
> > +++ linux-2.6/mm/backing-dev.c
> > @@ -45,6 +45,7 @@ LIST_HEAD(bdi_pending_list);
> >  
> >  static struct task_struct *sync_supers_tsk;
> >  static struct timer_list sync_supers_timer;
> > +static unsigned long supers_dirty __read_mostly;
> >  
> >  static int bdi_sync_supers(void *);
> >  static void sync_supers_timer_fn(unsigned long);
> > @@ -251,7 +252,6 @@ static int __init default_bdi_init(void)
> >  
> >  	init_timer(&sync_supers_timer);
> >  	setup_timer(&sync_supers_timer, sync_supers_timer_fn, 0);
> > -	bdi_arm_supers_timer();
> >  
> >  	err = bdi_init(&default_backing_dev_info);
> >  	if (!err)
> > @@ -362,17 +362,28 @@ static int bdi_sync_supers(void *unused)
> >  
> >  	while (!kthread_should_stop()) {
> >  		set_current_state(TASK_INTERRUPTIBLE);
> > -		schedule();
> > +		if (!supers_dirty)
> > +			schedule();
> > +		else
> > +			__set_current_state(TASK_RUNNING);
> 
> I think this will change the behavior of 'sync_supers()' too much. ATM,
> it makes only one SB pass, then sleeps, then another one, then sleeps.
> And we should probably preserve this behavior. So I'd rather make it:
> 
> if (supers_dirty)
> 	bdi_arm_supers_timer();
> set_current_state(TASK_INTERRUPTIBLE);
> schedule();
> 
> This way we will keep the behavior closer to the original.

Well your previous code had the same issue (ie. it could loop again
in sync_supers). But fair point perhaps.

But we cannot do the above, because again the timer might go off
before we set current state. We'd lose the wakeup and never wake
up again.

Putting it inside set_current_state() should be OK. I suppose.


> > +		supers_dirty = 0;
> >  		/*
> > -		 * Do this periodically, like kupdated() did before.
> > +		 * supers_dirty store must be visible to mark_sb_dirty (below)
> > +		 * before sync_supers runs (which loads sb->s_dirty).
> >  		 */
> 
> Very minor, but the code tends to change quickly, and this note (below)
> will probably become out-of-date soon.

Oh sure, get rid of the "(below)"

 
> > +		smp_mb();
> 
> There is spin_lock(&sb_lock) in sync_supers(), so strictly speak this
> 'smp_mb()' is not needed if we move supers_dirty = 0 into
> 'sync_supers()' and add a comment that a mb is required, in case some
> one modifies the code later?
> 
> Or this is not worth it?

It's a bit tricky. spin_lock only gives an acquire barrier, which
prevents CPU executing instructions inside the critical section
before acquiring the lock. It actually allows stores to be deferred
from becoming visible to other CPUs until inside the critical section.
So the load of sb->s_dirty could indeed still happen before the
store is seen.

Locks do allow you to avoid thinking about barriers, but *only* when
all memory accesses to all shared variables are inside the locks
(or when a section has just a single access, which by definition don't
need ordering with another access).

 
> >  		sync_supers();
> >  	}
> >  
> >  	return 0;
> >  }
> >  
> > +static void sync_supers_timer_fn(unsigned long unused)
> > +{
> > +	wake_up_process(sync_supers_tsk);
> > +}
> > +
> >  void bdi_arm_supers_timer(void)
> >  {
> >  	unsigned long next;
> > @@ -384,9 +395,17 @@ void bdi_arm_supers_timer(void)
> >  	mod_timer(&sync_supers_timer, round_jiffies_up(next));
> >  }
> >  
> > -static void sync_supers_timer_fn(unsigned long unused)
> > +void mark_sb_dirty(struct super_block *sb)
> >  {
> > -	wake_up_process(sync_supers_tsk);
> > +	sb->s_dirty = 1;
> > +	/*
> > +	 * sb->s_dirty store must be visible to sync_supers (above) before we
> > +	 * load supers_dirty in case we need to re-arm the timer.
> > +	 */
> Similar for the "(above)" note.

Sure.

 
> > +	smp_mb();
> > +	if (likely(supers_dirty))
> > +		return;
> > +	supers_dirty = 1;
> >  	bdi_arm_supers_timer();
> >  }
> 
> Here is the with my modifications. 
> 
> BTW, do you want me to keep you to be the patch author, add your
> signed-off-by and my original commit message?

I'm not concerned. You contributed more to the idea+implementation,
so record yourself as author.

