Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934109Ab0E0MHo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 08:07:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47870 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759014Ab0E0MHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 08:07:43 -0400
Date: Thu, 27 May 2010 22:07:38 +1000
From: Nick Piggin <npiggin@suse.de>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCHv4 17/17] writeback: lessen sync_supers wakeup count
Message-ID: <20100527120737.GN22536@laptop>
References: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
 <1274795352-3551-18-git-send-email-dedekind1@gmail.com>
 <20100527065041.GA31073@ZenIV.linux.org.uk>
 <20100527072240.GM22536@laptop>
 <1274957469.13159.20.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274957469.13159.20.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 01:51:09PM +0300, Artem Bityutskiy wrote:
> Nick, thanks for serialization suggestion.
> 
> On Thu, 2010-05-27 at 17:22 +1000, Nick Piggin wrote:
> > Yeah, we definitely don't want to add global cacheline writes in the
> > common case. Also I don't know why you do the strange -1 value. I
> > couldn't seem to find where you defined bdi_arm_supers_timer();
> 
> It is in mm/backing-dev.c:376 in today's Linus' tree. The -1 is used to

Yep I should have grepped. /hangs head


> indicate that 'sync_supers()' is in progress and avoid arming timer in
> that case. But yes, this is not really needed.

OK please remove it.

 
> > But why doesn't this work?
> > 
> >   sb->s_dirty = 1;
> >   smp_mb(); /* corresponding MB is in test_and_clear_bit */
> 
> AFAIU, test_and_clear_bit assumes 2 barriers - before the test and after
> the clear. Then I do not really understand why this smp_mb is needed.

You almost always need barriers executed on all sides of the
synchronisation protocol. Actually we need another, I confused
myself with the test_and_clear at the end.

1. sb->s_dirty = 1; /* store */
2. if (!supers_timer_armed) /* load */
3.   supers_timer_armed = 1; /* store */

and

A. supers_timer_armed = 0; /* store */
B. if (sb->s_dirty) /* load */
C.   sb->s_dirty = 0 /* store */

If these two sequences are executed, it must result in
sb->s_dirty == 1 iff supers_timer_armed

* If 2 is executed before 1 is visible, then 2 may miss A before B sees 1.
* If B is executed before A is visible, then B may miss 1 before 2 sees A.

So we need smp_mb() between 1/2 and A/B (I missed the 2nd one).

Now we still have a problem. After sync task rechecks
supers_timer_armed, the supers timer might execute before we mark
ourself as sleeping, and so we have another lost wakeup. It needs
to be checked after set_current_state.

Let's try this again. I much prefer to name the variable something
that indicates whether there is more work to be done, or whether we
can sleep.

How about something like this?
--

Index: linux-2.6/mm/backing-dev.c
===================================================================
--- linux-2.6.orig/mm/backing-dev.c
+++ linux-2.6/mm/backing-dev.c
@@ -45,6 +45,7 @@ LIST_HEAD(bdi_pending_list);
 
 static struct task_struct *sync_supers_tsk;
 static struct timer_list sync_supers_timer;
+static unsigned long supers_dirty __read_mostly;
 
 static int bdi_sync_supers(void *);
 static void sync_supers_timer_fn(unsigned long);
@@ -251,7 +252,6 @@ static int __init default_bdi_init(void)
 
 	init_timer(&sync_supers_timer);
 	setup_timer(&sync_supers_timer, sync_supers_timer_fn, 0);
-	bdi_arm_supers_timer();
 
 	err = bdi_init(&default_backing_dev_info);
 	if (!err)
@@ -362,17 +362,28 @@ static int bdi_sync_supers(void *unused)
 
 	while (!kthread_should_stop()) {
 		set_current_state(TASK_INTERRUPTIBLE);
-		schedule();
+		if (!supers_dirty)
+			schedule();
+		else
+			__set_current_state(TASK_RUNNING);
 
+		supers_dirty = 0;
 		/*
-		 * Do this periodically, like kupdated() did before.
+		 * supers_dirty store must be visible to mark_sb_dirty (below)
+		 * before sync_supers runs (which loads sb->s_dirty).
 		 */
+		smp_mb();
 		sync_supers();
 	}
 
 	return 0;
 }
 
+static void sync_supers_timer_fn(unsigned long unused)
+{
+	wake_up_process(sync_supers_tsk);
+}
+
 void bdi_arm_supers_timer(void)
 {
 	unsigned long next;
@@ -384,9 +395,17 @@ void bdi_arm_supers_timer(void)
 	mod_timer(&sync_supers_timer, round_jiffies_up(next));
 }
 
-static void sync_supers_timer_fn(unsigned long unused)
+void mark_sb_dirty(struct super_block *sb)
 {
-	wake_up_process(sync_supers_tsk);
+	sb->s_dirty = 1;
+	/*
+	 * sb->s_dirty store must be visible to sync_supers (above) before we
+	 * load supers_dirty in case we need to re-arm the timer.
+	 */
+	smp_mb();
+	if (likely(supers_dirty))
+		return;
+	supers_dirty = 1;
 	bdi_arm_supers_timer();
 }
 
