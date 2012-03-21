Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759535Ab2CUQW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 12:22:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756059Ab2CUQWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 12:22:25 -0400
Date: Wed, 21 Mar 2012 17:22:13 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [RESEND PATCH 1/3] genirq: Minor readablity improvement in
 irq_wake_thread()
Message-ID: <20120321162212.GO24806@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

exit_irq_thread() clears IRQTF_RUNTHREAD flag and drops the thread's bit in
desc->threads_oneshot then. The bit must not be set again in between and it
does not, since irq_wake_thread() sees PF_EXITING flag first and returns.

Due to above the order or checking PF_EXITING and IRQTF_RUNTHREAD flags in
irq_wake_thread() is important. This fix just makes it more visible in the
source code.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 kernel/irq/handle.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 6ff84e6..bdb1803 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -54,14 +54,18 @@ static void warn_no_thread(unsigned int irq, struct irqaction *action)
 static void irq_wake_thread(struct irq_desc *desc, struct irqaction *action)
 {
 	/*
-	 * Wake up the handler thread for this action. In case the
-	 * thread crashed and was killed we just pretend that we
-	 * handled the interrupt. The hardirq handler has disabled the
-	 * device interrupt, so no irq storm is lurking. If the
+	 * In case the thread crashed and was killed we just pretend that
+	 * we handled the interrupt. The hardirq handler has disabled the
+	 * device interrupt, so no irq storm is lurking.
+	 */
+	if (action->thread->flags & PF_EXITING)
+		return;
+
+	/*
+	 * Wake up the handler thread for this action. If the
 	 * RUNTHREAD bit is already set, nothing to do.
 	 */
-	if ((action->thread->flags & PF_EXITING) ||
-	    test_and_set_bit(IRQTF_RUNTHREAD, &action->thread_flags))
+	if (test_and_set_bit(IRQTF_RUNTHREAD, &action->thread_flags))
 		return;
 
 	/*
-- 
1.7.7.6

