Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964809Ab1DMWtD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 18:49:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46947 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964779Ab1DMWtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 18:49:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [uclinux-dist-devel] freezer: should barriers be smp ?
Date: Thu, 14 Apr 2011 00:49:23 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, uclinux-dist-devel@blackfin.uclinux.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <BANLkTi=F-C-vwX4PGGfbkdTBw3OWL-twfg@mail.gmail.com> <201104132353.09282.rjw@sisk.pl> <BANLkTik1tg2fzFgZmeSCGZxbNPDydotb-w@mail.gmail.com>
In-Reply-To: <BANLkTik1tg2fzFgZmeSCGZxbNPDydotb-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104140049.23344.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 14, 2011, Mike Frysinger wrote:
> On Wed, Apr 13, 2011 at 17:53, Rafael J. Wysocki wrote:
> > On Wednesday, April 13, 2011, Mike Frysinger wrote:
> >> On Wed, Apr 13, 2011 at 17:05, Pavel Machek wrote:
> >> > On Wed 2011-04-13 17:02:45, Mike Frysinger wrote:
> >> >> On Wed, Apr 13, 2011 at 16:58, Rafael J. Wysocki wrote:
> >> >> > On Wednesday, April 13, 2011, Mike Frysinger wrote:
> >> >> >> when we suspend/resume Blackfin SMP systems, we notice that the
> >> >> >> freezer code runs on multiple cores.  this is of course what you want
> >> >> >> -- freeze processes in parallel.  however, the code only uses non-smp
> >> >> >> based barriers which causes us problems ... our cores need software
> >> >> >> support to keep caches in sync, so our smp barriers do just that.  but
> >> >> >> the non-smp barriers do not, and so the frozen/thawed processes
> >> >> >> randomly get stuck in the wrong task state.
> >> >> >>
> >> >> >> thinking about it, shouldnt the freezer code be using smp barriers ?
> >> >> >
> >> >> > Yes, it should, but rmb() and wmb() are supposed to be SMP barriers.
> >> >> >
> >> >> > Or do you mean something different?
> >> >>
> >> >> then what's the diff between smp_rmb() and rmb() ?
> >> >>
> >> >> this is what i'm proposing:
> >> >> --- a/kernel/freezer.c
> >> >> +++ b/kernel/freezer.c
> >> >> @@ -17,7 +17,7 @@ static inline void frozen_process(void)
> >> >>  {
> >> >>     if (!unlikely(current->flags & PF_NOFREEZE)) {
> >> >>         current->flags |= PF_FROZEN;
> >> >> -       wmb();
> >> >> +       smp_wmb();
> >> >>     }
> >> >>     clear_freeze_flag(current);
> >> >>  }
> >> >> @@ -93,7 +93,7 @@ bool freeze_task(struct task_struct *p, bool sig_only)
> >> >>      * the task as frozen and next clears its TIF_FREEZE.
> >> >>      */
> >> >>     if (!freezing(p)) {
> >> >> -       rmb();
> >> >> +       smp_rmb();
> >> >>         if (frozen(p))
> >> >>             return false;
> >> >
> >> > smp_rmb() is NOP on uniprocessor.
> >> >
> >> > I believe the code is correct as is.
> >>
> >> that isnt what the code / documentation says.  unless i'm reading them
> >> wrong, both seem to indicate that the proposed patch is what we
> >> actually want.
> >
> > Not really.
> >
> >> include/linux/compiler-gcc.h:
> >> #define barrier() __asm__ __volatile__("": : :"memory")
> >>
> >> include/asm-generic/system.h:
> >> #define mb()    asm volatile ("": : :"memory")
> >> #define rmb()   mb()
> >> #define wmb()   asm volatile ("": : :"memory")
> >>
> >> #ifdef CONFIG_SMP
> >> #define smp_mb()    mb()
> >> #define smp_rmb()   rmb()
> >> #define smp_wmb()   wmb()
> >> #else
> >> #define smp_mb()    barrier()
> >> #define smp_rmb()   barrier()
> >> #define smp_wmb()   barrier()
> >> #endif
> >
> > The above means that smp_*mb() are defined as *mb() if CONFIG_SMP is set,
> > which basically means that *mb() are more restrictive than the corresponding
> > smp_*mb().  More precisely, they also cover the cases in which the CPU
> > reorders instructions on uniprocessor, which we definitely want to cover.
> >
> > IOW, your patch would break things on uniprocessor where the CPU reorders
> > instructions.
> >
> >> Documentation/memory-barriers.txt:
> >> SMP memory barriers are reduced to compiler barriers on uniprocessor compiled
> >> systems because it is assumed that a CPU will appear to be self-consistent,
> >> and will order overlapping accesses correctly with respect to itself.
> >
> > Exactly, which is not guaranteed in general (e.g. on Alpha).  That is, some
> > CPUs can reorder instructions in such a way that a compiler barrier is not
> > sufficient to prevent breakage.
> >
> > The code _may_ be wrong for a different reason, though.  I need to check.
> 
> so the current code is protecting against a UP system swapping in/out
> freezer threads for processes, and the barriers are to make sure that
> the updated flags variable is posted by the time another swapped in
> thread gets to that point.

The existing memory barriers are SMP barriers too, but they are more than
_just_ SMP barriers.  At least that's how it is _supposed_ to be (eg.
rmb() is supposed to be stronger than smp_rmb()).

> i guess the trouble for us is that you have one CPU posting writes to
> task->flags (and doing so by grabbing the task's spinlock), but the
> other CPU is simply reading those flags.  there are no SMP barriers in
> between the read and write steps, nor is the reading CPU grabbing any
> locks which would be an implicit SMP barrier.  since the Blackfin SMP
> port lacks hardware cache coherency, there is no way for us to know
> "we've got to sync the caches before we can do this read".  by using
> the patch i posted above, we have that signal and so things work
> correctly.,

In theory I wouldn't expect the patch to work correctly, because it replaces
_stronger_ memory barriers with _weaker_ SMP barriers.  However, looking at
the blackfin's definitions of SMP barriers I see that it uses extra stuff that
should _also_ be used in the definitions of the mandatory barriers.

In my opinion is an architecture problem, not the freezer code problem.

Thanks,
Rafael
