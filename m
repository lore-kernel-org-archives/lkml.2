Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab2APETp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 23:19:45 -0500
Received: from relais.videotron.ca ([24.201.245.36]:10865 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab2APETo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 23:19:44 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Sun, 15 Jan 2012 23:19:43 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
To: Will Deacon <will.deacon@arm.com>
Cc: Hugh Dickins <hughd@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "moussaba@micron.com" <moussaba@micron.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [RFC PATCH] proc: clear_refs: do not clear reserved pages
In-reply-to: <20120115150706.GA7474@mudshark.cambridge.arm.com>
Message-id: <alpine.LFD.2.02.1201152314420.2722@xanadu.home>
References: <1326467587-22218-1-git-send-email-will.deacon@arm.com>
 <alpine.LFD.2.02.1201131748380.2722@xanadu.home>
 <alpine.LSU.2.00.1201140901260.2381@eggly.anvils>
 <20120115150706.GA7474@mudshark.cambridge.arm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Jan 2012, Will Deacon wrote:

> Hi Hugh,
> 
> Thanks for the explanation.
> 
> On Sat, Jan 14, 2012 at 05:36:37PM +0000, Hugh Dickins wrote:
> > I'm not saying the horrible hack gate_vma mechanism is any safer
> > than yours (the latest bug in it was fixed all of 13 days ago).
> > But I am saying that one horrible hack is safer than two.

Absolutely.

> Something like what I've got below seems to do the trick, and clear_refs
> also seems to behave when it's presented with the gate_vma. If Russell is
> happy with the approach, we can move to the gate_vma in the future.

I like it much better, although I haven't tested it fully yet.

However your patch is missing the worst of the current ARM hack I would 
be glad to see go as follows:

diff --git a/arch/arm/include/asm/mmu_context.h b/arch/arm/include/asm/mmu_context.h
index 71605d9f8e..876e545297 100644
--- a/arch/arm/include/asm/mmu_context.h
+++ b/arch/arm/include/asm/mmu_context.h
@@ -18,6 +18,7 @@
 #include <asm/cacheflush.h>
 #include <asm/cachetype.h>
 #include <asm/proc-fns.h>
+#include <asm-generic/mm_hooks.h>
 
 void __check_kvm_seq(struct mm_struct *mm);
 
@@ -133,32 +135,4 @@ switch_mm(struct mm_struct *prev, struct mm_struct *next,
 #define deactivate_mm(tsk,mm)	do { } while (0)
 #define activate_mm(prev,next)	switch_mm(prev, next, NULL)
 
-/*
- * We are inserting a "fake" vma for the user-accessible vector page so
- * gdb and friends can get to it through ptrace and /proc/<pid>/mem.
- * But we also want to remove it before the generic code gets to see it
- * during process exit or the unmapping of it would  cause total havoc.
- * (the macro is used as remove_vma() is static to mm/mmap.c)
- */
-#define arch_exit_mmap(mm) \
-do { \
-	struct vm_area_struct *high_vma = find_vma(mm, 0xffff0000); \
-	if (high_vma) { \
-		BUG_ON(high_vma->vm_next);  /* it should be last */ \
-		if (high_vma->vm_prev) \
-			high_vma->vm_prev->vm_next = NULL; \
-		else \
-			mm->mmap = NULL; \
-		rb_erase(&high_vma->vm_rb, &mm->mm_rb); \
-		mm->mmap_cache = NULL; \
-		mm->map_count--; \
-		remove_vma(high_vma); \
-	} \
-} while (0)
-
-static inline void arch_dup_mmap(struct mm_struct *oldmm,
-				 struct mm_struct *mm)
-{
-}
-
 #endif


Nicolas
