Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312Ab2DEWV7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 18:21:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38134 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756282Ab2DEWVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 18:21:44 -0400
Date: Fri, 6 Apr 2012 00:21:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Anton Arapov <anton@redhat.com>
Subject: [PATCH 2/6] uprobes: introduce is_swbp_at_addr_fast()
Message-ID: <20120405222106.GB19166@redhat.com>
References: <20120405222024.GA19154@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120405222024.GA19154@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the new helper, is_swbp_at_addr_fast(), will be used by
find_active_uprobe().

It is almost the same as is_swbp_at_addr(), but since it plays
with current->mm it can avoid the slow get_user_pages() in the
likely case.
---
 kernel/events/uprobes.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 3d0a4d6..2050b1a 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1474,6 +1474,29 @@ static bool can_skip_sstep(struct uprobe *uprobe, struct pt_regs *regs)
 	return false;
 }
 
+int __weak is_swbp_at_addr_fast(unsigned long vaddr)
+{
+	uprobe_opcode_t opcode;
+	int fault;
+
+	pagefault_disable();
+	fault = __copy_from_user_inatomic(&opcode, (void __user*)vaddr,
+							sizeof(opcode));
+	pagefault_enable();
+
+	if (unlikely(fault)) {
+		/*
+		 * XXX: read_opcode() lacks FOLL_FORCE, it can fail if
+		 * we race with another thread which does mprotect(NONE)
+		 * after we hit bp.
+		 */
+		if (read_opcode(current->mm, vaddr, &opcode))
+			return -EFAULT;
+	}
+
+	return is_swbp_insn(&opcode);
+}
+
 static struct uprobe *find_active_uprobe(unsigned long bp_vaddr)
 {
 	struct mm_struct *mm = current->mm;
-- 
1.5.5.1


