Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203Ab1CXRtD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 13:49:03 -0400
Received: from flusers.ccur.com ([173.221.59.2]:45835 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756422Ab1CXRs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 13:48:57 -0400
Date: Thu, 24 Mar 2011 13:48:03 -0400
From: Joe Korty <joe.korty@ccur.com>
To: paulmck@linux.vnet.ibm.com
Cc: fweisbec@gmail.com, peterz@infradead.org, laijs@cn.fujitsu.com,
        mathieu.desnoyers@efficios.com, dhowells@redhat.com,
        loic.minier@linaro.org, dhaval.giani@gmail.com, tglx@linutronix.de,
        josh@joshtriplett.org, houston.jim@comcast.net, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 16/24] jrcu: separate barrier and sync stats
Message-ID: <20110324174803.GA18914@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jrcu: seperate barrier/sync stats.

Now that barriers are distinct from syncs, give
each their own stats.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: b/kernel/jrcu.c
===================================================================
--- a/kernel/jrcu.c
+++ b/kernel/jrcu.c
@@ -122,6 +122,7 @@ static struct rcu_stats {
 	unsigned npasses;	/* #passes made */
 	unsigned nbatches;	/* #end-of-batches (eobs) seen */
 	atomic_t nbarriers;	/* #rcu barriers processed */
+	atomic_t nsyncs;	/* #rcu syncs processed */
 	u64 ninvoked;		/* #invoked (ie, finished) callbacks */
 	atomic_t nleft;		/* #callbacks left (ie, not yet invoked) */
 	unsigned nforced;	/* #forced eobs (should be zero) */
@@ -215,7 +216,7 @@ void synchronize_sched(void)
 	init_completion(&rcu.completion);
 	call_rcu(&rcu.head, wakeme_after_rcu);
 	wait_for_completion(&rcu.completion);
-	atomic_inc(&rcu_stats.nbarriers);
+	atomic_inc(&rcu_stats.nsyncs);
 
 }
 EXPORT_SYMBOL_GPL(synchronize_sched);
@@ -224,6 +225,7 @@ void rcu_barrier(void)
 {
 	synchronize_sched();
 	synchronize_sched();
+	atomic_inc(&rcu_stats.nbarriers);
 }
 EXPORT_SYMBOL_GPL(rcu_barrier);
 
@@ -604,6 +606,8 @@ static int rcu_debugfs_show(struct seq_f
 	seq_printf(m, "\n");
 	seq_printf(m, "%14u: #barriers\n",
 		atomic_read(&rcu_stats.nbarriers));
+	seq_printf(m, "%14u: #syncs\n",
+		atomic_read(&rcu_stats.nsyncs));
 	seq_printf(m, "%14llu: #callbacks invoked\n",
 		rcu_stats.ninvoked);
 	seq_printf(m, "%14u: #callbacks left to invoke\n",
