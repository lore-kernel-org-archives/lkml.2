Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab1CIWRp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 17:17:45 -0500
Received: from flusers.ccur.com ([173.221.59.2]:33745 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754067Ab1CIWRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 17:17:41 -0500
Date: Wed, 9 Mar 2011 17:17:14 -0500
From: Joe Korty <joe.korty@ccur.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "mathieu.desnoyers@efficios.com" <mathieu.desnoyers@efficios.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "loic.minier@linaro.org" <loic.minier@linaro.org>,
        "dhaval.giani@gmail.com" <dhaval.giani@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "houston.jim@comcast.net" <houston.jim@comcast.net>
Subject: [PATCH 4/4] jrcu: add new stat to /sys/kernel/debug/rcu/rcudata
Message-ID: <20110309221714.GD24670@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <4CD912E9.1080907@cn.fujitsu.com>
 <20101110155419.GC5750@nowhere>
 <1289410271.2084.25.camel@laptop>
 <20101111041920.GD3134@linux.vnet.ibm.com>
 <20101113223046.GB5445@nowhere>
 <20101116012846.GV2555@linux.vnet.ibm.com>
 <20101116135230.GA5362@nowhere>
 <20101116155104.GB2497@linux.vnet.ibm.com>
 <20101117005229.GC26243@nowhere>
 <20110307203106.GA23002@tsunami.ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110307203106.GA23002@tsunami.ccur.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jrcu: display #passes in /sys/kernel/debug/rcu/rcudata.

Sometimes, when things are not working right, you cannot
tell if that is because the daemon is not running at all,
or because it is running, but on every pass it decides
to do no work.  With this change those two states can
now be distinguished.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: b/kernel/jrcu.c
===================================================================
--- a/kernel/jrcu.c
+++ b/kernel/jrcu.c
@@ -115,6 +115,7 @@ static struct rcu_data rcu_data[NR_CPUS]
 
 /* debug & statistics stuff */
 static struct rcu_stats {
+	unsigned npasses;	/* #passes made */
 	unsigned nbatches;	/* #end-of-batches (eobs) seen */
 	atomic_t nbarriers;	/* #rcu barriers processed */
 	u64 ninvoked;		/* #invoked (ie, finished) callbacks */
@@ -362,6 +363,7 @@ static void rcu_delimit_batches(void)
 	struct rcu_list pending;
 
 	rcu_list_init(&pending);
+	rcu_stats.npasses++;
 
 	raw_local_irq_save(flags);
 	smp_rmb();
@@ -529,6 +531,8 @@ static int rcu_debugfs_show(struct seq_f
 	msecs = div_s64(sched_clock() - rcu_timestamp, NSEC_PER_MSEC);
 	raw_local_irq_enable();
 
+	seq_printf(m, "%14u: #passes seen\n",
+		rcu_stats.npasses);
 	seq_printf(m, "%14u: #batches seen\n",
 		rcu_stats.nbatches);
 	seq_printf(m, "%14u: #barriers seen\n",
