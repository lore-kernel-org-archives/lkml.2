Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933058Ab1CXRtK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 13:49:10 -0400
Received: from flusers.ccur.com ([173.221.59.2]:33544 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756533Ab1CXRs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 13:48:57 -0400
Date: Thu, 24 Mar 2011 13:48:04 -0400
From: Joe Korty <joe.korty@ccur.com>
To: paulmck@linux.vnet.ibm.com
Cc: fweisbec@gmail.com, peterz@infradead.org, laijs@cn.fujitsu.com,
        mathieu.desnoyers@efficios.com, dhowells@redhat.com,
        loic.minier@linaro.org, dhaval.giani@gmail.com, tglx@linutronix.de,
        josh@joshtriplett.org, houston.jim@comcast.net, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 24/24] jrcu: show #passes affected by NMI
Message-ID: <20110324174804.GA18972@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jrcu: show #passes affected by NMIs.

If one has a system that generates lots of NMIs, they
may disturb jrcu significantly.  It is good to see that
happening in the rcudata file stats.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: b/kernel/jrcu.c
===================================================================
--- a/kernel/jrcu.c
+++ b/kernel/jrcu.c
@@ -122,6 +122,7 @@ static struct rcu_stats {
 	unsigned npasses;	/* #passes made */
 	unsigned nlast;		/* #passes since last end-of-batch */
 	unsigned nbatches;	/* #end-of-batches (eobs) seen */
+	unsigned nmis;		/* #passes discarded due to NMI */
 	atomic_t nbarriers;	/* #rcu barriers processed */
 	atomic_t nsyncs;	/* #rcu syncs processed */
 	u64 ninvoked;		/* #invoked (ie, finished) callbacks */
@@ -302,17 +303,20 @@ static void __rcu_delimit_batches(struct
 	struct rcu_list *plist;
 	int cpu, eob, prev;
 
+	if (!rcu_scheduler_active)
+		return;
+
+	rcu_stats.nlast++;
+
 	/* If an NMI occured then the previous batch may not yet be
 	 * quiescent.  Let's wait till it is.
 	 */
 	if (rcu_nmi_seen) {
 		rcu_nmi_seen = 0;
+		rcu_stats.nmis++;
 		return;
 	}
 
-	if (!rcu_scheduler_active)
-		return;
-
 	/*
 	 * Find out if the current batch has ended
 	 * (end-of-batch).
@@ -329,8 +333,6 @@ static void __rcu_delimit_batches(struct
 		}
 	}
 
-	rcu_stats.nlast++;
-
 	/*
 	 * Exit if batch has not ended.  But first, tickle all non-cooperating
 	 * CPUs if enough time has passed.
@@ -345,7 +347,7 @@ static void __rcu_delimit_batches(struct
 			}
 		}
 		rcu_wdog_ctr += rcu_hz_period_us;
-		return eob;
+		return;
 	}
 
 	/*
@@ -603,10 +605,12 @@ static int rcu_debugfs_show(struct seq_f
 	seq_printf(m, "\n");
 	seq_printf(m, "%14u: #passes\n",
 		rcu_stats.npasses);
+	seq_printf(m, "%14u: #passes discarded due to NMI\n",
+		rcu_stats.nmis);
 	seq_printf(m, "%14u: #passes resulting in end-of-batch\n",
 		rcu_stats.nbatches);
 	seq_printf(m, "%14u: #passes not resulting in end-of-batch\n",
-		rcu_stats.npasses - rcu_stats.nbatches);
+		rcu_stats.npasses - rcu_stats.nbatches - rcu_stats.nmis);
 	seq_printf(m, "%14u: #passes since last end-of-batch\n",
 		rcu_stats.nlast);
 	seq_printf(m, "%14u: #passes forced (0 is best)\n",
