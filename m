Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031724Ab2CSO7R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 10:59:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757318Ab2CSO7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 10:59:14 -0400
Date: Mon, 19 Mar 2012 15:59:05 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] genirq: Clean up IRQ threaded handler exit path
Message-ID: <20120319145903.GH2147@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fact that a threaded handler is serving interrupts is encoded in
irq_thread flag explicitly and in the kthread's should_stop flag
implicitly. This fix eliminates the duplicate by checking should_stop
flag only.

This fix also converts irq_thread flag into a new per process flag that
indicates a kernel thread is actually a IRQ thread handler. As an effect
thread handlers become distinguishable. As a result we can have a single
exit path rather than two.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 kernel/irq/manage.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index bf606a5..03a4c28 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -808,11 +808,7 @@ static int irq_thread(void *data)
 	 * cannot touch the oneshot mask at this point anymore as
 	 * __setup_irq() might have given out currents thread_mask
 	 * again.
-	 *
-	 * Clear irq_thread. Otherwise exit_irq_thread() would make
-	 * fuzz about an active irq thread going into nirvana.
 	 */
-	current->irq_thread = 0;
 	return 0;
 }
 
@@ -828,6 +824,16 @@ void exit_irq_thread(void)
 	if (!tsk->irq_thread)
 		return;
 
+	/*
+	 * __free_irq() ensured with synchronize_irq() that the thread
+	 * finished running. So if should_stop flag is set we are guaranteed
+	 * exiting normally. Conversly, if the handler crashed and was killed
+	 * then synchronize_irq() would not have returned and __free_irq()
+	 * would not have called kthread_stop().
+	 */
+	if (kthread_should_stop())
+		return;
+
 	action = kthread_data(tsk);
 
 	printk(KERN_ERR
-- 
1.7.7.6

