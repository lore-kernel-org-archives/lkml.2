Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965158Ab2J3ReJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 13:34:09 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:35526 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965100Ab2J3ReG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 13:34:06 -0400
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
Subject: [PATCH tip/core/rcu 11/14] rcu: split 'rcugp' to each flavor
Date: Tue, 30 Oct 2012 10:05:10 -0700
Message-Id: <1351616713-26930-11-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1351616713-26930-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20121030170454.GA25712@linux.vnet.ibm.com>
 <1351616713-26930-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103017-7408-0000-0000-000009C5CA82
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Wang <wangyun@linux.vnet.ibm.com>

This patch add new 'rcugp' to each flavor's folder, now we could use:
	'cat /debugfs/rcu/rsp/rcugp'
to get the selected rsp info.

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_trace.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index b6fd147..bbfb6e2 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -357,6 +357,26 @@ static const struct file_operations rcugp_fops = {
 	.release = single_release,
 };
 
+static int new_show_rcugp(struct seq_file *m, void *v)
+{
+	struct rcu_state *rsp = (struct rcu_state *)m->private;
+	show_one_rcugp(m, rsp);
+	return 0;
+}
+
+static int new_rcugp_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, new_show_rcugp, inode->i_private);
+}
+
+static const struct file_operations new_rcugp_fops = {
+	.owner = THIS_MODULE,
+	.open = new_rcugp_open,
+	.read = seq_read,
+	.llseek = no_llseek,
+	.release = seq_release,
+};
+
 static void print_one_rcu_pending(struct seq_file *m, struct rcu_data *rdp)
 {
 	if (!rdp->beenonline)
@@ -465,6 +485,12 @@ static int __init rcutree_trace_init(void)
 					goto free_out;
 			}
 #endif
+
+			retval = debugfs_create_file("rcugp", 0444,
+					rspdir, rsp, &new_rcugp_fops);
+			if (!retval)
+				goto free_out;
+
 	}
 
 	retval = debugfs_create_file("rcubarrier", 0444, rcudir,
-- 
1.7.8

