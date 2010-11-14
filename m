Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603Ab0KNRta (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 12:49:30 -0500
Received: from smtp-out-139.synserver.de ([212.40.180.139]:1040 "HELO
	smtp-out-139.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756434Ab0KNRt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 12:49:29 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 877
Date: Sun, 14 Nov 2010 18:49:21 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Mike Galbraith <efault@gmx.de>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101114174921.GA1569@arch.trippelsdorf.de>
References: <20101021162924.GA3225@redhat.com>
 <1288076838.11930.1.camel@marge.simson.net>
 <1288078144.7478.9.camel@marge.simson.net>
 <AANLkTimOJAv2uRfq4bW_QPngkGCmJDjNX5n_izpX=eB8@mail.gmail.com>
 <1289489200.11397.21.camel@maggy.simson.net>
 <20101111202703.GA16282@redhat.com>
 <1289514000.21413.204.camel@maggy.simson.net>
 <20101112181240.GB8659@redhat.com>
 <1289648524.22764.149.camel@maggy.simson.net>
 <1289755150.3228.44.camel@maggy.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289755150.3228.44.camel@maggy.simson.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010.11.14 at 10:19 -0700, Mike Galbraith wrote:
> On Sat, 2010-11-13 at 04:42 -0700, Mike Galbraith wrote:
> > On Fri, 2010-11-12 at 19:12 +0100, Oleg Nesterov wrote:
> > > On 11/11, Mike Galbraith wrote:
> > > >
> > > > On Thu, 2010-11-11 at 21:27 +0100, Oleg Nesterov wrote:
> > > >
> > > > > But the real problem is that copy_process() can fail after that,
> > > > > and in this case we have the unbalanced kref_get().
> > > >
> > > > Memory leak, will fix.
> > > >
> > > > > > +++ linux-2.6.36.git/kernel/exit.c
> > > > > > @@ -174,6 +174,7 @@ repeat:
> > > > > >  	write_lock_irq(&tasklist_lock);
> > > > > >  	tracehook_finish_release_task(p);
> > > > > >  	__exit_signal(p);
> > > > > > +	sched_autogroup_exit(p);
> > > > >
> > > > > This doesn't look right. Note that "p" can run/sleep after that
> > > > > (or in parallel), set_task_rq() can use the freed ->autogroup.
> > > >
> > > > So avoiding refcounting rcu released task_group backfired.  Crud.
> > > 
> > > Just in case, the lock order may be wrong. sched_autogroup_exit()
> > > takes task_group_lock under write_lock(tasklist), while
> > > sched_autogroup_handler() takes them in reverse order.
> > 
> > Bug self destructs when global classifier goes away.
> 
> I didn't nuke the handler, but did hide it under a debug option since it
> is useful for testing.  If the user enables it, and turns autogroup off,
> imho off should means off NOW, so I stuck with it as is.  I coded up a
> lazy (tick time check) move to handle pinned tasks not otherwise being
> moved, but that was too much for even my (lack of) taste to handle.
> 
> The locking should be fine as it was now, since autogroup_exit() isn't
> under the tasklist lock any more.  (surprising i didn't hit any problems
> with this or use after free in rt kernel given how hard i beat on it)
> 
> Pondering adding some debug bits to identify autogroup tasks, maybe
> in /proc/N/cgroup or such.
> 
> > > I am not sure, but perhaps this can be simpler?
> > > wake_up_new_task() does autogroup_fork(), and do_exit() does
> > > sched_autogroup_exit() before the last schedule. Possible?
> > 
> > That's what I was going to do.  That said, I couldn't have had the
> > problem if I'd tied final put directly to life of container, and am
> > thinking I should do that instead when I go back to p->signal.
> 
> I ended up tying it directly to p->signal's life, and beat on it with
> CONFIG_PREEMPT.  I wanted to give it a thrashing in PREEMPT_RT, but
> when I snagged your signal patches, I apparently didn't snag quite
> enough, as the rt kernel with those patches is early boot doorstop.
> 
> > > Very basic question. Currently sched_autogroup_create_attach()
> > > has the only caller, __proc_set_tty(). It is a bit strange that
> > > signal->tty change is process-wide, but sched_autogroup_create_attach()
> > > move the single thread, the caller. What about other threads in
> > > this thread group? The same for proc_clear_tty().
> > 
> > Yeah, I really should (will) move all on the spot...
> 
> Did that, and the rest.  This patch will apply to tip or .git.

Unfortunately it won't. There's a missing "+" at line 507:

markus@arch linux % patch -p1 --dry-run < /home/markus/tty_autogroup2.patch
patching file include/linux/sched.h
Hunk #3 succeeded at 1935 (offset -1 lines).
patching file kernel/sched.c
Hunk #2 succeeded at 607 (offset 1 line).
Hunk #3 succeeded at 2011 with fuzz 2 (offset 1 line).
Hunk #4 succeeded at 7959 (offset -25 lines).
Hunk #5 succeeded at 8489 (offset -25 lines).
Hunk #6 succeeded at 8514 (offset -25 lines).
patching file kernel/fork.c
patching file drivers/tty/tty_io.c
patching file kernel/sched_autogroup.h
patching file kernel/sched_autogroup.c
patch: **** malformed patch at line 507: Index: linux-2.6/kernel/sysctl.c
-- 
Markus
