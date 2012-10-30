Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964968Ab2J3QzU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 12:55:20 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:58967 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964944Ab2J3QzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 12:55:14 -0400
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
Subject: [PATCH tip/core/rcu 1/7] rcu: Fix comment about _rcu_barrier()/orphanage exclusion
Date: Tue, 30 Oct 2012 09:54:30 -0700
Message-Id: <1351616076-25617-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <20121030165415.GA25438@linux.vnet.ibm.com>
References: <20121030165415.GA25438@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103016-3534-0000-0000-00000E5E123E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

In the old days, _rcu_barrier() acquired ->onofflock to exclude
rcu_send_cbs_to_orphanage(), which allowed the latter to avoid memory
barriers in callback handling.  However, _rcu_barrier() recently started
doing get_online_cpus() to lock out CPU-hotplug operations entirely, which
means that the comment in rcu_send_cbs_to_orphanage() that talks about
->onofflock is now obsolete.  This commit therefore fixes the comment.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 74df86b..ac8aed8 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1581,8 +1581,8 @@ rcu_send_cbs_to_orphanage(int cpu, struct rcu_state *rsp,
 {
 	/*
 	 * Orphan the callbacks.  First adjust the counts.  This is safe
-	 * because ->onofflock excludes _rcu_barrier()'s adoption of
-	 * the callbacks, thus no memory barrier is required.
+	 * because _rcu_barrier() excludes CPU-hotplug operations, so it
+	 * cannot be running now.  Thus no memory barrier is required.
 	 */
 	if (rdp->nxtlist != NULL) {
 		rsp->qlen_lazy += rdp->qlen_lazy;
-- 
1.7.8

