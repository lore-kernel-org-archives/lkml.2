Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab1JOTFW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 15:05:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448Ab1JOTFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 15:05:20 -0400
Date: Sat, 15 Oct 2011 21:00:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/X] uprobes: write_opcode() needs put_page(new_page)
	unconditionally
Message-ID: <20111015190057.GC30243@redhat.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com> <20111015190007.GA30243@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111015190007.GA30243@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every write_opcode()->__replace_page() leaks the new page on success.

We have the reference after alloc_page_vma(), then __replace_page()
does another get_page() for the new mapping, we need put_page(new_page)
in any case.

Alternatively we could remove __replace_page()->get_page() but it is
better to change write_opcode(). This way it is simpler to unify the
code with ksm.c:replace_page() and we can simplify the error handling
in write_opcode(), the patch simply adds a single page_cache_release()
under "unlock_out" label.
---
 kernel/uprobes.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/kernel/uprobes.c b/kernel/uprobes.c
index 52b20c8..fd9c8e3 100644
--- a/kernel/uprobes.c
+++ b/kernel/uprobes.c
@@ -193,15 +193,12 @@ static int write_opcode(struct task_struct *tsk, struct uprobe * uprobe,
 	if (vaddr != (unsigned long) addr)
 		goto put_out;
 
-	/* Allocate a page */
+	ret = -ENOMEM;
 	new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, vaddr);
-	if (!new_page) {
-		ret = -ENOMEM;
+	if (!new_page)
 		goto put_out;
-	}
 
 	__SetPageUptodate(new_page);
-
 	/*
 	 * lock page will serialize against do_wp_page()'s
 	 * PageAnon() handling
@@ -220,18 +217,16 @@ static int write_opcode(struct task_struct *tsk, struct uprobe * uprobe,
 	kunmap_atomic(vaddr_old);
 
 	ret = anon_vma_prepare(vma);
-	if (ret) {
-		page_cache_release(new_page);
+	if (ret)
 		goto unlock_out;
-	}
 
 	lock_page(new_page);
 	ret = __replace_page(vma, old_page, new_page);
 	unlock_page(new_page);
-	if (ret != 0)
-		page_cache_release(new_page);
+
 unlock_out:
 	unlock_page(old_page);
+	page_cache_release(new_page);
 
 put_out:
 	put_page(old_page); /* we did a get_page in the beginning */
-- 
1.5.5.1


