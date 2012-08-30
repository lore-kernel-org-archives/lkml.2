Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab2H3VoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 17:44:14 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:54790 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108Ab2H3VoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 17:44:11 -0400
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
Subject: [PATCH tip/core/rcu 11/15] rcu: Avoid spurious RCU CPU stall warnings
Date: Thu, 30 Aug 2012 11:56:24 -0700
Message-Id: <1346352988-32444-11-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120830185607.GA32148@linux.vnet.ibm.com>
 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12083021-9360-0000-0000-00000A06A263
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

If a given CPU avoids the idle loop but also avoids starting a new
RCU grace period for a full minute, RCU can issue spurious RCU CPU
stall warnings.  This commit fixes this issue by adding a check for
ongoing grace period to avoid these spurious stall warnings.

Reported-by: Becky Bruce <bgillbruce@gmail.com>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index fbe43b0..e58097b 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -820,7 +820,8 @@ static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
 	j = ACCESS_ONCE(jiffies);
 	js = ACCESS_ONCE(rsp->jiffies_stall);
 	rnp = rdp->mynode;
-	if ((ACCESS_ONCE(rnp->qsmask) & rdp->grpmask) && ULONG_CMP_GE(j, js)) {
+	if (rcu_gp_in_progress(rsp) &&
+	    (ACCESS_ONCE(rnp->qsmask) & rdp->grpmask) && ULONG_CMP_GE(j, js)) {
 
 		/* We haven't checked in, so go dump stack. */
 		print_cpu_stall(rsp);
-- 
1.7.8

