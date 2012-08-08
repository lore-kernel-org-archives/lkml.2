Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759081Ab2HHRlH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 13:41:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62247 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759051Ab2HHRlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 13:41:02 -0400
Date: Wed, 8 Aug 2012 19:37:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] uprobes: do not use -EEXIST in install_breakpoint()
	paths
Message-ID: <20120808173744.GA13269@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120808173659.GA13220@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-EEXIST from install_breakpoint() no longer makes sense, all
callers should simply treat it as "success". Change the code
to return zero and simplify register_for_each_vma().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |   16 +++++-----------
 1 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 2e269d1..309309e 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -334,7 +334,7 @@ int __weak set_swbp(struct arch_uprobe *auprobe, struct mm_struct *mm, unsigned
 	 */
 	result = is_swbp_at_addr(mm, vaddr);
 	if (result == 1)
-		return -EEXIST;
+		return 0;
 
 	if (result)
 		return result;
@@ -659,7 +659,7 @@ install_breakpoint(struct uprobe *uprobe, struct mm_struct *mm,
 	 * Hence behave as if probe already existed.
 	 */
 	if (!uprobe->consumers)
-		return -EEXIST;
+		return 0;
 
 	if (!(uprobe->flags & UPROBE_COPY_INSN)) {
 		ret = copy_insn(uprobe, vma->vm_file);
@@ -819,17 +819,11 @@ static int register_for_each_vma(struct uprobe *uprobe, bool is_register)
 		    vaddr_to_offset(vma, info->vaddr) != uprobe->offset)
 			goto unlock;
 
-		if (is_register) {
+		if (is_register)
 			err = install_breakpoint(uprobe, mm, vma, info->vaddr);
-			/*
-			 * We can race against uprobe_mmap(), see the
-			 * comment near uprobe_hash().
-			 */
-			if (err == -EEXIST)
-				err = 0;
-		} else {
+		else
 			remove_breakpoint(uprobe, mm, info->vaddr);
-		}
+
  unlock:
 		up_write(&mm->mmap_sem);
  free:
-- 
1.5.5.1

