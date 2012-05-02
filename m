Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574Ab2EBDSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 23:18:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:37311 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758372Ab2EBDSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 23:18:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="160734856"
Message-ID: <4FA0A743.2070904@intel.com>
Date: Wed, 02 May 2012 11:17:23 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: aarcange@redhat.com, riel@redhat.com, mgorman@suse.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] THP: need is_vma_temporary_stack() when reference transparent_hugepage_enabled
References: <1335594795-30876-1-git-send-email-alex.shi@intel.com> <20120430160520.4c1cc05c.akpm@linux-foundation.org>
In-Reply-To: <20120430160520.4c1cc05c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2012 07:05 AM, Andrew Morton wrote:

> On Sat, 28 Apr 2012 14:33:15 +0800
> Alex Shi <alex.shi@intel.com> wrote:
> 
>> When the transparent_hugepage_enabled() used out of mm/,
>> is_vma_temporary_stack() need be referenced. Otherwise, it has compile
>> error.
> 
> This is a poor changelog - it doesn't tell us how this compilation
> error comes about.  Is there some known build error in the mainline
> kernel, or did you discover this when altering the kernel, or what?

> 

> One of the several reasons for this information is to permit others to
> work out which kernel version(s) should be fixed.
> 




I am sorry for the unclear log!
When I try to transparent_hugepage_enabled() in arch/x86/mm/tlb.c with
huge_mm.h include: +#include <linux/huge_mm.h>. make give me the following
error:
...
  CC      arch/x86/mm/srat.o
arch/x86/mm/tlb.c: In function ‘flush_tlb_range’:
arch/x86/mm/tlb.c:324:4: error: implicit declaration of function ‘is_vma_temporary_stack’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
...
Since it is not convenitant for user to include 2 head files just for one 
target function, I send this patch. 

> is_vma_temporary_stack() is already declared in rmap.h.  We should not
> declare it in two places.




Oh, yes. Since is_vma_temporay_stack is just used in rmap.c and huge_memory.c
. is it better to move it to huge_mm.h?

---
>From 7c208e10b3f4fc2f4f9c41068ea4d65a1119970e Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Wed, 2 May 2012 11:04:04 +0800
Subject: [PATCH] mm/THP: need is_vma_temporary_stack() when reference
 transparent_hugepage_enabled
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When the transparent_hugepage_enabled() using out of mm/,
like in a altering arch/x86/xx/tlb.c:

+       if (!cpu_has_invlpg || vma->vm_flags & VM_HUGETLB
+                       || transparent_hugepage_enabled(vma)) {
+               flush_tlb_mm(vma->vm_mm);

is_vma_temporary_stack() isn't referenced in huge_mm.h, so it has compile
errors:
arch/x86/mm/tlb.c: In function ‘flush_tlb_range’:
arch/x86/mm/tlb.c:324:4: error: implicit declaration of function ‘is_vma_temporary_stack’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

Since is_vma_temporay_stack() is just used in rmap.c and huge_memory.c.
It is better to move it to huge_mm.h from rmap.h to avoid such error.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 include/linux/huge_mm.h |    2 ++
 include/linux/rmap.h    |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 1b92129..acf3ab1 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -56,6 +56,8 @@ extern pmd_t *page_check_address_pmd(struct page *page,
 #define HPAGE_PMD_MASK HPAGE_MASK
 #define HPAGE_PMD_SIZE HPAGE_SIZE
 
+extern bool is_vma_temporary_stack(struct vm_area_struct *vma);
+
 #define transparent_hugepage_enabled(__vma)				\
 	((transparent_hugepage_flags &					\
 	  (1<<TRANSPARENT_HUGEPAGE_FLAG) ||				\
diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 1cdd62a..267fb6b 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -174,8 +174,6 @@ enum ttu_flags {
 };
 #define TTU_ACTION(x) ((x) & TTU_ACTION_MASK)
 
-bool is_vma_temporary_stack(struct vm_area_struct *vma);
-
 int try_to_unmap(struct page *, enum ttu_flags flags);
 int try_to_unmap_one(struct page *, struct vm_area_struct *,
 			unsigned long address, enum ttu_flags flags);
-- 
1.7.5.1

