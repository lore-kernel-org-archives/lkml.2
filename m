Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab2G2SZi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 14:25:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62979 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753475Ab2G2SZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 14:25:36 -0400
Date: Sun, 29 Jul 2012 20:22:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Anton Arapov <anton@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/14] uprobes: kill insert_vm_struct()->uprobe_mmap()
Message-ID: <20120729182238.GA20349@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120729182128.GA20269@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kill insert_vm_struct()->uprobe_mmap(). It is not needed, nobody
except arch/ia64/kernel/perfmon.c uses insert_vm_struct(vma) with
vma->vm_file != NULL.

And it is wrong. Again, get_user_pages() can not succeed before
vma_link(vma) makes is visible to find_vma(). And even if this
worked, we must not insert the new bp before this mapping is
visible to vma_prio_tree_foreach() for uprobe_unregister().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar.vnet.ibm.com>
---
 mm/mmap.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index e5a4614..4fe2697 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2345,9 +2345,6 @@ int insert_vm_struct(struct mm_struct * mm, struct vm_area_struct * vma)
 	     security_vm_enough_memory_mm(mm, vma_pages(vma)))
 		return -ENOMEM;
 
-	if (vma->vm_file && uprobe_mmap(vma))
-		return -EINVAL;
-
 	vma_link(mm, vma, prev, rb_link, rb_parent);
 	return 0;
 }
-- 
1.5.5.1

