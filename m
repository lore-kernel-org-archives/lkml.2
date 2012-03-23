Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760313Ab2CWAbx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 20:31:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43262 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550Ab2CWAbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 20:31:51 -0400
Date: Thu, 22 Mar 2012 17:31:33 -0700
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-a6fca40f1d7f3e232c9de27c1cebbb9f787fbc4f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de
In-Reply-To: <1332460885.16101.147.camel@sbsiddha-desk.sc.intel.com>
References: <1332460885.16101.147.camel@sbsiddha-desk.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, tlb: Switch cr3 in leave_mm() only when needed
Git-Commit-ID: a6fca40f1d7f3e232c9de27c1cebbb9f787fbc4f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 22 Mar 2012 17:31:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a6fca40f1d7f3e232c9de27c1cebbb9f787fbc4f
Gitweb:     http://git.kernel.org/tip/a6fca40f1d7f3e232c9de27c1cebbb9f787fbc4f
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Thu, 22 Mar 2012 17:01:25 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 22 Mar 2012 17:23:48 -0700

x86, tlb: Switch cr3 in leave_mm() only when needed

Currently leave_mm() unconditionally switches the cr3 to swapper_pg_dir.
But there is no need to change the cr3, if we already left that mm.

intel_idle() for example calls leave_mm() on every deep c-state entry where
the CPU flushes the TLB for us. Similarly flush_tlb_all() was also calling
leave_mm() whenever the TLB is in LAZY state. Both these paths will be
improved with this change.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Link: http://lkml.kernel.org/r/1332460885.16101.147.camel@sbsiddha-desk.sc.intel.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
 
