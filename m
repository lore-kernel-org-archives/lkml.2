Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab2LUAuv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 19:50:51 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:53245 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab2LUAuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 19:50:19 -0500
From: Michel Lespinasse <walken@google.com>
To: Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Jorn_Engel <joern@logfs.org>, Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/9] mm: use mm_populate() when adjusting brk with MCL_FUTURE in effect.
Date: Thu, 20 Dec 2012 16:49:53 -0800
Message-Id: <1356050997-2688-6-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1356050997-2688-1-git-send-email-walken@google.com>
References: <1356050997-2688-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michel Lespinasse <walken@google.com>

---
 mm/mmap.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index a16fc499dbd1..4c8d39e64e80 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -240,6 +240,7 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
 	unsigned long newbrk, oldbrk;
 	struct mm_struct *mm = current->mm;
 	unsigned long min_brk;
+	bool populate;
 
 	down_write(&mm->mmap_sem);
 
@@ -289,8 +290,15 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
 	/* Ok, looks good - let it rip. */
 	if (do_brk(oldbrk, newbrk-oldbrk) != oldbrk)
 		goto out;
+
 set_brk:
 	mm->brk = brk;
+	populate = newbrk > oldbrk && (mm->def_flags & VM_LOCKED) != 0;
+	up_write(&mm->mmap_sem);
+	if (populate)
+		mm_populate(oldbrk, newbrk - oldbrk);
+	return brk;
+
 out:
 	retval = mm->brk;
 	up_write(&mm->mmap_sem);
@@ -2274,10 +2282,8 @@ static unsigned long do_brk(unsigned long addr, unsigned long len)
 out:
 	perf_event_mmap(vma);
 	mm->total_vm += len >> PAGE_SHIFT;
-	if (flags & VM_LOCKED) {
-		if (!mlock_vma_pages_range(vma, addr, addr + len))
-			mm->locked_vm += (len >> PAGE_SHIFT);
-	}
+	if (flags & VM_LOCKED)
+		mm->locked_vm += (len >> PAGE_SHIFT);
 	return addr;
 }
 
@@ -2285,10 +2291,14 @@ unsigned long vm_brk(unsigned long addr, unsigned long len)
 {
 	struct mm_struct *mm = current->mm;
 	unsigned long ret;
+	bool populate;
 
 	down_write(&mm->mmap_sem);
 	ret = do_brk(addr, len);
+	populate = ((mm->def_flags & VM_LOCKED) != 0);
 	up_write(&mm->mmap_sem);
+	if (populate)
+		mm_populate(addr, len);
 	return ret;
 }
 EXPORT_SYMBOL(vm_brk);
-- 
1.7.7.3
