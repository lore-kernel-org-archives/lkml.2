Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab2H3Vo7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 17:44:59 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:33148 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070Ab2H3Vnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 17:43:47 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 03/15] rcu: Properly initialize ->boost_tasks on CPU offline
Date: Thu, 30 Aug 2012 11:56:16 -0700
Message-Id: <1346352988-32444-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120830185607.GA32148@linux.vnet.ibm.com>
 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12083021-1780-0000-0000-000008E02467
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000293; HX=3.00000196; KW=3.00000007;
 PH=3.00000001; SC=3.00000007; SDB=6.00169896; UDB=6.00038517; UTC=2012-08-30
 21:43:45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

When rcu_preempt_offline_tasks() clears tasks from a leaf rcu_node
structure, it does not NULL out the structure's ->boost_tasks field.
This commit therefore fixes this issue.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_plugin.h |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 7f3244c..b1b4851 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -584,8 +584,11 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
 		raw_spin_unlock(&rnp_root->lock); /* irqs still disabled */
 	}
 
+	rnp->gp_tasks = NULL;
+	rnp->exp_tasks = NULL;
 #ifdef CONFIG_RCU_BOOST
-	/* In case root is being boosted and leaf is not. */
+	rnp->boost_tasks = NULL;
+	/* In case root is being boosted and leaf was not. */
 	raw_spin_lock(&rnp_root->lock); /* irqs already disabled */
 	if (rnp_root->boost_tasks != NULL &&
 	    rnp_root->boost_tasks != rnp_root->gp_tasks)
@@ -593,8 +596,6 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
 	raw_spin_unlock(&rnp_root->lock); /* irqs still disabled */
 #endif /* #ifdef CONFIG_RCU_BOOST */
 
-	rnp->gp_tasks = NULL;
-	rnp->exp_tasks = NULL;
 	return retval;
 }
 
-- 
1.7.8

