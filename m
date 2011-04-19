Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab1DSUYt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:24:49 -0400
Received: from kroah.org ([198.145.64.141]:35569 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754736Ab1DSURV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:17:21 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:47 2011
Message-Id: <20110419201047.244779851@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:08:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>
Subject: [38/70] oom-kill: remove boost_dying_task_prio()
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit 341aea2bc48bf652777fb015cc2b3dfa9a451817 upstream.

This is an almost-revert of commit 93b43fa ("oom: give the dying task a
higher priority").

That commit dramatically improved oom killer logic when a fork-bomb
occurs.  But I've found that it has nasty corner case.  Now cpu cgroup has
strange default RT runtime.  It's 0!  That said, if a process under cpu
cgroup promote RT scheduling class, the process never run at all.

If an admin inserts a !RT process into a cpu cgroup by setting
rtruntime=0, usually it runs perfectly because a !RT task isn't affected
by the rtruntime knob.  But if it promotes an RT task via an explicit
setscheduler() syscall or an OOM, the task can't run at all.  In short,
the oom killer doesn't work at all if admins are using cpu cgroup and don't
touch the rtruntime knob.

Eventually, kernel may hang up when oom kill occur.  I and the original
author Luis agreed to disable this logic.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Luis Claudio R. Goncalves <lclaudio@uudg.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/oom_kill.c |   27 ---------------------------
 1 file changed, 27 deletions(-)

--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -84,24 +84,6 @@ static bool has_intersects_mems_allowed(
 #endif /* CONFIG_NUMA */
 
 /*
- * If this is a system OOM (not a memcg OOM) and the task selected to be
- * killed is not already running at high (RT) priorities, speed up the
- * recovery by boosting the dying task to the lowest FIFO priority.
- * That helps with the recovery and avoids interfering with RT tasks.
- */
-static void boost_dying_task_prio(struct task_struct *p,
-				  struct mem_cgroup *mem)
-{
-	struct sched_param param = { .sched_priority = 1 };
-
-	if (mem)
-		return;
-
-	if (!rt_task(p))
-		sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
-}
-
-/*
  * The process p may have detached its own ->mm while exiting or through
  * use_mm(), but one or more of its subthreads may still have a valid
  * pointer.  Return p, or any of its subthreads with a valid ->mm, with
@@ -452,13 +434,6 @@ static int oom_kill_task(struct task_str
 	set_tsk_thread_flag(p, TIF_MEMDIE);
 	force_sig(SIGKILL, p);
 
-	/*
-	 * We give our sacrificial lamb high priority and access to
-	 * all the memory it needs. That way it should be able to
-	 * exit() and clear out its resources quickly...
-	 */
-	boost_dying_task_prio(p, mem);
-
 	return 0;
 }
 #undef K
@@ -482,7 +457,6 @@ static int oom_kill_process(struct task_
 	 */
 	if (p->flags & PF_EXITING) {
 		set_tsk_thread_flag(p, TIF_MEMDIE);
-		boost_dying_task_prio(p, mem);
 		return 0;
 	}
 
@@ -701,7 +675,6 @@ void out_of_memory(struct zonelist *zone
 	 */
 	if (fatal_signal_pending(current)) {
 		set_thread_flag(TIF_MEMDIE);
-		boost_dying_task_prio(current, NULL);
 		return;
 	}
 


