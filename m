Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965878Ab2EOC6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:58:42 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53261 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964981Ab2EOCRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:00 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 074/179] xen: Use IRQF_FORCE_RESUME
Date: Mon, 14 May 2012 22:12:50 -0400
Message-ID: <1337048075-6132-75-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 676dc3cf5bc36a9e129a3ad8fe3bd7b2ebf20f5d upstream.

Mark the IRQF_NO_SUSPEND interrupts IRQF_FORCE_RESUME and remove the extra
walk through the interrupt descriptors.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/xen/events.c |   19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 9c66deb..9b471cc 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -537,7 +537,7 @@ int bind_ipi_to_irqhandler(enum ipi_vector ipi,
 	if (irq < 0)
 		return irq;
 
-	irqflags |= IRQF_NO_SUSPEND;
+	irqflags |= IRQF_NO_SUSPEND | IRQF_FORCE_RESUME;
 	retval = request_irq(irq, handler, irqflags, devname, dev_id);
 	if (retval != 0) {
 		unbind_from_irq(irq);
@@ -896,7 +896,6 @@ void xen_poll_irq(int irq)
 void xen_irq_resume(void)
 {
 	unsigned int cpu, irq, evtchn;
-	struct irq_desc *desc;
 
 	init_evtchn_cpu_bindings();
 
@@ -916,22 +915,6 @@ void xen_irq_resume(void)
 		restore_cpu_ipis(cpu);
 	}
 
-	/*
-	 * Unmask any IRQF_NO_SUSPEND IRQs which are enabled. These
-	 * are not handled by the IRQ core.
-	 */
-	for_each_irq_desc(irq, desc) {
-		if (!desc->action || !(desc->action->flags & IRQF_NO_SUSPEND))
-			continue;
-		if (desc->status & IRQ_DISABLED)
-			continue;
-
-		evtchn = evtchn_from_irq(irq);
-		if (evtchn == -1)
-			continue;
-
-		unmask_evtchn(evtchn);
-	}
 }
 
 static struct irq_chip xen_dynamic_chip __read_mostly = {
-- 
1.7.9.6

