Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751Ab2KNHvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:51:20 -0500
Received: from mga14.intel.com ([143.182.124.37]:19689 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756699Ab2KNHvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:51:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,249,1352102400"; 
   d="scan'208";a="168160005"
Subject: [PATCH] x86/irq,io_apic: Fix wrong unmask_ioapic calling when the
 irq is masked
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: mingo@redhat.com, tglx@linutronix.de
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, chuansheng.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Nov 2012 00:52:42 +0800
Message-ID: <1352911962.15558.1676.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There is one typical case will cause this issue, that is:
One io-apic interrupt with ONE_SHOT and threaded, when interrupt is coming:
handle_fasteoi_irq()
--> mask_irq(desc)
    ...
    desc->irq_data.chip->irq_eoi(&desc->irq_data)[ack_apic_level]
    --> ioapic_irqd_mask()
        ...
        ioapic_irqd_unmask()

After that, the irq will be in unmasked state.

It will break the ONE_SHOT and threaded irq, and brings some unwanted issues.
Here adding the irqd_irq_masked() condition to know if unmasking action is
needed.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 arch/x86/kernel/apic/io_apic.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 1817fa9..d963e76 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2479,7 +2479,8 @@ static inline void ioapic_irqd_unmask(struct irq_data *data,
 		 */
 		if (!io_apic_level_ack_pending(cfg))
 			irq_move_masked_irq(data);
-		unmask_ioapic(cfg);
+		if (!irqd_irq_masked(data))
+			unmask_ioapic(cfg);
 	}
 }
 #else
-- 
1.7.0.4



