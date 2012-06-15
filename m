Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135Ab2FOVGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 17:06:50 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:60154 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757987Ab2FOVGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 17:06:44 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 11/15] rcu: Add rcu_barrier() statistics to debugfs tracing
Date: Fri, 15 Jun 2012 14:06:06 -0700
Message-Id: <1339794370-28119-11-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1339794370-28119-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120615210550.GA27506@linux.vnet.ibm.com>
 <1339794370-28119-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061521-6148-0000-0000-000006BD874A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

This commit adds an rcubarrier file to RCU's debugfs statistical tracing
directory, providing diagnostic information on rcu_barrier().

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_trace.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index a3556a2..057408b 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -46,6 +46,40 @@
 #define RCU_TREE_NONCORE
 #include "rcutree.h"
 
+static void print_rcubarrier(struct seq_file *m, struct rcu_state *rsp)
+{
+	seq_printf(m, "%c bcc: %d nbd: %lu\n",
+		   rsp->rcu_barrier_in_progress ? 'B' : '.',
+		   atomic_read(&rsp->barrier_cpu_count),
+		   rsp->n_barrier_done);
+}
+
+static int show_rcubarrier(struct seq_file *m, void *unused)
+{
+#ifdef CONFIG_TREE_PREEMPT_RCU
+	seq_puts(m, "rcu_preempt: ");
+	print_rcubarrier(m, &rcu_preempt_state);
+#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+	seq_puts(m, "rcu_sched: ");
+	print_rcubarrier(m, &rcu_sched_state);
+	seq_puts(m, "rcu_bh: ");
+	print_rcubarrier(m, &rcu_bh_state);
+	return 0;
+}
+
+static int rcubarrier_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, show_rcubarrier, NULL);
+}
+
+static const struct file_operations rcubarrier_fops = {
+	.owner = THIS_MODULE,
+	.open = rcubarrier_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
 #ifdef CONFIG_RCU_BOOST
 
 static char convert_kthread_status(unsigned int kthread_status)
@@ -453,6 +487,11 @@ static int __init rcutree_trace_init(void)
 	if (!rcudir)
 		goto free_out;
 
+	retval = debugfs_create_file("rcubarrier", 0444, rcudir,
+						NULL, &rcubarrier_fops);
+	if (!retval)
+		goto free_out;
+
 	retval = debugfs_create_file("rcudata", 0444, rcudir,
 						NULL, &rcudata_fops);
 	if (!retval)
-- 
1.7.8

