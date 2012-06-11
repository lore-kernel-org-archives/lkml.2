Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486Ab2FKK1u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 06:27:50 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41037 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab2FKK1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 06:27:49 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FD5C791.9090902@jp.fujitsu.com>
Date: Mon, 11 Jun 2012 19:25:21 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        akpm@linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, khlebnikov@openvz.org, hughd@google.com,
        stable@vger.kernel.org
Subject: Re: [patch 12/12] mm: correctly synchronize rss-counters at exit/exec
References: <20120607212114.E4F5AA02F8@akpm.mtv.corp.google.com> <CA+55aFxOWR_h1vqRLAd_h5_woXjFBLyBHP--P8F7WsYrciXdmA@mail.gmail.com> <CA+55aFyQUBXhjVLJH6Fhz9xnpfXZ=9Mej5ujt6ss7VUqT1g9Jg@mail.gmail.com> <20120608010520.GA25317@x4> <CA+55aFwuA3ex+XXW+TzOee8ax0g1NK9Mm5F3nYtY1m6YtvUFhQ@mail.gmail.com> <20120608121816.GA23147@redhat.com>
In-Reply-To: <20120608121816.GA23147@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/08 21:18), Oleg Nesterov wrote:
> On 06/07, Linus Torvalds wrote:
>>
>> It does totally insane things in xacct_add_tsk(). You can't call
>> "sync_mm_rss(mm)" on somebody elses mm,
>
> Damn, I am stupid. Yes, I forgot about fill_stats_for_pid().
> And I didn't bother to look at get_task_mm() which clearly
> shows that this tsk can be !current.
>
> We can add the "p == current" check as Hugh suggested.
>
> But,
>
>> Doing it
>> *anywhere* where mm is not clearly "current->mm" is wrong.
>
> Agreed.
>
> How about v2? It adds sync_mm_rss() into taskstats_exit(). Note
> that it preserves the "tsk->mm != NULL" check we currently have.
> I think it should be removed (see the changelog), but even if I
> am right I'd prefer to do this in a separate patch.
>

I'm sorry I've been silent...one another fix I can think of is
this kind of change to sync_mm_rss(). How do you think ?

==
 From be49ed6843b09ae33d758f2a51cf8357f7502512 Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 11 Jun 2012 19:45:09 +0900
Subject: [PATCH] fix sync_mm_rss() leakage.

Any page fault after sync_mm_rss() in do_exit() causes problem
in check_mm(). It happens because task's rss counter is not
synchronized after the last sync_mm_rss().

This patch replaces the last sync_mm_rss() with finalize_mm_rss()
and disallow per-task rss count caching after finalization.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
  fs/exec.c          |    3 ++-
  include/linux/mm.h |   10 ++++++++++
  kernel/exit.c      |    3 +--
  mm/memory.c        |   21 ++++++++++++++++++---
  4 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index a79786a..3e47772 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -819,7 +819,7 @@ static int exec_mmap(struct mm_struct *mm)
  	/* Notify parent that we're no longer interested in the old VM */
  	tsk = current;
  	old_mm = current->mm;
-	sync_mm_rss(old_mm);
+	finalize_mm_rss();
  	mm_release(tsk, old_mm);
  
  	if (old_mm) {
@@ -851,6 +851,7 @@ static int exec_mmap(struct mm_struct *mm)
  		return 0;
  	}
  	mmdrop(active_mm);
+	initialize_mm_rss();
  	return 0;
  }
  
diff --git a/include/linux/mm.h b/include/linux/mm.h
index b36d08c..995d7ff 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1129,10 +1129,20 @@ static inline void setmax_mm_hiwater_rss(unsigned long *maxrss,
  
  #if defined(SPLIT_RSS_COUNTING)
  void sync_mm_rss(struct mm_struct *mm);
+void finalize_mm_rss(void);
+void initialize_mm_rss(void);
  #else
+static inline void finalize_mm_rss(void)
+{
+}
+
  static inline void sync_mm_rss(struct mm_struct *mm)
  {
  }
+
+static inline void initialize_mm_rss(void)
+{
+}
  #endif
  
  int vma_wants_writenotify(struct vm_area_struct *vma);
diff --git a/kernel/exit.c b/kernel/exit.c
index 34867cc..2111879 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -961,8 +961,7 @@ void do_exit(long code)
  
  	acct_update_integrals(tsk);
  	/* sync mm's RSS info before statistics gathering */
-	if (tsk->mm)
-		sync_mm_rss(tsk->mm);
+	finalize_mm_rss();
  	group_dead = atomic_dec_and_test(&tsk->signal->live);
  	if (group_dead) {
  		hrtimer_cancel(&tsk->signal->real_timer);
diff --git a/mm/memory.c b/mm/memory.c
index 1b7dc66..07aa887d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -125,6 +125,20 @@ core_initcall(init_zero_pfn);
  
  #if defined(SPLIT_RSS_COUNTING)
  
+void initialize_mm_rss(void)
+{
+	current->rss_stat.events = 0;
+}
+
+void finalize_mm_rss(void)
+{
+	current->rss_stat.events = -1;
+	if (current->mm)
+		sync_mm_rss(current->mm);
+}
+
+#define rss_count_finalized(task)	((task)->rss_stat.events < 0)
+
  void sync_mm_rss(struct mm_struct *mm)
  {
  	int i;
@@ -135,14 +149,15 @@ void sync_mm_rss(struct mm_struct *mm)
  			current->rss_stat.count[i] = 0;
  		}
  	}
-	current->rss_stat.events = 0;
+	if (!rss_count_finalized(current))
+		current->rss_stat.events = 0;
  }
  
  static void add_mm_counter_fast(struct mm_struct *mm, int member, int val)
  {
  	struct task_struct *task = current;
  
-	if (likely(task->mm == mm))
+	if (likely(task->mm == mm && !rss_count_finalized(task)))
  		task->rss_stat.count[member] += val;
  	else
  		add_mm_counter(mm, member, val);
@@ -154,7 +169,7 @@ static void add_mm_counter_fast(struct mm_struct *mm, int member, int val)
  #define TASK_RSS_EVENTS_THRESH	(64)
  static void check_sync_rss_stat(struct task_struct *task)
  {
-	if (unlikely(task != current))
+	if (unlikely(task != current || rss_count_finalized(task)))
  		return;
  	if (unlikely(task->rss_stat.events++ > TASK_RSS_EVENTS_THRESH))
  		sync_mm_rss(task->mm);
-- 
1.7.4.1



