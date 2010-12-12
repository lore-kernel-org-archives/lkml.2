Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab0LLXsO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:48:14 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36668 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755757Ab0LLXsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:48:07 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: penberg@kernel.org, ak@linux.intel.com, mingo@elte.hu,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [180/223] perf_events: Fix perf_counter_mmap() hook in mprotect()
Message-Id: <20101212234805.5FBF2B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:48:05 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Pekka Enberg <penberg@kernel.org>

commit 63bfd7384b119409685a17d5c58f0b56e5dc03da upstream.

As pointed out by Linus, commit dab5855 ("perf_counter: Add mmap event hooks to
mprotect()") is fundamentally wrong as mprotect_fixup() can free 'vma' due to
merging. Fix the problem by moving perf_event_mmap() hook to
mprotect_fixup().

Note: there's another successful return path from mprotect_fixup() if old
flags equal to new flags. We don't, however, need to call
perf_event_mmap() there because 'perf' already knows the VMA is
executable.

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Analyzed-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Reviewed-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/mprotect.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/mm/mprotect.c
===================================================================
--- linux.orig/mm/mprotect.c
+++ linux/mm/mprotect.c
@@ -211,6 +211,7 @@ success:
 	mmu_notifier_invalidate_range_end(mm, start, end);
 	vm_stat_account(mm, oldflags, vma->vm_file, -nrpages);
 	vm_stat_account(mm, newflags, vma->vm_file, nrpages);
+	perf_event_mmap(vma);
 	return 0;
 
 fail:
@@ -299,7 +300,6 @@ SYSCALL_DEFINE3(mprotect, unsigned long,
 		error = mprotect_fixup(vma, &prev, nstart, tmp, newflags);
 		if (error)
 			goto out;
-		perf_event_mmap(vma);
 		nstart = tmp;
 
 		if (nstart < prev->vm_end)
