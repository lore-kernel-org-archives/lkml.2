Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163104Ab2GMQuO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 12:50:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163081Ab2GMQtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 12:49:20 -0400
Date: Fri, 13 Jul 2012 18:46:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Anton Arapov <anton@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 9/9] uprobes: kill insert_vm_struct()->uprobe_mmap()
Message-ID: <20120713164641.GA23575@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120713164552.GA23509@redhat.com>
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

