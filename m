Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab1JMXZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 19:25:27 -0400
Received: from peace.netnation.com ([204.174.223.2]:36961 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787Ab1JMXZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 19:25:26 -0400
Date: Thu, 13 Oct 2011 16:25:21 -0700
From: Simon Kirby <sim@hostway.ca>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Linux 3.1-rc9
Message-ID: <20111013232521.GA5654@hostway.ca>
References: <CA+55aFxPNszU5UHFrDDYnshLEMupaviFwhgEsgmPkqpmuWNZ8A@mail.gmail.com> <20111007070842.GA27555@hostway.ca> <20111007174848.GA11011@hostway.ca> <1318010515.398.8.camel@twins> <20111008005035.GC22843@hostway.ca> <1318060551.8395.0.camel@twins> <20111012213555.GC24461@hostway.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111012213555.GC24461@hostway.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 02:35:55PM -0700, Simon Kirby wrote:

> On Sat, Oct 08, 2011 at 09:55:51AM +0200, Peter Zijlstra wrote:
> 
> > On Fri, 2011-10-07 at 17:50 -0700, Simon Kirby wrote:
> > > On Fri, Oct 07, 2011 at 08:01:55PM +0200, Peter Zijlstra wrote:
> > > 
> > > > @@ -2571,6 +2573,7 @@ void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times);
> > > >  static inline void thread_group_cputime_init(struct signal_struct *sig)
> > > >  {
> > > >       raw_spin_lock_init(&sig->cputimer.lock);
> > > > +     raw_spin_lock_init(&sig->cputimer.runtime_lock);
> > > 
> > > My 3.1-rc9 tree has just spin_lock_init() here, not raw_*.
> > > 
> > > Which tree is your patch against? -next or something?
> > 
> > or something yeah.. tip/master I think.
> > 
> > > It applies with some cooking like this, but will it be right?
> > > 
> > > > sed s/raw_// ../sched-patch-noraw.diff | patch -p1 --dry
> > > patching file include/linux/sched.h
> > > Hunk #1 succeeded at 503 (offset -1 lines).
> > > Hunk #2 succeeded at 512 (offset -1 lines).
> > > Hunk #3 succeeded at 2568 (offset -5 lines).
> > > patching file kernel/posix-cpu-timers.c
> > > patching file kernel/sched_stats.h 
> > 
> > yes that would be fine.
> 
> This patch (s/raw_//) has been stable on 5 boxes for a day. I'll push to
> another 15 shortly and confirm tomorrow. Meanwhile, we had another ~4
> boxes lock up on 3.1-rc9 _with_ d670ec13 reverted (all CPUs spinning),
> but there weren't enough serial cables to log all of them and we haven't
> been lucky enough to capture anything other than what fits on 80x25.
> I'm hoping it's just the same bug you've already fixed. Strangely, boxes
> on -rc6 and -rc7 haven't hit it, but those are across clusters with
> different workloads.

Looks good. No hangs or crashes for two days on any of them running
3.1-rc9 plus this patch. Not sure if you want to deuglify it, but it
seems to work...

Tested-by: Simon Kirby <sim@hostway.ca>

diff against Linus reproduced below.

Simon-

 include/linux/sched.h     |    3 +++
 kernel/posix-cpu-timers.c |    6 +++++-
 kernel/sched_stats.h      |    4 ++--
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 41d0237..ad9eafc 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -503,6 +503,7 @@ struct task_cputime {
  * @running:		non-zero when there are timers running and
  * 			@cputime receives updates.
  * @lock:		lock for fields in this struct.
+ * @runtime_lock:	lock for cputime.sum_exec_runtime
  *
  * This structure contains the version of task_cputime, above, that is
  * used for thread group CPU timer calculations.
@@ -511,6 +512,7 @@ struct thread_group_cputimer {
 	struct task_cputime cputime;
 	int running;
 	spinlock_t lock;
+	spinlock_t runtime_lock;
 };
 
 #include <linux/rwsem.h>
@@ -2566,6 +2568,7 @@ void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times);
 static inline void thread_group_cputime_init(struct signal_struct *sig)
 {
 	spin_lock_init(&sig->cputimer.lock);
+	spin_lock_init(&sig->cputimer.runtime_lock);
 }
 
 /*
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index c8008dd..fa189a6 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -284,9 +284,13 @@ void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times)
 		 * it.
 		 */
 		thread_group_cputime(tsk, &sum);
+		spin_lock(&cputimer->runtime_lock);
 		update_gt_cputime(&cputimer->cputime, &sum);
-	}
+	} else
+		spin_lock(&cputimer->runtime_lock);
+
 	*times = cputimer->cputime;
+	spin_unlock(&cputimer->runtime_lock);
 	spin_unlock_irqrestore(&cputimer->lock, flags);
 }
 
diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
index 331e01b..a7e2c1a 100644
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -330,7 +330,7 @@ static inline void account_group_exec_runtime(struct task_struct *tsk,
 	if (!cputimer->running)
 		return;
 
-	spin_lock(&cputimer->lock);
+	spin_lock(&cputimer->runtime_lock);
 	cputimer->cputime.sum_exec_runtime += ns;
-	spin_unlock(&cputimer->lock);
+	spin_unlock(&cputimer->runtime_lock);
 }
