Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab1LBBUU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 20:20:20 -0500
Received: from mga14.intel.com ([143.182.124.37]:37912 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755433Ab1LBBUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 20:20:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,281,1320652800"; 
   d="scan'208";a="81324907"
Date: Fri, 2 Dec 2011 09:10:15 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] exit: fix writeback build errors
Message-ID: <20111202011015.GA9724@localhost>
References: <20111201155342.45847a6edcf25cde48c4a6de@canb.auug.org.au>
 <4ED7C51F.3090007@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ED7C51F.3090007@xenotime.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 02, 2011 at 02:19:11AM +0800, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Fix build errors:
> kernel/exit.c:1039:3: error: 'dirty_throttle_leaks' undeclared (first use in this function)
> kernel/exit.c:1039:3: warning: type defaults to 'int' in type name
> kernel/exit.c:1039:3: warning: initialization makes pointer from integer without a cast
> kernel/exit.c:1039:1: warning: type defaults to 'int' in declaration of 'pao_T__'
> kernel/exit.c:1039:1: warning: type defaults to 'int' in declaration of 'pao_T__'
> kernel/exit.c:1039:1: warning: type defaults to 'int' in declaration of 'pao_T__'
> kernel/exit.c:1039:1: warning: type defaults to 'int' in declaration of 'pao_T__'
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks! I merged this with the original patch, so as to make it
bisectable.

---
Subject: writeback: charge leaked page dirties to active tasks
Date: Tue Apr 05 13:21:19 CST 2011

It's a years long problem that a large number of short-lived dirtiers
(eg. gcc instances in a fast kernel build) may starve long-run dirtiers
(eg. dd) as well as pushing the dirty pages to the global hard limit.

The solution is to charge the pages dirtied by the exited gcc to the
other random dirtying tasks. It sounds not perfect, however should
behave good enough in practice, seeing as that throttled tasks aren't
actually running so those that are running are more likely to pick it up
and get throttled, therefore promoting an equal spread.

Randy: fix compile error: 'dirty_throttle_leaks' undeclared in exit.c

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/writeback.h |    2 ++
 kernel/exit.c             |    3 +++
 mm/page-writeback.c       |   27 +++++++++++++++++++++++++++
 3 files changed, 32 insertions(+)

--- linux-next.orig/include/linux/writeback.h	2011-11-30 15:11:31.000000000 +0800
+++ linux-next/include/linux/writeback.h	2011-12-02 09:07:19.000000000 +0800
@@ -7,6 +7,8 @@
 #include <linux/sched.h>
 #include <linux/fs.h>
 
+DECLARE_PER_CPU(int, dirty_throttle_leaks);
+
 /*
  * The 1/4 region under the global dirty thresh is for smooth dirty throttling:
  *
--- linux-next.orig/mm/page-writeback.c	2011-11-30 15:11:39.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-12-02 09:07:19.000000000 +0800
@@ -1236,6 +1236,22 @@ void set_page_dirty_balance(struct page 
 
 static DEFINE_PER_CPU(int, bdp_ratelimits);
 
+/*
+ * Normal tasks are throttled by
+ *	loop {
+ *		dirty tsk->nr_dirtied_pause pages;
+ *		take a snap in balance_dirty_pages();
+ *	}
+ * However there is a worst case. If every task exit immediately when dirtied
+ * (tsk->nr_dirtied_pause - 1) pages, balance_dirty_pages() will never be
+ * called to throttle the page dirties. The solution is to save the not yet
+ * throttled page dirties in dirty_throttle_leaks on task exit and charge them
+ * randomly into the running tasks. This works well for the above worst case,
+ * as the new task will pick up and accumulate the old task's leaked dirty
+ * count and eventually get throttled.
+ */
+DEFINE_PER_CPU(int, dirty_throttle_leaks) = 0;
+
 /**
  * balance_dirty_pages_ratelimited_nr - balance dirty memory state
  * @mapping: address_space which was dirtied
@@ -1283,6 +1299,17 @@ void balance_dirty_pages_ratelimited_nr(
 			ratelimit = 0;
 		}
 	}
+	/*
+	 * Pick up the dirtied pages by the exited tasks. This avoids lots of
+	 * short-lived tasks (eg. gcc invocations in a kernel build) escaping
+	 * the dirty throttling and livelock other long-run dirtiers.
+	 */
+	p = &__get_cpu_var(dirty_throttle_leaks);
+	if (*p > 0 && current->nr_dirtied < ratelimit) {
+		nr_pages_dirtied = min(*p, ratelimit - current->nr_dirtied);
+		*p -= nr_pages_dirtied;
+		current->nr_dirtied += nr_pages_dirtied;
+	}
 	preempt_enable();
 
 	if (unlikely(current->nr_dirtied >= ratelimit))
--- linux-next.orig/kernel/exit.c	2011-11-30 15:11:31.000000000 +0800
+++ linux-next/kernel/exit.c	2011-12-02 09:08:12.000000000 +0800
@@ -51,6 +51,7 @@
 #include <trace/events/sched.h>
 #include <linux/hw_breakpoint.h>
 #include <linux/oom.h>
+#include <linux/writeback.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -1037,6 +1038,8 @@ NORET_TYPE void do_exit(long code)
 	validate_creds_for_do_exit(tsk);
 
 	preempt_disable();
+	if (tsk->nr_dirtied)
+		__this_cpu_add(dirty_throttle_leaks, tsk->nr_dirtied);
 	exit_rcu();
 	/* causes final put_task_struct in finish_task_switch(). */
 	tsk->state = TASK_DEAD;
