Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879Ab2GOLFI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 07:05:08 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41338 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab2GOLEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 07:04:55 -0400
From: Pekka Enberg <penberg@kernel.org>
To: mingo@kernel.org
Cc: yinghai@kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Pekka Enberg <penberg@kernel.org>, Joe Perches <joe@perches.com>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH v2 2/3] x86/mm: Simplify free_init_pages()
Date: Sun, 15 Jul 2012 14:04:45 +0300
Message-Id: <1342350286-6670-2-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1342350286-6670-1-git-send-email-penberg@kernel.org>
References: <1342350286-6670-1-git-send-email-penberg@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a cleanup, separate the #ifdef'd code in a new helper function and move
initial "addr" assignment to the for-loop construct.

Cc: Joe Perches <joe@perches.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 arch/x86/mm/init.c |   44 ++++++++++++++++++++++++--------------------
 1 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 9eb53c2..4f863cc 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -332,35 +332,20 @@ int devmem_is_allowed(unsigned long pagenr)
 	return 0;
 }
 
-void free_init_pages(char *what, unsigned long begin, unsigned long end)
+static void __free_init_pages(char *what, unsigned long begin, unsigned long end)
 {
-	unsigned long addr;
-	unsigned long begin_aligned, end_aligned;
-
-	/* Make sure boundaries are page aligned */
-	begin_aligned = PAGE_ALIGN(begin);
-	end_aligned   = end & PAGE_MASK;
-
-	if (WARN_ON(begin_aligned != begin || end_aligned != end)) {
-		begin = begin_aligned;
-		end   = end_aligned;
-	}
-
-	if (begin >= end)
-		return;
-
-	addr = begin;
-
+#ifdef CONFIG_DEBUG_PAGEALLOC
 	/*
 	 * If debugging page accesses then do not free this memory but
 	 * mark them not present - any buggy init-section access will
 	 * create a kernel page fault:
 	 */
-#ifdef CONFIG_DEBUG_PAGEALLOC
 	printk(KERN_INFO "debug: unmapping init [mem %#010lx-%#010lx]\n",
 		begin, end - 1);
 	set_memory_np(begin, (end - begin) >> PAGE_SHIFT);
 #else
+	unsigned long addr;
+
 	/*
 	 * We just marked the kernel text read only above, now that
 	 * we are going to free part of that, we need to make that
@@ -371,7 +356,7 @@ void free_init_pages(char *what, unsigned long begin, unsigned long end)
 
 	printk(KERN_INFO "Freeing %s: %luk freed\n", what, (end - begin) >> 10);
 
-	for (; addr < end; addr += PAGE_SIZE) {
+	for (addr = begin; addr < end; addr += PAGE_SIZE) {
 		ClearPageReserved(virt_to_page(addr));
 		init_page_count(virt_to_page(addr));
 		memset((void *)addr, POISON_FREE_INITMEM, PAGE_SIZE);
@@ -381,6 +366,25 @@ void free_init_pages(char *what, unsigned long begin, unsigned long end)
 #endif
 }
 
+void free_init_pages(char *what, unsigned long begin, unsigned long end)
+{
+	unsigned long begin_aligned, end_aligned;
+
+	/* Make sure boundaries are page aligned */
+	begin_aligned = PAGE_ALIGN(begin);
+	end_aligned   = end & PAGE_MASK;
+
+	if (WARN_ON(begin_aligned != begin || end_aligned != end)) {
+		begin = begin_aligned;
+		end   = end_aligned;
+	}
+
+	if (begin >= end)
+		return;
+
+	__free_init_pages(what, begin, end);
+}
+
 void free_initmem(void)
 {
 	free_init_pages("unused kernel memory",
-- 
1.7.7.6

