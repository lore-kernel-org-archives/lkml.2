Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab2FXPDN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 11:03:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932073Ab2FXPDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 11:03:11 -0400
Date: Sun, 24 Jun 2012 17:00:53 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/5] uprobes: cleanup and document
	write_opcode()->lock_page(old_page)
Message-ID: <20120624150053.GD23277@redhat.com>
References: <20120624145936.GA23269@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120624145936.GA23269@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment above write_opcode()->lock_page(old_page) tells about
the race with do_wp_page(). I don't really understand which exactly
race it means, but afaics this lock_page() was not enough to close
all races with do_wp_page().

Anyway, since 77fc4af1 this code is always called with ->mmap_sem
hold for writing so we can forget about do_wp_page().

However, we can't simply remove this lock_page(), and the only
(afaics) reason is __replace_page()->try_to_free_swap().

Nothing in write_opcode() needs it, move it into __replace_page()
and fix the comment.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |   27 ++++++++++++++-------------
 1 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 23c562b..5db150b 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -139,10 +139,15 @@ static int __replace_page(struct vm_area_struct *vma, unsigned long addr,
 	struct mm_struct *mm = vma->vm_mm;
 	spinlock_t *ptl;
 	pte_t *ptep;
+	int err;
 
+	/* freeze PageSwapCache() for try_to_free_swap() below */
+	lock_page(page);
+
+	err = -EAGAIN;
 	ptep = page_check_address(page, mm, addr, &ptl, 0);
 	if (!ptep)
-		return -EAGAIN;
+		goto unlock;
 
 	get_page(kpage);
 	page_add_new_anon_rmap(kpage, vma, addr);
@@ -162,7 +167,10 @@ static int __replace_page(struct vm_area_struct *vma, unsigned long addr,
 	put_page(page);
 	pte_unmap_unlock(ptep, ptl);
 
-	return 0;
+	err = 0;
+ unlock:
+	unlock_page(page);
+	return err;
 }
 
 /**
@@ -216,15 +224,10 @@ retry:
 	ret = -ENOMEM;
 	new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, vaddr);
 	if (!new_page)
-		goto put_out;
+		goto put_old;
 
 	__SetPageUptodate(new_page);
 
-	/*
-	 * lock page will serialize against do_wp_page()'s
-	 * PageAnon() handling
-	 */
-	lock_page(old_page);
 	/* copy the page now that we've got it stable */
 	vaddr_old = kmap_atomic(old_page);
 	vaddr_new = kmap_atomic(new_page);
@@ -237,15 +240,13 @@ retry:
 
 	ret = anon_vma_prepare(vma);
 	if (ret)
-		goto unlock_out;
+		goto put_new;
 
 	ret = __replace_page(vma, vaddr, old_page, new_page);
 
-unlock_out:
-	unlock_page(old_page);
+put_new:
 	page_cache_release(new_page);
-
-put_out:
+put_old:
 	put_page(old_page);
 
 	if (unlikely(ret == -EAGAIN))
-- 
1.5.5.1


