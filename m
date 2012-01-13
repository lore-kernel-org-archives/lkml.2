Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997Ab2AMLrr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 06:47:47 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:48035 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756121Ab2AMLrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 06:47:45 -0500
Message-ID: <4F101969.8050601@linux.vnet.ibm.com>
Date: Fri, 13 Jan 2012 19:45:45 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        William Irwin <wli@holomorphy.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] hugetlb: try to search again if it is really needed
References: <4F101904.8090405@linux.vnet.ibm.com>
In-Reply-To: <4F101904.8090405@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12011301-1618-0000-0000-000000888E1D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Search again only if some holes may be skipped in the first time

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/mm/hugetlbpage.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/hugetlbpage.c b/arch/x86/mm/hugetlbpage.c
index e12debc..6bf5735 100644
--- a/arch/x86/mm/hugetlbpage.c
+++ b/arch/x86/mm/hugetlbpage.c
@@ -309,9 +309,8 @@ static unsigned long hugetlb_get_unmapped_area_topdown(struct file *file,
 	struct hstate *h = hstate_file(file);
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
-	unsigned long base = mm->mmap_base, addr = addr0;
+	unsigned long base = mm->mmap_base, addr = addr0, start_addr;
 	unsigned long largest_hole = mm->cached_hole_size;
-	int first_time = 1;

 	/* don't allow allocations above current base */
 	if (mm->free_area_cache > base)
@@ -322,6 +321,8 @@ static unsigned long hugetlb_get_unmapped_area_topdown(struct file *file,
 		mm->free_area_cache  = base;
 	}
 try_again:
+	start_addr = mm->free_area_cache;
+
 	/* make sure it can fit in the remaining address space */
 	if (mm->free_area_cache < len)
 		goto fail;
@@ -357,10 +358,9 @@ fail:
 	 * if hint left us with no space for the requested
 	 * mapping then try again:
 	 */
-	if (first_time) {
+	if (start_addr != base) {
 		mm->free_area_cache = base;
 		largest_hole = 0;
-		first_time = 0;
 		goto try_again;
 	}
 	/*
-- 
1.7.7.5

