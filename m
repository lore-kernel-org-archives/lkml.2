Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759147Ab2BJLZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 06:25:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47923 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755094Ab2BJLZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 06:25:42 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] unwind, test: Add backtrace unwind test code
Date: Fri, 10 Feb 2012 12:25:19 +0100
Message-Id: <1328873119-21553-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1328873119-21553-1-git-send-email-jolsa@redhat.com>
References: <1328873119-21553-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding test code for backtrace unwinding. The debugfs file
'unwind_test' is created in debugfs root. Writing to this
file triggers backtrace from process and irq context.

Mostly stolen from kernel/backtracetest.c. Getting following
output in dmesg:

 # echo > ./unwind_test
 Testing unwind from process context.
 unwind backtrace:
     [0xffffffff810ef759] unw_backtrace+0x29/0x80
     [0xffffffff810ef7d4] test_write+0x24/0x90
     [0xffffffff81138940] vfs_write+0xd0/0x1a0
     [0xffffffff81138b14] sys_write+0x54/0xa0
     [0xffffffff814d7352] system_call_fastpath+0x16/0x1b
 Testing a unwind from irq context.
 unwind backtrace:
     [0xffffffff810ef759] unw_backtrace+0x29/0x80
     [0xffffffff810ef84e] unwind_test_irq_callback+0xe/0x20
     [0xffffffff8103d1c3] tasklet_action+0x143/0x150
     [0xffffffff8103d9bd] __do_softirq+0xdd/0x250
     [0xffffffff8103dc18] run_ksoftirqd+0xe8/0x200
     [0xffffffff8105a1b6] kthread+0xc6/0xd0
     [0xffffffff814d8564] kernel_thread_helper+0x4/0x10
---
 kernel/unwind.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/kernel/unwind.c b/kernel/unwind.c
index f5191d5..5a8c5bb 100644
--- a/kernel/unwind.c
+++ b/kernel/unwind.c
@@ -178,3 +178,47 @@ void unw_backtrace(void)
 	} while (!unw_step(&unw));
 
 }
+
+static DECLARE_COMPLETION(unwind_work);
+
+static void unwind_test_irq_callback(unsigned long data)
+{
+	unw_backtrace();
+	complete(&unwind_work);
+}
+
+static DECLARE_TASKLET(unwind_tasklet, &unwind_test_irq_callback, 0);
+
+static void unw_test_irq(void)
+{
+        printk("Testing a unwind from irq context.\n");
+
+        init_completion(&unwind_work);
+        tasklet_schedule(&unwind_tasklet);
+        wait_for_completion(&unwind_work);
+}
+
+static ssize_t
+test_write(struct file *filp, const char __user *ubuf,
+	   size_t cnt, loff_t *ppos)
+{
+	printk("Testing unwind from process context.\n");
+	unw_backtrace();
+	unw_test_irq();
+	return cnt;
+}
+
+static const struct file_operations test_fops = {
+	.write = test_write,
+};
+
+static int __init unwind_init_test(void)
+{
+	if (!debugfs_create_file("unwind_test", 0644, NULL, NULL,
+				 &test_fops))
+		return -ENOMEM;
+
+	return 0;
+}
+
+late_initcall(unwind_init_test);
-- 
1.7.1

