Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934161Ab1EWWOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 18:14:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:27263 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932197Ab1EWWOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 18:14:18 -0400
X-ExtLoop1: 1
From: "Luck, Tony" <tony.luck@intel.com>
To: linux-kernel@vger.kernel.org
Cc: "Ingo Molnar" <mingo@elte.hu>, "Huang, Ying" <ying.huang@intel.com>,
        "Andi Kleen" <andi@firstfloor.org>, "Borislav Petkov" <bp@alien8.de>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <4ddad79317108eb33d@agluck-desktop.sc.intel.com>
Subject: [RFC 6/9] HWPOISON: Handle hwpoison in current process
Date: Mon, 23 May 2011 15:14:18 -0700
Message-Id: <4ddadc3a1716839948@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>

When hardware poison handles the current process use
a forced signal with _AR severity.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 mm/memory-failure.c |   28 ++++++++++++++++------------
 1 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 2b9a5ee..a203113 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -184,8 +184,7 @@ int hwpoison_filter(struct page *p)
 EXPORT_SYMBOL_GPL(hwpoison_filter);
 
 /*
- * Send all the processes who have the page mapped an ``action optional''
- * signal.
+ * Send all the processes who have the page mapped a SIGBUS.
  */
 static int kill_proc_ao(struct task_struct *t, unsigned long addr, int trapno,
 			unsigned long pfn, struct page *page)
@@ -194,23 +193,28 @@ static int kill_proc_ao(struct task_struct *t, unsigned long addr, int trapno,
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
-- 
1.7.3.1

