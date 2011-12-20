Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207Ab1LTNp4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 08:45:56 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39945 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab1LTNpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 08:45:52 -0500
MIME-Version: 1.0
Date: Tue, 20 Dec 2011 21:45:51 +0800
Message-ID: <CAJd=RBDC9hxAFbbTvSWVa=t1kuyBH8=UoTYxRDtDm6iXLGkQWg@mail.gmail.com>
Subject: [PATCH] mm: hugetlb: fix pgoff computation when unmapping page from vma
From: Hillf Danton <dhillf@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The computation for pgoff is incorrect, at least with

	(vma->vm_pgoff >> PAGE_SHIFT)

involved. It is fixed with the available method if HPAGE_SIZE is concerned in
page cache lookup.

Cc: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/mm/hugetlb.c	Tue Dec 20 21:26:30 2011
+++ b/mm/hugetlb.c	Tue Dec 20 21:40:44 2011
@@ -2315,8 +2315,7 @@ static int unmap_ref_private(struct mm_s
 	 * from page cache lookup which is in HPAGE_SIZE units.
 	 */
 	address = address & huge_page_mask(h);
-	pgoff = ((address - vma->vm_start) >> PAGE_SHIFT)
-		+ (vma->vm_pgoff >> PAGE_SHIFT);
+	pgoff = linear_hugepage_index(vma, address);
 	mapping = (struct address_space *)page_private(page);

 	/*
