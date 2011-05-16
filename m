Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab1EPQt1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 12:49:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:39773 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876Ab1EPQt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 12:49:26 -0400
Date: Mon, 16 May 2011 16:49:13 GMT
From: tip-bot for Youquan Song <youquan.song@intel.com>
Message-ID: <tip-e503f9e4b092e2349a9477a333543de8f3c7f5d9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yong.y.wang@intel.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
        youquan.song@intel.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        suresh.b.siddha@intel.com, yong.y.wang@intel.com, tglx@linutronix.de,
        youquan.song@intel.com, mingo@elte.hu
In-Reply-To: <1303402963-17738-1-git-send-email-youquan.song@intel.com>
References: <1303402963-17738-1-git-send-email-youquan.song@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, apic: Fix spurious error interrupts triggering on all non-boot APs
Git-Commit-ID: e503f9e4b092e2349a9477a333543de8f3c7f5d9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 16 May 2011 16:49:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e503f9e4b092e2349a9477a333543de8f3c7f5d9
Gitweb:     http://git.kernel.org/tip/e503f9e4b092e2349a9477a333543de8f3c7f5d9
Author:     Youquan Song <youquan.song@intel.com>
AuthorDate: Fri, 22 Apr 2011 00:22:43 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 16 May 2011 13:48:25 +0200

x86, apic: Fix spurious error interrupts triggering on all non-boot APs

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
Cc: <stable@kernel.org> # As far back as possible
Link: http://lkml.kernel.org/r/1303402963-17738-1-git-send-email-youquan.song@intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
index 6f8c5e9..0f03446 100644
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
