Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab1HRM7r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 08:59:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755495Ab1HRM7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 08:59:46 -0400
Date: Thu, 18 Aug 2011 08:58:49 -0400
From: Don Zickus <dzickus@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Luck, Tony" <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: pstore: change mutex locking to spin_locks
Message-ID: <20110818125849.GZ1972@redhat.com>
References: <4e4568eb10165cbab6@agluck-desktop.sc.intel.com>
 <20110817142225.8645fff7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110817142225.8645fff7.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 02:22:25PM -0700, Andrew Morton wrote:
> On Fri, 12 Aug 2011 10:54:51 -0700
> "Luck, Tony" <tony.luck@intel.com> wrote:
> 
> > From: Don Zickus <dzickus@redhat.com>
> > 
> > pstore was using mutex locking to protect read/write access to the
> > backend plug-ins.  This causes problems when pstore is executed in
> > an NMI context through panic() -> kmsg_dump().
> > 
> > This patch changes the mutex to a spin_lock_irqsave then also checks to
> > see if we are in an NMI context.  If we are in an NMI and can't get the
> > lock, just print a message stating that and blow by the locking.
> > 
> > All this is probably a hack around the bigger locking problem but it
> > solves my current situation of trying to sleep in an NMI context.
> > 
> > Tested by loading the lkdtm module and executing a HARDLOCKUP which
> > will cause the machine to panic inside the nmi handler.
> > 
> > ...
> >
> > +	if (in_nmi()) {
> > +		is_locked = spin_trylock(&psinfo->buf_lock);
> > +		if (!is_locked)
> > +			pr_err("pstore dump routine blocked in NMI, may corrupt error record\n");
> > +	} else
> > +		spin_lock_irqsave(&psinfo->buf_lock, flags);
> >  	oopscount++;
> >  	while (total < kmsg_bytes) {
> >  		dst = psinfo->buf;
> > @@ -123,7 +131,11 @@ static void pstore_dump(struct kmsg_dumper *dumper,
> >  		total += l1_cpy + l2_cpy;
> >  		part++;
> >  	}
> > -	mutex_unlock(&psinfo->buf_mutex);
> > +	if (in_nmi()) {
> > +		if (is_locked)
> > +			spin_unlock(&psinfo->buf_lock);
> > +	} else
> > +		spin_unlock_irqrestore(&psinfo->buf_lock, flags);
> >  }
> 
> It's still bad if lockdep is enabled.  See
> kernel/lockdep.c:lock_acquire() and lock_release().  They aren't
> NMI-safe.
> 
> One approach would be to switch to bit_spin_lock().  Which will break
> if/when bit spinlocks get lockdep-enabled, so don't do that.
> 
> A better approach would be to use the underlying spinlock functions
> which bypass lockdep, but I cannot immediately locate those amongst
> the misama of spinlock interface mess.

Probably the raw_spin_* stuff.  I think those purposely avoid the lockdep
mechanisms.

> 
> This problem of locking-vs-NMIs has been "solved" several times before
> but I don't recall any standardized approach being developed.  Does
> anyone have a favorite implementation to look at?

The ones I have looked at perf and apei/ghes, had issues of receiving data
in an NMI context and trying to pass it to userspace.  This was solved
with irq_work_queue.  Sometimes one can sprinkle some cmpxchg commands in
there to quickly write to registers from a normal context which seems to
play nicely with a process in an NMI context wants to write to the same
register.

But in this case we have a filesystem that can be read/written to from a
normal context and also written to from an NMI context.  irq_work_queue
doesn't apply here and I don't think you can just cmpxchg a PAGE full of
data into a firmware storage area.  This doesn't even get into the state
machine the kernel needs to walk through to store the data (which can
easily be interrupted by an NMI).

I would be excited in there was a solution that we can copy, but I didn't
see any nor would I really expect one in this unusual case.

The patch that I provided that Tony reposted is just a lesser of two evils
approach.  It is still flawed, just not as much as before.  The idea was
to buy time until we could think of a better approach to solving this.

Cheers,
Don

