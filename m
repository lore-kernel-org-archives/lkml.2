Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab2G2SZk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 14:25:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753361Ab2G2SZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 14:25:34 -0400
Date: Sun, 29 Jul 2012 20:22:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Anton Arapov <anton@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/14] uprobes: kill copy_vma()->uprobe_mmap()
Message-ID: <20120729182236.GA20342@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120729182128.GA20269@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kill copy_vma()->uprobe_mmap(new_vma), it is absolutely wrong.

This new_vma was just initialized to represent the new unmapped area,
[vm_start, vm_end) was returned by get_unmapped_area() in the caller.

This means that uprobe_mmap()->get_user_pages() will fail for sure,
simply because find_vma() can never succeed. And I verified that
sys_mremap()->mremap_to() indeed always fails with the wrong ENOMEM
code if [addr, addr+old_len] is probed.

And why this uprobe_mmap() was added? I believe the intent was wrong.
Note that the caller is going to do move_page_tables(), all registered
uprobes are already faulted in, we only change the virtual addresses.

NOTE: However, somehow we need to close the race with uprobe_register()
which relies on map_info->vaddr. This needs another fix I'll try to do
later. Probably we need uprobe_mmap() in move_vma() but we can not do
this right now, this can confuse uprobes_state.counter (which I still
hope we are going to kill).

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar.vnet.ibm.com>
---
 mm/mmap.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 3edfcdf..e5a4614 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2418,9 +2418,6 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 			if (new_vma->vm_file) {
 				get_file(new_vma->vm_file);
 
-				if (uprobe_mmap(new_vma))
-					goto out_free_mempol;
-
 				if (vma->vm_flags & VM_EXECUTABLE)
 					added_exe_file_vma(mm);
 			}
-- 
1.5.5.1

