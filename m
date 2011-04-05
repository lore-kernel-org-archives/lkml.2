Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751310Ab1DEAKP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 20:10:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:16525 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823Ab1DEAKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 20:10:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,300,1299484800"; 
   d="scan'208";a="675189969"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH] x86/mrst: move sfi timer irqs after gsi_top
Date: Mon,  4 Apr 2011 17:09:35 -0700
Message-Id: <1301962175-4336-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moorestown borrows mp_irqs for its early SFI device IRQs, it used
to be 1:1 mapped between irq # and ioapic pin#. After gsi_top is
introduced, we have to allocate irqs on top of gsi_top since below
that irqs are not set to ioapic chip whereas Moorestown SFI device
irqs are all routed via ioapic chip.

Without this fix, Moorestown fails to boot at secondary clock setup
since it cannot do request_irq on cpu 1 timer which does not have a
valid irq_chip.

Also use correct MP configuration table entry type INTSRC, which is
used for IO interrupt assignment.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/kernel/apb_timer.c   |    2 +-
 arch/x86/platform/mrst/mrst.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index cd1ffed..f9f82cb 100644
--- a/arch/x86/kernel/apb_timer.c
+++ b/arch/x86/kernel/apb_timer.c
@@ -630,7 +630,7 @@ void __init apbt_time_init(void)
 		p_mtmr = sfi_get_mtmr(i);
 		if (p_mtmr) {
 			adev->tick = p_mtmr->freq_hz;
-			adev->irq = p_mtmr->irq;
+			adev->irq = p_mtmr->irq + gsi_top;
 		} else
 			printk(KERN_ERR "Failed to get timer for cpu %d\n", i);
 		adev->count = 0;
diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index 5c0207b..448c20d 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -97,12 +97,12 @@ static int __init sfi_parse_mtmr(struct sfi_table_header *table)
 			pentry->freq_hz, pentry->irq);
 			if (!pentry->irq)
 				continue;
-			mp_irq.type = MP_IOAPIC;
+			mp_irq.type = MP_INTSRC;
 			mp_irq.irqtype = mp_INT;
 /* triggering mode edge bit 2-3, active high polarity bit 0-1 */
 			mp_irq.irqflag = 5;
 			mp_irq.srcbus = 0;
-			mp_irq.srcbusirq = pentry->irq;	/* IRQ */
+			mp_irq.srcbusirq = pentry->irq + gsi_top; /* IRQ */
 			mp_irq.dstapic = MP_APIC_ALL;
 			mp_irq.dstirq = pentry->irq;
 			mp_save_irq(&mp_irq);
-- 
1.7.1

