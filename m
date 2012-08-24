Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757679Ab2HXI6B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 04:58:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:60699 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757459Ab2HXI5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 04:57:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,302,1344236400"; 
   d="scan'208";a="213359268"
From: Alex Shi <alex.shi@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: cpw@sgi.com, akpm@linux-foundation.org, steiner@sgi.com,
        jeremy.fitzhardinge@citrix.com, alex.shi@intel.com,
        linux-kernel@vger.kernel.org, jbeulich@suse.com
Subject: [PATCH] UV: fix incorrect tlb flush all issue
Date: Fri, 24 Aug 2012 16:57:35 +0800
Message-Id: <1345798655-3669-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The flush tlb optimization code has logical issue on UV platform.
It doesn't flush the full range at all, since it simply
ignores its 'end' parameter (and hence also the "all" indicator)
in uv_flush_tlb_others() function.

This patch fixed this issue, but untested due to hardware leaking.

Reported-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 arch/x86/include/asm/uv/uv_bau.h |    6 ++++--
 arch/x86/platform/uv/tlb_uv.c    |   14 ++++++++------
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv_bau.h b/arch/x86/include/asm/uv/uv_bau.h
index a06983c..ac6f326 100644
--- a/arch/x86/include/asm/uv/uv_bau.h
+++ b/arch/x86/include/asm/uv/uv_bau.h
@@ -225,8 +225,10 @@ struct bau_local_cpumask {
  * The payload is software-defined for INTD transactions
  */
 struct bau_msg_payload {
-	unsigned long	address;		/* signifies a page or all
-						   TLB's of the cpu */
+	unsigned long	start;			/* start address to flush TLB
+						   of the cpu */
+	unsigned long	end;			/* end address to flush TLB
+						   of the cpu */
 	/* 64 bits */
 	unsigned short	sending_cpu;		/* filled in by sender */
 	/* 16 bits */
diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index b8b3a37..c603d15 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -280,12 +280,12 @@ static void bau_process_message(struct msg_desc *mdp, struct bau_control *bcp,
 	/*
 	 * This must be a normal message, or retry of a normal message
 	 */
-	if (msg->address == TLB_FLUSH_ALL) {
+	if (msg->end == 0) {
+		__flush_tlb_one(msg->start);
+		stat->d_onetlb++;
+	} else {
 		local_flush_tlb();
 		stat->d_alltlb++;
-	} else {
-		__flush_tlb_one(msg->address);
-		stat->d_onetlb++;
 	}
 	stat->d_requestee++;
 
@@ -1034,7 +1034,8 @@ static int set_distrib_bits(struct cpumask *flush_mask, struct bau_control *bcp,
  * globally purge translation cache of a virtual address or all TLB's
  * @cpumask: mask of all cpu's in which the address is to be removed
  * @mm: mm_struct containing virtual address range
- * @va: virtual address to be removed (or TLB_FLUSH_ALL for all TLB's on cpu)
+ * @start: start virtual address to be removed from TLB
+ * @end: end virtual address to be remove from TLB
  * @cpu: the current cpu
  *
  * This is the entry point for initiating any UV global TLB shootdown.
@@ -1113,7 +1114,8 @@ const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
 
 	record_send_statistics(stat, locals, hubs, remotes, bau_desc);
 
-	bau_desc->payload.address = start;
+	bau_desc->payload.start = start;
+	bau_desc->payload.end	= end;
 	bau_desc->payload.sending_cpu = cpu;
 	/*
 	 * uv_flush_send_and_wait returns 0 if all cpu's were messaged,
-- 
1.7.5.4

