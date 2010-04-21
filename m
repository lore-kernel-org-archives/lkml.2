Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab0DUK3L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 06:29:11 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34284 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab0DUK3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 06:29:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=wH8B9SpdobBtMkONv7TIFx/kFRuiUQHSzcaYLQVgSMwm+PUVsj+RPLMeKEi+GMyBkI
         GF/onQdrslqTAXBKTV5+YQuQiLkuSJZZnMaa5Rv+d9/opADtvhe+VtGtFZa/0OzznsIY
         cAlYzHdvDCfeyQstJ94rQYldVHLKYR92JGK84=
Date: Wed, 21 Apr 2010 12:27:59 +0200
From: Dan Carpenter <error27@gmail.com>
To: Izik Eidus <ieidus@redhat.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       kernel-janitors@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [patch] ksm: check for ERR_PTR from follow_page()
Message-ID: <20100421102759.GA29647@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Izik Eidus <ieidus@redhat.com>,
	Hugh Dickins <hugh.dickins@tiscali.co.uk>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, kernel-janitors@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The follow_page() function can potentially return -EFAULT so I added 
checks for this.

Also I silenced an uninitialized variable warning on my version of gcc 
(version 4.3.2).

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
I'm not very familiar with this code, so handle with care.

diff --git a/mm/ksm.c b/mm/ksm.c
index 8cdfc2a..956880f 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -365,7 +365,7 @@ static int break_ksm(struct vm_area_struct *vma, unsigned long addr)
 	do {
 		cond_resched();
 		page = follow_page(vma, addr, FOLL_GET);
-		if (!page)
+		if (IS_ERR_OR_NULL(page))
 			break;
 		if (PageKsm(page))
 			ret = handle_mm_fault(vma->vm_mm, vma, addr,
@@ -447,7 +447,7 @@ static struct page *get_mergeable_page(struct rmap_item *rmap_item)
 		goto out;
 
 	page = follow_page(vma, addr, FOLL_GET);
-	if (!page)
+	if (IS_ERR_OR_NULL(page))
 		goto out;
 	if (PageAnon(page)) {
 		flush_anon_page(vma, page, addr);
@@ -1086,7 +1086,7 @@ struct rmap_item *unstable_tree_search_insert(struct rmap_item *rmap_item,
 		cond_resched();
 		tree_rmap_item = rb_entry(*new, struct rmap_item, node);
 		tree_page = get_mergeable_page(tree_rmap_item);
-		if (!tree_page)
+		if (IS_ERR_OR_NULL(tree_page))
 			return NULL;
 
 		/*
@@ -1294,7 +1294,7 @@ next_mm:
 			if (ksm_test_exit(mm))
 				break;
 			*page = follow_page(vma, ksm_scan.address, FOLL_GET);
-			if (*page && PageAnon(*page)) {
+			if (!IS_ERR_OR_NULL(*page) && PageAnon(*page)) {
 				flush_anon_page(vma, *page, ksm_scan.address);
 				flush_dcache_page(*page);
 				rmap_item = get_next_rmap_item(slot,
@@ -1308,7 +1308,7 @@ next_mm:
 				up_read(&mm->mmap_sem);
 				return rmap_item;
 			}
-			if (*page)
+			if (!IS_ERR_OR_NULL(*page))
 				put_page(*page);
 			ksm_scan.address += PAGE_SIZE;
 			cond_resched();
@@ -1367,7 +1367,7 @@ next_mm:
 static void ksm_do_scan(unsigned int scan_npages)
 {
 	struct rmap_item *rmap_item;
-	struct page *page;
+	struct page *uninitialized_var(page);
 
 	while (scan_npages--) {
 		cond_resched();
