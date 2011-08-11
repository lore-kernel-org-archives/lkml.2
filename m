Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988Ab1HKHVM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 03:21:12 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47953 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab1HKHVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 03:21:09 -0400
Subject: [PATCH] mfd: twl6030-irq: Make sure to call request_irq before
 using the irq_num
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Rajendra Nayak <rnayak@ti.com>, Balaji T K <balajitk@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Aug 2011 15:21:00 +0800
Message-ID: <1313047260.27089.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was trying to fix the error handling part because in the case of
request_irq failure, it should call kthread_stop instead of free_irq.
But it seems more reasonable to do request_irq before calling kthread_run.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/twl6030-irq.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/mfd/twl6030-irq.c b/drivers/mfd/twl6030-irq.c
index b57383b..e0baff8 100644
--- a/drivers/mfd/twl6030-irq.c
+++ b/drivers/mfd/twl6030-irq.c
@@ -332,12 +332,6 @@ int twl6030_init_irq(int irq_num, unsigned irq_base, unsigned irq_end)
 
 	/* install an irq handler to demultiplex the TWL6030 interrupt */
 	init_completion(&irq_event);
-	task = kthread_run(twl6030_irq_thread, (void *)irq_num, "twl6030-irq");
-	if (IS_ERR(task)) {
-		pr_err("twl6030: could not create irq %d thread!\n", irq_num);
-		status = PTR_ERR(task);
-		goto fail_kthread;
-	}
 
 	status = request_irq(irq_num, handle_twl6030_pih, IRQF_DISABLED,
 				"TWL6030-PIH", &irq_event);
@@ -345,11 +339,19 @@ int twl6030_init_irq(int irq_num, unsigned irq_base, unsigned irq_end)
 		pr_err("twl6030: could not claim irq%d: %d\n", irq_num, status);
 		goto fail_irq;
 	}
+
+	task = kthread_run(twl6030_irq_thread, (void *)irq_num, "twl6030-irq");
+	if (IS_ERR(task)) {
+		pr_err("twl6030: could not create irq %d thread!\n", irq_num);
+		status = PTR_ERR(task);
+		goto fail_kthread;
+	}
 	return status;
-fail_irq:
-	free_irq(irq_num, &irq_event);
 
 fail_kthread:
+	free_irq(irq_num, &irq_event);
+
+fail_irq:
 	for (i = irq_base; i < irq_end; i++)
 		irq_set_chip_and_handler(i, NULL, NULL);
 	return status;
-- 
1.7.4.1



