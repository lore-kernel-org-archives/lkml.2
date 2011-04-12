Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab1DLHkR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 03:40:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:59875 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434Ab1DLHkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 03:40:15 -0400
Date: Tue, 12 Apr 2011 07:40:00 GMT
From: tip-bot for Jacob Pan <jacob.jun.pan@linux.intel.com>
Message-ID: <tip-9d90e49da57fe73a2f35334fdd2fb60dbf3933ed@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, arjan@linux.intel.com, ebiederm@xmission.com,
        tglx@linutronix.de, jacob.jun.pan@linux.intel.com, feng.tang@intel.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, arjan@linux.intel.com,
        ebiederm@xmission.com, tglx@linutronix.de,
        jacob.jun.pan@linux.intel.com, feng.tang@intel.com, mingo@elte.hu
In-Reply-To: <1302286980-21139-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1302286980-21139-1-git-send-email-jacob.jun.pan@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/mrst: Fix boot crash caused by incorrect pin to irq mapping
Git-Commit-ID: 9d90e49da57fe73a2f35334fdd2fb60dbf3933ed
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 12 Apr 2011 07:40:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9d90e49da57fe73a2f35334fdd2fb60dbf3933ed
Gitweb:     http://git.kernel.org/tip/9d90e49da57fe73a2f35334fdd2fb60dbf3933ed
Author:     Jacob Pan <jacob.jun.pan@linux.intel.com>
AuthorDate: Fri, 8 Apr 2011 11:23:00 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 12 Apr 2011 08:38:52 +0200

x86/mrst: Fix boot crash caused by incorrect pin to irq mapping

Moorestown systems crash on boot because the secondary CPU
clockevent (apbt1) will fail to request irq#1, which does not
have ioapic chip in its irq_desc[] entry.

Background:

Moorestown platform does not have ISA bus nor legacy IRQs. It
reuses the range of legacy IRQs for regular device interrupts.
The routing information of early system device IRQs (timers) are
obtained from firmware provided SFI tables. We reuse/fake MP
configuration table to facilitate IRQ setup with IOAPIC.

Maintaining a 1:1 mapping of IOAPIC pin (RTE entry) and IRQ#
makes routing information clean and easy to understand on
Moorestown. Though optional.

This patch allows SFI timer and vRTC IRQ to be treated as ISA
IRQ so that pin2irq mapping will be 1:1.

Also fixed MP table type and use macros to clearly set MP IRQ
entries. As a result, apbt timer and RTC interrupts on
Moorestown are within legacy IRQ range:

 # cat /proc/interrupts
            CPU0       CPU1
   0:      11249          0   IO-APIC-edge      apbt0
   1:          0      12271   IO-APIC-edge      apbt1
   8:        887          0   IO-APIC-fasteoi   dw_spi
  13:          0          0   IO-APIC-fasteoi   INTEL_MID_DMAC2
  14:          0          0   IO-APIC-fasteoi   rtc0

Further discussion of this patch can be found at:

  https://lkml.org/lkml/2010/6/10/70

Suggested-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Link: http://lkml.kernel.org/r/1302286980-21139-1-git-send-email-jacob.jun.pan@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
