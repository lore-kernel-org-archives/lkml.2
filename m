Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965887Ab2EOC64 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:58:56 -0400
Received: from mail.windriver.com ([147.11.1.11]:49499 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964974Ab2EOCQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:59 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 073/179] genirq: Add IRQF_FORCE_RESUME
Date: Mon, 14 May 2012 22:12:49 -0400
Message-ID: <1337048075-6132-74-git-send-email-paul.gortmaker@windriver.com>
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

commit dc5f219e88294b93009eef946251251ffffb6d60 upstream.

Xen needs to reenable interrupts which are marked IRQF_NO_SUSPEND in the
resume path. Add a flag to force the reenabling in the resume code.

Tested-and-acked-by: Ian Campbell <Ian.Campbell@eu.citrix.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/interrupt.h |    3 ++-
 kernel/irq/manage.c       |   11 ++++++++++-
 kernel/irq/pm.c           |    3 ---
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 01db7a1..953ff1c 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -53,7 +53,7 @@
  *                Used by threaded interrupts which need to keep the
  *                irq line disabled until the threaded handler has been run.
  * IRQF_NO_SUSPEND - Do not disable this IRQ during suspend
- *
+ * IRQF_FORCE_RESUME - Force enable it on resume even if IRQF_NO_SUSPEND is set
  */
 #define IRQF_DISABLED		0x00000020
 #define IRQF_SAMPLE_RANDOM	0x00000040
@@ -65,6 +65,7 @@
 #define IRQF_IRQPOLL		0x00001000
 #define IRQF_ONESHOT		0x00002000
 #define IRQF_NO_SUSPEND		0x00004000
+#define IRQF_FORCE_RESUME	0x00008000
 
 #define IRQF_TIMER		(__IRQF_TIMER | IRQF_NO_SUSPEND)
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 8305828..46f10b1 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -265,8 +265,17 @@ EXPORT_SYMBOL(disable_irq);
 
 void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume)
 {
-	if (resume)
+	if (resume) {
+		if (!(desc->status & IRQ_SUSPENDED)) {
+			if (!desc->action)
+				return;
+			if (!(desc->action->flags & IRQF_FORCE_RESUME))
+				return;
+			/* Pretend that it got disabled ! */
+			desc->depth++;
+		}
 		desc->status &= ~IRQ_SUSPENDED;
+	}
 
 	switch (desc->depth) {
 	case 0:
diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
index 0d4005d8..d6bfb89 100644
--- a/kernel/irq/pm.c
+++ b/kernel/irq/pm.c
@@ -53,9 +53,6 @@ void resume_device_irqs(void)
 	for_each_irq_desc(irq, desc) {
 		unsigned long flags;
 
-		if (!(desc->status & IRQ_SUSPENDED))
-			continue;
-
 		raw_spin_lock_irqsave(&desc->lock, flags);
 		__enable_irq(desc, irq, true);
 		raw_spin_unlock_irqrestore(&desc->lock, flags);
-- 
1.7.9.6

