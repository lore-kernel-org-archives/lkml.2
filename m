Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965126Ab2J3Rct (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 13:32:49 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:35014 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964929Ab2J3Rco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 13:32:44 -0400
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
Subject: [PATCH tip/core/rcu 03/14] rcu: Optimize the 'rcudata' for RCU trace
Date: Tue, 30 Oct 2012 10:05:02 -0700
Message-Id: <1351616713-26930-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1351616713-26930-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20121030170454.GA25712@linux.vnet.ibm.com>
 <1351616713-26930-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103017-7408-0000-0000-000009C5C924
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Wang <wangyun@linux.vnet.ibm.com>

This patch implements the new 'rcudata' interface under each rsp
directory, by using the 'CPU units sequence reading', thus avoiding loss
of tracing data.

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_trace.c |   31 +++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 0dfe9b5..a11522f 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -174,6 +174,32 @@ static const struct file_operations rcudata_fops = {
 	.release = single_release,
 };
 
+static int new_show_rcudata(struct seq_file *m, void *v)
+{
+	print_one_rcu_data(m, (struct rcu_data *)v);
+	return 0;
+}
+
+static const struct seq_operations new_rcudate_op = {
+	.start = r_start,
+	.next  = r_next,
+	.stop  = r_stop,
+	.show  = new_show_rcudata,
+};
+
+static int new_rcudata_open(struct inode *inode, struct file *file)
+{
+	return r_open(inode, file, &new_rcudate_op);
+}
+
+static const struct file_operations new_rcudata_fops = {
+	.owner = THIS_MODULE,
+	.open = new_rcudata_open,
+	.read = seq_read,
+	.llseek = no_llseek,
+	.release = seq_release,
+};
+
 static void print_one_rcu_data_csv(struct seq_file *m, struct rcu_data *rdp)
 {
 	if (!rdp->beenonline)
@@ -488,6 +514,11 @@ static int __init rcutree_trace_init(void)
 		rspdir = debugfs_create_dir(rsp->name, rcudir);
 		if (!rspdir)
 			goto free_out;
+
+			retval = debugfs_create_file("rcudata", 0444,
+					rspdir, rsp, &new_rcudata_fops);
+			if (!retval)
+				goto free_out;
 	}
 
 	retval = debugfs_create_file("rcubarrier", 0444, rcudir,
-- 
1.7.8

