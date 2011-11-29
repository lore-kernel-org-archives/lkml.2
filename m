Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168Ab1K2IMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 03:12:18 -0500
Received: from mga14.intel.com ([143.182.124.37]:47418 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055Ab1K2IMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 03:12:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,590,1315206000"; 
   d="scan'208";a="42019250"
From: Feng Tang <feng.tang@intel.com>
To: dtor@mail.ru, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        kwlee@mtekvision.com
Cc: joel.clark@intel.com, Feng Tang <feng.tang@intel.com>
Subject: [PATCH 1/2] Input: tsc2007 - Disable irq when the irq thread is handling data
Date: Tue, 29 Nov 2011 16:12:57 +0800
Message-Id: <1322554378-348-1-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TSC2007 data sheet say in some case the HW may fire some false
interrrupt, which I also met during integrating one TSC2007 device.
So add the disable_irq/enable_irq protection around data handling.

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 drivers/input/touchscreen/tsc2007.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/input/touchscreen/tsc2007.c b/drivers/input/touchscreen/tsc2007.c
index 1f674cb..789f216 100644
--- a/drivers/input/touchscreen/tsc2007.c
+++ b/drivers/input/touchscreen/tsc2007.c
@@ -171,6 +171,13 @@ static irqreturn_t tsc2007_soft_irq(int irq, void *handle)
 	struct ts_event tc;
 	u32 rt;
 
+	/*
+	 * Disable the irq, as it may fire several other IRQs during
+	 * this thread is handling data, as suggested by the TSC2007
+	 * datasheet, p19, "Touch Detect" chapter
+	 */
+	disable_irq_nosync(irq);
+
 	while (!ts->stopped && tsc2007_is_pen_down(ts)) {
 
 		/* pen is down, continue with the measurement */
@@ -221,6 +228,7 @@ static irqreturn_t tsc2007_soft_irq(int irq, void *handle)
 	if (ts->clear_penirq)
 		ts->clear_penirq();
 
+	enable_irq(irq);
 	return IRQ_HANDLED;
 }
 
-- 
1.7.1

