Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab2G3ONQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 10:13:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45574 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab2G3ONO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 10:13:14 -0400
Date: Mon, 30 Jul 2012 07:12:18 -0700
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Message-ID: <tip-9f92448ceeea5326db7d114005a7e7ac03904edf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, anton@redhat.com, hpa@zytor.com,
        mingo@kernel.org, srikar@linux.vnet.ibm.com, oleg@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, anton@redhat.com,
        linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20120729182220.GA20322@redhat.com>
References: <20120729182220.GA20322@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] uprobes: Clean up and document write_opcode()->
 lock_page(old_page)
Git-Commit-ID: 9f92448ceeea5326db7d114005a7e7ac03904edf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 30 Jul 2012 07:12:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9f92448ceeea5326db7d114005a7e7ac03904edf
Gitweb:     http://git.kernel.org/tip/9f92448ceeea5326db7d114005a7e7ac03904edf
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Sun, 29 Jul 2012 20:22:20 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 30 Jul 2012 11:27:20 +0200

uprobes: Clean up and document write_opcode()->lock_page(old_page)

The comment above write_opcode()->lock_page(old_page) tells
about the race with do_wp_page(). I don't really understand
which exactly race it means, but afaics this lock_page() was not
enough to close all races with do_wp_page().

Anyway, since:

   77fc4af1b59d uprobes: Change register_for_each_vma() to take mm->mmap_sem for writing

this code is always called with ->mmap_sem held for writing,
so we can forget about do_wp_page().

However, we can't simply remove this lock_page(), and the only
(afaics) reason is __replace_page()->try_to_free_swap().

Nothing in write_opcode() needs it, move it into
__replace_page() and fix the comment.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar.vnet.ibm.com>
Cc: Anton Arapov <anton@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20120729182220.GA20322@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/uprobes.c |   27 ++++++++++++++-------------
 1 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 23c562b7..5db150b 100644
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
