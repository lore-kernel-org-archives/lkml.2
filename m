Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085Ab2IPRvA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 13:51:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753008Ab2IPRu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 13:50:56 -0400
Date: Sun, 16 Sep 2012 19:52:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] uprobes: Restrict valid_vma(false) to skip VM_SHARED
Message-ID: <20120916175248.GA32373@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120916175210.GA32337@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

valid_vma(false) ignores ->vm_flags, this is not actually right.
We should never try to write into MAP_SHARED mapping, this can
confuse an apllication which actually writes to ->vm_file.

With this patch valid_vma(false) ignores VM_WRITE only but checks
other (immutable) bits checked by valid_vma(true). This can also
speedup uprobe_munmap() and uprobe_unregister().

Note: even after this patch _unregister can confuse the probed
application if it does mprotect(PROT_WRITE) after _register and
installs "int3", but this is hardly possible to avoid and this
doesn't differ from gdb case.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index b9b50dd..78364a2 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -100,17 +100,12 @@ struct uprobe {
  */
 static bool valid_vma(struct vm_area_struct *vma, bool is_register)
 {
-	if (!vma->vm_file)
-		return false;
-
-	if (!is_register)
-		return true;
+	vm_flags_t flags = VM_HUGETLB | VM_MAYEXEC | VM_SHARED;
 
-	if ((vma->vm_flags & (VM_HUGETLB | VM_WRITE | VM_MAYEXEC | VM_SHARED))
-				== VM_MAYEXEC)
-		return true;
+	if (is_register)
+		flags |= VM_WRITE;
 
-	return false;
+	return vma->vm_file && (vma->vm_flags & flags) == VM_MAYEXEC;
 }
 
 static unsigned long offset_to_vaddr(struct vm_area_struct *vma, loff_t offset)
-- 
1.5.5.1

