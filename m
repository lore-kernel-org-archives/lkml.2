Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404Ab1DYUi3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:38:29 -0400
Received: from 1wt.eu ([62.212.114.60]:34377 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932244Ab1DYUZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:25:06 -0400
Message-Id: <20110425200236.209472504@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:03:46 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Milton Miller <miltonm@bga.com>, Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 074/173] powerpc: Use more accurate limit for first segment memory allocations
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 095c7965f4dc870ed2b65143b1e2610de653416c upstream.

Author: Milton Miller <miltonm@bga.com>

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
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/kernel/setup_64.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -432,9 +432,18 @@ void __init setup_system(void)
 	DBG(" <- setup_system()\n");
 }
 
+static u64 slb0_limit(void)
+{
+	if (cpu_has_feature(CPU_FTR_1T_SEGMENT)) {
+		return 1UL << SID_SHIFT_1T;
+	}
+	return 1UL << SID_SHIFT;
+}
+
 #ifdef CONFIG_IRQSTACKS
 static void __init irqstack_early_init(void)
 {
+	u64 limit = slb0_limit();
 	unsigned int i;
 
 	/*
@@ -444,10 +453,10 @@ static void __init irqstack_early_init(v
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
@@ -478,7 +487,7 @@ static void __init exc_lvl_early_init(vo
  */
 static void __init emergency_stack_init(void)
 {
-	unsigned long limit;
+	u64 limit;
 	unsigned int i;
 
 	/*
@@ -490,7 +499,7 @@ static void __init emergency_stack_init(
 	 * bringup, we need to get at them in real mode. This means they
 	 * must also be within the RMO region.
 	 */
-	limit = min(0x10000000UL, lmb.rmo_size);
+	limit = min(slb0_limit(), lmb.rmo_size);
 
 	for_each_possible_cpu(i) {
 		unsigned long sp;


