Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382Ab2E3SVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 14:21:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:50442 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757181Ab2E3SVO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 14:21:14 -0400
Message-ID: <1338402061.28384.22.camel@twins>
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
Date: Wed, 30 May 2012 20:21:01 +0200
In-Reply-To: <20120530180409.GO15587@linux.vnet.ibm.com>
References: <20120530165757.GA8077@redhat.com>
	 <20120530165816.GA8085@redhat.com> <1338398931.28384.7.camel@twins>
	 <20120530173717.GM15587@linux.vnet.ibm.com>
	 <1338400142.28384.12.camel@twins> <1338400450.28384.16.camel@twins>
	 <20120530180409.GO15587@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-30 at 23:34 +0530, Srikar Dronamraju wrote:
> Nit: {,un}egister_uprobe should have been uprobe_{,un}register  at
> couple of places. 

Ah indeed.. very silly.. hopefully last version.


---
Subject: uprobe: Document uprobe_register() vs uprobe_mmap() race

Because the mind is treacherous and makes us forget we need to write
stuff down.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/events/uprobes.c |   29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 985be4d..fd6fb30 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -45,6 +45,23 @@ static DEFINE_SPINLOCK(uprobes_treelock);	/* serialize rbtree access */
 
 #define UPROBES_HASH_SZ	13
 
+/*
+ * We need separate register/unregister and mmap/munmap lock hashes because of
+ * mmap_sem nesting.
+ *
+ * uprobe_register() needs to install probes on (potentially) all processes
+ * and thus needs to acquire multiple mmap_sems (consequtively, not
+ * concurrently), whereas uprobe_mmap() is called while holding mmap_sem
+ * for the particular process doing the mmap.
+ *
+ * uprobe_register()->register_for_each_vma() needs to drop/acquire mmap_sem
+ * because of lock order against i_mmap_mutex. This means there's a hole in the
+ * register vma iteration where a mmap() can happen.
+ *
+ * Thus uprobe_register() can race with uprobe_mmap() and we can try and
+ * install a probe where one is already installed.
+ */
+
 /* serialize (un)register */
 static struct mutex uprobes_mutex[UPROBES_HASH_SZ];
 
@@ -356,6 +373,9 @@ int __weak set_swbp(struct arch_uprobe *auprobe, struct mm_struct *mm, unsigned
 {
 	int result;
 
+	/*
+	 * See the comment near uprobes_hash().
+	 */
 	result = is_swbp_at_addr(mm, vaddr);
 	if (result == 1)
 		return -EEXIST;
@@ -870,6 +890,10 @@ static int register_for_each_vma(struct uprobe *uprobe, bool is_register)
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
@@ -1080,7 +1104,10 @@ int uprobe_mmap(struct vm_area_struct *vma)
 
 			ret = install_breakpoint(uprobe, vma->vm_mm, vma, vaddr);
 
-			/* Ignore double add: */
+			/* 
+			 * We can race against uprobe_register(), see the
+			 * comment near uprobe_hash().
+			 */
 			if (ret == -EEXIST) {
 				ret = 0;
 

