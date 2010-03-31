Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368Ab0CaPvu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 11:51:50 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:46233 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757142Ab0CaPvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 11:51:47 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Date: Wed, 31 Mar 2010 21:21:42 +0530
Message-Id: <20100331155142.4181.44278.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20100331155106.4181.50759.sendpatchset@localhost6.localdomain6>
References: <20100331155106.4181.50759.sendpatchset@localhost6.localdomain6>
Subject: [PATCH v2 3/11] Enhance replace_page() to support pagecache
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance replace_page() to support pagecache

Currently replace_page would work only for anonymous pages.
This patch enhances replace_page() to work for pagecache pages

This enhancement is useful for user_bkpt's replace_page based
background page replacement for insertion and removal of breakpoints.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---

 mm/memory.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)


diff --git a/mm/memory.c b/mm/memory.c
index 66a3632..5acf686 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2617,7 +2617,10 @@ int replace_page(struct vm_area_struct *vma, struct page *page,
 	}
 
 	get_page(kpage);
-	page_add_anon_rmap(kpage, vma, addr);
+	if (PageAnon(kpage))
+		page_add_anon_rmap(kpage, vma, addr);
+	else
+		page_add_file_rmap(kpage);
 
 	flush_cache_page(vma, addr, pte_pfn(*ptep));
 	ptep_clear_flush(vma, addr, ptep);
