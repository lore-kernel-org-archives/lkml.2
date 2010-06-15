Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab0FOG3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 02:29:31 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52178 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab0FOG3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 02:29:30 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 15 Jun 2010 15:24:50 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [PATCH] use find_lock_task_mm in memory cgroups oom
Message-Id: <20100615152450.f82c1f8c.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


based on  oom-introduce-find_lock_task_mm-to-fix-mm-false-positives.patch
tested on mm-of-the-moment snapshot 2010-06-11-16-40.

==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

When the OOM killer scans task, it check a task is under memcg or
not when it's called via memcg's context.

But, as Oleg pointed out, a thread group leader may have NULL ->mm
and task_in_mem_cgroup() may do wrong decision. We have to use
find_lock_task_mm() in memcg as generic OOM-Killer does.

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/oom.h |    2 ++
 mm/memcontrol.c     |   10 +++++++---
 mm/oom_kill.c       |    8 ++++++--
 3 files changed, 15 insertions(+), 5 deletions(-)

Index: mmotm-2.6.35-0611/include/linux/oom.h
===================================================================
--- mmotm-2.6.35-0611.orig/include/linux/oom.h
+++ mmotm-2.6.35-0611/include/linux/oom.h
@@ -45,6 +45,8 @@ static inline void oom_killer_enable(voi
 	oom_killer_disabled = false;
 }
 
+extern struct task_struct *find_lock_task_mm(struct task_struct *p);
+
 /* sysctls */
 extern int sysctl_oom_dump_tasks;
 extern int sysctl_oom_kill_allocating_task;
Index: mmotm-2.6.35-0611/mm/memcontrol.c
===================================================================
--- mmotm-2.6.35-0611.orig/mm/memcontrol.c
+++ mmotm-2.6.35-0611/mm/memcontrol.c
@@ -47,6 +47,7 @@
 #include <linux/mm_inline.h>
 #include <linux/page_cgroup.h>
 #include <linux/cpu.h>
+#include <linux/oom.h>
 #include "internal.h"
 
 #include <asm/uaccess.h>
@@ -838,10 +839,13 @@ int task_in_mem_cgroup(struct task_struc
 {
 	int ret;
 	struct mem_cgroup *curr = NULL;
+	struct task_struct *p;
 
-	task_lock(task);
-	curr = try_get_mem_cgroup_from_mm(task->mm);
-	task_unlock(task);
+	p = find_lock_task_mm(task);
+	if (!p)
+		return 0;
+	curr = try_get_mem_cgroup_from_mm(p->mm);
+	task_unlock(p);
 	if (!curr)
 		return 0;
 	/*
Index: mmotm-2.6.35-0611/mm/oom_kill.c
===================================================================
--- mmotm-2.6.35-0611.orig/mm/oom_kill.c
+++ mmotm-2.6.35-0611/mm/oom_kill.c
@@ -81,13 +81,17 @@ static bool has_intersects_mems_allowed(
 }
 #endif /* CONFIG_NUMA */
 
-/*
+/**
+ * find_lock_task_mm - Checking a process which a task belongs to has valid mm
+ * and return a locked task which has a valid pointer to mm.
+ *
+ * @p: the task of a process to be checked.
  * The process p may have detached its own ->mm while exiting or through
  * use_mm(), but one or more of its subthreads may still have a valid
  * pointer.  Return p, or any of its subthreads with a valid ->mm, with
  * task_lock() held.
  */
-static struct task_struct *find_lock_task_mm(struct task_struct *p)
+struct task_struct *find_lock_task_mm(struct task_struct *p)
 {
 	struct task_struct *t = p;
 

