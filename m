Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275Ab1EBXJi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 19:09:38 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:54332 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221Ab1EBXJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 19:09:28 -0400
X-Greylist: delayed 911 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 May 2011 19:09:25 EDT
Message-Id: <201105022254.p42MsPDQ030353@farm-0023.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 2 May 2011 15:13:13 -0400
Subject: [PATCH] arch/tile: allow nonatomic stores to interoperate with fast atomic syscalls
To: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 02 May 2011 22:54:26.0081 (UTC) FILETIME=[E2CDD910:01CC091B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This semantic was already true for atomic operations within the kernel,
and this change makes it true for the fast atomic syscalls (__NR_cmpxchg
and __NR_atomic_update) as well.  Previously, user-space had to use
the fast atomic syscalls exclusively to update memory, since raw stores
could lose a race with the atomic update code even when the atomic update
hadn't actually modified the value.

With this change, we no longer write back the value to memory if it
hasn't changed.  This allows certain types of idioms in user space to
work as expected, e.g. "atomic exchange" to acquire a spinlock, followed
by a raw store of zero to release the lock.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/intvec_32.S  |   61 +++++++++++++++++-----------------------
 arch/tile/lib/atomic_asm_32.S |    2 +-
 2 files changed, 27 insertions(+), 36 deletions(-)

diff --git a/arch/tile/kernel/intvec_32.S b/arch/tile/kernel/intvec_32.S
index f35c312..72ade79 100644
--- a/arch/tile/kernel/intvec_32.S
+++ b/arch/tile/kernel/intvec_32.S
@@ -1470,7 +1470,10 @@ STD_ENTRY(_sys_clone)
  * We place it in the __HEAD section to ensure it is relatively
  * near to the intvec_SWINT_1 code (reachable by a conditional branch).
  *
- * Must match register usage in do_page_fault().
+ * Our use of ATOMIC_LOCK_REG here must match do_page_fault_ics().
+ *
+ * As we do in lib/atomic_asm_32.S, we bypass a store if the value we
+ * would store is the same as the value we just loaded.
  */
 	__HEAD
 	.align 64
@@ -1531,17 +1534,7 @@ ENTRY(sys_cmpxchg)
 	{
 	 shri	r20, r25, 32 - ATOMIC_HASH_L1_SHIFT
 	 slt_u  r23, r0, r23
-
-	 /*
-	  * Ensure that the TLB is loaded before we take out the lock.
-	  * On TILEPro, this will start fetching the value all the way
-	  * into our L1 as well (and if it gets modified before we
-	  * grab the lock, it will be invalidated from our cache
-	  * before we reload it).  On tile64, we'll start fetching it
-	  * into our L1 if we're the home, and if we're not, we'll
-	  * still at least start fetching it into the home's L2.
-	  */
-	 lw	r26, r0
+	 lw	r26, r0  /* see comment in the "#else" for the "lw r26". */
 	}
 	{
 	 s2a    r21, r20, r21
@@ -1557,18 +1550,9 @@ ENTRY(sys_cmpxchg)
 	 bbs    r23, .Lcmpxchg64
 	 andi   r23, r0, 7       /* Precompute alignment for cmpxchg64. */
 	}
-
 	{
-	 /*
-	  * We very carefully align the code that actually runs with
-	  * the lock held (nine bundles) so that we know it is all in
-	  * the icache when we start.  This instruction (the jump) is
-	  * at the start of the first cache line, address zero mod 64;
-	  * we jump to somewhere in the second cache line to issue the
-	  * tns, then jump back to finish up.
-	  */
 	 s2a	ATOMIC_LOCK_REG_NAME, r25, r21
-	 j      .Lcmpxchg32_tns
+	 j      .Lcmpxchg32_tns   /* see comment in the #else for the jump. */
 	}
 
 #else /* ATOMIC_LOCKS_FOUND_VIA_TABLE() */
@@ -1633,24 +1617,25 @@ ENTRY(sys_cmpxchg)
 	{
 	 /*
 	  * We very carefully align the code that actually runs with
-	  * the lock held (nine bundles) so that we know it is all in
+	  * the lock held (twelve bundles) so that we know it is all in
 	  * the icache when we start.  This instruction (the jump) is
 	  * at the start of the first cache line, address zero mod 64;
-	  * we jump to somewhere in the second cache line to issue the
-	  * tns, then jump back to finish up.
+	  * we jump to the very end of the second cache line to get that
+	  * line loaded in the icache, then fall through to issue the tns
+	  * in the third cache line, at which point it's all cached.
+	  * Note that is for performance, not correctness.
 	  */
 	 j      .Lcmpxchg32_tns
 	}
 
 #endif /* ATOMIC_LOCKS_FOUND_VIA_TABLE() */
 
-	ENTRY(__sys_cmpxchg_grab_lock)
+/* Symbol for do_page_fault_ics() to use to compare against the PC. */
+.global __sys_cmpxchg_grab_lock
+__sys_cmpxchg_grab_lock:
 
 	/*
 	 * Perform the actual cmpxchg or atomic_update.
-	 * Note that the system <arch/atomic.h> header relies on
-	 * atomic_update() to always perform an "mf", so don't make
-	 * it optional or conditional without modifying that code.
 	 */
 .Ldo_cmpxchg32:
 	{
@@ -1668,10 +1653,13 @@ ENTRY(sys_cmpxchg)
 	}
 	{
 	 mvnz	r24, r23, r25    /* Use atomic_update value if appropriate. */
-	 bbns   r22, .Lcmpxchg32_mismatch
+	 bbns   r22, .Lcmpxchg32_nostore
 	}
+	seq     r22, r24, r21    /* Are we storing the value we loaded? */
+	bbs     r22, .Lcmpxchg32_nostore
 	sw      r0, r24
 
+	/* The following instruction is the start of the second cache line. */
 	/* Do slow mtspr here so the following "mf" waits less. */
 	{
 	 move   sp, r27
@@ -1679,7 +1667,6 @@ ENTRY(sys_cmpxchg)
 	}
 	mf
 
-	/* The following instruction is the start of the second cache line. */
 	{
 	 move   r0, r21
 	 sw     ATOMIC_LOCK_REG_NAME, zero
@@ -1687,7 +1674,7 @@ ENTRY(sys_cmpxchg)
 	iret
 
 	/* Duplicated code here in the case where we don't overlap "mf" */
-.Lcmpxchg32_mismatch:
+.Lcmpxchg32_nostore:
 	{
 	 move   r0, r21
 	 sw     ATOMIC_LOCK_REG_NAME, zero
@@ -1703,8 +1690,6 @@ ENTRY(sys_cmpxchg)
 	 * and for 64-bit cmpxchg.  We provide it as a macro and put
 	 * it into both versions.  We can't share the code literally
 	 * since it depends on having the right branch-back address.
-	 * Note that the first few instructions should share the cache
-	 * line with the second half of the actual locked code.
 	 */
 	.macro  cmpxchg_lock, bitwidth
 
@@ -1730,7 +1715,7 @@ ENTRY(sys_cmpxchg)
 	}
 	/*
 	 * The preceding instruction is the last thing that must be
-	 * on the second cache line.
+	 * hot in the icache before we do the "tns" above.
 	 */
 
 #ifdef CONFIG_SMP
@@ -1761,6 +1746,12 @@ ENTRY(sys_cmpxchg)
 	.endm
 
 .Lcmpxchg32_tns:
+	/*
+	 * This is the last instruction on the second cache line.
+	 * The nop here loads the second line, then we fall through
+	 * to the tns to load the third line before we take the lock.
+	 */
+	nop
 	cmpxchg_lock 32
 
 	/*
diff --git a/arch/tile/lib/atomic_asm_32.S b/arch/tile/lib/atomic_asm_32.S
index 82f64cc..2444873 100644
--- a/arch/tile/lib/atomic_asm_32.S
+++ b/arch/tile/lib/atomic_asm_32.S
@@ -59,7 +59,7 @@
  * bad kernel addresses).
  *
  * Note that if the value we would store is the same as what we
- * loaded, we bypass the load.  Other platforms with true atomics can
+ * loaded, we bypass the store.  Other platforms with true atomics can
  * make the guarantee that a non-atomic __clear_bit(), for example,
  * can safely race with an atomic test_and_set_bit(); this example is
  * from bit_spinlock.h in slub_lock() / slub_unlock().  We can't do
-- 
1.6.5.2

