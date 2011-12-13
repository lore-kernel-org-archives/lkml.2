Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394Ab1LOVSA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 16:18:00 -0500
Received: from mga02.intel.com ([134.134.136.20]:18333 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756524Ab1LOVR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 16:17:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="87842205"
Message-Id: <f047b536da2126d7ca3d5670d2e67141ea4feeb2.1323979146.git.tony.luck@intel.com>
In-Reply-To: <cover.1323979146.git.tony.luck@intel.com>
References: <cover.1323979146.git.tony.luck@intel.com>
From: Tony Luck <tony.luck@intel.com>
Date: Tue, 13 Dec 2011 09:27:58 -0800
Subject: [PATCH 2/6] HWPOISON: Add code to handle "action required" errors.
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        Chen Gong <gong.chen@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new flag bit "MF_ACTION_REQUIRED" to be used by machine check
code to force a signal with si_code = BUS_MCEERR_AR in the case
where the error occurs in processor execution context. Pass the
flags argument along call chain:
	memory_failure()
	  hwpoison_user_mappings()
	    kill_procs()
	      kill_proc()

Drop the "_ao" suffix from kill_procs_ao() and kill_proc_ao() since
they can now handle "action required" as well as "action optional" errors.

Acked-by: Borislav Petkov <bp@amd64.org>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/mm.h  |    1 +
 mm/memory-failure.c |   50 +++++++++++++++++++++++++++++---------------------
 2 files changed, 30 insertions(+), 21 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index bcc5234..bf169ca 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1606,6 +1606,7 @@ void vmemmap_populate_print_last(void);
 
 enum mf_flags {
 	MF_COUNT_INCREASED = 1 << 0,
+	MF_ACTION_REQUIRED = 1 << 1,
 };
 extern int memory_failure(unsigned long pfn, int trapno, int flags);
 extern void memory_failure_queue(unsigned long pfn, int trapno, int flags);
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index ab259bb..95fd307 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -187,33 +187,40 @@ int hwpoison_filter(struct page *p)
 EXPORT_SYMBOL_GPL(hwpoison_filter);
 
 /*
- * Send all the processes who have the page mapped an ``action optional''
- * signal.
+ * Send all the processes who have the page mapped a signal.
+ * ``action optional'' if they are not immediately affected by the error
+ * ``action required'' if error happened in current execution context
  */
-static int kill_proc_ao(struct task_struct *t, unsigned long addr, int trapno,
-			unsigned long pfn, struct page *page)
+static int kill_proc(struct task_struct *t, unsigned long addr, int trapno,
+			unsigned long pfn, struct page *page, int flags)
 {
 	struct siginfo si;
 	int ret;
 
 	printk(KERN_ERR
-		"MCE %#lx: Killing %s:%d early due to hardware memory corruption\n",
+		"MCE %#lx: Killing %s:%d due to hardware memory corruption\n",
 		pfn, t->comm, t->pid);
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
+
+	if ((flags & MF_ACTION_REQUIRED) && t == current) {
+		si.si_code = BUS_MCEERR_AR;
+		ret = force_sig_info(SIGBUS, &si, t);
+	} else {
+		/*
+		 * Don't use force here, it's convenient if the signal
+		 * can be temporarily blocked.
+		 * This could cause a loop when the user sets SIGBUS
+		 * to SIG_IGN, but hopefully no one will do that?
+		 */
+		si.si_code = BUS_MCEERR_AO;
+		ret = send_sig_info(SIGBUS, &si, t);  /* synchronous? */
+	}
 	if (ret < 0)
 		printk(KERN_INFO "MCE: Error sending signal to %s:%d: %d\n",
 		       t->comm, t->pid, ret);
@@ -338,8 +345,9 @@ static void add_to_kill(struct task_struct *tsk, struct page *p,
  * Also when FAIL is set do a force kill because something went
  * wrong earlier.
  */
-static void kill_procs_ao(struct list_head *to_kill, int doit, int trapno,
-			  int fail, struct page *page, unsigned long pfn)
+static void kill_procs(struct list_head *to_kill, int doit, int trapno,
+			  int fail, struct page *page, unsigned long pfn,
+			  int flags)
 {
 	struct to_kill *tk, *next;
 
@@ -363,8 +371,8 @@ static void kill_procs_ao(struct list_head *to_kill, int doit, int trapno,
 			 * check for that, but we need to tell the
 			 * process anyways.
 			 */
-			else if (kill_proc_ao(tk->tsk, tk->addr, trapno,
-					      pfn, page) < 0)
+			else if (kill_proc(tk->tsk, tk->addr, trapno,
+					      pfn, page, flags) < 0)
 				printk(KERN_ERR
 		"MCE %#lx: Cannot send advisory machine check signal to %s:%d\n",
 					pfn, tk->tsk->comm, tk->tsk->pid);
@@ -844,7 +852,7 @@ static int page_action(struct page_state *ps, struct page *p,
  * the pages and send SIGBUS to the processes if the data was dirty.
  */
 static int hwpoison_user_mappings(struct page *p, unsigned long pfn,
-				  int trapno)
+				  int trapno, int flags)
 {
 	enum ttu_flags ttu = TTU_UNMAP | TTU_IGNORE_MLOCK | TTU_IGNORE_ACCESS;
 	struct address_space *mapping;
@@ -962,8 +970,8 @@ static int hwpoison_user_mappings(struct page *p, unsigned long pfn,
 	 * use a more force-full uncatchable kill to prevent
 	 * any accesses to the poisoned memory.
 	 */
-	kill_procs_ao(&tokill, !!PageDirty(ppage), trapno,
-		      ret != SWAP_SUCCESS, p, pfn);
+	kill_procs(&tokill, !!PageDirty(ppage), trapno,
+		      ret != SWAP_SUCCESS, p, pfn, flags);
 
 	return ret;
 }
@@ -1148,7 +1156,7 @@ int memory_failure(unsigned long pfn, int trapno, int flags)
 	 * Now take care of user space mappings.
 	 * Abort on fail: __delete_from_page_cache() assumes unmapped page.
 	 */
-	if (hwpoison_user_mappings(p, pfn, trapno) != SWAP_SUCCESS) {
+	if (hwpoison_user_mappings(p, pfn, trapno, flags) != SWAP_SUCCESS) {
 		printk(KERN_ERR "MCE %#lx: cannot unmap page, give up\n", pfn);
 		res = -EBUSY;
 		goto out;
-- 
1.7.3.1

