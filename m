Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab2IYMd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 08:33:26 -0400
Received: from relay1.sgi.com ([192.48.179.29]:42656 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754891Ab2IYMdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 08:33:23 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH] UV: fix incorrect tlb flush all issue
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Message-Id: <E1TGULk-000162-7Y@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Tue, 25 Sep 2012 07:34:52 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Wickman <cpw@sgi.com>

(this was sent as an ack on 9/13, but with incorrect title and sign-off)

Ack.
But with the adjustment below.  The 'end' argument was not declared long.

I tested the patch on a UV.
It has the effect of either clearing 1 or all TLBs in a cpu.
I added some debugging to test for the cases when clearing all TLBs is
overkill, and in practice it happens very seldom.

Reported-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Alex Shi <alex.shi@intel.com>
Signed-off-by: Cliff Wickman <cpw@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/include/asm/uv/uv.h  |    2 +-
 arch/x86/platform/uv/tlb_uv.c |   10 +++++++---
 2 files changed, 8 insertions(+), 4 deletions(-)

Index: linux/arch/x86/platform/uv/tlb_uv.c
===================================================================
--- linux.orig/arch/x86/platform/uv/tlb_uv.c
+++ linux/arch/x86/platform/uv/tlb_uv.c
@@ -1034,7 +1034,8 @@ static int set_distrib_bits(struct cpuma
  * globally purge translation cache of a virtual address or all TLB's
  * @cpumask: mask of all cpu's in which the address is to be removed
  * @mm: mm_struct containing virtual address range
- * @va: virtual address to be removed (or TLB_FLUSH_ALL for all TLB's on cpu)
+ * @start: start virtual address to be removed from TLB
+ * @end: end virtual address to be remove from TLB
  * @cpu: the current cpu
  *
  * This is the entry point for initiating any UV global TLB shootdown.
@@ -1056,7 +1057,7 @@ static int set_distrib_bits(struct cpuma
  */
 const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
 				struct mm_struct *mm, unsigned long start,
-				unsigned end, unsigned int cpu)
+				unsigned long end, unsigned int cpu)
 {
 	int locals = 0;
 	int remotes = 0;
@@ -1113,7 +1114,10 @@ const struct cpumask *uv_flush_tlb_other
 
 	record_send_statistics(stat, locals, hubs, remotes, bau_desc);
 
-	bau_desc->payload.address = start;
+	if (!end || (end - start) <= PAGE_SIZE)
+		bau_desc->payload.address = start;
+	else
+		bau_desc->payload.address = TLB_FLUSH_ALL;
 	bau_desc->payload.sending_cpu = cpu;
 	/*
 	 * uv_flush_send_and_wait returns 0 if all cpu's were messaged,
Index: linux/arch/x86/include/asm/uv/uv.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv.h
+++ linux/arch/x86/include/asm/uv/uv.h
@@ -16,7 +16,7 @@ extern void uv_system_init(void);
 extern const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
 						 struct mm_struct *mm,
 						 unsigned long start,
-						 unsigned end,
+						 unsigned long end,
 						 unsigned int cpu);
 
 #else	/* X86_UV */
