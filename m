Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626Ab1CXJem (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 05:34:42 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36030 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab1CXJel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 05:34:41 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 24 Mar 2011 18:28:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rientjes@google.com" <rientjes@google.com>,
        Andrey Vagin <avagin@openvz.org>
Subject: [PATCH 3/5] forkbomb : mm histroy scanning and locks
Message-Id: <20110324182812.df71e831.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110324182240.5fe56de2.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110324182240.5fe56de2.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a code for scanning mm_history tree. Later, we need
to scan all mm_histroy from children->parent direction.

And this patch adds a global lock which will be required for scanning.
Because scanning isn't called frequently, using rwsem with a help of
percpu variable.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/oom_kill.c |  116 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 116 insertions(+)

Index: mm-work2/mm/oom_kill.c
===================================================================
--- mm-work2.orig/mm/oom_kill.c
+++ mm-work2/mm/oom_kill.c
@@ -31,6 +31,7 @@
 #include <linux/memcontrol.h>
 #include <linux/mempolicy.h>
 #include <linux/security.h>
+#include <linux/cpu.h>
 
 int sysctl_panic_on_oom;
 int sysctl_oom_kill_allocating_task;
@@ -764,6 +765,58 @@ void pagefault_out_of_memory(void)
 
 #ifdef CONFIG_FORKBOMB_KILLER
 
+static DEFINE_PER_CPU(unsigned long, pcpu_history_lock);
+static DECLARE_RWSEM(hist_rwsem);
+static int need_global_history_lock;
+
+static void update_history_lock(void)
+{
+retry:
+	preempt_disable();
+	this_cpu_inc(pcpu_history_lock);
+	smp_rmb();
+	if (need_global_history_lock) {
+		this_cpu_dec(pcpu_history_lock);
+		preempt_enable();
+		down_read(&hist_rwsem);
+		up_read(&hist_rwsem);
+		goto retry;
+	}
+}
+
+static void update_history_unlock(void)
+{
+	this_cpu_dec(pcpu_history_lock);
+	preempt_enable();
+}
+
+static void scan_history_lock(void)
+{
+	int cpu;
+	bool loop;
+
+	down_write(&hist_rwsem);
+	need_global_history_lock++;
+	do {
+		loop = false;
+		get_online_cpus();
+		for_each_online_cpu(cpu)
+			if (per_cpu(pcpu_history_lock, cpu)) {
+				loop = true;
+				break;
+			}
+		put_online_cpus();
+		cpu_relax();
+	} while (loop);
+}
+
+static void scan_history_unlock(void)
+{
+	need_global_history_lock--;
+	up_write(&hist_rwsem);
+}
+
+
 struct mm_history {
 	spinlock_t	lock;
 	struct mm_struct *mm;
@@ -791,6 +844,7 @@ void track_mm_history(struct mm_struct *
 	hist = kmalloc(sizeof(*hist), GFP_KERNEL);
 	if (!hist)
 		return;
+	update_history_lock();
 	spin_lock_init(&hist->lock);
 	INIT_LIST_HEAD(&hist->children);
 	hist->mm = new;
@@ -806,6 +860,7 @@ void track_mm_history(struct mm_struct *
 	spin_lock(&phist->lock);
 	list_add_tail(&hist->siblings, &phist->children);
 	spin_unlock(&phist->lock);
+	update_history_unlock();
 	return;
 }
 
@@ -816,6 +871,7 @@ void delete_mm_history(struct mm_struct 
 
 	if (!mm->history)
 		return;
+	update_history_lock();
 	hist = mm->history;
 	spin_lock(&hist->lock);
 	nochild = list_empty(&hist->children);
@@ -833,6 +889,66 @@ void delete_mm_history(struct mm_struct 
 		kfree(hist);
 		hist = phist;
 	}
+	update_history_unlock();
 }
 
+/* Because we have global scan lock, we need no lock at scaning. */
+static struct mm_history* __first_child(struct mm_history *p)
+{
+	if (list_empty(&p->children))
+		return NULL;
+	return list_first_entry(&p->children, struct mm_history, siblings);
+}
+
+static struct mm_history* __next_sibling(struct mm_history *p)
+{
+	if (p->siblings.next == &p->parent->children)
+		return NULL;
+	return list_first_entry(&p->siblings, struct mm_history, siblings);
+}
+
+static struct mm_history *first_deepest_child(struct mm_history *p)
+{
+	struct mm_history *tmp;
+
+	do {
+		tmp = __first_child(p);
+		if (!tmp)
+			return p;
+		p = tmp;
+	} while (1);
+}
+
+static struct mm_history *mm_history_scan_start(struct mm_history *hist)
+{
+	return first_deepest_child(hist);
+}
+
+static struct mm_history *mm_history_scan_next(struct mm_history *pos)
+{
+	struct mm_history *tmp;
+
+	tmp = __next_sibling(pos);
+	if (!tmp)
+		return pos->parent;
+	pos = tmp;
+	pos = first_deepest_child(pos);
+	return pos;
+}
+
+#define for_each_mm_history_under(pos, root)\
+	for (pos = mm_history_scan_start(root);\
+		pos != root;\
+		pos = mm_history_scan_next(pos))
+
+#define for_each_mm_history_safe_under(pos, root, tmp)\
+	for (pos =  mm_history_scan_start(root),\
+		tmp = mm_history_scan_next(pos);\
+		pos != root;\
+		pos = tmp, tmp = mm_history_scan_next(pos))
+
+#define for_each_mm_history(pos) for_each_mm_history_under((pos), &init_hist)
+#define for_each_mm_history_safe(pos, tmp)\
+	for_each_mm_history_safe_under((pos), &init_hist, (tmp))
+
 #endif

