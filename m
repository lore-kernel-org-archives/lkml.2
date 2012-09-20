Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab2ITSug (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 14:50:36 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:41327 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152Ab2ITSub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 14:50:31 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 23/23] rcu: Shrink RCU based on number of CPUs
Date: Thu, 20 Sep 2012 11:48:19 -0700
Message-Id: <1348166900-18716-23-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1348166900-18716-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120920184751.GA18657@linux.vnet.ibm.com>
 <1348166900-18716-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092018-4242-0000-0000-000002F75025
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Currently, rcu_init_geometry() only reshapes RCU's combining trees
if the leaf fanout is changed at boot time.  This means that by
default, kernels compiled with (say) NR_CPUS=4096 will keep oversized
data structures, even when running on systems with (say) four CPUs.

This commit therefore checks to see if the maximum number of CPUs on
the actual running system (nr_cpu_ids) differs from NR_CPUS, and if so
reshapes the combining trees accordingly.

Reported-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 5068e51..52b24c0 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -2819,7 +2819,8 @@ static void __init rcu_init_geometry(void)
 	int rcu_capacity[MAX_RCU_LVLS + 1];
 
 	/* If the compile-time values are accurate, just leave. */
-	if (rcu_fanout_leaf == CONFIG_RCU_FANOUT_LEAF)
+	if (rcu_fanout_leaf == CONFIG_RCU_FANOUT_LEAF &&
+	    nr_cpu_ids == NR_CPUS)
 		return;
 
 	/*
-- 
1.7.8

