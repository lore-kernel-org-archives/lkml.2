Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab2G2S1P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 14:27:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364Ab2G2SZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 14:25:31 -0400
Date: Sun, 29 Jul 2012 20:22:33 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Anton Arapov <anton@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/14] uprobes: fix overflow in
	vma_address/find_active_uprobe
Message-ID: <20120729182233.GA20339@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120729182128.GA20269@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vma->vm_pgoff is "unsigned long", it should be promoted to loff_t
before the multiplication to avoid the overflow.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar.vnet.ibm.com>
---
 kernel/events/uprobes.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 47c4e24..6194edb 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -117,7 +117,7 @@ static loff_t vma_address(struct vm_area_struct *vma, loff_t offset)
 	loff_t vaddr;
 
 	vaddr = vma->vm_start + offset;
-	vaddr -= vma->vm_pgoff << PAGE_SHIFT;
+	vaddr -= (loff_t)vma->vm_pgoff << PAGE_SHIFT;
 
 	return vaddr;
 }
@@ -1450,7 +1450,7 @@ static struct uprobe *find_active_uprobe(unsigned long bp_vaddr, int *is_swbp)
 
 			inode = vma->vm_file->f_mapping->host;
 			offset = bp_vaddr - vma->vm_start;
-			offset += (vma->vm_pgoff << PAGE_SHIFT);
+			offset += (loff_t)vma->vm_pgoff << PAGE_SHIFT;
 			uprobe = find_uprobe(inode, offset);
 		}
 
-- 
1.5.5.1

