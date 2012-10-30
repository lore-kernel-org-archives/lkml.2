Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965118Ab2J3RfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 13:35:25 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:60372 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965057Ab2J3RcZ (ORCPT
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
Subject: [PATCH tip/core/rcu 12/14] rcu: split 'rcuhier' to each flavor
Date: Tue, 30 Oct 2012 10:05:11 -0700
Message-Id: <1351616713-26930-12-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1351616713-26930-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20121030170454.GA25712@linux.vnet.ibm.com>
 <1351616713-26930-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103017-5518-0000-0000-000008D73818
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Wang <wangyun@linux.vnet.ibm.com>

This patch add new 'rcuhier' to each flavor's folder, now we could use:
	'cat /debugfs/rcu/rsp/rcuhier'
to get the selected rsp info.

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_trace.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index bbfb6e2..db46464 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -313,6 +313,26 @@ static const struct file_operations rcuhier_fops = {
 	.release = single_release,
 };
 
+static int new_show_rcuhier(struct seq_file *m, void *v)
+{
+	struct rcu_state *rsp = (struct rcu_state *)m->private;
+	print_one_rcu_state(m, rsp);
+	return 0;
+}
+
+static int new_rcuhier_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, new_show_rcuhier, inode->i_private);
+}
+
+static const struct file_operations new_rcuhier_fops = {
+	.owner = THIS_MODULE,
+	.open = new_rcuhier_open,
+	.read = seq_read,
+	.llseek = no_llseek,
+	.release = seq_release,
+};
+
 static void show_one_rcugp(struct seq_file *m, struct rcu_state *rsp)
 {
 	unsigned long flags;
@@ -491,6 +511,10 @@ static int __init rcutree_trace_init(void)
 			if (!retval)
 				goto free_out;
 
+			retval = debugfs_create_file("rcuhier", 0444,
+					rspdir, rsp, &new_rcuhier_fops);
+			if (!retval)
+				goto free_out;
 	}
 
 	retval = debugfs_create_file("rcubarrier", 0444, rcudir,
-- 
1.7.8

