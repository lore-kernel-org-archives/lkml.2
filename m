Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032043Ab2I1UXV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:23:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47839 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032029Ab2I1UXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:23:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [ 032/218] workqueue: reimplement work_on_cpu() using system_wq
Date: Fri, 28 Sep 2012 13:14:09 -0700
Message-Id: <20120928201505.045078402@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/workqueue.c |   25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3620,18 +3620,17 @@ static int __devinit workqueue_cpu_down_
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
@@ -3646,19 +3645,11 @@ static int do_work_for_cpu(void *_wfc)
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


