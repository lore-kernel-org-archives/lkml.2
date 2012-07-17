Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab2GQMyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 08:54:32 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:49142 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751366Ab2GQMy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 08:54:27 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX184ToIZi284SmJyGIxbudHNiAn7RpbfuqgY/sKqQe
	BY6Emxki4ybJrw
Message-ID: <1342529657.7353.104.camel@marge.simpson.net>
Subject: Re: 3.4.4-rt13: btrfs + xfstests 006 = BOOM..  and a bonus rt_mutex
 deadlock report for absolutely free!
From: Mike Galbraith <efault@gmx.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Chris Mason <chris.mason@fusionio.com>,
        "Chris L. Mason" <clmason@fusionio.com>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 17 Jul 2012 14:54:17 +0200
In-Reply-To: <1342498722.7353.37.camel@marge.simpson.net>
References: <1342072060.7338.102.camel@marge.simpson.net>
	 <20120713125043.GH30128@shiny> <1342260883.7368.30.camel@marge.simpson.net>
	 <20120715175612.GF25961@shiny.int.fusionio.com>
	 <1342404140.7659.27.camel@marge.simpson.net>
	 <1342454547.5410.3.camel@gandalf.stny.rr.com>
	 <1342455968.7659.93.camel@marge.simpson.net>
	 <1342456567.7659.97.camel@marge.simpson.net>
	 <1342458195.2783.5.camel@acer.local.home>
	 <1342498722.7353.37.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-17 at 06:18 +0200, Mike Galbraith wrote: 
> On Mon, 2012-07-16 at 13:03 -0400, Steven Rostedt wrote: 
> > On Mon, 2012-07-16 at 18:36 +0200, Mike Galbraith wrote:
> > >  
> > > > > Ouch, you just turned the rt_read_lock() into a spin lock. If a higher
> > > > > priority process preempted a lower priority process that holds the same
> > > > > lock, it will deadlock.
> > > > 
> > > > Hm, how, it's doing cpu_chill()?
> > > 
> > > 'course PI is toast, so *poof*.  Since just enabling the lockdep bits
> > > seems to fix it up, maybe that's the patchlet to submit (less is more).
> > 
> > There's that too. But the issue I was talking about is with all trylock
> > loops. As holding an rt-mutex now disables migration, if a high priority
> > process preempts a task that holds the lock, and then the high prio task
> > starts spinning waiting for that lock to release, the lower priority
> > process will never get to run to release it. The cpu_chill() doesn't
> > help.
> 
> Hrm.  I better go make a testcase, this one definitely wants pounding
> through thick skull.
> 
> I think all of the chilling in patchlet is really ugly anyway, so would
> prefer to trash it all, just enable the lockdep bits.  If it turns out
> we really do need to bounce off of counts, go get a bigger hammer when
> the need arises.  For the nonce, the pre-installed hammer _seemed_ big
> enough for the job.

All night dbench session, and all day doing many full xfstests runs
(what will run on btrfs), fsstress -p64, and generic beating says the
pre-installed tool is fine all by itself, so here comes a zero line
patch.. the second best kind ;-)

rt,fs,btrfs: fix rt deadlock on extent_buffer->lock

Trivially repeatable deadlock is cured by enabling lockdep code in
btrfs_clear_path_blocking() as suggested by Chris Mason.  He also
suggested restricting blocking reader count to one, and not allowing
a spinning reader while blocking reader exists.  This has proven to
be unnecessary, the strict lock order enforcement is enough.. or
rather that's my box's opinion after long hours of hard pounding.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Chris Mason <chris.mason@fusionio.com>

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 2e66786..1f71eb0 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -72,7 +72,7 @@ noinline void btrfs_clear_path_blocking(struct btrfs_path *p,
 {
 	int i;
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
+#if (defined(CONFIG_DEBUG_LOCK_ALLOC) || defined (CONFIG_PREEMPT_RT_BASE))
 	/* lockdep really cares that we take all of these spinlocks
 	 * in the right order.  If any of the locks in the path are not
 	 * currently blocking, it is going to complain.  So, make really
@@ -89,7 +89,7 @@ noinline void btrfs_clear_path_blocking(struct btrfs_path *p,
 			btrfs_clear_lock_blocking(p->nodes[i]);
 	}
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
+#if (defined(CONFIG_DEBUG_LOCK_ALLOC) || defined (CONFIG_PREEMPT_RT_BASE))
 	if (held)
 		btrfs_clear_lock_blocking(held);
 #endif


