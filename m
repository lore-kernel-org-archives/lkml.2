Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965079Ab2J3RfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 13:35:23 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:60376 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965061Ab2J3RcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 13:32:25 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        Michael Wang <wangyun@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 04/14] rcu: Optimize the 'rcudata.csv' for RCU trace
Date: Tue, 30 Oct 2012 10:05:03 -0700
Message-Id: <1351616713-26930-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1351616713-26930-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20121030170454.GA25712@linux.vnet.ibm.com>
 <1351616713-26930-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103017-5518-0000-0000-000008D73809
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Wang <wangyun@linux.vnet.ibm.com>

This patch implements the new 'rcudata.csv' interface under each rsp
directory, by using the 'CPU units sequence reading', thus avoiding loss
of tracing data.

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_trace.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index a11522f..e387a64 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -267,6 +267,43 @@ static const struct file_operations rcudata_csv_fops = {
 	.release = single_release,
 };
 
+static int new_show_rcudata_csv(struct seq_file *m, void *v)
+{
+	struct rcu_data *rdp = (struct rcu_data *)v;
+	if (cpumask_first(cpu_possible_mask) == rdp->cpu) {
+		seq_puts(m, "\"CPU\",\"Online?\",\"c\",\"g\",\"pq\",\"pq\",");
+		seq_puts(m, "\"dt\",\"dt nesting\",\"dt NMI nesting\",\"df\",");
+		seq_puts(m, "\"of\",\"qll\",\"ql\",\"qs\"");
+#ifdef CONFIG_RCU_BOOST
+		seq_puts(m, "\"kt\",\"ktl\"");
+#endif /* #ifdef CONFIG_RCU_BOOST */
+		seq_puts(m, ",\"b\",\"ci\",\"co\",\"ca\"\n");
+	}
+
+	print_one_rcu_data_csv(m, rdp);
+	return 0;
+}
+
+static const struct seq_operations new_rcudate_csv_op = {
+	.start = r_start,
+	.next  = r_next,
+	.stop  = r_stop,
+	.show  = new_show_rcudata_csv,
+};
+
+static int new_rcudata_csv_open(struct inode *inode, struct file *file)
+{
+	return r_open(inode, file, &new_rcudate_csv_op);
+}
+
+static const struct file_operations new_rcudata_csv_fops = {
+	.owner = THIS_MODULE,
+	.open = new_rcudata_csv_open,
+	.read = seq_read,
+	.llseek = no_llseek,
+	.release = seq_release,
+};
+
 #ifdef CONFIG_RCU_BOOST
 
 static void print_one_rcu_node_boost(struct seq_file *m, struct rcu_node *rnp)
@@ -519,6 +556,11 @@ static int __init rcutree_trace_init(void)
 					rspdir, rsp, &new_rcudata_fops);
 			if (!retval)
 				goto free_out;
+
+			retval = debugfs_create_file("rcudata.csv", 0444,
+					rspdir, rsp, &new_rcudata_csv_fops);
+			if (!retval)
+				goto free_out;
 	}
 
 	retval = debugfs_create_file("rcubarrier", 0444, rcudir,
-- 
1.7.8

