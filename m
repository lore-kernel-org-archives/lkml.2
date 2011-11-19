Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab1KSLuW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 06:50:22 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:45407 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679Ab1KSLuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 06:50:21 -0500
MIME-Version: 1.0
Date: Sat, 19 Nov 2011 19:50:19 +0800
Message-ID: <CAJd=RBDP_z68Ewvw_O_dMxOnE0=weXqt+1FQy85_n76HAEdFHg@mail.gmail.com>
Subject: [PATCH] ksm: use FAULT_FLAG_ALLOW_RETRY in breaking COW
From: Hillf Danton <dhillf@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The flag, FAULT_FLAG_ALLOW_RETRY, was introduced by the patch,

	mm: retry page fault when blocking on disk transfer
	commit: d065bd810b6deb67d4897a14bfe21f8eb526ba99

for reducing mmap_sem hold times that are caused by waiting for disk
transfers when accessing file mapped VMAs.

To break COW, handle_mm_fault() is repeated with mmap_sem held, where
the introduced flag could be used again.

The straight way is to add changes in break_ksm(), but the function could be
under write-mode mmap_sem, so it has to be dupilcated.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/mm/ksm.c	Sat Nov 19 16:08:10 2011
+++ b/mm/ksm.c	Sat Nov 19 19:33:49 2011
@@ -394,7 +394,31 @@ static void break_cow(struct rmap_item *
 		goto out;
 	if (!(vma->vm_flags & VM_MERGEABLE) || !vma->anon_vma)
 		goto out;
-	break_ksm(vma, addr);
+	for (;;) {
+		struct page *page;
+		int ret;
+
+		page = follow_page(vma, addr, FOLL_GET);
+		if (IS_ERR_OR_NULL(page))
+			break;
+
+		if (PageKsm(page))
+			ret = handle_mm_fault(mm, vma, addr,
+				FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_WRITE);
+		else
+			ret = VM_FAULT_WRITE;
+
+		put_page(page);
+
+		if (!(ret & (VM_FAULT_WRITE|VM_FAULT_SIGBUS|VM_FAULT_OOM))) {
+			if (ret & VM_FAULT_RETRY)
+				down_read(&mm->mmap_sem);
+		} else {
+			if (ret & VM_FAULT_RETRY)
+				return;
+			break;
+		}
+	}
 out:
 	up_read(&mm->mmap_sem);
 }
