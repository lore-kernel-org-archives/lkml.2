Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932972Ab2AXCwi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:52:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50672 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932897Ab2AXCs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:48:57 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:35 2012
Message-Id: <20120124023934.962874019@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:35:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Will Deacon <will.deacon@arm.com>,
        Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>,
        Russell King <rmk@arm.linux.org.uk>, Nicolas Pitre <nico@linaro.org>,
        Matt Mackall <mpm@selenic.com>
Subject: [124/129] proc: clear_refs: do not clear reserved pages
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 2171
Lines: 58

From: Will Deacon <will.deacon@arm.com>

commit 85e72aa5384b1a614563ad63257ded0e91d1a620 upstream.

/proc/pid/clear_refs is used to clear the Referenced and YOUNG bits for
pages and corresponding page table entries of the task with PID pid, which
includes any special mappings inserted into the page tables in order to
provide things like vDSOs and user helper functions.

On ARM this causes a problem because the vectors page is mapped as a
global mapping and since ec706dab ("ARM: add a vma entry for the user
accessible vector page"), a VMA is also inserted into each task for this
page to aid unwinding through signals and syscall restarts.  Since the
vectors page is required for handling faults, clearing the YOUNG bit (and
subsequently writing a faulting pte) means that we lose the vectors page
*globally* and cannot fault it back in.  This results in a system deadlock
on the next exception.

To see this problem in action, just run:

	$ echo 1 > /proc/self/clear_refs

on an ARM platform (as any user) and watch your system hang.  I think this
has been the case since 2.6.37

This patch avoids clearing the aforementioned bits for reserved pages,
therefore leaving the vectors page intact on ARM.  Since reserved pages
are not candidates for swap, this change should not have any impact on the
usefulness of clear_refs.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Reported-by: Moussa Ba <moussaba@micron.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Acked-by: Nicolas Pitre <nico@linaro.org>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/proc/task_mmu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -518,6 +518,9 @@ static int clear_refs_pte_range(pmd_t *p
 		if (!page)
 			continue;
 
+		if (PageReserved(page))
+			continue;
+
 		/* Clear accessed and referenced bits. */
 		ptep_test_and_clear_young(vma, addr, pte);
 		ClearPageReferenced(page);


