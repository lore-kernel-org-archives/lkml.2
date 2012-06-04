Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932Ab2FDOz3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 10:55:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754420Ab2FDOzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 10:55:22 -0400
Date: Mon, 4 Jun 2012 16:53:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] uprobes: rework register_for_each_vma() to make it O(n)
Message-ID: <20120604145300.GA6416@redhat.com>
References: <20120604145238.GA6408@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120604145238.GA6408@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently register_for_each_vma() is O(n ** 2) + O(n ** 3), every
time find_next_vma_info() "restarts" the vma_prio_tree_foreach()
loop and each iteration rechecks the whole try_list. This also
means that try_list can grow "indefinitely" if register/unregister
races with munmap/mmap activity even if the number of mapping is
bounded at any time.

With this patch register_for_each_vma() builds the list of mm/vaddr
structures only once and does install_breakpoint() for each entry.

We do not care about the new mappings which can be created after
build_map_info() drops mapping->i_mmap_mutex, uprobe_mmap() should
do its work.

Note that we do not allocate map_info under i_mmap_mutex, this can
deadlock with page reclaim (but see the next patch). So we use 2
lists, "curr" which we are going to return, and "prev" which holds
the already allocated memory. The main loop deques the entry from
"prev" (initially it is empty), and if "prev" becomes empty again
it counts the number of entries we need to pre-allocate outside of
i_mmap_mutex.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |  199 ++++++++++++++++++++---------------------------
 1 files changed, 86 insertions(+), 113 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index de931e7..a1bbcab 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -60,17 +60,6 @@ static struct mutex uprobes_mmap_mutex[UPROBES_HASH_SZ];
  */
 static atomic_t uprobe_events = ATOMIC_INIT(0);
 
-/*
- * Maintain a temporary per vma info that can be used to search if a vma
- * has already been handled. This structure is introduced since extending
- * vm_area_struct wasnt recommended.
- */
-struct vma_info {
-	struct list_head	probe_list;
-	struct mm_struct	*mm;
-	loff_t			vaddr;
-};
-
 struct uprobe {
 	struct rb_node		rb_node;	/* node in the rb tree */
 	atomic_t		ref;
@@ -752,139 +741,123 @@ static void delete_uprobe(struct uprobe *uprobe)
 	atomic_dec(&uprobe_events);
 }
 
-static struct vma_info *
-__find_next_vma_info(struct address_space *mapping, struct list_head *head,
-			struct vma_info *vi, loff_t offset, bool is_register)
+struct map_info {
+	struct map_info *next;
+	struct mm_struct *mm;
+	loff_t vaddr;
+};
+
+static inline struct map_info *free_map_info(struct map_info *info)
 {
+	struct map_info *next = info->next;
+	kfree(info);
+	return next;
+}
+
+static struct map_info *
+build_map_info(struct address_space *mapping, loff_t offset, bool is_register)
+{
+	unsigned long pgoff = offset >> PAGE_SHIFT;
 	struct prio_tree_iter iter;
 	struct vm_area_struct *vma;
-	struct vma_info *tmpvi;
-	unsigned long pgoff;
-	int existing_vma;
-	loff_t vaddr;
-
-	pgoff = offset >> PAGE_SHIFT;
+	struct map_info *curr = NULL;
+	struct map_info *prev = NULL;
+	struct map_info *info;
+	int more = 0;
 
+ again:
+	mutex_lock(&mapping->i_mmap_mutex);
 	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
 		if (!valid_vma(vma, is_register))
 			continue;
 
-		existing_vma = 0;
-		vaddr = vma_address(vma, offset);
-
-		list_for_each_entry(tmpvi, head, probe_list) {
-			if (tmpvi->mm == vma->vm_mm && tmpvi->vaddr == vaddr) {
-				existing_vma = 1;
-				break;
-			}
-		}
-
-		/*
-		 * Another vma needs a probe to be installed. However skip
-		 * installing the probe if the vma is about to be unlinked.
-		 */
-		if (!existing_vma && atomic_inc_not_zero(&vma->vm_mm->mm_users)) {
-			vi->mm = vma->vm_mm;
-			vi->vaddr = vaddr;
-			list_add(&vi->probe_list, head);
-
-			return vi;
+		if (!prev) {
+			more++;
+			continue;
 		}
-	}
 
-	return NULL;
-}
-
-/*
- * Iterate in the rmap prio tree  and find a vma where a probe has not
- * yet been inserted.
- */
-static struct vma_info *
-find_next_vma_info(struct address_space *mapping, struct list_head *head,
-		loff_t offset, bool is_register)
-{
-	struct vma_info *vi, *retvi;
+		if (!atomic_inc_not_zero(&vma->vm_mm->mm_users))
+			continue;
 
-	vi = kzalloc(sizeof(struct vma_info), GFP_KERNEL);
-	if (!vi)
-		return ERR_PTR(-ENOMEM);
+		info = prev;
+		prev = prev->next;
+		info->next = curr;
+		curr = info;
 
-	mutex_lock(&mapping->i_mmap_mutex);
-	retvi = __find_next_vma_info(mapping, head, vi, offset, is_register);
+		info->mm = vma->vm_mm;
+		info->vaddr = vma_address(vma, offset);
+	}
 	mutex_unlock(&mapping->i_mmap_mutex);
 
-	if (!retvi)
-		kfree(vi);
+	if (!more)
+		goto out;
+
+	prev = curr;
+	while (curr) {
+		mmput(curr->mm);
+		curr = curr->next;
+	}
 
-	return retvi;
+	do {
+		info = kmalloc(sizeof(struct map_info), GFP_KERNEL);
+		if (!info) {
+			curr = ERR_PTR(-ENOMEM);
+			goto out;
+		}
+		info->next = prev;
+		prev = info;
+	} while (--more);
+
+	goto again;
+ out:
+	while (prev)
+		prev = free_map_info(prev);
+	return curr;
 }
 
 static int register_for_each_vma(struct uprobe *uprobe, bool is_register)
 {
-	struct list_head try_list;
-	struct vm_area_struct *vma;
-	struct address_space *mapping;
-	struct vma_info *vi, *tmpvi;
-	struct mm_struct *mm;
-	loff_t vaddr;
-	int ret;
+	struct map_info *info;
+	int err = 0;
 
-	mapping = uprobe->inode->i_mapping;
-	INIT_LIST_HEAD(&try_list);
+	info = build_map_info(uprobe->inode->i_mapping,
+					uprobe->offset, is_register);
+	if (IS_ERR(info))
+		return PTR_ERR(info);
 
-	ret = 0;
-
-	for (;;) {
-		vi = find_next_vma_info(mapping, &try_list, uprobe->offset, is_register);
-		if (!vi)
-			break;
+	while (info) {
+		struct mm_struct *mm = info->mm;
+		struct vm_area_struct *vma;
+		loff_t vaddr;
 
-		if (IS_ERR(vi)) {
-			ret = PTR_ERR(vi);
-			break;
-		}
+		if (err)
+			goto free;
 
-		mm = vi->mm;
 		down_write(&mm->mmap_sem);
-		vma = find_vma(mm, (unsigned long)vi->vaddr);
-		if (!vma || !valid_vma(vma, is_register)) {
-			list_del(&vi->probe_list);
-			kfree(vi);
-			up_write(&mm->mmap_sem);
-			mmput(mm);
-			continue;
-		}
+		vma = find_vma(mm, (unsigned long)info->vaddr);
+		if (!vma || !valid_vma(vma, is_register))
+			goto unlock;
+
 		vaddr = vma_address(vma, uprobe->offset);
 		if (vma->vm_file->f_mapping->host != uprobe->inode ||
-						vaddr != vi->vaddr) {
-			list_del(&vi->probe_list);
-			kfree(vi);
-			up_write(&mm->mmap_sem);
-			mmput(mm);
-			continue;
-		}
-
-		if (is_register)
-			ret = install_breakpoint(uprobe, mm, vma, vi->vaddr);
-		else
-			remove_breakpoint(uprobe, mm, vi->vaddr);
+						vaddr != info->vaddr)
+			goto unlock;
 
-		up_write(&mm->mmap_sem);
-		mmput(mm);
 		if (is_register) {
-			if (ret && ret == -EEXIST)
-				ret = 0;
-			if (ret)
-				break;
+			err = install_breakpoint(uprobe, mm, vma, info->vaddr);
+			if (err == -EEXIST)
+				err = 0;
+		} else {
+			remove_breakpoint(uprobe, mm, info->vaddr);
 		}
+ unlock:
+		up_write(&mm->mmap_sem);
+ free:
+		mmput(mm);
+		info = free_map_info(info);
 	}
 
-	list_for_each_entry_safe(vi, tmpvi, &try_list, probe_list) {
-		list_del(&vi->probe_list);
-		kfree(vi);
-	}
-
-	return ret;
+	return err;
 }
 
 static int __uprobe_register(struct uprobe *uprobe)
-- 
1.5.5.1


