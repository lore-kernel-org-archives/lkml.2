Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067Ab2BATy7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:54:59 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:44327 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab2BATme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:42:34 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 24/41] rcu: Check for idle-loop entry while in RCU read-side critical section
Date: Wed,  1 Feb 2012 11:41:42 -0800
Message-Id: <1328125319-5205-24-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020119-5518-0000-0000-000001F05D41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

The inner idle loop is an extended quiescent state for all flavors
of RCU, but there have been recent bug involving use of RCU read-side
primitives from within the idle loop.  Therefore, this commit enlists
lockdep-RCU to detect attempts to enter the inner idle loop while in
an RCU read-side critical section, emitting a lockdep-RCU splat if so.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 6168153..e11bee9 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -366,6 +366,20 @@ static void rcu_idle_enter_common(struct rcu_dynticks *rdtp, long long oldval)
 	atomic_inc(&rdtp->dynticks);
 	smp_mb__after_atomic_inc();  /* Force ordering with next sojourn. */
 	WARN_ON_ONCE(atomic_read(&rdtp->dynticks) & 0x1);
+
+	/*
+	 * The idle task is not permitted to enter the idle loop while
+	 * in an RCU read-side critical section.
+	 */
+	rcu_lockdep_assert(!lock_is_held(&rcu_lock_map),
+			   "Illegal idle entry in RCU read-side "
+			   "critical section.");
+	rcu_lockdep_assert(!lock_is_held(&rcu_bh_lock_map),
+			   "Illegal idle entry in RCU-bh read-side "
+			   "critical section.");
+	rcu_lockdep_assert(!lock_is_held(&rcu_sched_lock_map),
+			   "Illegal idle entry in RCU-sched read-side "
+			   "critical section.");
 }
 
 /**
-- 
1.7.8

