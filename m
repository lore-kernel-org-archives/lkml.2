Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691Ab1BBAov (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:44:51 -0500
Received: from mga02.intel.com ([134.134.136.20]:54182 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753646Ab1BBAos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="703028522"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: andreas.herrmann3@amd.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [85/139] x86, amd: Fix panic on AMD CPU family 0x15
Message-Id: <20110202004442.B7D823E09C6@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Andreas Herrmann <andreas.herrmann3@amd.com>

[The mainline kernel doesn't have this problem. Commit "(23588c3) x86,
amd: Add support for CPUID topology extension of AMD CPUs" removed the
family check. But 2.6.32.y needs to be fixed.]

This CPU family check is not required -- existence of the NodeId MSR
is indicated by a CPUID feature flag which is already checked in
amd_fixup_dcm() -- and it needlessly prevents amd_fixup_dcm() to be
called for newer AMD CPUs.

In worst case this can lead to a panic in the scheduler code for AMD
family 0x15 multi-node AMD CPUs. I just have a picture of VGA console
output so I can't copy-and-paste it herein, but the call stack of such
a panic looked like:

  do_divide_error
  ...
  find_busiest_group
  run_rebalance_domains
  ...
  apic_timer_interrupt
  ...
  cpu_idle

The mainline kernel doesn't have this problem. Commit "(23588c3) x86,
amd: Add support for CPUID topology extension of AMD CPUs" removed the
family check. But 2.6.32.y needs to be fixed.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/amd.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6.35.y/arch/x86/kernel/cpu/amd.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/kernel/cpu/amd.c
+++ linux-2.6.35.y/arch/x86/kernel/cpu/amd.c
@@ -305,8 +305,7 @@ static void __cpuinit amd_detect_cmp(str
 	/* use socket ID also for last level cache */
 	per_cpu(cpu_llc_id, cpu) = c->phys_proc_id;
 	/* fixup topology information on multi-node processors */
-	if ((c->x86 == 0x10) && (c->x86_model == 9))
-		amd_fixup_dcm(c);
+	amd_fixup_dcm(c);
 #endif
 }
 
