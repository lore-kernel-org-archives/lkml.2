Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268Ab2E3SDv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 14:03:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:50166 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756327Ab2E3SDu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 14:03:50 -0400
Message-ID: <1338401016.28384.17.camel@twins>
Subject: Re: [PATCH 1/3] uprobes: install_breakpoint() should fail if
 is_swbp_insn() == T
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 30 May 2012 20:03:36 +0200
In-Reply-To: <1338400450.28384.16.camel@twins>
References: <20120530165757.GA8077@redhat.com>
	 <20120530165816.GA8085@redhat.com> <1338398931.28384.7.camel@twins>
	 <20120530173717.GM15587@linux.vnet.ibm.com>
	 <1338400142.28384.12.camel@twins> <1338400450.28384.16.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-30 at 19:54 +0200, Peter Zijlstra wrote:
> Something like so?

---
 kernel/events/uprobes.c |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 985be4d..16f986d 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -45,6 +45,19 @@ static DEFINE_SPINLOCK(uprobes_treelock);	/* serialize rbtree access */
 
 #define UPROBES_HASH_SZ	13
 
+/*
+ * We need separate register/unregister and mmap/munmap lock hashes because of
+ * mmap_sem nesting.
+ *
+ * {,un}egister_uprobe() need to install probes on (potentially) all processes
+ * and thus need to acquire multiple mmap_sems (consequtively, not
+ * concurrently), whereas uprobe_m{,un}map() are called while holding mmap_sem
+ * for the particular process doing the mmap.
+ *
+ * This all means that register_uprobe() can race with uprobe_mmap() and we
+ * can try and install a probe where one is already installed.
+ */
+
 /* serialize (un)register */
 static struct mutex uprobes_mutex[UPROBES_HASH_SZ];
 
@@ -356,6 +369,9 @@ int __weak set_swbp(struct arch_uprobe *auprobe, struct mm_struct *mm, unsigned
 {
 	int result;
 
+	/*
+	 * See the comment near uprobes_hash().
+	 */
 	result = is_swbp_at_addr(mm, vaddr);
 	if (result == 1)
 		return -EEXIST;
@@ -870,6 +886,10 @@ static int register_for_each_vma(struct uprobe *uprobe, bool is_register)
 		up_read(&mm->mmap_sem);
 		mmput(mm);
 		if (is_register) {
+			/*
+			 * We can race against uprobe_mmap() see the comment
+			 * near uprobe_hash().
+			 */
 			if (ret && ret == -EEXIST)
 				ret = 0;
 			if (ret)
@@ -1080,7 +1100,10 @@ int uprobe_mmap(struct vm_area_struct *vma)
 
 			ret = install_breakpoint(uprobe, vma->vm_mm, vma, vaddr);
 
-			/* Ignore double add: */
+			/* 
+			 * We can race against register_uprobe(), see the
+			 * comment near uprobe_hash().
+			 */
 			if (ret == -EEXIST) {
 				ret = 0;
 

