Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab1DHSXE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 14:23:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:48799 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946Ab1DHSXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 14:23:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,325,1299484800"; 
   d="scan'208";a="625670895"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Feng Tang <feng.tang@intel.com>,
        Alan Cox <alan@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH v2] x86/mrst: correct pin to irq mapping
Date: Fri,  8 Apr 2011 11:23:00 -0700
Message-Id: <1302286980-21139-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moorestown platform does not have ISA bus nor legacy IRQs. It reuses the
range of legacy IRQs for regular device interrupts. The routing information
of early system device IRQs (timers) are obtained from firmware provided SFI
tables. We reuse/fake MP configuration table to facilitate IRQ setup with
IOAPIC.

Maintaining a 1:1 mapping of IOAPIC pin (RTE entry) and IRQ# makes routing
information clean and easy to understand on Moorestown. Though optional.

This patch allows SFI timer and vRTC IRQ to be treated as ISA IRQ so that
pin2irq mapping will be 1:1.

Also fixed MP table type and use macros to clearly set MP IRQ entries.
As a result, apbt timer and RTC interrupts on Moorestown are within legacy
IRQ range.

sh-3.2# cat /proc/interrupts
           CPU0       CPU1
  0:      11249          0   IO-APIC-edge      apbt0
  1:          0      12271   IO-APIC-edge      apbt1
  8:        887          0   IO-APIC-fasteoi   dw_spi
 13:          0          0   IO-APIC-fasteoi   INTEL_MID_DMAC2
 14:          0          0   IO-APIC-fasteoi   rtc0

Refer to discussion in:
https://lkml.org/lkml/2010/6/10/70

Suggested-by: "Eric W. Biederman" <ebiederm@xmission.com>

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/platform/mrst/mrst.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index 5c0207b..275dbc1 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -97,11 +97,11 @@ static int __init sfi_parse_mtmr(struct sfi_table_header *table)
 			pentry->freq_hz, pentry->irq);
 			if (!pentry->irq)
 				continue;
-			mp_irq.type = MP_IOAPIC;
+			mp_irq.type = MP_INTSRC;
 			mp_irq.irqtype = mp_INT;
 /* triggering mode edge bit 2-3, active high polarity bit 0-1 */
 			mp_irq.irqflag = 5;
-			mp_irq.srcbus = 0;
+			mp_irq.srcbus = MP_BUS_ISA;
 			mp_irq.srcbusirq = pentry->irq;	/* IRQ */
 			mp_irq.dstapic = MP_APIC_ALL;
 			mp_irq.dstirq = pentry->irq;
@@ -168,10 +168,10 @@ int __init sfi_parse_mrtc(struct sfi_table_header *table)
 	for (totallen = 0; totallen < sfi_mrtc_num; totallen++, pentry++) {
 		pr_debug("RTC[%d]: paddr = 0x%08x, irq = %d\n",
 			totallen, (u32)pentry->phys_addr, pentry->irq);
-		mp_irq.type = MP_IOAPIC;
+		mp_irq.type = MP_INTSRC;
 		mp_irq.irqtype = mp_INT;
 		mp_irq.irqflag = 0xf;	/* level trigger and active low */
-		mp_irq.srcbus = 0;
+		mp_irq.srcbus = MP_BUS_ISA;
 		mp_irq.srcbusirq = pentry->irq;	/* IRQ */
 		mp_irq.dstapic = MP_APIC_ALL;
 		mp_irq.dstirq = pentry->irq;
@@ -282,7 +282,7 @@ void __init x86_mrst_early_setup(void)
 	/* Avoid searching for BIOS MP tables */
 	x86_init.mpparse.find_smp_config = x86_init_noop;
 	x86_init.mpparse.get_smp_config = x86_init_uint_noop;
-
+	set_bit(MP_BUS_ISA, mp_bus_not_pci);
 }
 
 /*
-- 
1.7.1

