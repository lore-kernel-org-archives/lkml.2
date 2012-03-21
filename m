Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965018Ab2CUG4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 02:56:36 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39114 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964952Ab2CUG4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 02:56:20 -0400
Subject: [PATCH 01/16] mm: introduce NR_VMA_FLAGS
To: Andrew Morton <akpm@linux-foundation.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Wed, 21 Mar 2012 10:56:16 +0400
Message-ID: <20120321065616.13852.56502.stgit@zurg>
In-Reply-To: <20120321065140.13852.52315.stgit@zurg>
References: <20120321065140.13852.52315.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds NR_VMA_FLAGS constant into generated/bounds.h
and switch type of vm_flags_t depending on it.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
---
 include/linux/mm.h       |    8 ++++++++
 include/linux/mm_types.h |    5 +++++
 kernel/bounds.c          |    2 ++
 3 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5b29b4f..69915a2 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4,6 +4,7 @@
 #include <linux/errno.h>
 
 #ifdef __KERNEL__
+#ifndef __GENERATING_BOUNDS_H
 
 #include <linux/gfp.h>
 #include <linux/bug.h>
@@ -67,6 +68,8 @@ extern struct rw_semaphore nommu_region_sem;
 extern unsigned int kobjsize(const void *objp);
 #endif
 
+#endif /* __GENERATING_BOUNDS_H */
+
 /*
  * vm_flags in vm_area_struct, see mm_types.h.
  */
@@ -120,6 +123,10 @@ extern unsigned int kobjsize(const void *objp);
 #define VM_PFN_AT_MMAP	0x40000000	/* PFNMAP vma that is fully mapped at mmap time */
 #define VM_MERGEABLE	0x80000000	/* KSM may merge identical pages */
 
+#define __NR_VMA_FLAGS	32
+
+#ifndef __GENERATING_BOUNDS_H
+
 /* Bits set in the VMA until the stack is in its final location */
 #define VM_STACK_INCOMPLETE_SETUP	(VM_RAND_READ | VM_SEQ_READ)
 
@@ -1642,5 +1649,6 @@ static inline unsigned int debug_guardpage_minorder(void) { return 0; }
 static inline bool page_is_guard(struct page *page) { return false; }
 #endif /* CONFIG_DEBUG_PAGEALLOC */
 
+#endif /* __GENERATING_BOUNDS_H */
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MM_H */
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 76bbdaf..3aeb8f6 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -12,6 +12,7 @@
 #include <linux/completion.h>
 #include <linux/cpumask.h>
 #include <linux/page-debug-flags.h>
+#include <generated/bounds.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
 
@@ -170,7 +171,11 @@ struct page_frag {
 #endif
 };
 
+#if (NR_VMA_FLAGS > 32)
+typedef unsigned long long __nocast vm_flags_t;
+#else
 typedef unsigned long __nocast vm_flags_t;
+#endif
 
 /*
  * A region containing a mapping of a non-memory backed file under NOMMU
diff --git a/kernel/bounds.c b/kernel/bounds.c
index 0c9b862..6d2732f 100644
--- a/kernel/bounds.c
+++ b/kernel/bounds.c
@@ -7,6 +7,7 @@
 #define __GENERATING_BOUNDS_H
 /* Include headers that define the enum constants of interest */
 #include <linux/page-flags.h>
+#include <linux/mm.h>
 #include <linux/mmzone.h>
 #include <linux/kbuild.h>
 #include <linux/page_cgroup.h>
@@ -15,6 +16,7 @@ void foo(void)
 {
 	/* The enum constants to put into include/generated/bounds.h */
 	DEFINE(NR_PAGEFLAGS, __NR_PAGEFLAGS);
+	DEFINE(NR_VMA_FLAGS, __NR_VMA_FLAGS);
 	DEFINE(MAX_NR_ZONES, __MAX_NR_ZONES);
 	DEFINE(NR_PCG_FLAGS, __NR_PCG_FLAGS);
 	/* End of constants */

