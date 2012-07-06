Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933411Ab2GFWB4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 18:01:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:45267 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932549Ab2GFWBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 18:01:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="162299569"
Message-Id: <6695e005b7368df4307d34276300fe030e83466c.1341611925.git.tony.luck@intel.com>
From: Tony Luck <tony.luck@intel.com>
Date: Fri, 6 Jul 2012 14:33:15 -0700
Subject: [PATCH] x86/mce: Need to let kill_proc() send signal to doomed
 process
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        Chen Gong <gong.chen@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit dad1743e5993f19b3d7e7bd0fb35dc45b5326626
  x86/mce: Only restart instruction after machine check recovery if it is safe
we fixed mce_notify_process() to force a signal to the current process
if it was not restartable (RIPV bit not set in MCG_STATUS). But doing
it here means that the process doesn't get told the virtual address of
the fault via siginfo_t->si_addr. This would prevent application level
recovery from the fault.

Make a new MF_MUST_KILL flag bit for memory_failure() et. al. to use
so that we will provide the right information with the signal.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c | 4 ++--
 include/linux/mm.h               | 1 +
 mm/memory-failure.c              | 8 +++++---
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index da27c5d..43f918d 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1200,8 +1200,8 @@ void mce_notify_process(void)
 	 * doomed. We still need to mark the page as poisoned and alert any
 	 * other users of the page.
 	 */
-	if (memory_failure(pfn, MCE_VECTOR, MF_ACTION_REQUIRED) < 0 ||
-			   mi->restartable == 0) {
+	if (memory_failure(pfn, MCE_VECTOR,
+			   MF_ACTION_REQUIRED|MF_MUST_KILL) < 0) {
 		pr_err("Memory error not recovered");
 		force_sig(SIGBUS, current);
 	}
diff --git a/include/linux/mm.h b/include/linux/mm.h
index b36d08c..f9f279c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1591,6 +1591,7 @@ void vmemmap_populate_print_last(void);
 enum mf_flags {
 	MF_COUNT_INCREASED = 1 << 0,
 	MF_ACTION_REQUIRED = 1 << 1,
+	MF_MUST_KILL = 1 << 2,
 };
 extern int memory_failure(unsigned long pfn, int trapno, int flags);
 extern void memory_failure_queue(unsigned long pfn, int trapno, int flags);
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index ab1e714..e3e0045 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -858,7 +858,7 @@ static int hwpoison_user_mappings(struct page *p, unsigned long pfn,
 	struct address_space *mapping;
 	LIST_HEAD(tokill);
 	int ret;
-	int kill = 1;
+	int kill = 1, doit;
 	struct page *hpage = compound_head(p);
 	struct page *ppage;
 
@@ -965,12 +965,14 @@ static int hwpoison_user_mappings(struct page *p, unsigned long pfn,
 	 * Now that the dirty bit has been propagated to the
 	 * struct page and all unmaps done we can decide if
 	 * killing is needed or not.  Only kill when the page
-	 * was dirty, otherwise the tokill list is merely
+	 * was dirty or the process is not restartable,
+	 * otherwise the tokill list is merely
 	 * freed.  When there was a problem unmapping earlier
 	 * use a more force-full uncatchable kill to prevent
 	 * any accesses to the poisoned memory.
 	 */
-	kill_procs(&tokill, !!PageDirty(ppage), trapno,
+	doit = !!PageDirty(ppage) || (flags & MF_MUST_KILL) != 0;
+	kill_procs(&tokill, doit, trapno,
 		      ret != SWAP_SUCCESS, p, pfn, flags);
 
 	return ret;
-- 
1.7.10.2.552.gaa3bb87

