Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab1CGLsq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 06:48:46 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:51398 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab1CGLsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 06:48:45 -0500
Date: Mon, 7 Mar 2011 17:18:39 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, anton@samba.org,
        benh@kernel.crashing.org
Subject: [PATCH 3/7] powerpc: Use more accurate limit for first segment
	memory allocations
Message-ID: <20110307114839.GE8194@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    powerpc: Use more accurate limit for first segment memory allocations

    Commit: 095c7965f4dc870ed2b65143b1e2610de653416c upstream

    On large machines we are running out of room below 256MB. In some cases we
    only need to ensure the allocation is in the first segment, which may be
    256MB or 1TB.

    Add slb0_limit and use it to specify the upper limit for the irqstack and
    emergency stacks.

    On a large ppc64 box, this fixes a panic at boot when the crashkernel=
    option is specified (previously we would run out of memory below 256MB).

    Signed-off-by: Milton Miller <miltonm@bga.com>
    Signed-off-by: Anton Blanchard <anton@samba.org>
    Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
    Signed-off-by: Kamalesh babulal <kamalesh@linux.vnet.ibm.com>
---
 arch/powerpc/kernel/setup_64.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

Index: b/arch/powerpc/kernel/setup_64.c
===================================================================
--- a/arch/powerpc/kernel/setup_64.c	2011-03-07 00:31:51.559273335 -0800
+++ b/arch/powerpc/kernel/setup_64.c	2011-03-07 02:12:58.681888270 -0800
@@ -432,9 +432,18 @@
	DBG(" <- setup_system()\n");
 }

+static u64 slb0_limit(void)
+{
+	if (cpu_has_feature(CPU_FTR_1T_SEGMENT))
+		return 1UL << SID_SHIFT_1T;
+
+       return 1UL << SID_SHIFT;
+}
+
 #ifdef CONFIG_IRQSTACKS
 static void __init irqstack_early_init(void)
 {
+	u64 limit = slb0_limit();
	unsigned int i;

	/*
@@ -444,10 +453,10 @@
	for_each_possible_cpu(i) {
		softirq_ctx[i] = (struct thread_info *)
			__va(lmb_alloc_base(THREAD_SIZE,
-					    THREAD_SIZE, 0x10000000));
+					    THREAD_SIZE, limit));
		hardirq_ctx[i] = (struct thread_info *)
			__va(lmb_alloc_base(THREAD_SIZE,
-					    THREAD_SIZE, 0x10000000));
+					    THREAD_SIZE, limit));
	}
 }
 #else
@@ -478,7 +487,7 @@
  */
 static void __init emergency_stack_init(void)
 {
-	unsigned long limit;
+	u64 limit;
	unsigned int i;

	/*
@@ -490,7 +499,7 @@
	 * bringup, we need to get at them in real mode. This means they
	 * must also be within the RMO region.
	 */
-	limit = min(0x10000000ULL, lmb.rmo_size);
+	limit = min(slb0_limit(), lmb.rmo_size);

	for_each_possible_cpu(i) {
		unsigned long sp;
