Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab2IRT5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 15:57:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38021 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361Ab2IRT5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 15:57:51 -0400
Date: Tue, 18 Sep 2012 12:57:46 -0700
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Bjorn Helgaas <bhelgaas@google.com>,
        Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH] workqueue: reimplement work_on_cpu() using system_wq
Message-ID: <20120918195746.GE8474@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 760824d48d8a1f302b80367681ada19836d93521 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Tue, 18 Sep 2012 12:48:43 -0700

The existing work_on_cpu() implementation is hugely inefficient.  It
creates a new kthread, execute that single function and then let the
kthread die on each invocation.

Now that system_wq can handle concurrent executions, there's no
advantage of doing this.  Reimplement work_on_cpu() using system_wq
which makes it simpler and way more efficient.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
---
Applying to wq/for-3.7.

Thanks.

 kernel/workqueue.c |   25 ++++++++-----------------
 1 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 3e324aa..737ab01 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3624,18 +3624,17 @@ static int __cpuinit workqueue_cpu_down_callback(struct notifier_block *nfb,
 #ifdef CONFIG_SMP
 
 struct work_for_cpu {
-	struct completion completion;
+	struct work_struct work;
 	long (*fn)(void *);
 	void *arg;
 	long ret;
 };
 
-static int do_work_for_cpu(void *_wfc)
+static void work_for_cpu_fn(struct work_struct *work)
 {
-	struct work_for_cpu *wfc = _wfc;
+	struct work_for_cpu *wfc = container_of(work, struct work_for_cpu, work);
+
 	wfc->ret = wfc->fn(wfc->arg);
-	complete(&wfc->completion);
-	return 0;
 }
 
 /**
@@ -3650,19 +3649,11 @@ static int do_work_for_cpu(void *_wfc)
  */
 long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
 {
-	struct task_struct *sub_thread;
-	struct work_for_cpu wfc = {
-		.completion = COMPLETION_INITIALIZER_ONSTACK(wfc.completion),
-		.fn = fn,
-		.arg = arg,
-	};
+	struct work_for_cpu wfc = { .fn = fn, .arg = arg };
 
-	sub_thread = kthread_create(do_work_for_cpu, &wfc, "work_for_cpu");
-	if (IS_ERR(sub_thread))
-		return PTR_ERR(sub_thread);
-	kthread_bind(sub_thread, cpu);
-	wake_up_process(sub_thread);
-	wait_for_completion(&wfc.completion);
+	INIT_WORK_ONSTACK(&wfc.work, work_for_cpu_fn);
+	schedule_work_on(cpu, &wfc.work);
+	flush_work(&wfc.work);
 	return wfc.ret;
 }
 EXPORT_SYMBOL_GPL(work_on_cpu);
-- 
1.7.7.3

