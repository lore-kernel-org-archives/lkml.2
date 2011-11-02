Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab1KBUbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 16:31:37 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:59104 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988Ab1KBUbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 16:31:32 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 04/28] rcu: Make synchronize_sched_expedited() better at work sharing
Date: Wed,  2 Nov 2011 13:30:25 -0700
Message-Id: <1320265849-5744-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111102203017.GA3830@linux.vnet.ibm.com>
References: <20111102203017.GA3830@linux.vnet.ibm.com>
x-cbid: 11110220-5930-0000-0000-000000D635BE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When synchronize_sched_expedited() takes its second and subsequent
snapshots of sync_sched_expedited_started, it subtracts 1.  This
means that the concurrent caller of synchronize_sched_expedited()
that incremented to that value sees our successful completion, it
will not be able to take advantage of it.  This restriction is
pointless, given that our full expedited grace period would have
happened after the other guy started, and thus should be able to
serve as a proxy for the other guy successfully executing
try_stop_cpus().

This commit therefore removes the subtraction of 1.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_plugin.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 7986053..708dc57 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1910,7 +1910,7 @@ void synchronize_sched_expedited(void)
 		 * grace period works for us.
 		 */
 		get_online_cpus();
-		snap = atomic_read(&sync_sched_expedited_started) - 1;
+		snap = atomic_read(&sync_sched_expedited_started);
 		smp_mb(); /* ensure read is before try_stop_cpus(). */
 	}
 
-- 
1.7.3.2

