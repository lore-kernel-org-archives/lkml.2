Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965091Ab2J3Rc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 13:32:28 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:34331 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965007Ab2J3RcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 13:32:17 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 14/14] rcu: Add tracing for synchronize_sched_expedited()
Date: Tue, 30 Oct 2012 10:05:13 -0700
Message-Id: <1351616713-26930-14-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1351616713-26930-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20121030170454.GA25712@linux.vnet.ibm.com>
 <1351616713-26930-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103017-7408-0000-0000-000009C5C6A2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

This commit adds a per-RCU-flavor "rcuexp" file that dumps out
statistics for synchonize_sched_expedited().

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_trace.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index c6f9cb3..e84679c 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -171,6 +171,45 @@ static const struct file_operations rcudata_fops = {
 	.release = seq_release,
 };
 
+static int show_rcuexp(struct seq_file *m, void *v)
+{
+	struct rcu_state *rsp = (struct rcu_state *)v;
+
+	seq_printf(m, "s=%lu d=%lu w=%lu tf=%lu wd1=%lu wd2=%lu n=%lu sc=%lu dt=%lu dl=%lu dx=%lu",
+		   atomic_long_read(&rsp->expedited_start),
+		   atomic_long_read(&rsp->expedited_done),
+		   atomic_long_read(&rsp->expedited_wrap),
+		   atomic_long_read(&rsp->expedited_tryfail),
+		   atomic_long_read(&rsp->expedited_workdone1),
+		   atomic_long_read(&rsp->expedited_workdone2),
+		   atomic_long_read(&rsp->expedited_normal),
+		   atomic_long_read(&rsp->expedited_stoppedcpus),
+		   atomic_long_read(&rsp->expedited_done_tries),
+		   atomic_long_read(&rsp->expedited_done_lost),
+		   atomic_long_read(&rsp->expedited_done_exit));
+	return 0;
+}
+
+static const struct seq_operations rcuexp_op = {
+	.start = r_start,
+	.next  = r_next,
+	.stop  = r_stop,
+	.show  = show_rcuexp,
+};
+
+static int rcuexp_open(struct inode *inode, struct file *file)
+{
+	return r_open(inode, file, &rcuexp_op);
+}
+
+static const struct file_operations rcuexp_fops = {
+	.owner = THIS_MODULE,
+	.open = rcuexp_open,
+	.read = seq_read,
+	.llseek = no_llseek,
+	.release = seq_release,
+};
+
 #ifdef CONFIG_RCU_BOOST
 
 static void print_one_rcu_node_boost(struct seq_file *m, struct rcu_node *rnp)
@@ -402,6 +441,11 @@ static int __init rcutree_trace_init(void)
 		if (!retval)
 			goto free_out;
 
+		retval = debugfs_create_file("rcuexp", 0444,
+				rspdir, rsp, &rcuexp_fops);
+		if (!retval)
+			goto free_out;
+
 		retval = debugfs_create_file("rcu_pending", 0444,
 				rspdir, rsp, &rcu_pending_fops);
 		if (!retval)
-- 
1.7.8

