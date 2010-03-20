Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888Ab0CTOZi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 10:25:38 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:37737 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806Ab0CTOZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 10:25:34 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Date: Sat, 20 Mar 2010 19:55:28 +0530
Message-Id: <20100320142528.11427.51791.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20100320142455.11427.76925.sendpatchset@localhost6.localdomain6>
References: <20100320142455.11427.76925.sendpatchset@localhost6.localdomain6>
Subject: [PATCH v1 3/10] Enhance replace_page() to support pagecache
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
index 8b3ca1b..cd5541c 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2616,7 +2616,10 @@ int replace_page(struct vm_area_struct *vma, struct page *page,
 	}
 
 	get_page(kpage);
-	page_add_anon_rmap(kpage, vma, addr);
+	if (PageAnon(kpage))
+		page_add_anon_rmap(kpage, vma, addr);
+	else
+		page_add_file_rmap(kpage);
 
 	flush_cache_page(vma, addr, pte_pfn(*ptep));
 	ptep_clear_flush(vma, addr, ptep);
