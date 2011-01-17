Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab1AQOdr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 09:33:47 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62434 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab1AQOdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 09:33:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=RMcfkBbAFwhE1mv9mu2iDqtaLtCqlPN7yJ1Fq96RBf7eNM/Rs4L5NuF+3qwqZ0KCBh
         NaeLH4oVQoz1XLGzstPjakbtqcuPuzumi7ms5cU3IrZ1MsR3/YTA65FLsCEaOon4rX2E
         2aEVmZLRwQGG//UB90pRrGO1iZymYhWOZ2JNM=
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH -rt] genirq: IRQF_NODELAY must be consistent between shared irqs
Date: Mon, 17 Jan 2011 22:33:31 +0800
Message-Id: <1295274811-3504-1-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IRQF_NODELAY can not be messed up for shared irqs, because if
one of the regestered irq can be threaded, irq_desc->status will
set with IRQ_ONESHOT. Thus when irq is triggered, the
none-threaded one will warn with warn_no_thread().

So let __setup_irq fail if IRQF_NODELAY is not consistent between
them.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/manage.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index cda70cb..7ce9050 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -797,10 +797,11 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 		 * Can't share interrupts unless both agree to and are
 		 * the same type (level, edge, polarity). So both flag
 		 * fields must have IRQF_SHARED set and the bits which
-		 * set the trigger type must match.
+		 * set the trigger type and IRQF_NODELAY must match.
 		 */
 		if (!((old->flags & new->flags) & IRQF_SHARED) ||
-		    ((old->flags ^ new->flags) & IRQF_TRIGGER_MASK)) {
+		    ((old->flags ^ new->flags) & (IRQF_TRIGGER_MASK |
+						  IRQF_NODELAY))) {
 			old_name = old->name;
 			goto mismatch;
 		}
-- 
1.7.1

