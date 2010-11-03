Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab0KCGon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 02:44:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:1441 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753624Ab0KCGoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 02:44:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,287,1286175600"; 
   d="scan'208";a="673766292"
Subject: [RFC 4/4]x86: avoid tlbstate lock if no enough cpus
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Nov 2010 14:44:28 +0800
Message-ID: <1288766668.23014.117.camel@sli10-conroe>
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

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 arch/x86/mm/tlb.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

Index: linux/arch/x86/mm/tlb.c
===================================================================
--- linux.orig/arch/x86/mm/tlb.c	2010-11-02 10:31:51.000000000 +0800
+++ linux/arch/x86/mm/tlb.c	2010-11-02 14:53:27.000000000 +0800
@@ -174,17 +174,16 @@ static void flush_tlb_others_ipi(const s
 {
 	unsigned int sender;
 	union smp_flush_state *f;
+	bool do_lock = false;
 
 	/* Caller has disabled preemption */
 	sender = this_cpu_read(tlb_vector_offset);
 	f = &flush_state[sender];
 
-	/*
-	 * Could avoid this lock when
-	 * num_online_cpus() <= NUM_INVALIDATE_TLB_VECTORS, but it is
-	 * probably not worth checking this for a cache-hot lock.
-	 */
-	raw_spin_lock(&f->tlbstate_lock);
+	if (num_online_cpus() > NUM_INVALIDATE_TLB_VECTORS) {
+		do_lock = true;
+		raw_spin_lock(&f->tlbstate_lock);
+	}
 
 	f->flush_mm = mm;
 	f->flush_va = va;
@@ -202,7 +201,8 @@ static void flush_tlb_others_ipi(const s
 
 	f->flush_mm = NULL;
 	f->flush_va = 0;
-	raw_spin_unlock(&f->tlbstate_lock);
+	if (do_lock)
+		raw_spin_unlock(&f->tlbstate_lock);
 }
 
 void native_flush_tlb_others(const struct cpumask *cpumask,


