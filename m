Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab2LUAu5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 19:50:57 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:40522 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab2LUAuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 19:50:21 -0500
From: Michel Lespinasse <walken@google.com>
To: Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Jorn_Engel <joern@logfs.org>, Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/9] mm: use mm_populate() for mremap() of VM_LOCKED vmas
Date: Thu, 20 Dec 2012 16:49:54 -0800
Message-Id: <1356050997-2688-7-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1356050997-2688-1-git-send-email-walken@google.com>
References: <1356050997-2688-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michel Lespinasse <walken@google.com>

---
 mm/mremap.c |   25 +++++++++++++------------
 1 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 1b61c2d3307a..c5a8bf344b1f 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -208,7 +208,7 @@ unsigned long move_page_tables(struct vm_area_struct *vma,
 
 static unsigned long move_vma(struct vm_area_struct *vma,
 		unsigned long old_addr, unsigned long old_len,
-		unsigned long new_len, unsigned long new_addr)
+		unsigned long new_len, unsigned long new_addr, bool *locked)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_area_struct *new_vma;
@@ -299,9 +299,7 @@ static unsigned long move_vma(struct vm_area_struct *vma,
 
 	if (vm_flags & VM_LOCKED) {
 		mm->locked_vm += new_len >> PAGE_SHIFT;
-		if (new_len > old_len)
-			mlock_vma_pages_range(new_vma, new_addr + old_len,
-						       new_addr + new_len);
+		*locked = true;
 	}
 
 	return new_addr;
@@ -366,9 +364,8 @@ Eagain:
 	return ERR_PTR(-EAGAIN);
 }
 
-static unsigned long mremap_to(unsigned long addr,
-	unsigned long old_len, unsigned long new_addr,
-	unsigned long new_len)
+static unsigned long mremap_to(unsigned long addr, unsigned long old_len,
+		unsigned long new_addr, unsigned long new_len, bool *locked)
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
@@ -418,7 +415,7 @@ static unsigned long mremap_to(unsigned long addr,
 	if (ret & ~PAGE_MASK)
 		goto out1;
 
-	ret = move_vma(vma, addr, old_len, new_len, new_addr);
+	ret = move_vma(vma, addr, old_len, new_len, new_addr, locked);
 	if (!(ret & ~PAGE_MASK))
 		goto out;
 out1:
@@ -456,6 +453,7 @@ SYSCALL_DEFINE5(mremap, unsigned long, addr, unsigned long, old_len,
 	struct vm_area_struct *vma;
 	unsigned long ret = -EINVAL;
 	unsigned long charged = 0;
+	bool locked = false;
 
 	down_write(&current->mm->mmap_sem);
 
@@ -478,7 +476,8 @@ SYSCALL_DEFINE5(mremap, unsigned long, addr, unsigned long, old_len,
 
 	if (flags & MREMAP_FIXED) {
 		if (flags & MREMAP_MAYMOVE)
-			ret = mremap_to(addr, old_len, new_addr, new_len);
+			ret = mremap_to(addr, old_len, new_addr, new_len,
+					&locked);
 		goto out;
 	}
 
@@ -520,8 +519,8 @@ SYSCALL_DEFINE5(mremap, unsigned long, addr, unsigned long, old_len,
 			vm_stat_account(mm, vma->vm_flags, vma->vm_file, pages);
 			if (vma->vm_flags & VM_LOCKED) {
 				mm->locked_vm += pages;
-				mlock_vma_pages_range(vma, addr + old_len,
-						   addr + new_len);
+				locked = true;
+				new_addr = addr;
 			}
 			ret = addr;
 			goto out;
@@ -547,11 +546,13 @@ SYSCALL_DEFINE5(mremap, unsigned long, addr, unsigned long, old_len,
 			goto out;
 		}
 
-		ret = move_vma(vma, addr, old_len, new_len, new_addr);
+		ret = move_vma(vma, addr, old_len, new_len, new_addr, &locked);
 	}
 out:
 	if (ret & ~PAGE_MASK)
 		vm_unacct_memory(charged);
 	up_write(&current->mm->mmap_sem);
+	if (locked && new_len > old_len)
+		mm_populate(new_addr + old_len, new_len - old_len);
 	return ret;
 }
-- 
1.7.7.3
