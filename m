Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965033Ab2J3RcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 13:32:21 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:59552 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934036Ab2J3RcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 13:32:15 -0400
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
Subject: [PATCH tip/core/rcu 02/14] rcu: Fundamental facility for 'CPU units sequence reading'
Date: Tue, 30 Oct 2012 10:05:01 -0700
Message-Id: <1351616713-26930-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1351616713-26930-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20121030170454.GA25712@linux.vnet.ibm.com>
 <1351616713-26930-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103017-7182-0000-0000-000002FDE52D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Wang <wangyun@linux.vnet.ibm.com>

This patch add the fundamental facility used by the following patches, so we
can implement the 'CPU units sequence reading' later.

This helps us avoid losing data when there are too many CPUs and too
small of a buffer, since this new approach allows userspace to read out
the data one CPU at a time.  Thus, if the buffer is not large enough,
userspace will get whatever CPUs fit, and can then issue another read
for the remainder of the data.

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_trace.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 62223a2..0dfe9b5 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -46,6 +46,36 @@
 #define RCU_TREE_NONCORE
 #include "rcutree.h"
 
+static int r_open(struct inode *inode, struct file *file,
+					const struct seq_operations *op)
+{
+	int ret = seq_open(file, op);
+	if (!ret) {
+		struct seq_file *m = (struct seq_file *)file->private_data;
+		m->private = inode->i_private;
+	}
+	return ret;
+}
+
+static void *r_start(struct seq_file *m, loff_t *pos)
+{
+	struct rcu_state *rsp = (struct rcu_state *)m->private;
+	*pos = cpumask_next(*pos - 1, cpu_possible_mask);
+	if ((*pos) < nr_cpu_ids)
+		return per_cpu_ptr(rsp->rda, *pos);
+	return NULL;
+}
+
+static void *r_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	(*pos)++;
+	return r_start(m, pos);
+}
+
+static void r_stop(struct seq_file *m, void *v)
+{
+}
+
 static int show_rcubarrier(struct seq_file *m, void *unused)
 {
 	struct rcu_state *rsp;
-- 
1.7.8

