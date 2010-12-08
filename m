Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932749Ab0LHBDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:03:35 -0500
Received: from kroah.org ([198.145.64.141]:33736 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932736Ab0LHBDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:03:32 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:45 2010
Message-Id: <20101208005745.295405482@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 17:00:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@kernel.org>
Subject: [239/289] perf_events: Fix perf_counter_mmap() hook in mprotect()
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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
Analyzed-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Reviewed-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/mprotect.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mprotect.c
+++ b/mm/mprotect.c
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


