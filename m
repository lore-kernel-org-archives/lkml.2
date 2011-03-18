Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab1CRINN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 04:13:13 -0400
Received: from [77.233.226.4] ([77.233.226.4]:57510 "EHLO
	public.doredevelopment.dk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750996Ab1CRINJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 04:13:09 -0400
X-Greylist: delayed 598 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Mar 2011 04:13:09 EDT
From: eha@doredevelopment.dk
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, grant.likely@secretlab.ca,
        Esben Haabendal <eha@doredevelopment.dk>
Subject: [PATCH] Support IRQ_NOAUTOEN flag in set_irq_chained_handler()
Date: Fri, 18 Mar 2011 09:03:09 +0100
Message-Id: <1300435389-11048-1-git-send-email-eha@doredevelopment.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Esben Haabendal <eha@doredevelopment.dk>

Handle IRQ_NOAUTOEN in __set_irq_handler() (ie. for
set_irq_chained_handler()) instead of just silently ignoring it, and in
the same way as is done in __setup_irq() (ie. request_irq()).

This give a more consistent interface, and also adheres better to
the rule of least surprise.

Signed-off-by: Esben Haabendal <eha@doredevelopment.dk>
---
 kernel/irq/chip.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index baa5c4a..5594b17 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -731,10 +731,13 @@ __set_irq_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 	desc->name = name;
 
 	if (handle != handle_bad_irq && is_chained) {
-		desc->status &= ~IRQ_DISABLED;
 		desc->status |= IRQ_NOREQUEST | IRQ_NOPROBE;
-		desc->depth = 0;
-		desc->irq_data.chip->irq_startup(&desc->irq_data);
+		if (!(desc->status & IRQ_NOAUTOEN)) {
+			desc->depth = 0;
+			desc->status &= ~IRQ_DISABLED;
+			desc->irq_data.chip->irq_startup(&desc->irq_data);
+		} else
+			desc->depth = 1;
 	}
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 	chip_bus_sync_unlock(desc);
-- 
1.7.1

