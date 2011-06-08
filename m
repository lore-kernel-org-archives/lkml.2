Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab1FHNVC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 09:21:02 -0400
Received: from protonic.xs4all.nl ([213.84.116.84]:22132 "EHLO
	protonic.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987Ab1FHNVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 09:21:00 -0400
From: David Jander <david@protonic.nl>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        David Jander <david@protonic.nl>
Subject: [PATCH v4 5/6] GPIO: pca953x.c: Fix warning of enabled interrupts in handler
Date: Wed,  8 Jun 2011 14:48:33 +0200
Message-Id: <1307537314-4345-6-git-send-email-david@protonic.nl>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307537314-4345-1-git-send-email-david@protonic.nl>
References: <1307537314-4345-1-git-send-email-david@protonic.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using nested threaded irqs, use handle_nested_irq(). This function
does not call the chip handler, so no handler is set.

Signed-off-by: David Jander <david@protonic.nl>
---
 drivers/gpio/pca953x.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
index 97e0d32..dfed81f 100644
--- a/drivers/gpio/pca953x.c
+++ b/drivers/gpio/pca953x.c
@@ -436,7 +436,7 @@ static irqreturn_t pca953x_irq_handler(int irq, void *devid)
 
 	do {
 		level = __ffs(pending);
-		generic_handle_irq(level + chip->irq_base);
+		handle_nested_irq(level + chip->irq_base);
 
 		pending &= ~(1 << level);
 	} while (pending);
@@ -484,8 +484,8 @@ static int pca953x_irq_setup(struct pca953x_chip *chip,
 
 			irq_clear_status_flags(irq, IRQ_NOREQUEST);
 			irq_set_chip_data(irq, chip);
-			irq_set_chip_and_handler(irq, &pca953x_irq_chip,
-						 handle_simple_irq);
+			irq_set_chip(irq, &pca953x_irq_chip);
+			irq_set_nested_thread(irq, true);
 #ifdef CONFIG_ARM
 			set_irq_flags(irq, IRQF_VALID);
 #else
-- 
1.7.4.1

