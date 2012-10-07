Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642Ab2JGXWV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:22:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38183 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752698Ab2JGXWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:22:02 -0400
Message-Id: <20121007225836.245888197@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:58:45 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [ 011/108] workqueue: reimplement work_on_cpu() using system_wq
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit ed48ece27cd3d5ee0354c32bbaec0f3e1d4715c3 upstream.

The existing work_on_cpu() implementation is hugely inefficient.  It
creates a new kthread, execute that single function and then let the
kthread die on each invocation.

Now that system_wq can handle concurrent executions, there's no
advantage of doing this.  Reimplement work_on_cpu() using system_wq
which makes it simpler and way more efficient.

stable: While this isn't a fix in itself, it's needed to fix a
        workqueue related bug in cpufreq/powernow-k8.  AFAICS, this
        shouldn't break other existing users.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Jiri Kosina <jkosina@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/workqueue.c |   25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index b80065a..3c5a79e 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3576,18 +3576,17 @@ static int __devinit workqueue_cpu_down_callback(struct notifier_block *nfb,
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
@@ -3602,19 +3601,11 @@ static int do_work_for_cpu(void *_wfc)
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


