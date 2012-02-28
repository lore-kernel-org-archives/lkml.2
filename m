Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab2B1BGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:06:23 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49705 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756400Ab2B1BGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:06:18 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.129.162 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010204.397256192@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:02:05 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>,
        David Howells <dhowells@redhat.com>
Subject: [ 02/73] NOMMU: Lock i_mmap_mutex for access to the VMA prio list
In-Reply-To: <20120228010246.GA24299@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -697,9 +697,11 @@ static void add_vma_to_mm(struct mm_stru
 	if (vma->vm_file) {
 		mapping = vma->vm_file->f_mapping;
 
+		mutex_lock(&mapping->i_mmap_mutex);
 		flush_dcache_mmap_lock(mapping);
 		vma_prio_tree_insert(vma, &mapping->i_mmap);
 		flush_dcache_mmap_unlock(mapping);
+		mutex_unlock(&mapping->i_mmap_mutex);
 	}
 
 	/* add the VMA to the tree */
@@ -761,9 +763,11 @@ static void delete_vma_from_mm(struct vm
 	if (vma->vm_file) {
 		mapping = vma->vm_file->f_mapping;
 
+		mutex_lock(&mapping->i_mmap_mutex);
 		flush_dcache_mmap_lock(mapping);
 		vma_prio_tree_remove(vma, &mapping->i_mmap);
 		flush_dcache_mmap_unlock(mapping);
+		mutex_unlock(&mapping->i_mmap_mutex);
 	}
 
 	/* remove from the MM's tree and list */
@@ -2061,6 +2065,7 @@ int nommu_shrink_inode_mappings(struct i
 	high = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
 	down_write(&nommu_region_sem);
+	mutex_lock(&inode->i_mapping->i_mmap_mutex);
 
 	/* search for VMAs that fall within the dead zone */
 	vma_prio_tree_foreach(vma, &iter, &inode->i_mapping->i_mmap,
@@ -2068,6 +2073,7 @@ int nommu_shrink_inode_mappings(struct i
 		/* found one - only interested if it's shared out of the page
 		 * cache */
 		if (vma->vm_flags & VM_SHARED) {
+			mutex_unlock(&inode->i_mapping->i_mmap_mutex);
 			up_write(&nommu_region_sem);
 			return -ETXTBSY; /* not quite true, but near enough */
 		}
@@ -2095,6 +2101,7 @@ int nommu_shrink_inode_mappings(struct i
 		}
 	}
 
+	mutex_unlock(&inode->i_mapping->i_mmap_mutex);
 	up_write(&nommu_region_sem);
 	return 0;
 }


