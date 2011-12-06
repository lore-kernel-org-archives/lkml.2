Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933170Ab1LFKAA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 05:00:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35057 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933072Ab1LFJ77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 04:59:59 -0500
Date: Tue, 6 Dec 2011 01:59:35 -0800
From: tip-bot for Stanislaw Gruszka <sgruszka@redhat.com>
Message-ID: <tip-54c29c635ae91f5d75ced7bffeaa77ba37ca02bb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        mgorman@suse.de, tglx@linutronix.de, sgruszka@redhat.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mgorman@suse.de, tglx@linutronix.de, sgruszka@redhat.com,
        mingo@elte.hu
In-Reply-To: <1322582711-14571-1-git-send-email-sgruszka@redhat.com>
References: <1322582711-14571-1-git-send-email-sgruszka@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] mm, x86: Remove debug_pagealloc_enabled
Git-Commit-ID: 54c29c635ae91f5d75ced7bffeaa77ba37ca02bb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Dec 2011 01:59:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  54c29c635ae91f5d75ced7bffeaa77ba37ca02bb
Gitweb:     http://git.kernel.org/tip/54c29c635ae91f5d75ced7bffeaa77ba37ca02bb
Author:     Stanislaw Gruszka <sgruszka@redhat.com>
AuthorDate: Tue, 29 Nov 2011 17:05:11 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Dec 2011 09:24:07 +0100

mm, x86: Remove debug_pagealloc_enabled

When (no)bootmem finish operation, it pass pages to buddy
allocator. Since debug_pagealloc_enabled is not set, we will do
not protect pages, what is not what we want with
CONFIG_DEBUG_PAGEALLOC=y.

To fix remove debug_pagealloc_enabled. That variable was
introduced by commit 12d6f21e "x86: do not PSE on
CONFIG_DEBUG_PAGEALLOC=y" to get more CPA (change page
attribude) code testing. But currently we have CONFIG_CPA_DEBUG,
which test CPA.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: linux-mm@kvack.org
Link: http://lkml.kernel.org/r/1322582711-14571-1-git-send-email-sgruszka@redhat.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/pageattr.c |    6 ------
 include/linux/mm.h     |   10 ----------
 init/main.c            |    5 -----
 mm/debug-pagealloc.c   |    3 ---
 4 files changed, 0 insertions(+), 24 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index f9e5267..5031eef 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -1334,12 +1334,6 @@ void kernel_map_pages(struct page *page, int numpages, int enable)
 	}
 
 	/*
-	 * If page allocator is not up yet then do not call c_p_a():
-	 */
-	if (!debug_pagealloc_enabled)
-		return;
-
-	/*
 	 * The return value is ignored as the calls cannot fail.
 	 * Large pages for identity mappings are not used at boot time
 	 * and hence no memory allocations during large page split.
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 3dc3a8c..0a22db1 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1537,23 +1537,13 @@ static inline void vm_stat_account(struct mm_struct *mm,
 #endif /* CONFIG_PROC_FS */
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
-extern int debug_pagealloc_enabled;
-
 extern void kernel_map_pages(struct page *page, int numpages, int enable);
-
-static inline void enable_debug_pagealloc(void)
-{
-	debug_pagealloc_enabled = 1;
-}
 #ifdef CONFIG_HIBERNATION
 extern bool kernel_page_present(struct page *page);
 #endif /* CONFIG_HIBERNATION */
 #else
 static inline void
 kernel_map_pages(struct page *page, int numpages, int enable) {}
-static inline void enable_debug_pagealloc(void)
-{
-}
 #ifdef CONFIG_HIBERNATION
 static inline bool kernel_page_present(struct page *page) { return true; }
 #endif /* CONFIG_HIBERNATION */
diff --git a/init/main.c b/init/main.c
index 217ed23..99c4ba3 100644
--- a/init/main.c
+++ b/init/main.c
@@ -282,10 +282,6 @@ static int __init unknown_bootoption(char *param, char *val)
 	return 0;
 }
 
-#ifdef CONFIG_DEBUG_PAGEALLOC
-int __read_mostly debug_pagealloc_enabled = 0;
-#endif
-
 static int __init init_setup(char *str)
 {
 	unsigned int i;
@@ -597,7 +593,6 @@ asmlinkage void __init start_kernel(void)
 	}
 #endif
 	page_cgroup_init();
-	enable_debug_pagealloc();
 	debug_objects_mem_init();
 	kmemleak_init();
 	setup_per_cpu_pageset();
diff --git a/mm/debug-pagealloc.c b/mm/debug-pagealloc.c
index 7cea557..789ff70 100644
--- a/mm/debug-pagealloc.c
+++ b/mm/debug-pagealloc.c
@@ -95,9 +95,6 @@ static void unpoison_pages(struct page *page, int n)
 
 void kernel_map_pages(struct page *page, int numpages, int enable)
 {
-	if (!debug_pagealloc_enabled)
-		return;
-
 	if (enable)
 		unpoison_pages(page, numpages);
 	else
