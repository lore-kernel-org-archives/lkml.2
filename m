Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427Ab1LUOcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 09:32:21 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53311 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab1LUOcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 09:32:20 -0500
From: Michal Simek <monstr@monstr.eu>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Michal Simek <monstr@monstr.eu>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Ryan Mallon <rmallon@gmail.com>
Subject: [PATCH 1/4] block: xsysace: Don't use NO_IRQ
Date: Wed, 21 Dec 2011 15:32:09 +0100
Message-Id: <1324477932-19262-1-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers shouldn't use NO_IRQ. Microblaze and PPC
define NO_IRQ as 0 and this reference will be removed
in near future.

Signed-off-by: Michal Simek <monstr@monstr.eu>
CC: Grant Likely <grant.likely@secretlab.ca>
CC: Rob Herring <rob.herring@calxeda.com>
CC: Ryan Mallon <rmallon@gmail.com>
---
 drivers/block/xsysace.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index fb1975d..1a17e33 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -456,7 +456,7 @@ static inline void ace_fsm_yieldirq(struct ace_device *ace)
 {
 	dev_dbg(ace->dev, "ace_fsm_yieldirq()\n");
 
-	if (ace->irq == NO_IRQ)
+	if (!ace->irq)
 		/* No IRQ assigned, so need to poll */
 		tasklet_schedule(&ace->fsm_tasklet);
 	ace->fsm_continue_flag = 0;
@@ -1034,12 +1034,12 @@ static int __devinit ace_setup(struct ace_device *ace)
 		ACE_CTRL_DATABUFRDYIRQ | ACE_CTRL_ERRORIRQ);
 
 	/* Now we can hook up the irq handler */
-	if (ace->irq != NO_IRQ) {
+	if (ace->irq) {
 		rc = request_irq(ace->irq, ace_interrupt, 0, "systemace", ace);
 		if (rc) {
 			/* Failure - fall back to polled mode */
 			dev_err(ace->dev, "request_irq failed\n");
-			ace->irq = NO_IRQ;
+			ace->irq = 0;
 		}
 	}
 
@@ -1086,7 +1086,7 @@ static void __devexit ace_teardown(struct ace_device *ace)
 
 	tasklet_kill(&ace->fsm_tasklet);
 
-	if (ace->irq != NO_IRQ)
+	if (ace->irq)
 		free_irq(ace->irq, ace);
 
 	iounmap(ace->baseaddr);
@@ -1156,7 +1156,7 @@ static int __devinit ace_probe(struct platform_device *dev)
 	resource_size_t physaddr = 0;
 	int bus_width = ACE_BUS_WIDTH_16; /* FIXME: should not be hard coded */
 	u32 id = dev->id;
-	int irq = NO_IRQ;
+	int irq = 0;
 	int i;
 
 	dev_dbg(&dev->dev, "ace_probe(%p)\n", dev);
-- 
1.7.5.4

