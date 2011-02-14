Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab1BNSHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 13:07:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:45626 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670Ab1BNSH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 13:07:28 -0500
Date: Mon, 14 Feb 2011 13:53:29 GMT
From: tip-bot for Shaohua Li <shaohua.li@intel.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, eric.dumazet@gmail.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, shaohua.li@intel.com, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, andi@firstfloor.org,
        eric.dumazet@gmail.com, a.p.zijlstra@chello.nl, shaohua.li@intel.com,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1295232727.1949.709.camel@sli10-conroe>
References: <1295232727.1949.709.camel@sli10-conroe>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86: Scale up the number of TLB invalidate vectors with NR_CPUs, up to 32
Message-ID: <tip-70e4a369733a21e3d16b059a6ccdad22a344bf57@git.kernel.org>
Git-Commit-ID: 70e4a369733a21e3d16b059a6ccdad22a344bf57
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 14 Feb 2011 18:07:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  70e4a369733a21e3d16b059a6ccdad22a344bf57
Gitweb:     http://git.kernel.org/tip/70e4a369733a21e3d16b059a6ccdad22a344bf57
Author:     Shaohua Li <shaohua.li@intel.com>
AuthorDate: Mon, 17 Jan 2011 10:52:07 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 14 Feb 2011 13:03:08 +0100

x86: Scale up the number of TLB invalidate vectors with NR_CPUs, up to 32

Make the maxium TLB invalidate vectors depend on NR_CPUS linearly,
with a maximum of 32 vectors.

We currently only have 8 vectors for TLB invalidation and that is clearly
inadequate. If we have a lot of CPUs, the CPUs need share the 8 vectors and
tlbstate_lock is used to protect them. flush_tlb_page() is
heavily used in page reclaim, which will cause a lot of lock
contention for tlbstate_lock.

Andi Kleen suggested increasing the vectors number to 32, which should be
good for current typical systems to reduce the tlbstate_lock contention.

My test system has 4 sockets and 64G memory, and 64 CPUs. My
workload creates 64 processes. Each process mmap reads a big
empty sparse file. The total size of the files are 2*total_mem,
so this will cause a lot of page reclaim.

Below is the result I get from perf call-graph profiling:

 without the patch:
 ------------------

    24.25%           usemem  [kernel]                                   [k] _raw_spin_lock
                     |
                     --- _raw_spin_lock
                        |
                        |--42.15%-- native_flush_tlb_others

 with the patch:
 ------------------

    14.96%           usemem  [kernel]                                   [k] _raw_spin_lock
                     |
                     --- _raw_spin_lock
                        |--13.89%-- native_flush_tlb_others

So this heavily reduces the tlbstate_lock contention.

Suggested-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1295232727.1949.709.camel@sli10-conroe>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/irq_vectors.h |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 42f0d4a..4980f48 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
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
+#if NR_CPUS <= 32
+# define NUM_INVALIDATE_TLB_VECTORS NR_CPUS
+#else
+# define NUM_INVALIDATE_TLB_VECTORS 32
+#endif
+
 #define INVALIDATE_TLB_VECTOR_END	0xee
 #define INVALIDATE_TLB_VECTOR_START	\
 	(INVALIDATE_TLB_VECTOR_END - NUM_INVALIDATE_TLB_VECTORS + 1)
