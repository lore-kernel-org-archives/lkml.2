Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071Ab3AJGkN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 01:40:13 -0500
Received: from mga03.intel.com ([143.182.124.21]:44868 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785Ab3AJGkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 01:40:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,442,1355126400"; 
   d="scan'208";a="242154029"
Subject: [PATCH] genirq: Give warning when setup an already-setup
 non-shared irq
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, chuansheng.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Jan 2013 23:55:01 +0800
Message-ID: <1357833301.21958.10.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Meet the case when the request_threaded_irq() with the same irq
is called twice continually, get the below mismatch info:
"IRQ handler type mismatch for IRQ 323"

Here give a right warning that like below:
"Trying to setup already-setup non-shared IRQ 323"

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 kernel/irq/manage.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index e49a288..6802ce1 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -999,6 +999,16 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 	old_ptr = &desc->action;
 	old = *old_ptr;
 	if (old) {
+		/* Give warning when setup an irq which has been setup
+		 * already.
+		 */
+		if (!(old->flags & IRQF_SHARED)) {
+			ret = -EINVAL;
+			WARN(1, "Trying to setup already-setup non-shared IRQ %d\n",
+				irq);
+			goto out_mask;
+		}
+
 		/*
 		 * Can't share interrupts unless both agree to and are
 		 * the same type (level, edge, polarity). So both flag
-- 
1.7.0.4



