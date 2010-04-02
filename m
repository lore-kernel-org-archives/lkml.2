Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab0DBSfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 14:35:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769Ab0DBSfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 14:35:14 -0400
Date: Fri, 2 Apr 2010 20:33:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: anfei <anfei.zhou@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       nishimura@mxp.nes.nec.co.jp,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm 4/4] oom: oom_forkbomb_penalty: move
	thread_group_cputime() out of task_lock()
Message-ID: <20100402183309.GE31723@redhat.com>
References: <alpine.DEB.2.00.1003291302170.14859@chino.kir.corp.google.com> <20100330154659.GA12416@redhat.com> <alpine.DEB.2.00.1003301320020.5234@chino.kir.corp.google.com> <20100331175836.GA11635@redhat.com> <20100331204718.GD11635@redhat.com> <alpine.DEB.2.00.1004010133190.6285@chino.kir.corp.google.com> <20100401135927.GA12460@redhat.com> <alpine.DEB.2.00.1004011210380.30661@chino.kir.corp.google.com> <20100402111406.GA4432@redhat.com> <20100402183057.GA31723@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100402183057.GA31723@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It doesn't make sense to call thread_group_cputime() under task_lock(),
we can drop this lock right after we read get_mm_rss() and save the
value in the local variable.

Note: probably it makes more sense to use sum_exec_runtime instead
of utime + stime, it is much more precise. A task can eat a lot of
CPU time, but its Xtime can be zero.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 mm/oom_kill.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- MM/mm/oom_kill.c~4_FORKBOMB_DROP_TASK_LOCK_EARLIER	2010-04-02 19:55:46.000000000 +0200
+++ MM/mm/oom_kill.c	2010-04-02 20:16:13.000000000 +0200
@@ -110,13 +110,16 @@ static unsigned long oom_forkbomb_penalt
 		return 0;
 	list_for_each_entry(child, &tsk->children, sibling) {
 		struct task_cputime task_time;
-		unsigned long runtime;
+		unsigned long runtime, rss;
 
 		task_lock(child);
 		if (!child->mm || child->mm == tsk->mm) {
 			task_unlock(child);
 			continue;
 		}
+		rss = get_mm_rss(child->mm);
+		task_unlock(child);
+
 		thread_group_cputime(child, &task_time);
 		runtime = cputime_to_jiffies(task_time.utime) +
 			  cputime_to_jiffies(task_time.stime);
@@ -126,10 +129,9 @@ static unsigned long oom_forkbomb_penalt
 		 * get to execute at all in such cases anyway.
 		 */
 		if (runtime < HZ) {
-			child_rss += get_mm_rss(child->mm);
+			child_rss += rss;
 			forkcount++;
 		}
-		task_unlock(child);
 	}
 
 	/*

