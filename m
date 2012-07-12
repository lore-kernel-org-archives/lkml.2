Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161396Ab2GLRNG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 13:13:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932521Ab2GLRND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 13:13:03 -0400
Date: Thu, 12 Jul 2012 19:10:17 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] uprobes: introduce vaddr_to_offset(vma, vaddr)
Message-ID: <20120712171017.GA25497@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120712170934.GA25455@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the new helper, vaddr_to_offset(vma, vaddr) which returns the
offset in vma->vm_file this vaddr is mapped at.

Change build_probe_list() and find_active_uprobe() to use the new
helper, the next patch adds another user.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index c825404..5c87042 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -122,6 +122,11 @@ static loff_t vma_address(struct vm_area_struct *vma, loff_t offset)
 	return vaddr;
 }
 
+static loff_t vaddr_to_offset(struct vm_area_struct *vma, unsigned long vaddr)
+{
+	return ((loff_t)vma->vm_pgoff << PAGE_SHIFT) + (vaddr - vma->vm_start);
+}
+
 /**
  * __replace_page - replace page in vma by new page.
  * based on replace_page in mm/ksm.c
@@ -978,7 +983,7 @@ static void build_probe_list(struct inode *inode,
 	struct uprobe *u;
 
 	INIT_LIST_HEAD(head);
-	min = ((loff_t)vma->vm_pgoff << PAGE_SHIFT) + start - vma->vm_start;
+	min = vaddr_to_offset(vma, start);
 	max = min + (end - start) - 1;
 
 	spin_lock_irqsave(&uprobes_treelock, flags);
@@ -1442,12 +1447,9 @@ static struct uprobe *find_active_uprobe(unsigned long bp_vaddr, int *is_swbp)
 	vma = find_vma(mm, bp_vaddr);
 	if (vma && vma->vm_start <= bp_vaddr) {
 		if (valid_vma(vma, false)) {
-			struct inode *inode;
-			loff_t offset;
+			struct inode *inode = vma->vm_file->f_mapping->host;
+			loff_t offset = vaddr_to_offset(vma, bp_vaddr);
 
-			inode = vma->vm_file->f_mapping->host;
-			offset = bp_vaddr - vma->vm_start;
-			offset += (loff_t)vma->vm_pgoff << PAGE_SHIFT;
 			uprobe = find_uprobe(inode, offset);
 		}
 
-- 
1.5.5.1

