Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161987Ab2CPXKK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:10:10 -0400
Received: from mail-vx0-f202.google.com ([209.85.220.202]:45998 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161898Ab2CPXKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:10:07 -0400
From: Colin Cross <ccross@android.com>
To: linux-kernel@vger.kernel.org
Cc: Colin Cross <ccross@android.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] irq: generic-chip: pass an irq in chip to suspend/resume
Date: Fri, 16 Mar 2012 16:10:02 -0700
Message-Id: <1331939402-12110-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_gc_suspend and irq_gc_resume pass the irq_data of irq_base
to the ops, but if irq_mask bit 0 is not set, that irq_data is
not part of the generic chip, and there is no way to get to the
generic chip data from there.  Instead, pass the irq_data of
gc->irq_base + gc->irq_cnt - 1, which is guaranteed to be part
of this generic chip.

Change-Id: Idec42ea5714aae8dad16f9994a9f96ba9b61bfb6
Signed-off-by: Colin Cross <ccross@android.com>
---
 kernel/irq/generic-chip.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
index c89295a..40b952f 100644
--- a/kernel/irq/generic-chip.c
+++ b/kernel/irq/generic-chip.c
@@ -324,9 +324,10 @@ static int irq_gc_suspend(void)
 
 	list_for_each_entry(gc, &gc_list, list) {
 		struct irq_chip_type *ct = gc->chip_types;
+		int irq = gc->irq_base + gc->irq_cnt - 1;
 
 		if (ct->chip.irq_suspend)
-			ct->chip.irq_suspend(irq_get_irq_data(gc->irq_base));
+			ct->chip.irq_suspend(irq_get_irq_data(irq));
 	}
 	return 0;
 }
@@ -337,9 +338,10 @@ static void irq_gc_resume(void)
 
 	list_for_each_entry(gc, &gc_list, list) {
 		struct irq_chip_type *ct = gc->chip_types;
+		int irq = gc->irq_base + gc->irq_cnt - 1;
 
 		if (ct->chip.irq_resume)
-			ct->chip.irq_resume(irq_get_irq_data(gc->irq_base));
+			ct->chip.irq_resume(irq_get_irq_data(irq));
 	}
 }
 #else
-- 
1.7.7.3

