Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab2IRFAJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 01:00:09 -0400
Received: from mga14.intel.com ([143.182.124.37]:50538 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753714Ab2IRFAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 01:00:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,441,1344236400"; 
   d="scan'208";a="193936713"
Subject: Re: [PATCH] genirq: Add the IRQS_ONESHOT support for edge interrupt
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, chuansheng.liu@intel.com
In-Reply-To: <1347972841.4312.2.camel@cliu38-desktop-build>
References: <1347972841.4312.2.camel@cliu38-desktop-build>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Sep 2012 21:57:12 +0800
Message-ID: <1347976632.4312.6.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, update the patch.

On Tue, 2012-09-18 at 20:54 +0800, Chuansheng Liu wrote:
> In handle_edge_irq(), currently do not care about the flag IRQS_ONESHOT,
> but there are many edge interrupt handler with irq thread need it indeed,
> so implement here.
> 
> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> ---
>  kernel/irq/chip.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 

In handle_edge_irq(), currently do not care about the flag IRQS_ONESHOT,
but there are many edge interrupt handler with irq thread need it indeed,
so implement here.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 kernel/irq/chip.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)
 mode change 100644 => 100755 kernel/irq/chip.c

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
old mode 100644
new mode 100755
index eebd6d5..04da0d7
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -497,7 +497,13 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 	kstat_incr_irqs_this_cpu(irq, desc);
 
 	/* Start handling the irq */
-	desc->irq_data.chip->irq_ack(&desc->irq_data);
+	if (desc->istate & IRQS_ONESHOT) {
+		mask_ack_irq(desc);
+		handle_irq_event(desc);
+		cond_unmask_irq(desc);
+		goto out_unlock;
+	} else
+		desc->irq_data.chip->irq_ack(&desc->irq_data);
 
 	do {
 		if (unlikely(!desc->action)) {
-- 
1.7.0.4



