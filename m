Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965144Ab2B1BLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:11:48 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50501 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964986Ab2B1BLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:11:46 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.204.106 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010433.738291981@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:05:18 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>,
        David Howells <dhowells@redhat.com>
Subject: [ 49/72] NOMMU: Lock i_mmap_mutex for access to the VMA prio list
In-Reply-To: <20120228010511.GA8453@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit 918e556ec214ed2f584e4cac56d7b29e4bb6bf27 upstream.

Lock i_mmap_mutex for access to the VMA prio list to prevent concurrent
access.  Currently, certain parts of the mmap handling are protected by
the region mutex, but not all.

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/nommu.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -696,9 +696,11 @@ static void add_vma_to_mm(struct mm_stru
 	if (vma->vm_file) {
 		mapping = vma->vm_file->f_mapping;
 
+		mutex_lock(&mapping->i_mmap_mutex);
 		flush_dcache_mmap_lock(mapping);
 		vma_prio_tree_insert(vma, &mapping->i_mmap);
 		flush_dcache_mmap_unlock(mapping);
+		mutex_unlock(&mapping->i_mmap_mutex);
 	}
 
 	/* add the VMA to the tree */
@@ -760,9 +762,11 @@ static void delete_vma_from_mm(struct vm
 	if (vma->vm_file) {
 		mapping = vma->vm_file->f_mapping;
 
+		mutex_lock(&mapping->i_mmap_mutex);
 		flush_dcache_mmap_lock(mapping);
 		vma_prio_tree_remove(vma, &mapping->i_mmap);
 		flush_dcache_mmap_unlock(mapping);
+		mutex_unlock(&mapping->i_mmap_mutex);
 	}
 
 	/* remove from the MM's tree and list */
@@ -2052,6 +2056,7 @@ int nommu_shrink_inode_mappings(struct i
 	high = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
 	down_write(&nommu_region_sem);
+	mutex_lock(&inode->i_mapping->i_mmap_mutex);
 
 	/* search for VMAs that fall within the dead zone */
 	vma_prio_tree_foreach(vma, &iter, &inode->i_mapping->i_mmap,
@@ -2059,6 +2064,7 @@ int nommu_shrink_inode_mappings(struct i
 		/* found one - only interested if it's shared out of the page
 		 * cache */
 		if (vma->vm_flags & VM_SHARED) {
+			mutex_unlock(&inode->i_mapping->i_mmap_mutex);
 			up_write(&nommu_region_sem);
 			return -ETXTBSY; /* not quite true, but near enough */
 		}
@@ -2086,6 +2092,7 @@ int nommu_shrink_inode_mappings(struct i
 		}
 	}
 
+	mutex_unlock(&inode->i_mapping->i_mmap_mutex);
 	up_write(&nommu_region_sem);
 	return 0;
 }


