Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291Ab2GFOKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 10:10:54 -0400
Received: from mga14.intel.com ([143.182.124.37]:22458 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720Ab2GFOKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 10:10:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="119531406"
Message-ID: <4FF6F1E9.7050709@intel.com>
Date: Fri, 06 Jul 2012 22:10:49 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Fwd: Re: [linux-next-20120706] x86/mm: incompatible pointer type
 warning.
References: <4FF6F14C.3070104@intel.com>
In-Reply-To: <4FF6F14C.3070104@intel.com>
X-Forwarded-Message-Id: <4FF6F14C.3070104@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forward to LKML

-------- Original Message --------
Subject: Re: [linux-next-20120706] x86/mm: incompatible pointer type
warning.
Date: Fri, 06 Jul 2012 22:08:12 +0800
From: Alex Shi <alex.shi@intel.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: yongjie.ren@intel.com, hpa@zytor.com,  "Wu, Fengguang"
<fengguang.wu@intel.com>

On 07/06/2012 08:13 PM, Tetsuo Handa wrote:

> Hello.
> 
> Commit 611ae8e3 "x86/tlb: enable tlb flush range support for x86" causes
> below warning on allnoconfig.
> 
>   mm/memory.c: In function 'tlb_flush_mmu':
>   mm/memory.c:231: warning: passing argument 1 of 'flush_tlb_mm_range' from incompatible pointer type
>   /usr/src/linux-next/arch/x86/include/asm/tlbflush.h:108: note: expected 'struct vm_area_struct *' but argument is of type 'struct mm_struct *'
>   mm/memory.c:231: warning: passing argument 1 of 'flush_tlb_mm_range' from incompatible pointer type
>   /usr/src/linux-next/arch/x86/include/asm/tlbflush.h:108: note: expected 'struct vm_area_struct *' but argument is of type 'struct mm_struct *'
> 
> Did tlb->mm in tlb_flush() mean tlb->mm->mmap or tlb->mm->mmap_cache?



Thanks for your report, mm should means mm_struct. no vma. My fault.
Could you like try this patch.

Fengguang, I remember you build system also collect the warning message
before. Do you stop this? :)

---

>From 97781231b130e7f7fced12244653ed9b9946c944 Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Fri, 6 Jul 2012 20:49:25 +0800
Subject: [PATCH] x86/tlb: fix allnoconfig building warning

The incompatible parameter of flush_tlb_mm_range cause build warning.
Fix it by correct parameter.

Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 arch/x86/include/asm/tlbflush.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/tlbflush.h
b/arch/x86/include/asm/tlbflush.h
index b5a27bd..74a4433 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -105,10 +105,10 @@ static inline void flush_tlb_range(struct
vm_area_struct *vma,
 		__flush_tlb();
 }

-static inline void flush_tlb_mm_range(struct vm_area_struct *vma,
+static inline void flush_tlb_mm_range(struct mm_struct *mm,
 	   unsigned long start, unsigned long end, unsigned long vmflag)
 {
-	if (vma->vm_mm == current->active_mm)
+	if (mm == current->active_mm)
 		__flush_tlb();
 }

-- 
1.7.5.4

