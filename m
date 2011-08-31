Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019Ab1HaW0C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 18:26:02 -0400
Received: from mga11.intel.com ([192.55.52.93]:41361 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757006Ab1HaW0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 18:26:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,309,1312182000"; 
   d="scan'208";a="47278174"
From: "Luck, Tony" <tony.luck@intel.com>
To: linux-kernel@vger.kernel.org
Cc: "Ingo Molnar" <mingo@elte.hu>, "Borislav Petkov" <bp@amd64.org>,
        "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>
In-Reply-To: <4e5eb3f12101199595@agluck-desktop.sc.intel.com>
Subject: [PATCH 3/5] HWPOISON: Handle hwpoison in current process
Date: Wed, 31 Aug 2011 15:26:00 -0700
Message-Id: <4e5eb4f8210553892f@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:	"Luck, Tony" <tony.luck@intel.com>

From: Andi Kleen <andi@firstfloor.org>

When hardware poison handles the current process use
a forced signal with _AR severity.

[Tony: changed some function names .. the "_ao" suffix was no longer meaningful]

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 mm/memory-failure.c |   39 ++++++++++++++++++++++-----------------
 1 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 2b43ba0..6ccb8a6 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -186,33 +186,38 @@ int hwpoison_filter(struct page *p)
 EXPORT_SYMBOL_GPL(hwpoison_filter);
 
 /*
- * Send all the processes who have the page mapped an ``action optional''
- * signal.
+ * Send one process who has the page mapped a SIGBUS. It might
+ * be able to catch it and initiate its own task level recovery.
  */
-static int kill_proc_ao(struct task_struct *t, unsigned long addr, int trapno,
+static int user_recovery(struct task_struct *t, unsigned long addr, int trapno,
 			unsigned long pfn, struct page *page)
 {
 	struct siginfo si;
 	int ret;
 
 	printk(KERN_ERR
-		"MCE %#lx: Killing %s:%d early due to hardware memory corruption\n",
-		pfn, t->comm, t->pid);
+		"MCE %#lx: Killing %s:%d due to hardware memory corruption\n",
+	       pfn, t->comm, t->pid);
 	si.si_signo = SIGBUS;
 	si.si_errno = 0;
-	si.si_code = BUS_MCEERR_AO;
 	si.si_addr = (void *)addr;
 #ifdef __ARCH_SI_TRAPNO
 	si.si_trapno = trapno;
 #endif
 	si.si_addr_lsb = compound_trans_order(compound_head(page)) + PAGE_SHIFT;
-	/*
-	 * Don't use force here, it's convenient if the signal
-	 * can be temporarily blocked.
-	 * This could cause a loop when the user sets SIGBUS
-	 * to SIG_IGN, but hopefully no one will do that?
-	 */
-	ret = send_sig_info(SIGBUS, &si, t);  /* synchronous? */
+	if (t == current) {
+		si.si_code = BUS_MCEERR_AR;
+		ret = force_sig_info(SIGBUS, &si, t);
+	} else {
+		/*
+		 * Don't use force here, it's convenient if the signal
+		 * can be temporarily blocked.
+		 * This could cause a loop when the user sets SIGBUS
+		 * to SIG_IGN, but hopefully noone will do that?
+		 */
+		si.si_code = BUS_MCEERR_AO;
+		ret = send_sig_info(SIGBUS, &si, t);
+	}
 	if (ret < 0)
 		printk(KERN_INFO "MCE: Error sending signal to %s:%d: %d\n",
 		       t->comm, t->pid, ret);
@@ -330,14 +335,14 @@ static void add_to_kill(struct task_struct *tsk, struct page *p,
 }
 
 /*
- * Kill the processes that have been collected earlier.
+ * Signal the processes that have been collected earlier.
  *
  * Only do anything when DOIT is set, otherwise just free the list
  * (this is used for clean pages which do not need killing)
  * Also when FAIL is set do a force kill because something went
  * wrong earlier.
  */
-static void kill_procs_ao(struct list_head *to_kill, int doit, int trapno,
+static void kill_procs(struct list_head *to_kill, int doit, int trapno,
 			  int fail, struct page *page, unsigned long pfn)
 {
 	struct to_kill *tk, *next;
@@ -362,7 +367,7 @@ static void kill_procs_ao(struct list_head *to_kill, int doit, int trapno,
 			 * check for that, but we need to tell the
 			 * process anyways.
 			 */
-			else if (kill_proc_ao(tk->tsk, tk->addr, trapno,
+			else if (user_recovery(tk->tsk, tk->addr, trapno,
 					      pfn, page) < 0)
 				printk(KERN_ERR
 		"MCE %#lx: Cannot send advisory machine check signal to %s:%d\n",
@@ -961,7 +966,7 @@ static int hwpoison_user_mappings(struct page *p, unsigned long pfn,
 	 * use a more force-full uncatchable kill to prevent
 	 * any accesses to the poisoned memory.
 	 */
-	kill_procs_ao(&tokill, !!PageDirty(ppage), trapno,
+	kill_procs(&tokill, !!PageDirty(ppage), trapno,
 		      ret != SWAP_SUCCESS, p, pfn);
 
 	return ret;
-- 
1.7.3.1

