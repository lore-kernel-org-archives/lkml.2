Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455Ab2DKKnE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 06:43:04 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:42139 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757167Ab2DKKnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 06:43:02 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Oleg Nesterov <oleg@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Anton Arapov <anton@redhat.com>
Date: Wed, 11 Apr 2012 16:05:16 +0530
Message-Id: <20120411103516.23245.2700.sendpatchset@srdronam.in.ibm.com>
Subject: [PATCH 1/2] uprobes/core: Make background page replacement logic account for rss_stat counters
x-cbid: 12041110-5816-0000-0000-000002183271
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

Background page replacement logic adds a new anonymous page instead of a
filebacked(while inserting a breakpoint) / anonymous page(while removing a
breakpoint). Hence logic should take care to update the rss_stat counters
accordingly. This bug became apparent courtesy commit c3f0327f8e9d7

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 kernel/events/uprobes.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 29e881b..c5caeec 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -160,6 +160,11 @@ static int __replace_page(struct vm_area_struct *vma, struct page *page, struct 
 	get_page(kpage);
 	page_add_new_anon_rmap(kpage, vma, addr);
 
+	if (!PageAnon(page)) {
+		dec_mm_counter(mm, MM_FILEPAGES);
+		inc_mm_counter(mm, MM_ANONPAGES);
+	}
+
 	flush_cache_page(vma, addr, pte_pfn(*ptep));
 	ptep_clear_flush(vma, addr, ptep);
 	set_pte_at_notify(mm, addr, ptep, mk_pte(kpage, vma->vm_page_prot));


