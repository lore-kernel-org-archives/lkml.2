Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab2FSTu6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 15:50:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753658Ab2FSTu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 15:50:56 -0400
Date: Tue, 19 Jun 2012 21:47:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] uprobes: write_opcode: alloc the new page outside of
	"retry" loop
Message-ID: <20120619194759.GE30146@redhat.com>
References: <20120619194636.GA30137@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120619194636.GA30137@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is ugly to free and re-alloc new_page if write_opcode() needs to
retry. Move alloc_page_vma/page_cache_release outside of "retry" loop.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |   26 +++++++++++---------------
 1 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 442064d..3fd7bdf 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -214,19 +214,18 @@ static int write_opcode(struct arch_uprobe *auprobe, struct mm_struct *mm,
 	struct vm_area_struct *vma;
 	int ret;
 
-retry:
-	/* Read the page with vaddr into memory */
-	ret = get_user_pages(NULL, mm, vaddr, 1, 0, 0, &old_page, &vma);
-	if (ret <= 0)
-		return ret;
-
-	ret = -ENOMEM;
 	new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, vaddr);
 	if (!new_page)
-		goto put_old;
+		return -ENOMEM;
 
 	__SetPageUptodate(new_page);
 
+ retry:
+	/* Read the page with vaddr into memory */
+	ret = get_user_pages(NULL, mm, vaddr, 1, 0, 0, &old_page, &vma);
+	if (ret <= 0)
+		goto out;
+
 	/* copy the page now that we've got it stable */
 	vaddr_old = kmap_atomic(old_page);
 	vaddr_new = kmap_atomic(new_page);
@@ -238,18 +237,15 @@ retry:
 	kunmap_atomic(vaddr_old);
 
 	ret = anon_vma_prepare(vma);
-	if (ret)
-		goto put_new;
+	if (!ret)
+		ret = __replace_page(vma, vaddr, old_page, new_page);
 
-	ret = __replace_page(vma, vaddr, old_page, new_page);
-
-put_new:
-	page_cache_release(new_page);
-put_old:
 	put_page(old_page);
 
 	if (unlikely(ret == -EAGAIN))
 		goto retry;
+ out:
+	page_cache_release(new_page);
 	return ret;
 }
 
-- 
1.5.5.1


