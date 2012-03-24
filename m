Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab2CXK3F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 06:29:05 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51264 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277Ab2CXK3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 06:29:02 -0400
Date: Sat, 24 Mar 2012 14:27:51 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>
Cc: Russell King <linux@arm.linux.org.uk>, Mike Frysinger <vapier@gentoo.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Richard Weinberger <richard@nod.at>, Paul Mundt <lethal@linux-sh.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        John Stultz <john.stultz@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linuxppc-dev@lists.ozlabs.org,
        linux-sh@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        linux-mm@kvack.org
Subject: [PATCH 01/10] cpu: Introduce clear_tasks_mm_cpumask() helper
Message-ID: <20120324102751.GA29067@lizard>
References: <20120324102609.GA28356@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120324102609.GA28356@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many architctures clear tasks' mm_cpumask like this:

	read_lock(&tasklist_lock);
	for_each_process(p) {
		if (p->mm)
			cpumask_clear_cpu(cpu, mm_cpumask(p->mm));
	}
	read_unlock(&tasklist_lock);

The code above has several problems, such as:

1. Working with task->mm w/o getting mm or grabing the task lock is
   dangerous as ->mm might disappear (exit_mm() assigns NULL under
   task_lock(), so tasklist lock is not enough).

2. Checking for process->mm is not enough because process' main
   thread may exit or detach its mm via use_mm(), but other threads
   may still have a valid mm.

This patch implements a small helper function that does things
correctly, i.e.:

1. We take the task's lock while whe handle its mm (we can't use
   get_task_mm()/mmput() pair as mmput() might sleep);

2. To catch exited main thread case, we use find_lock_task_mm(),
   which walks up all threads and returns an appropriate task
   (with task lock held).

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 include/linux/cpu.h |    1 +
 kernel/cpu.c        |   18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 1f65875..941e865 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -171,6 +171,7 @@ extern void put_online_cpus(void);
 #define hotcpu_notifier(fn, pri)	cpu_notifier(fn, pri)
 #define register_hotcpu_notifier(nb)	register_cpu_notifier(nb)
 #define unregister_hotcpu_notifier(nb)	unregister_cpu_notifier(nb)
+void clear_tasks_mm_cpumask(int cpu);
 int cpu_down(unsigned int cpu);
 
 #ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 2060c6e..5255936 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -10,6 +10,7 @@
 #include <linux/sched.h>
 #include <linux/unistd.h>
 #include <linux/cpu.h>
+#include <linux/oom.h>
 #include <linux/export.h>
 #include <linux/kthread.h>
 #include <linux/stop_machine.h>
@@ -171,6 +172,23 @@ void __ref unregister_cpu_notifier(struct notifier_block *nb)
 }
 EXPORT_SYMBOL(unregister_cpu_notifier);
 
+void clear_tasks_mm_cpumask(int cpu)
+{
+	struct task_struct *p;
+
+	read_lock(&tasklist_lock);
+	for_each_process(p) {
+		struct task_struct *t;
+
+		t = find_lock_task_mm(p);
+		if (!t)
+			continue;
+		cpumask_clear_cpu(cpu, mm_cpumask(t->mm));
+		task_unlock(t);
+	}
+	read_unlock(&tasklist_lock);
+}
+
 static inline void check_for_tasks(int cpu)
 {
 	struct task_struct *p;
-- 
1.7.9.2

