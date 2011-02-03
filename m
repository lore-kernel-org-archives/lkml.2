Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab1BCROk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 12:14:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54326 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756128Ab1BCROj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 12:14:39 -0500
Date: Thu, 3 Feb 2011 18:14:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] irq fix
Message-ID: <20110203171406.GA14307@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq-fixes-for-linus

 Thanks,

	Ingo

------------------>
Thomas Gleixner (1):
      genirq: Prevent irq storm on migration


 kernel/irq/migration.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/kernel/irq/migration.c b/kernel/irq/migration.c
index 1d25419..441fd62 100644
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
