Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965104Ab2J3Rcg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 13:32:36 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:59733 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964958Ab2J3Rce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 13:32:34 -0400
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
Subject: [PATCH tip/core/rcu 09/14] rcu: split 'rcubarrier' to each flavor
Date: Tue, 30 Oct 2012 10:05:08 -0700
Message-Id: <1351616713-26930-9-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1351616713-26930-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20121030170454.GA25712@linux.vnet.ibm.com>
 <1351616713-26930-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103017-7182-0000-0000-000002FDE5A6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Wang <wangyun@linux.vnet.ibm.com>

This patch add new 'rcubarrier' to each flavor's folder, now we could use:
	'cat /debugfs/rcu/rsp/rcubarrier'
to get the selected rsp info.

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_trace.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 209e696..8b03bfb 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -101,6 +101,28 @@ static const struct file_operations rcubarrier_fops = {
 	.release = single_release,
 };
 
+static int new_show_rcubarrier(struct seq_file *m, void *v)
+{
+	struct rcu_state *rsp = (struct rcu_state *)m->private;
+	seq_printf(m, "bcc: %d nbd: %lu\n",
+		   atomic_read(&rsp->barrier_cpu_count),
+		   rsp->n_barrier_done);
+	return 0;
+}
+
+static int new_rcubarrier_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, new_show_rcubarrier, inode->i_private);
+}
+
+static const struct file_operations new_rcubarrier_fops = {
+	.owner = THIS_MODULE,
+	.open = new_rcubarrier_open,
+	.read = seq_read,
+	.llseek = no_llseek,
+	.release = seq_release,
+};
+
 #ifdef CONFIG_RCU_BOOST
 
 static char convert_kthread_status(unsigned int kthread_status)
@@ -429,6 +451,11 @@ static int __init rcutree_trace_init(void)
 					rspdir, rsp, &rcu_pending_fops);
 			if (!retval)
 				goto free_out;
+
+			retval = debugfs_create_file("rcubarrier", 0444,
+					rspdir, rsp, &new_rcubarrier_fops);
+			if (!retval)
+				goto free_out;
 	}
 
 	retval = debugfs_create_file("rcubarrier", 0444, rcudir,
-- 
1.7.8

