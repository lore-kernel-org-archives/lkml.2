Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921Ab1BJATo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 19:19:44 -0500
Received: from smtp2.caviumnetworks.com ([209.113.159.134]:2084 "EHLO
	smtp2.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab1BJATn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 19:19:43 -0500
X-Greylist: delayed 908 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Feb 2011 19:19:43 EST
From: David Daney <ddaney@caviumnetworks.com>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH] genirq: Call chip_bus_lock()/chip_bus_sync_unlock() in setup_irq().
Date: Wed,  9 Feb 2011 16:04:25 -0800
Message-Id: <1297296265-18680-1-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.3
X-OriginalArrivalTime: 10 Feb 2011 00:04:33.0566 (UTC) FILETIME=[18C99BE0:01CBC8B6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irq_chips that supply .irq_bus_lock/.irq_bus_sync_unlock functions,
expect that the other chip methods will be called inside of calls to
the pair.  If this expectation is not met, things tend to not work.

Make setup_irq() call chip_bus_lock()/chip_bus_sync_unlock() too.

For the vast majority of irq_chips, this will be a NOP as most don't
have these bus lock functions.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 kernel/irq/manage.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 0caa59f..a00bf2c 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -871,9 +871,14 @@ out_thread:
  */
 int setup_irq(unsigned int irq, struct irqaction *act)
 {
+	int retval;
 	struct irq_desc *desc = irq_to_desc(irq);
 
-	return __setup_irq(irq, desc, act);
+	chip_bus_lock(desc);
+	retval = __setup_irq(irq, desc, act);
+	chip_bus_sync_unlock(desc);
+
+	return retval;
 }
 EXPORT_SYMBOL_GPL(setup_irq);
 
-- 
1.7.2.3

