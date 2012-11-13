Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab2KMIBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 03:01:34 -0500
Received: from mga11.intel.com ([192.55.52.93]:16643 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753247Ab2KMIBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 03:01:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,764,1344236400"; 
   d="scan'208";a="248249980"
Subject: [PATCH] genirq: Fix the case of irqflag with IRQF_SHARED and
 IRQF_NO_THREAD
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Nov 2012 01:02:55 +0800
Message-ID: <1352826175.15558.1662.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When one shared irq is requested as below:
req1: request_irq(irqnb, cb1, IRQF_SHARED, ...);
then:
req2: request_irq(irqnb, cb2, IRQF_SHARED|IRQF_NO_THREAD, ...);

Both req1 and req2 will be successful.

But if we passed threadirqs in commandline, and executing req1 and req2,
the req2 will fail. The reason is req1 without IRQF_NO_THREAD, then
the IRQF_ONESHOT will be added into flag, while req2 will has no IRQS_ONESHOT
flag, it cause type mismatch case for shared interrupt.

Here add the check of agreeing on NO_THREAD, to make sure the req1/req2
can work well for both scenerio.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 kernel/irq/manage.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 4c69326..dda0f26 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -971,7 +971,8 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 		 */
 		if (!((old->flags & new->flags) & IRQF_SHARED) ||
 		    ((old->flags ^ new->flags) & IRQF_TRIGGER_MASK) ||
-		    ((old->flags ^ new->flags) & IRQF_ONESHOT))
+		    ((old->flags ^ new->flags) & IRQF_ONESHOT) ||
+		    ((old->flags ^ new->flags) & IRQF_NO_THREAD))
 			goto mismatch;
 
 		/* All handlers must agree on per-cpuness */
-- 
1.7.0.4



