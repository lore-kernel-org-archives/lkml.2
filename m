Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab3ACM27 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 07:28:59 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:45707 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab3ACM24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 07:28:56 -0500
Subject: [PATCH net-next] softirq: reduce latencies
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tom Herbert <therbert@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Jan 2013 04:28:52 -0800
Message-ID: <1357216132.21409.24107.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

In various network workloads, __do_softirq() latencies can be up
to 20 ms if HZ=1000, and 200 ms if HZ=100.

This is because we iterate 10 times in the softirq dispatcher,
and some actions can consume a lot of cycles.

This patch changes the fallback to ksoftirqd condition to :

- A time limit of 2 ms.
- need_resched() being set on current task

When one of this condition is met, we wakeup ksoftirqd for further
softirq processing if we still have pending softirqs.

I ran several benchmarks and got no significant difference in
throughput, but a very significant reduction of maximum latencies.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: David Miller <davem@davemloft.net>
Cc: Tom Herbert <therbert@google.com>
---
 kernel/softirq.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index ed567ba..64d61ea 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -195,21 +195,21 @@ void local_bh_enable_ip(unsigned long ip)
 EXPORT_SYMBOL(local_bh_enable_ip);
 
 /*
- * We restart softirq processing MAX_SOFTIRQ_RESTART times,
- * and we fall back to softirqd after that.
+ * We restart softirq processing for at most 2 ms,
+ * and if need_resched() is not set.
  *
- * This number has been established via experimentation.
+ * These limits have been established via experimentation.
  * The two things to balance is latency against fairness -
  * we want to handle softirqs as soon as possible, but they
  * should not be able to lock up the box.
  */
-#define MAX_SOFTIRQ_RESTART 10
+#define MAX_SOFTIRQ_TIME  min(1, (2*HZ/1000))
 
 asmlinkage void __do_softirq(void)
 {
 	struct softirq_action *h;
 	__u32 pending;
-	int max_restart = MAX_SOFTIRQ_RESTART;
+	unsigned long end = jiffies + MAX_SOFTIRQ_TIME;
 	int cpu;
 	unsigned long old_flags = current->flags;
 
@@ -264,11 +264,12 @@ restart:
 	local_irq_disable();
 
 	pending = local_softirq_pending();
-	if (pending && --max_restart)
-		goto restart;
+	if (pending) {
+		if (time_before(jiffies, end) && !need_resched())
+			goto restart;
 
-	if (pending)
 		wakeup_softirqd();
+	}
 
 	lockdep_softirq_exit();
 


