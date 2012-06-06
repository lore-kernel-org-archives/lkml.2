Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518Ab2FFRX2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 13:23:28 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:33571 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab2FFRX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 13:23:27 -0400
Message-ID: <201206061723.q56HNQYO016218@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 6 Jun 2012 11:21:44 -0400
Subject: [PATCH] tile: remove cpu_idle_on_new_stack
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This routine isn't used unless CONFIG_HOMECACHE is enabled, which
isn't even available as a public configuration option yet.
Since it no longer links correctly in 3.4, just remove it for now.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/thread_info.h |    5 -----
 arch/tile/kernel/entry.S            |   14 --------------
 2 files changed, 0 insertions(+), 19 deletions(-)

diff --git a/arch/tile/include/asm/thread_info.h b/arch/tile/include/asm/thread_info.h
index 7e1fef3..e9c670d 100644
--- a/arch/tile/include/asm/thread_info.h
+++ b/arch/tile/include/asm/thread_info.h
@@ -91,11 +91,6 @@ extern void smp_nap(void);
 /* Enable interrupts racelessly and nap forever: helper for cpu_idle(). */
 extern void _cpu_idle(void);
 
-/* Switch boot idle thread to a freshly-allocated stack and free old stack. */
-extern void cpu_idle_on_new_stack(struct thread_info *old_ti,
-				  unsigned long new_sp,
-				  unsigned long new_ss10);
-
 #else /* __ASSEMBLY__ */
 
 /*
diff --git a/arch/tile/kernel/entry.S b/arch/tile/kernel/entry.S
index 133c4b5..c31637b 100644
--- a/arch/tile/kernel/entry.S
+++ b/arch/tile/kernel/entry.S
@@ -68,20 +68,6 @@ STD_ENTRY(KBacktraceIterator_init_current)
 	jrp lr   /* keep backtracer happy */
 	STD_ENDPROC(KBacktraceIterator_init_current)
 
-/*
- * Reset our stack to r1/r2 (sp and ksp0+cpu respectively), then
- * free the old stack (passed in r0) and re-invoke cpu_idle().
- * We update sp and ksp0 simultaneously to avoid backtracer warnings.
- */
-STD_ENTRY(cpu_idle_on_new_stack)
-	{
-	 move sp, r1
-	 mtspr SPR_SYSTEM_SAVE_K_0, r2
-	}
-	jal free_thread_info
-	j cpu_idle
-	STD_ENDPROC(cpu_idle_on_new_stack)
-
 /* Loop forever on a nap during SMP boot. */
 STD_ENTRY(smp_nap)
 	nap
-- 
1.6.5.2

