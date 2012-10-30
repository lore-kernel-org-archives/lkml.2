Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965132Ab2J3RdE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 13:33:04 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:60099 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964929Ab2J3Rc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 13:32:59 -0400
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
Subject: [PATCH tip/core/rcu 05/14] rcu: Optimize the 'rcu_pending' for RCU trace
Date: Tue, 30 Oct 2012 10:05:04 -0700
Message-Id: <1351616713-26930-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1351616713-26930-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20121030170454.GA25712@linux.vnet.ibm.com>
 <1351616713-26930-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103017-7182-0000-0000-000002FDE6C0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Wang <wangyun@linux.vnet.ibm.com>

This patch implements the new 'rcu_pending' interface under each rsp
directory, by using the 'CPU units sequence reading', thus avoiding loss
of tracing data.

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_trace.c |   41 +++++++++++++++++++++++++++++++++++------
 1 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index e387a64..8b24867 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -467,6 +467,8 @@ static const struct file_operations rcugp_fops = {
 
 static void print_one_rcu_pending(struct seq_file *m, struct rcu_data *rdp)
 {
+	if (!rdp->beenonline)
+		return;
 	seq_printf(m, "%3d%cnp=%ld ",
 		   rdp->cpu,
 		   cpu_is_offline(rdp->cpu) ? '!' : ' ',
@@ -485,16 +487,12 @@ static void print_one_rcu_pending(struct seq_file *m, struct rcu_data *rdp)
 static int show_rcu_pending(struct seq_file *m, void *unused)
 {
 	int cpu;
-	struct rcu_data *rdp;
 	struct rcu_state *rsp;
 
 	for_each_rcu_flavor(rsp) {
 		seq_printf(m, "%s:\n", rsp->name);
-		for_each_possible_cpu(cpu) {
-			rdp = per_cpu_ptr(rsp->rda, cpu);
-			if (rdp->beenonline)
-				print_one_rcu_pending(m, rdp);
-		}
+		for_each_possible_cpu(cpu)
+			print_one_rcu_pending(m, per_cpu_ptr(rsp->rda, cpu));
 	}
 	return 0;
 }
@@ -512,6 +510,32 @@ static const struct file_operations rcu_pending_fops = {
 	.release = single_release,
 };
 
+static int new_show_rcu_pending(struct seq_file *m, void *v)
+{
+	print_one_rcu_pending(m, (struct rcu_data *)v);
+	return 0;
+}
+
+static const struct seq_operations new_rcu_pending_op = {
+	.start = r_start,
+	.next  = r_next,
+	.stop  = r_stop,
+	.show  = new_show_rcu_pending,
+};
+
+static int new_rcu_pending_open(struct inode *inode, struct file *file)
+{
+	return r_open(inode, file, &new_rcu_pending_op);
+}
+
+static const struct file_operations new_rcu_pending_fops = {
+	.owner = THIS_MODULE,
+	.open = new_rcu_pending_open,
+	.read = seq_read,
+	.llseek = no_llseek,
+	.release = seq_release,
+};
+
 static int show_rcutorture(struct seq_file *m, void *unused)
 {
 	seq_printf(m, "rcutorture test sequence: %lu %s\n",
@@ -561,6 +585,11 @@ static int __init rcutree_trace_init(void)
 					rspdir, rsp, &new_rcudata_csv_fops);
 			if (!retval)
 				goto free_out;
+
+			retval = debugfs_create_file("rcu_pending", 0444,
+					rspdir, rsp, &new_rcu_pending_fops);
+			if (!retval)
+				goto free_out;
 	}
 
 	retval = debugfs_create_file("rcubarrier", 0444, rcudir,
-- 
1.7.8

