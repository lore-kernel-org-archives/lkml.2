Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab0HZVgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 17:36:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:43818 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674Ab0HZVgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 17:36:06 -0400
Date: Thu, 26 Aug 2010 21:33:58 GMT
From: tip-bot for Haicheng Li <haicheng.li@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, ak@linux.intel.com, tglx@linutronix.de,
        fengguang.wu@intel.com, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, haicheng.li@linux.intel.com,
        linux-kernel@vger.kernel.org, ak@linux.intel.com, tglx@linutronix.de,
        fengguang.wu@intel.com, hpa@linux.intel.com
In-Reply-To: <4C6E4ECD.1090607@linux.intel.com>
References: <4C6E4ECD.1090607@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, mm: Separate x86_64 vmalloc_sync_all() into separate functions
Message-ID: <tip-6afb5157b9eba4092e2f0f54d24a3806409bdde5@git.kernel.org>
Git-Commit-ID: 6afb5157b9eba4092e2f0f54d24a3806409bdde5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 26 Aug 2010 21:33:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6afb5157b9eba4092e2f0f54d24a3806409bdde5
Gitweb:     http://git.kernel.org/tip/6afb5157b9eba4092e2f0f54d24a3806409bdde5
Author:     Haicheng Li <haicheng.li@linux.intel.com>
AuthorDate: Wed, 19 May 2010 17:42:14 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 26 Aug 2010 14:02:29 -0700

x86, mm: Separate x86_64 vmalloc_sync_all() into separate functions

No behavior change.

Move some of vmalloc_sync_all() code into a new function
sync_global_pgds() that will be useful for memory hotplug.

Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
LKML-Reference: <4C6E4ECD.1090607@linux.intel.com>
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/pgtable_64.h |    2 ++
 arch/x86/mm/fault.c               |   24 +-----------------------
 arch/x86/mm/init_64.c             |   30 ++++++++++++++++++++++++++++++
 3 files changed, 33 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
index 076052c..f96ac9b 100644
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -102,6 +102,8 @@ static inline void native_pgd_clear(pgd_t *pgd)
 	native_set_pgd(pgd, native_make_pgd(0));
 }
 
+extern void sync_global_pgds(unsigned long start, unsigned long end);
+
 /*
  * Conversion functions: convert a page and protection to a page entry,
  * and a page entry and page directory to the page they refer to.
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 4c4508e..51f7ee7 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -326,29 +326,7 @@ out:
 
 void vmalloc_sync_all(void)
 {
-	unsigned long address;
-
-	for (address = VMALLOC_START & PGDIR_MASK; address <= VMALLOC_END;
-	     address += PGDIR_SIZE) {
-
-		const pgd_t *pgd_ref = pgd_offset_k(address);
-		unsigned long flags;
-		struct page *page;
-
-		if (pgd_none(*pgd_ref))
-			continue;
-
-		spin_lock_irqsave(&pgd_lock, flags);
-		list_for_each_entry(page, &pgd_list, lru) {
-			pgd_t *pgd;
-			pgd = (pgd_t *)page_address(page) + pgd_index(address);
-			if (pgd_none(*pgd))
-				set_pgd(pgd, *pgd_ref);
-			else
-				BUG_ON(pgd_page_vaddr(*pgd) != pgd_page_vaddr(*pgd_ref));
-		}
-		spin_unlock_irqrestore(&pgd_lock, flags);
-	}
+	sync_global_pgds(VMALLOC_START & PGDIR_MASK, VMALLOC_END);
 }
 
 /*
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 9a66746..61a1b4f 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -98,6 +98,36 @@ static int __init nonx32_setup(char *str)
 __setup("noexec32=", nonx32_setup);
 
 /*
+ * When memory was added/removed make sure all the processes MM have
+ * suitable PGD entries in the local PGD level page.
+ */
+void sync_global_pgds(unsigned long start, unsigned long end)
+{
+       unsigned long address;
+
+       for (address = start; address <= end; address += PGDIR_SIZE) {
+	       const pgd_t *pgd_ref = pgd_offset_k(address);
+	       unsigned long flags;
+	       struct page *page;
+
+	       if (pgd_none(*pgd_ref))
+		       continue;
+
+	       spin_lock_irqsave(&pgd_lock, flags);
+	       list_for_each_entry(page, &pgd_list, lru) {
+		       pgd_t *pgd;
+		       pgd = (pgd_t *)page_address(page) + pgd_index(address);
+		       if (pgd_none(*pgd))
+			       set_pgd(pgd, *pgd_ref);
+		       else
+			       BUG_ON(pgd_page_vaddr(*pgd)
+					!= pgd_page_vaddr(*pgd_ref));
+	       }
+	       spin_unlock_irqrestore(&pgd_lock, flags);
+       }
+}
+
+/*
  * NOTE: This function is marked __ref because it calls __init function
  * (alloc_bootmem_pages). It's safe to do it ONLY when after_bootmem == 0.
  */
