Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab2J3B0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 21:26:46 -0400
Received: from mga03.intel.com ([143.182.124.21]:7614 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891Ab2J3B0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 21:26:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,675,1344236400"; 
   d="scan'208";a="162162421"
Subject: [PATCH V2] hrtimer: Printing timer info when hitting BUG_ON()
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: tglx@linutronix.de, mingo@kernel.org, a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org, fei.li@intel.com,
        yanmin_zhang@linux.intel.com, chuansheng.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Oct 2012 18:27:00 +0800
Message-ID: <1351592820.15558.1450.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We encounted one BUG_ON() issue at function __run_hrtimer(),
but the panic info is not enough to find out which hrtimer
users use the hrtimer wrongly.
(in this BUG_ON case, it is callback running at the same time
hrtimer_start() is executed on different context.)

We can print basic timer info before BUG(), it is easy to find
out which hrtimer user has fault, the output info is like below:

<3>[   41.118552] timer info: state/3, func/test_timer_cb
<3>[   41.118618] timer stats: pid/786(sh), site/hrtimer_start
<0>[   41.118670] ------------[ cut here ]------------
<2>[   41.118691] kernel BUG at /root/r4_code/hardware/intel/linux-2.6/kernel/hrtimer.c:1260!
<0>[   41.118715] invalid opcode: 0000 [#1] PREEMPT SMP

The infos of callback/state are very helpful for debugging this BUG_ON().

Signed-off-by: Li Fei <fei.li@intel.com>
Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 kernel/hrtimer.c |   21 ++++++++++++++++++++-
 1 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 6db7a5e..0618eaf 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1204,6 +1204,22 @@ int hrtimer_get_res(const clockid_t which_clock, struct timespec *tp)
 }
 EXPORT_SYMBOL_GPL(hrtimer_get_res);
 
+/*
+ * dump_hrtimer_callinfo - print hrtimer information including:
+ * state, callback function, pid and start_site.
+*/
+static void dump_hrtimer_callinfo(struct hrtimer *timer)
+{
+
+	pr_err("timer info: state/%lx, func/%pf\n",
+		timer->state, timer->function);
+
+#ifdef CONFIG_TIMER_STATS
+	pr_err("timer stats: pid/%d(%s), site/%pf\n",
+		timer->start_pid, timer->start_comm, timer->start_site);
+#endif
+}
+
 static void __run_hrtimer(struct hrtimer *timer, ktime_t *now)
 {
 	struct hrtimer_clock_base *base = timer->base;
@@ -1235,7 +1251,10 @@ static void __run_hrtimer(struct hrtimer *timer, ktime_t *now)
 	 * hrtimer_start_range_ns() or in hrtimer_interrupt()
 	 */
 	if (restart != HRTIMER_NORESTART) {
-		BUG_ON(timer->state != HRTIMER_STATE_CALLBACK);
+		if (timer->state != HRTIMER_STATE_CALLBACK) {
+			dump_hrtimer_callinfo(timer);
+			BUG();
+		}
 		enqueue_hrtimer(timer, base);
 	}
 
-- 
1.7.0.4



