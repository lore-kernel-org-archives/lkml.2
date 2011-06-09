Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304Ab1FIVeo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 17:34:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:44628 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754707Ab1FIVem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 17:34:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,343,1304319600"; 
   d="scan'208";a="12188414"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Borislav Petkov" <bp@amd64.org>
Cc: linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
        "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>,
        "Avi Kivity" <avi@redhat.com>
In-Reply-To: <4df13a522720782e51@agluck-desktop.sc.intel.com>
Subject: [PATCH 06/10] HWPOISON: Handle hwpoison in current process
Date: Thu, 09 Jun 2011 14:34:42 -0700
Message-Id: <4df13c722729547622@agluck-desktop.sc.intel.com>
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

