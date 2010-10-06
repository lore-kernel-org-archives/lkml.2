Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933025Ab0JFUtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 16:49:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37487 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759555Ab0JFUtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 16:49:14 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: fengguang.wu@intel.com, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: [PATCH 3/4] HWPOISON: Report correct address granuality for AO huge page errors
Date: Wed,  6 Oct 2010 22:49:00 +0200
Message-Id: <1286398141-13749-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286398141-13749-1-git-send-email-andi@firstfloor.org>
References: <1286398141-13749-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The SIGBUS user space signalling is supposed to report the
address granuality of a corruption. Pass this information correctly
for huge pages by querying the hpage order.

Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: fengguang.wu@intel.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 mm/memory-failure.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 9c26eec..886144b 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -183,10 +183,11 @@ EXPORT_SYMBOL_GPL(hwpoison_filter);
  * signal.
  */
 static int kill_proc_ao(struct task_struct *t, unsigned long addr, int trapno,
-			unsigned long pfn)
+			unsigned long pfn, struct page *page)
 {
 	struct siginfo si;
 	int ret;
+	unsigned order;
 
 	printk(KERN_ERR
 		"MCE %#lx: Killing %s:%d early due to hardware memory corruption\n",
@@ -198,7 +199,8 @@ static int kill_proc_ao(struct task_struct *t, unsigned long addr, int trapno,
 #ifdef __ARCH_SI_TRAPNO
 	si.si_trapno = trapno;
 #endif
-	si.si_addr_lsb = PAGE_SHIFT;
+	order = PageCompound(page) ? huge_page_order(page) : PAGE_SHIFT;
+	si.si_addr_lsb = order;
 	/*
 	 * Don't use force here, it's convenient if the signal
 	 * can be temporarily blocked.
@@ -327,7 +329,7 @@ static void add_to_kill(struct task_struct *tsk, struct page *p,
  * wrong earlier.
  */
 static void kill_procs_ao(struct list_head *to_kill, int doit, int trapno,
-			  int fail, unsigned long pfn)
+			  int fail, struct page *page, unsigned long pfn)
 {
 	struct to_kill *tk, *next;
 
@@ -341,7 +343,8 @@ static void kill_procs_ao(struct list_head *to_kill, int doit, int trapno,
 			if (fail || tk->addr_valid == 0) {
 				printk(KERN_ERR
 		"MCE %#lx: forcibly killing %s:%d because of failure to unmap corrupted page\n",
-					pfn, tk->tsk->comm, tk->tsk->pid);
+					pfn,	
+					tk->tsk->comm, tk->tsk->pid);
 				force_sig(SIGKILL, tk->tsk);
 			}
 
@@ -352,7 +355,7 @@ static void kill_procs_ao(struct list_head *to_kill, int doit, int trapno,
 			 * process anyways.
 			 */
 			else if (kill_proc_ao(tk->tsk, tk->addr, trapno,
-					      pfn) < 0)
+					      pfn, page) < 0)
 				printk(KERN_ERR
 		"MCE %#lx: Cannot send advisory machine check signal to %s:%d\n",
 					pfn, tk->tsk->comm, tk->tsk->pid);
@@ -928,7 +931,7 @@ static int hwpoison_user_mappings(struct page *p, unsigned long pfn,
 	 * any accesses to the poisoned memory.
 	 */
 	kill_procs_ao(&tokill, !!PageDirty(hpage), trapno,
-		      ret != SWAP_SUCCESS, pfn);
+		      ret != SWAP_SUCCESS, p, pfn);
 
 	return ret;
 }
-- 
1.7.1

