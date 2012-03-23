Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760173Ab2CWAAS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 20:00:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:48644 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168Ab2CWAAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 20:00:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="120694062"
Subject: Re: [patch] x86, tlb: switch cr3 in leave_mm() only when needed
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Thu, 22 Mar 2012 17:01:25 -0700
In-Reply-To: <CA+55aFyf9RqAROx7t=CYUSGCDBXvv9z2c+LP1vRJjLU45_pD+Q@mail.gmail.com>
References: <1332459220.16101.144.camel@sbsiddha-desk.sc.intel.com>
	 <CA+55aFyf9RqAROx7t=CYUSGCDBXvv9z2c+LP1vRJjLU45_pD+Q@mail.gmail.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1332460885.16101.147.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-22 at 16:44 -0700, Linus Torvalds wrote:
> Hmm. If this is reasonably common (and intel_idle() certainly is),
> maybe we shouldn't even do the "test_and_clear" RMW cycle.
> 
> We could do it with a read-only bit test (no races I can see - if it's
> clear, it will stay clear), so we could do this with
> 
>     if (cpumask_test_cpu(cpu, mm_cpumask(active_mm))) {
>         cpumask_clear_cpu(cpu,mm_cpumask(active_mm));
>         load_cr3(swapper_pg_dir);
>     }
> 
> instead? And avoid touching that "mm_cpumask" (and the atomic
> serializing instruction) when not necessary?

Agreed. Updated patch appended. Thanks.
---
From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86, tlb: switch cr3 in leave_mm() only when needed

Currently leave_mm() unconditionally switches the cr3 to swapper_pg_dir.
But there is no need to change the cr3, if we already left that mm.

intel_idle() for example calls leave_mm() on every deep c-state entry where
the CPU flushes the TLB for us. Similarly flush_tlb_all() was also calling
leave_mm() whenever the TLB is in LAZY state. Both these paths will be
improved with this change.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/mm/tlb.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index d6c0418..125bcad 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -61,11 +61,13 @@ static DEFINE_PER_CPU_READ_MOSTLY(int, tlb_vector_offset);
  */
 void leave_mm(int cpu)
 {
+	struct mm_struct *active_mm = percpu_read(cpu_tlbstate.active_mm);
 	if (percpu_read(cpu_tlbstate.state) == TLBSTATE_OK)
 		BUG();
-	cpumask_clear_cpu(cpu,
-			  mm_cpumask(percpu_read(cpu_tlbstate.active_mm)));
-	load_cr3(swapper_pg_dir);
+	if (cpumask_test_cpu(cpu, mm_cpumask(active_mm))) {
+		cpumask_clear_cpu(cpu, mm_cpumask(active_mm));
+		load_cr3(swapper_pg_dir);
+	}
 }
 EXPORT_SYMBOL_GPL(leave_mm);
 



