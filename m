Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650Ab0KCGoa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 02:44:30 -0400
Received: from mga14.intel.com ([143.182.124.37]:62525 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753520Ab0KCGo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 02:44:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,287,1286175600"; 
   d="scan'208";a="343954174"
Subject: [RFC 3/4]x86: make tlb invalidate vector number configurable
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Nov 2010 14:44:24 +0800
Message-ID: <1288766664.23014.116.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the maxium TLB invalidate vectors depend on NR_CPUS, and the maxium
number is 32.
we currently only have 8 vectors for TLB invalidate. If we have a lot
of CPUs, the CPUs need share the 8 vectors and tlbstate_lock is used
to protect them. flush_tlb_page() is heavily used in page reclaim,
which will cause a lot of lock contention for tlbstate_lock. Andi Kleen
suggests increasing the vectors number to 32, which should be good for
current typical systems to reduce the tlbstate_lock contention.

My test system has 4 sockets and 64G memory, and 64 CPUs. My workload
creates 64 processes. Each process mmap reads a big empty sparse file.
The total size of the files are 2*total_mem, so this will cause a lot
of page reclaim. Below is the result I get from perf:
without the patch:
    24.25%           usemem  [kernel]                                   [k] _raw_spin_lock
                     |
                     --- _raw_spin_lock
                        |
                        |--42.15%-- native_flush_tlb_others
with the patch:
    14.96%           usemem  [kernel]                                   [k] _raw_spin_lock
                     |
                     --- _raw_spin_lock
                        |--13.89%-- native_flush_tlb_others
So this heavily reduces the tlbstate_lock contention.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 arch/x86/include/asm/irq_vectors.h |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

Index: linux/arch/x86/include/asm/irq_vectors.h
===================================================================
--- linux.orig/arch/x86/include/asm/irq_vectors.h	2010-11-02 14:41:01.000000000 +0800
+++ linux/arch/x86/include/asm/irq_vectors.h	2010-11-02 14:52:10.000000000 +0800
@@ -17,8 +17,8 @@
  *  Vectors   0 ...  31 : system traps and exceptions - hardcoded events
  *  Vectors  32 ... 127 : device interrupts
  *  Vector  128         : legacy int80 syscall interface
- *  Vectors 129 ... 229 : device interrupts
- *  Vectors 230 ... 255 : special interrupts
+ *  Vectors 129 ... INVALIDATE_TLB_VECTOR_START-1 : device interrupts
+ *  Vectors INVALIDATE_TLB_VECTOR_START ... 255 : special interrupts
  *
  * 64-bit x86 has per CPU IDT tables, 32-bit has one shared IDT table.
  *
@@ -124,8 +124,13 @@
  */
 #define LOCAL_TIMER_VECTOR		0xef
 
-/* f0-f7 used for spreading out TLB flushes: */
-#define NUM_INVALIDATE_TLB_VECTORS	   8
+/* up to 32 vectors used for spreading out TLB flushes: */
+#if NR_CPUS > 32
+#define NUM_INVALIDATE_TLB_VECTORS 32
+#else
+#define NUM_INVALIDATE_TLB_VECTORS NR_CPUS
+#endif
+
 #define INVALIDATE_TLB_VECTOR_END	0xee
 #define INVALIDATE_TLB_VECTOR_START	\
 	(INVALIDATE_TLB_VECTOR_END - NUM_INVALIDATE_TLB_VECTORS + 1)


