Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179Ab1BRQJN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 11:09:13 -0500
Received: from lon1-post-3.mail.demon.net ([195.173.77.150]:50118 "EHLO
	lon1-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754369Ab1BRQJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 11:09:11 -0500
X-Greylist: delayed 1199 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Feb 2011 11:09:11 EST
Subject: mm: mm_struct remove 16 bytes of alignment padding on 64 bit builds
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Feb 2011 15:49:07 +0000
Message-ID: <1298044147.2071.5.camel@castor.rsk>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorder mm_struct to remove 16 bytes of alignment padding on 64 bit
builds.
On my config this shrinks mm_struct by enough to fit in one fewer cache
lines and allows more objects per slab in mm_struct kmem_cache under
SLUB.

slabinfo before patch :-
    Sizes (bytes)     Slabs
    --------------------------------
    Object :     848  Total  :       9
    SlabObj:     896  Full   :       2
    SlabSiz:   16384  Partial:       5
    Loss   :      48  CpuSlab:       2
    Align  :      64  Objects:      18
    
 slabinfo after :-
    Sizes (bytes)     Slabs
    --------------------------------
    Object :     832  Total  :       7
    SlabObj:     832  Full   :       2
    SlabSiz:   16384  Partial:       3
    Loss   :       0  CpuSlab:       2
    Align  :      64  Objects:      19

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
---
patch against v2.6.38-rc4
compiled & tested on x86_64

regards
Richard


diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 26bc4e2..02aa561 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -237,8 +237,9 @@ struct mm_struct {
 	atomic_t mm_users;			/* How many users with user space? */
 	atomic_t mm_count;			/* How many references to "struct mm_struct" (users count as 1) */
 	int map_count;				/* number of VMAs */
-	struct rw_semaphore mmap_sem;
+
 	spinlock_t page_table_lock;		/* Protects page tables and some counters */
+	struct rw_semaphore mmap_sem;
 
 	struct list_head mmlist;		/* List of maybe swapped mm's.	These are globally strung
 						 * together off init_mm.mmlist, and are protected
@@ -281,6 +282,9 @@ struct mm_struct {
 	unsigned int token_priority;
 	unsigned int last_interval;
 
+	/* How many tasks sharing this mm are OOM_DISABLE */
+	atomic_t oom_disable_count;
+
 	unsigned long flags; /* Must use atomic bitops to access the bits */
 
 	struct core_state *core_state; /* coredumping support */
@@ -313,8 +317,6 @@ struct mm_struct {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	pgtable_t pmd_huge_pte; /* protected by page_table_lock */
 #endif
-	/* How many tasks sharing this mm are OOM_DISABLE */
-	atomic_t oom_disable_count;
 };
 
 /* Future-safe accessor for struct mm_struct's cpu_vm_mask. */


