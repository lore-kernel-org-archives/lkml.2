Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab1DUQ2m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 12:28:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:27394 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754867Ab1DUQ2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 12:28:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,252,1301900400"; 
   d="scan'208";a="423357767"
From: Youquan Song <youquan.song@intel.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
        hpa@zytor.com, hpa@linux.intel.com, suresh.b.siddha@intel.com,
        yong.y.wang@linux.intel.com, joe@perches.com, jbaron@redhat.com,
        trenn@suse.de, kent.liu@intel.com, chaohong.guo@intel.com,
        Youquan Song <youquan.song@linux.intel.com>,
        Youquan Song <youquan.song@intel.com>
Subject: [PATCH v4 1/2] apic: Fix error interrupt report at all APs
Date: Fri, 22 Apr 2011 00:22:43 +0800
Message-Id: <1303402963-17738-1-git-send-email-youquan.song@intel.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a bug reported from customer, who found many unreasonable error
 interrupts reported on all APs during the system boot stage.

According to Chapter 10 of Intel Software Developer Manual Volume 3A, Local APIC
 may signal an illegal vector error when an LVT entry is set as an illegal
vector value (0~15) under FIXED delivery mode (bits 8-11 is 0), regardless of
whether the mask bit is set or an interrupt actually happen. These errors are
seen as error interrupts.

The initial value of thermal LVT entries on all APs always reads 0x10000 because
 APs are woken up by BSP issuing INIT-SIPI-SIPI sequence to them and LVT
registers are reset to 0s except for the mask bits which are set to 1s when APs
receive INIT IPI.  When BIOS take over the thermal throttling interrupt, LVT
thermal deliver mode should be SMI and it is required to restore AP's LVT
thermal monitor register.

This issue happens when BIOS do not take over thermal throttling interrupt,
AP's LVT thermal monitor register will be restored to 0x10000 which means vector
 0 and fixed deliver mode, so all APs will signal illegal vector error
interrupt.  This patch check if interrupt delivery mode is not fixed mode before
 restore AP's LVT thermal monitor register.

Signed-off-by: Youquan Song <youquan.song@intel.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: Yong Wang <yong.y.wang@intel.com>
---
 arch/x86/include/asm/apicdef.h           |    1 +
 arch/x86/kernel/cpu/mcheck/therm_throt.c |   12 +++++++-----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
index d87988b..34595d5 100644
--- a/arch/x86/include/asm/apicdef.h
+++ b/arch/x86/include/asm/apicdef.h
@@ -78,6 +78,7 @@
 #define		APIC_DEST_LOGICAL	0x00800
 #define		APIC_DEST_PHYSICAL	0x00000
 #define		APIC_DM_FIXED		0x00000
+#define		APIC_DM_FIXED_MASK	0x00700
 #define		APIC_DM_LOWEST		0x00100
 #define		APIC_DM_SMI		0x00200
 #define		APIC_DM_REMRD		0x00300
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 6f8c5e9..22c212a 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -446,18 +446,20 @@ void intel_init_thermal(struct cpuinfo_x86 *c)
 	 */
 	rdmsr(MSR_IA32_MISC_ENABLE, l, h);
 
+	h = lvtthmr_init;
 	/*
 	 * The initial value of thermal LVT entries on all APs always reads
 	 * 0x10000 because APs are woken up by BSP issuing INIT-SIPI-SIPI
 	 * sequence to them and LVT registers are reset to 0s except for
 	 * the mask bits which are set to 1s when APs receive INIT IPI.
-	 * Always restore the value that BIOS has programmed on AP based on
-	 * BSP's info we saved since BIOS is always setting the same value
-	 * for all threads/cores
+	 * If BIOS take over the thermal interrupt and set its interrupt
+	 * delivery mode to SMI not fixed, it restore the value that BIOS has
+	 * programmed on AP based on BSP's info we saved since BIOS is always
+	 * setting the same value for all threads/cores.
 	 */
-	apic_write(APIC_LVTTHMR, lvtthmr_init);
+	if ((h & APIC_DM_FIXED_MASK) != APIC_DM_FIXED)
+		apic_write(APIC_LVTTHMR, lvtthmr_init);
 
-	h = lvtthmr_init;
 
 	if ((l & MSR_IA32_MISC_ENABLE_TM1) && (h & APIC_DM_SMI)) {
 		printk(KERN_DEBUG
-- 
1.6.4.2

