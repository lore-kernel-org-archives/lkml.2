Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965048Ab2J3RcX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 13:32:23 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:59557 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933957Ab2J3RcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
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
Subject: [PATCH tip/core/rcu 01/14] rcu: Create directory for each flavor of rcu
Date: Tue, 30 Oct 2012 10:05:00 -0700
Message-Id: <1351616713-26930-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <20121030170454.GA25712@linux.vnet.ibm.com>
References: <20121030170454.GA25712@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103017-7182-0000-0000-000002FDE52F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Wang <wangyun@linux.vnet.ibm.com>

This patch will create subdirectory according to each flavor of rcu, the new
structure will be:

	/debugfs/rcu/ -> rsp_0
		      -> rsp_1
		      -> ...

So we can go to '/debugfs/rcu/rsp_0' and get the cpu info of rsp_0 there.
The flavors of RCU are currently rcu_bh, rcu_preempt, and rcu_sched.

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_trace.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 693513b..62223a2 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -446,12 +446,20 @@ static struct dentry *rcudir;
 
 static int __init rcutree_trace_init(void)
 {
+	struct rcu_state *rsp;
 	struct dentry *retval;
+	struct dentry *rspdir;
 
 	rcudir = debugfs_create_dir("rcu", NULL);
 	if (!rcudir)
 		goto free_out;
 
+	for_each_rcu_flavor(rsp) {
+		rspdir = debugfs_create_dir(rsp->name, rcudir);
+		if (!rspdir)
+			goto free_out;
+	}
+
 	retval = debugfs_create_file("rcubarrier", 0444, rcudir,
 						NULL, &rcubarrier_fops);
 	if (!retval)
-- 
1.7.8

