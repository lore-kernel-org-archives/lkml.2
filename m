Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab0IHSmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 14:42:50 -0400
Received: from king.tilera.com ([72.1.168.226]:43250 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090Ab0IHSmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 14:42:33 -0400
Message-Id: <201009081842.o88IgWaD028128@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 8 Sep 2010 13:46:44 -0400
Subject: [PATCH] arch/tile: Save and restore extra user state for tilegx
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
X-OriginalArrivalTime: 08 Sep 2010 18:42:32.0259 (UTC) FILETIME=[98C6A130:01CB4F85]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During context switch, save and restore a couple of additional bits of
tilegx user state that can be persistently modified by userspace.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/arch/chip_tile64.h  |    3 +++
 arch/tile/include/arch/chip_tilepro.h |    3 +++
 arch/tile/include/asm/processor.h     |   12 ++++++++++++
 arch/tile/kernel/process.c            |   23 ++++++++++++++++-------
 4 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/arch/tile/include/arch/chip_tile64.h b/arch/tile/include/arch/chip_tile64.h
index 1246573..261aaba 100644
--- a/arch/tile/include/arch/chip_tile64.h
+++ b/arch/tile/include/arch/chip_tile64.h
@@ -150,6 +150,9 @@
 /** Is the PROC_STATUS SPR supported? */
 #define CHIP_HAS_PROC_STATUS_SPR() 0
 
+/** Is the DSTREAM_PF SPR supported? */
+#define CHIP_HAS_DSTREAM_PF() 0
+
 /** Log of the number of mshims we have. */
 #define CHIP_LOG_NUM_MSHIMS() 2
 
diff --git a/arch/tile/include/arch/chip_tilepro.h b/arch/tile/include/arch/chip_tilepro.h
index e864c47..7001769 100644
--- a/arch/tile/include/arch/chip_tilepro.h
+++ b/arch/tile/include/arch/chip_tilepro.h
@@ -150,6 +150,9 @@
 /** Is the PROC_STATUS SPR supported? */
 #define CHIP_HAS_PROC_STATUS_SPR() 1
 
+/** Is the DSTREAM_PF SPR supported? */
+#define CHIP_HAS_DSTREAM_PF() 0
+
 /** Log of the number of mshims we have. */
 #define CHIP_LOG_NUM_MSHIMS() 2
 
diff --git a/arch/tile/include/asm/processor.h b/arch/tile/include/asm/processor.h
index d942d09..ccd5f84 100644
--- a/arch/tile/include/asm/processor.h
+++ b/arch/tile/include/asm/processor.h
@@ -103,6 +103,18 @@ struct thread_struct {
 	/* Any other miscellaneous processor state bits */
 	unsigned long proc_status;
 #endif
+#if !CHIP_HAS_FIXED_INTVEC_BASE()
+	/* Interrupt base for PL0 interrupts */
+	unsigned long interrupt_vector_base;
+#endif
+#if CHIP_HAS_TILE_RTF_HWM()
+	/* Tile cache retry fifo high-water mark */
+	unsigned long tile_rtf_hwm;
+#endif
+#if CHIP_HAS_DSTREAM_PF()
+	/* Data stream prefetch control */
+	unsigned long dstream_pf;
+#endif
 #ifdef CONFIG_HARDWALL
 	/* Is this task tied to an activated hardwall? */
 	struct hardwall_info *hardwall;
diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index 8a099bb..cd0ee34 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -408,6 +408,15 @@ static void save_arch_state(struct thread_struct *t)
 #if CHIP_HAS_PROC_STATUS_SPR()
 	t->proc_status = __insn_mfspr(SPR_PROC_STATUS);
 #endif
+#if !CHIP_HAS_FIXED_INTVEC_BASE()
+	t->interrupt_vector_base = __insn_mfspr(SPR_INTERRUPT_VECTOR_BASE_0);
+#endif
+#if CHIP_HAS_TILE_RTF_HWM()
+	t->tile_rtf_hwm = __insn_mfspr(SPR_TILE_RTF_HWM);
+#endif
+#if CHIP_HAS_DSTREAM_PF()
+	t->dstream_pf = __insn_mfspr(SPR_DSTREAM_PF);
+#endif
 }
 
 static void restore_arch_state(const struct thread_struct *t)
@@ -428,14 +437,14 @@ static void restore_arch_state(const struct thread_struct *t)
 #if CHIP_HAS_PROC_STATUS_SPR()
 	__insn_mtspr(SPR_PROC_STATUS, t->proc_status);
 #endif
+#if !CHIP_HAS_FIXED_INTVEC_BASE()
+	__insn_mtspr(SPR_INTERRUPT_VECTOR_BASE_0, t->interrupt_vector_base);
+#endif
 #if CHIP_HAS_TILE_RTF_HWM()
-	/*
-	 * Clear this whenever we switch back to a process in case
-	 * the previous process was monkeying with it.  Even if enabled
-	 * in CBOX_MSR1 via TILE_RTF_HWM_MIN, it's still just a
-	 * performance hint, so isn't worth a full save/restore.
-	 */
-	__insn_mtspr(SPR_TILE_RTF_HWM, 0);
+	__insn_mtspr(SPR_TILE_RTF_HWM, t->tile_rtf_hwm);
+#endif
+#if CHIP_HAS_DSTREAM_PF()
+	__insn_mtspr(SPR_DSTREAM_PF, t->dstream_pf);
 #endif
 }
 
-- 
1.6.5.2

