Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410Ab1BPBa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:30:59 -0500
Received: from kroah.org ([198.145.64.141]:39336 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757315Ab1BPAVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:21:37 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:37 2011
Message-Id: <20110216001437.531975804@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:13:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [125/272] genirq: Prevent irq storm on migration
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit f1a06390d013244e721372b3f9b66e39b6429c71 upstream.

move_native_irq() masks and unmasks the interrupt line
unconditionally, but the interrupt line might be masked due to a
threaded oneshot handler in progress. Unmasking the line in that case
can lead to interrupt storms. Observed on PREEMPT_RT.

Originally-from: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/irq/migration.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/kernel/irq/migration.c
+++ b/kernel/irq/migration.c
@@ -56,6 +56,7 @@ void move_masked_irq(int irq)
 void move_native_irq(int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
+	bool masked;
 
 	if (likely(!(desc->status & IRQ_MOVE_PENDING)))
 		return;
@@ -63,8 +64,15 @@ void move_native_irq(int irq)
 	if (unlikely(desc->status & IRQ_DISABLED))
 		return;
 
-	desc->irq_data.chip->irq_mask(&desc->irq_data);
+	/*
+	 * Be careful vs. already masked interrupts. If this is a
+	 * threaded interrupt with ONESHOT set, we can end up with an
+	 * interrupt storm.
+	 */
+	masked = desc->status & IRQ_MASKED;
+	if (!masked)
+		desc->irq_data.chip->irq_mask(&desc->irq_data);
 	move_masked_irq(irq);
-	desc->irq_data.chip->irq_unmask(&desc->irq_data);
+	if (!masked)
+		desc->irq_data.chip->irq_unmask(&desc->irq_data);
 }
-


