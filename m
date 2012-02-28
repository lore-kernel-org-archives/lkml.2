Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab2B1RJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 12:09:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755386Ab2B1RJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 12:09:39 -0500
Date: Tue, 28 Feb 2012 18:09:36 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] do_exit(): do not panic if thread is not serving interrupts
Message-ID: <20120228170931.GG1978@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since introduction of in_serving_softirq() in 75e1056 we can differentiate
between bh being serviced and bh being disabled. This fix avoids crashing
if exiting thread has disabled bh, but not in fact is serving any. Still,
we will get the warning that exiting thread is in atomic context.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 include/linux/hardirq.h |    4 ++++
 kernel/exit.c           |    2 +-
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index bb7f309..ece9fd2 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -82,11 +82,15 @@
  * Are we in a softirq context? Interrupt context?
  * in_softirq - Are we currently processing softirq or have bh disabled?
  * in_serving_softirq - Are we currently processing softirq?
+ * in_serving_interrupt - Are we currently processing softirq, nmi or
+ *                        hardware interrupt?
  */
 #define in_irq()		(hardirq_count())
 #define in_softirq()		(softirq_count())
 #define in_interrupt()		(irq_count())
 #define in_serving_softirq()	(softirq_count() & SOFTIRQ_OFFSET)
+#define in_serving_interrupt()  (preempt_count() & (HARDIRQ_MASK \
+					| SOFTIRQ_OFFSET | NMI_MASK))
 
 /*
  * Are we in NMI context?
diff --git a/kernel/exit.c b/kernel/exit.c
index 4b4042f..4968d77 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -896,7 +896,7 @@ void do_exit(long code)
 
 	WARN_ON(blk_needs_flush_plug(tsk));
 
-	if (unlikely(in_interrupt()))
+	if (unlikely(in_serving_interrupt()))
 		panic("Aiee, killing interrupt handler!");
 	if (unlikely(!tsk->pid))
 		panic("Attempted to kill the idle task!");
-- 
1.7.7.6

