Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933499Ab1DNRus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:50:48 -0400
Received: from mail.windriver.com ([147.11.1.11]:38574 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933455Ab1DNRrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:47:24 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Pekka Enberg <penberg@kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 095/209] perf_events: Fix perf_counter_mmap() hook in mprotect()
Date: Thu, 14 Apr 2011 13:42:05 -0400
Message-Id: <1302803039-9400-96-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@kernel.org>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

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
Analyzed-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Reviewed-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 mm/mprotect.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 2d1bf7c..4c51338 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -211,6 +211,7 @@ success:
 	mmu_notifier_invalidate_range_end(mm, start, end);
 	vm_stat_account(mm, oldflags, vma->vm_file, -nrpages);
 	vm_stat_account(mm, newflags, vma->vm_file, nrpages);
+	perf_event_mmap(vma);
 	return 0;
 
 fail:
@@ -299,7 +300,6 @@ SYSCALL_DEFINE3(mprotect, unsigned long, start, size_t, len,
 		error = mprotect_fixup(vma, &prev, nstart, tmp, newflags);
 		if (error)
 			goto out;
-		perf_event_mmap(vma);
 		nstart = tmp;
 
 		if (nstart < prev->vm_end)
-- 
1.7.4.4

