Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965169Ab2J3ReL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 13:34:11 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:35495 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964958Ab2J3ReF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 13:34:05 -0400
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
Subject: [PATCH tip/core/rcu 10/14] rcu: split 'rcuboost' to each flavor
Date: Tue, 30 Oct 2012 10:05:09 -0700
Message-Id: <1351616713-26930-10-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1351616713-26930-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20121030170454.GA25712@linux.vnet.ibm.com>
 <1351616713-26930-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103017-7408-0000-0000-000009C5CAC5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Wang <wangyun@linux.vnet.ibm.com>

This patch add new 'rcuboost' to each flavor's folder, now we could use:
	'cat /debugfs/rcu/rsp/rcuboost'
to get the selected rsp info.

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_trace.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 8b03bfb..b6fd147 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -239,7 +239,7 @@ static const struct file_operations rcu_node_boost_fops = {
 	.owner = THIS_MODULE,
 	.open = rcu_node_boost_open,
 	.read = seq_read,
-	.llseek = seq_lseek,
+	.llseek = no_llseek,
 	.release = single_release,
 };
 
@@ -456,6 +456,15 @@ static int __init rcutree_trace_init(void)
 					rspdir, rsp, &new_rcubarrier_fops);
 			if (!retval)
 				goto free_out;
+
+#ifdef CONFIG_RCU_BOOST
+			if (rsp == &rcu_preempt_state) {
+				retval = debugfs_create_file("rcuboost", 0444,
+					rspdir, NULL, &rcu_node_boost_fops);
+				if (!retval)
+					goto free_out;
+			}
+#endif
 	}
 
 	retval = debugfs_create_file("rcubarrier", 0444, rcudir,
-- 
1.7.8

