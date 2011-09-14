Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab1INI6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 04:58:00 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51021 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754904Ab1INI57 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 04:57:59 -0400
thread-index: AcxyvGYcnTzd3On8RYWgTTNPbdDn9w==
Content-Transfer-Encoding: 8BIT
Content-Class: urn:content-classes:message
Importance: normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4657
From: Tero Kristo <t-kristo@ti.com>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH] irq: call also chip->irq_mask from irq_disable
Date: Wed, 14 Sep 2011 11:57:55 +0300
Message-ID: <1315990675-22814-1-git-send-email-t-kristo@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current implementation of the irq_disable only calls chip->irq_disable.
This fails to disable interrupt on some chip implementations, as there
are two alternative chip specific functions for this task,
chip->irq_disable and chip->irq_mask. Added alternative path for
chip->irq_disable also.

Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 kernel/irq/chip.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index d5a3009..15597f1 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -198,10 +198,11 @@ void irq_enable(struct irq_desc *desc)
 void irq_disable(struct irq_desc *desc)
 {
 	irq_state_set_disabled(desc);
-	if (desc->irq_data.chip->irq_disable) {
+	if (desc->irq_data.chip->irq_disable)
 		desc->irq_data.chip->irq_disable(&desc->irq_data);
-		irq_state_set_masked(desc);
-	}
+	else
+		desc->irq_data.chip->irq_mask(&desc->irq_data);
+	irq_state_set_masked(desc);
 }
 
 static inline void mask_ack_irq(struct irq_desc *desc)
-- 
1.7.4.1


Texas Instruments Oy, Tekniikantie 12, 02150 Espoo. Y-tunnus: 0115040-6. Kotipaikka: Helsinki
 

