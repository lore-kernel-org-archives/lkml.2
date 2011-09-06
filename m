Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571Ab1IGGUk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 02:20:40 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:49924 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754318Ab1IGGUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 02:20:35 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 31/55] rcu: Make rcu_implicit_dynticks_qs() locals be correct size
Date: Tue,  6 Sep 2011 11:00:25 -0700
Message-Id: <1315332049-2604-31-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110906180015.GA2560@linux.vnet.ibm.com>
References: <20110906180015.GA2560@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the ->dynticks field in the rcu_dynticks structure changed to an
atomic_t, its size on 64-bit systems changed from 64 bits to 32 bits.
The local variables in rcu_implicit_dynticks_qs() need to change as
well, hence this commit.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 0c6c30d..ebd18e5 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -488,11 +488,11 @@ static int dyntick_save_progress_counter(struct rcu_data *rdp)
  */
 static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
 {
-	unsigned long curr;
-	unsigned long snap;
+	unsigned int curr;
+	unsigned int snap;
 
-	curr = (unsigned long)atomic_add_return(0, &rdp->dynticks->dynticks);
-	snap = (unsigned long)rdp->dynticks_snap;
+	curr = (unsigned int)atomic_add_return(0, &rdp->dynticks->dynticks);
+	snap = (unsigned int)rdp->dynticks_snap;
 
 	/*
 	 * If the CPU passed through or entered a dynticks idle phase with
@@ -502,7 +502,7 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
 	 * read-side critical section that started before the beginning
 	 * of the current RCU grace period.
 	 */
-	if ((curr & 0x1) == 0 || ULONG_CMP_GE(curr, snap + 2)) {
+	if ((curr & 0x1) == 0 || UINT_CMP_GE(curr, snap + 2)) {
 		trace_rcu_fqs(rdp->rsp->name, rdp->gpnum, rdp->cpu, "dti");
 		rdp->dynticks_fqs++;
 		return 1;
-- 
1.7.3.2

