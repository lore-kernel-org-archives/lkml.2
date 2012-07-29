Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab2G2SZn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 14:25:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753361Ab2G2SZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 14:25:41 -0400
Date: Sun, 29 Jul 2012 20:22:42 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Anton Arapov <anton@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/14] uprobes: introduce vaddr_to_offset(vma, vaddr)
Message-ID: <20120729182242.GA20355@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120729182128.GA20269@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the new helper, vaddr_to_offset(vma, vaddr) which returns the
offset in vma->vm_file this vaddr is mapped at.

Change build_probe_list() and find_active_uprobe() to use the new
helper, the next patch adds another user.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar.vnet.ibm.com>
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

