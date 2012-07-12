Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161413Ab2GLRNO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 13:13:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161398Ab2GLRNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 13:13:11 -0400
Date: Thu, 12 Jul 2012 19:10:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] uprobes: fix register_for_each_vma()->vma_address()
	check
Message-ID: <20120712171020.GA25500@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120712170934.GA25455@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. register_for_each_vma() checks that vma_address() == vaddr but
   this is not enough. We should also ensure that vaddr >= vm_start,
   find_vma() guarantees "vaddr < vm_end" only.

2. After the prevous changes, register_for_each_vma() is the only
   reason why vma_address() has to return loff_t, all other users
   know that we have the valid mapping at this offset and thus the
   overflow is not possible.

   Change the code to use vaddr_to_offset() instead, imho this looks
   more clean/understandable and now we can change vma_address().

3. While at it, remove the unnecessary type-cast.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 5c87042..734e199 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -823,12 +823,13 @@ static int register_for_each_vma(struct uprobe *uprobe, bool is_register)
 			goto free;
 
 		down_write(&mm->mmap_sem);
-		vma = find_vma(mm, (unsigned long)info->vaddr);
-		if (!vma || !valid_vma(vma, is_register))
+		vma = find_vma(mm, info->vaddr);
+		if (!vma || !valid_vma(vma, is_register) ||
+		    vma->vm_file->f_mapping->host != uprobe->inode)
 			goto unlock;
 
-		if (vma->vm_file->f_mapping->host != uprobe->inode ||
-		    vma_address(vma, uprobe->offset) != info->vaddr)
+		if (vma->vm_start > info->vaddr ||
+		    vaddr_to_offset(vma, info->vaddr) != uprobe->offset)
 			goto unlock;
 
 		if (is_register) {
-- 
1.5.5.1

