Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162023Ab2CSQTQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:19:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032030Ab2CSQTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:19:03 -0400
Date: Mon, 19 Mar 2012 17:18:52 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] do_exit(): do not panic if exiting thread is not serving
 an interrupt
Message-ID: <20120319161851.GK2147@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently a crashed and killed forced oneshot threaded handler hits
in_interrupt() check in do_exit() and panics. As result, the code that
cleans up IRQ descriptor never not get called and IRQ line stays masked.

Similarly non-forced oneshot threaded handlers that crashed while holding
bh lock leave a IRQ line masked.

Regular threaded handlers that crashed while holding bh simply panic,
although they could have just terminate loudly.

This fix allows IRQ threaded handlers get killed gracefully instead of
panicking.

Since introduction of SOFTIRQ_DISABLE_OFFSET in 75e1056 we can differ
between bh being serviced and bh being disabled. Use this ability to
avoid unnecessary crashes when a exiting thread explicitly disabled bh
and is not serving any softirq. Still we will get the regular warning
that exiting thread is in atomic context.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 include/linux/hardirq.h |    4 ++++
 kernel/exit.c           |    2 +-
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index bb7f309..93aca12 100644
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
+#define in_serving_interrupt()	(preempt_count() & (HARDIRQ_MASK \
+					 | SOFTIRQ_OFFSET | NMI_MASK))
 
 /*
  * Are we in NMI context?
diff --git a/kernel/exit.c b/kernel/exit.c
index 752d2c0..0c78ae6 100644
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


