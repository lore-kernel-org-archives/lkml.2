Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512Ab1AQCwS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 21:52:18 -0500
Received: from mga01.intel.com ([192.55.52.88]:15177 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383Ab1AQCwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 21:52:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,332,1291622400"; 
   d="scan'208";a="878002645"
Subject: [PATCH 4/4]x86: avoid tlbstate lock if no enough cpus
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Jan 2011 10:52:10 +0800
Message-ID: <1295232730.1949.710.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This one isn't related to previous patch. If online cpus are below
NUM_INVALIDATE_TLB_VECTORS, we don't need the lock. The comments
in the code declares we don't need the check, but a hot lock still
needs an atomic operation and expensive, so add the check here.

Uses nr_cpu_ids here as suggested by Eric Dumazet.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 arch/x86/mm/tlb.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

Index: linux/arch/x86/mm/tlb.c
===================================================================
--- linux.orig/arch/x86/mm/tlb.c	2010-11-04 10:59:09.000000000 +0800
+++ linux/arch/x86/mm/tlb.c	2010-11-04 13:17:51.000000000 +0800
@@ -179,12 +179,8 @@ static void flush_tlb_others_ipi(const s
 	sender = this_cpu_read(tlb_vector_offset);
 	f = &flush_state[sender];
 
-	/*
-	 * Could avoid this lock when
-	 * num_online_cpus() <= NUM_INVALIDATE_TLB_VECTORS, but it is
-	 * probably not worth checking this for a cache-hot lock.
-	 */
-	raw_spin_lock(&f->tlbstate_lock);
+	if (nr_cpu_ids > NUM_INVALIDATE_TLB_VECTORS)
+		raw_spin_lock(&f->tlbstate_lock);
 
 	f->flush_mm = mm;
 	f->flush_va = va;
@@ -202,7 +198,8 @@ static void flush_tlb_others_ipi(const s
 
 	f->flush_mm = NULL;
 	f->flush_va = 0;
-	raw_spin_unlock(&f->tlbstate_lock);
+	if (nr_cpu_ids > NUM_INVALIDATE_TLB_VECTORS)
+		raw_spin_unlock(&f->tlbstate_lock);
 }
 
 void native_flush_tlb_others(const struct cpumask *cpumask,


