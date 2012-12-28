Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab2L1SNf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 13:13:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851Ab2L1SNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 13:13:31 -0500
Date: Fri, 28 Dec 2012 19:13:14 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] uprobes: Reintroduce uprobe_consumer->filter()
Message-ID: <20121228181314.GA6141@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121228181252.GA6120@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Finally add uprobe_consumer->filter() and change consumer_filter()
to actually call this method.

Note that ->filter() accepts mm_struct, not task_struct. Because:

	1. We do not have for_each_mm_user(mm, task).

	2. Even if we implement for_each_mm_user(), ->filter() can
	   use it itself.

	3. It is not clear who will actually need this interface to
	   do the "nontrivial" filtering.

Another argument is "enum uprobe_filter_ctx", consumer->filter() can
use it to figure out why/where it was called. For example, perhaps
we can add UPROBE_FILTER_PRE_REGISTER used by build_map_info() to
quickly "nack" the unwanted mm's. In this case consumer should know
that it is called under ->i_mmap_mutex.

See the previous discussion at http://marc.info/?t=135214229700002
Perhaps we should pass more arguments, vma/vaddr?

Note: this patch obviously can't help to filter out the child created
by fork(), this will be addressed later.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/uprobes.h |    9 +++++++++
 kernel/events/uprobes.c |   18 +++++++++++-------
 2 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index 83742b9..c2df693 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -35,8 +35,17 @@ struct inode;
 # include <asm/uprobes.h>
 #endif
 
+enum uprobe_filter_ctx {
+	UPROBE_FILTER_REGISTER,
+	UPROBE_FILTER_UNREGISTER,
+	UPROBE_FILTER_MMAP,
+};
+
 struct uprobe_consumer {
 	int (*handler)(struct uprobe_consumer *self, struct pt_regs *regs);
+	bool (*filter)(struct uprobe_consumer *self,
+				enum uprobe_filter_ctx ctx,
+				struct mm_struct *mm);
 
 	struct uprobe_consumer *next;
 };
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 60b0a90..e2ebb6f 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -579,19 +579,21 @@ static int prepare_uprobe(struct uprobe *uprobe, struct file *file,
 	return ret;
 }
 
-static inline bool consumer_filter(struct uprobe_consumer *uc)
+static inline bool consumer_filter(struct uprobe_consumer *uc,
+				   enum uprobe_filter_ctx ctx, struct mm_struct *mm)
 {
-	return true; /* TODO: !uc->filter || uc->filter(...) */
+	return !uc->filter || uc->filter(uc, ctx, mm);
 }
 
-static bool filter_chain(struct uprobe *uprobe)
+static bool filter_chain(struct uprobe *uprobe,
+			 enum uprobe_filter_ctx ctx, struct mm_struct *mm)
 {
 	struct uprobe_consumer *uc;
 	bool ret = false;
 
 	down_read(&uprobe->consumer_rwsem);
 	for (uc = uprobe->consumers; uc; uc = uc->next) {
-		ret = consumer_filter(uc);
+		ret = consumer_filter(uc, ctx, mm);
 		if (ret)
 			break;
 	}
@@ -772,10 +774,12 @@ static int register_for_each_vma(struct uprobe *uprobe, bool is_register)
 
 		if (is_register) {
 			/* consult only the "caller", new consumer. */
-			if (consumer_filter(uprobe->consumers))
+			if (consumer_filter(uprobe->consumers,
+					UPROBE_FILTER_REGISTER, mm))
 				err = install_breakpoint(uprobe, mm, vma, info->vaddr);
 		} else if (test_bit(MMF_HAS_UPROBES, &mm->flags)) {
-			if (!filter_chain(uprobe))
+			if (!filter_chain(uprobe,
+					UPROBE_FILTER_UNREGISTER, mm))
 				err |= remove_breakpoint(uprobe, mm, info->vaddr);
 		}
 
@@ -968,7 +972,7 @@ int uprobe_mmap(struct vm_area_struct *vma)
 	 */
 	list_for_each_entry_safe(uprobe, u, &tmp_list, pending_list) {
 		if (!fatal_signal_pending(current) &&
-		    filter_chain(uprobe)) {
+		    filter_chain(uprobe, UPROBE_FILTER_MMAP, vma->vm_mm)) {
 			unsigned long vaddr = offset_to_vaddr(vma, uprobe->offset);
 			install_breakpoint(uprobe, vma->vm_mm, vma, vaddr);
 		}
-- 
1.5.5.1

