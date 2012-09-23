Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab2IWUTK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 16:19:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754404Ab2IWUSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 16:18:10 -0400
Date: Sun, 23 Sep 2012 22:19:50 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] uprobes: Kill set_orig_insn()->is_swbp_at_addr()
Message-ID: <20120923201950.GA27456@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120923201921.GA27424@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unlike set_swbp(), set_orig_insn()->is_swbp_at_addr() makes sense,
although it can't prevent all confusions.

But the usage of is_swbp_at_addr() is equally confusing, and it adds
the extra get_user_pages() we can avoid.

This patch removes set_orig_insn()->is_swbp_at_addr() but changes
write_opcode() to do the necessary checks before replace_page().

Perhaps it also makes sense to ensure PAGE_MAPPING_ANON in unregister
case.

find_active_uprobe() becomes the only user of is_swbp_at_addr(),
we can change its semantics.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |   32 +++++++++++++++++++++++---------
 1 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 100a920..17454fb 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -190,6 +190,25 @@ static void copy_opcode(struct page *page, unsigned long vaddr, uprobe_opcode_t
 	kunmap_atomic(kaddr);
 }
 
+static int verify_opcode(struct page *page, unsigned long vaddr, uprobe_opcode_t *new_opcode)
+{
+	uprobe_opcode_t old_opcode;
+	bool is_swbp;
+
+	copy_opcode(page, vaddr, &old_opcode);
+	is_swbp = is_swbp_insn(&old_opcode);
+
+	if (is_swbp_insn(new_opcode)) {
+		if (is_swbp)		/* register: already installed? */
+			return 0;
+	} else {
+		if (!is_swbp)		/* unregister: was it changed by us? */
+			return -EINVAL;
+	}
+
+	return 1;
+}
+
 /*
  * NOTE:
  * Expect the breakpoint instruction to be the smallest size instruction for
@@ -226,6 +245,10 @@ retry:
 	if (ret <= 0)
 		return ret;
 
+	ret = verify_opcode(old_page, vaddr, &opcode);
+	if (ret <= 0)
+		goto put_old;
+
 	ret = -ENOMEM;
 	new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, vaddr);
 	if (!new_page)
@@ -311,15 +334,6 @@ int __weak set_swbp(struct arch_uprobe *auprobe, struct mm_struct *mm, unsigned
 int __weak
 set_orig_insn(struct arch_uprobe *auprobe, struct mm_struct *mm, unsigned long vaddr)
 {
-	int result;
-
-	result = is_swbp_at_addr(mm, vaddr);
-	if (!result)
-		return -EINVAL;
-
-	if (result != 1)
-		return result;
-
 	return write_opcode(mm, vaddr, *(uprobe_opcode_t *)auprobe->insn);
 }
 
-- 
1.5.5.1

