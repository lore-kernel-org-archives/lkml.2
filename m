Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933108Ab1CXRuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 13:50:08 -0400
Received: from flusers.ccur.com ([173.221.59.2]:29443 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756565Ab1CXRs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 13:48:57 -0400
Date: Thu, 24 Mar 2011 13:48:03 -0400
From: Joe Korty <joe.korty@ccur.com>
To: paulmck@linux.vnet.ibm.com
Cc: fweisbec@gmail.com, peterz@infradead.org, laijs@cn.fujitsu.com,
        mathieu.desnoyers@efficios.com, dhowells@redhat.com,
        loic.minier@linaro.org, dhaval.giani@gmail.com, tglx@linutronix.de,
        josh@joshtriplett.org, houston.jim@comcast.net, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 17/24] jrcu: track #passes since last end-of-batch
Message-ID: <20110324174803.GA18922@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jrcu: track how many passes have gone by since last end-of-batch.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: b/kernel/jrcu.c
===================================================================
--- a/kernel/jrcu.c
+++ b/kernel/jrcu.c
@@ -120,6 +120,7 @@ static struct rcu_data rcu_data[NR_CPUS]
 /* debug & statistics stuff */
 static struct rcu_stats {
 	unsigned npasses;	/* #passes made */
+	unsigned nlast;		/* #passes since last end-of-batch */
 	unsigned nbatches;	/* #end-of-batches (eobs) seen */
 	atomic_t nbarriers;	/* #rcu barriers processed */
 	atomic_t nsyncs;	/* #rcu syncs processed */
@@ -329,6 +330,8 @@ static void __rcu_delimit_batches(struct
 	 * gone by.
 	 */
 	rcu_now = sched_clock();
+	rcu_stats.nlast++;
+
 	if (!eob && !rcu_timestamp
 	&& ((rcu_now - rcu_timestamp) > (s64)rcu_wdog * NSEC_PER_SEC)) {
 		rcu_stats.nforced++;
@@ -389,6 +392,7 @@ static void __rcu_delimit_batches(struct
 	 */
 	xchg(&rcu_which, prev); /* only place where rcu_which is written to */
 	rcu_stats.nbatches++;
+	rcu_stats.nlast = 0;
 }
 
 static void rcu_delimit_batches(void)
@@ -598,6 +602,8 @@ static int rcu_debugfs_show(struct seq_f
 		rcu_stats.nbatches);
 	seq_printf(m, "%14u: #passes not resulting in end-of-batch\n",
 		rcu_stats.npasses - rcu_stats.nbatches);
+	seq_printf(m, "%14u: #passes since last end-of-batch\n",
+		rcu_stats.nlast);
 	seq_printf(m, "%14u: #msecs since last end-of-batch\n",
 		msecs);
 	seq_printf(m, "%14u: #passes forced (0 is best)\n",
