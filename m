Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965264Ab2CMA2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:28:42 -0400
Received: from mail.windriver.com ([147.11.1.11]:49017 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965273Ab2CMAZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:25:03 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Youquan Song <youquan.song@intel.com>,
        hpa@linux.intel.com, joe@perches.com, jbaron@redhat.com, trenn@suse.de,
        kent.liu@intel.com, chaohong.guo@intel.com,
        Ingo Molnar <mingo@elte.hu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 184/196] x86, apic: Fix spurious error interrupts triggering on all non-boot APs
Date: Mon, 12 Mar 2012 20:21:37 -0400
Message-Id: <1331598109-31424-139-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Youquan Song <youquan.song@intel.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit e503f9e4b092e2349a9477a333543de8f3c7f5d9 upstream.

This patch fixes a bug reported by a customer, who found
that many unreasonable error interrupts reported on all
non-boot CPUs (APs) during the system boot stage.

According to Chapter 10 of Intel Software Developer Manual
Volume 3A, Local APIC may signal an illegal vector error when
an LVT entry is set as an illegal vector value (0~15) under
FIXED delivery mode (bits 8-11 is 0), regardless of whether
the mask bit is set or an interrupt actually happen. These
errors are seen as error interrupts.

The initial value of thermal LVT entries on all APs always reads
0x10000 because APs are woken up by BSP issuing INIT-SIPI-SIPI
sequence to them and LVT registers are reset to 0s except for
the mask bits which are set to 1s when APs receive INIT IPI.

When the BIOS takes over the thermal throttling interrupt,
the LVT thermal deliver mode should be SMI and it is required
from the kernel to keep AP's LVT thermal monitoring register
programmed as such as well.

This issue happens when BIOS does not take over thermal throttling
interrupt, AP's LVT thermal monitor register will be restored to
0x10000 which means vector 0 and fixed deliver mode, so all APs will
signal illegal vector error interrupts.

This patch check if interrupt delivery mode is not fixed mode before
restoring AP's LVT thermal monitor register.

Signed-off-by: Youquan Song <youquan.song@intel.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Acked-by: Yong Wang <yong.y.wang@intel.com>
Cc: hpa@linux.intel.com
Cc: joe@perches.com
Cc: jbaron@redhat.com
Cc: trenn@suse.de
Cc: kent.liu@intel.com
Cc: chaohong.guo@intel.com
Link: http://lkml.kernel.org/r/1303402963-17738-1-git-send-email-youquan.song@intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/include/asm/apicdef.h           |    1 +
 arch/x86/kernel/cpu/mcheck/therm_throt.c |   12 +++++++-----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
index 7fe3b30..49d7c96 100644
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
index 81c499e..493b668 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -293,18 +293,20 @@ void intel_init_thermal(struct cpuinfo_x86 *c)
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
+	 * If BIOS takes over the thermal interrupt and sets its interrupt
+	 * delivery mode to SMI (not fixed), it restores the value that the
+	 * BIOS has programmed on AP based on BSP's info we saved since BIOS
+	 * is always setting the same value for all threads/cores.
 	 */
-	apic_write(APIC_LVTTHMR, lvtthmr_init);
+	if ((h & APIC_DM_FIXED_MASK) != APIC_DM_FIXED)
+		apic_write(APIC_LVTTHMR, lvtthmr_init);
 
-	h = lvtthmr_init;
 
 	if ((l & MSR_IA32_MISC_ENABLE_TM1) && (h & APIC_DM_SMI)) {
 		printk(KERN_DEBUG
-- 
1.7.9.3

