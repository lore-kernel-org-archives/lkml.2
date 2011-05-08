Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab1EHTnN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 15:43:13 -0400
Received: from smtp-out.google.com ([74.125.121.67]:2071 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877Ab1EHTnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 15:43:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=K81J9DQngokSKLNctIb9oYlLizHBUahMdzRUoRI06b/liiWDg4a3GCuVEnczRR3YtF
         3vt30BNsuA1QQ4Tq2gPg==
Date: Sun, 8 May 2011 12:43:19 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Konstantin Khlebnikov <khlebnikov@openvz.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] tmpfs: fix race between umount and swapoff
In-Reply-To: <alpine.LSU.2.00.1105081238010.15963@sister.anvils>
Message-ID: <alpine.LSU.2.00.1105081241590.15963@sister.anvils>
References: <4DAFD0B1.9090603@parallels.com> <20110421064150.6431.84511.stgit@localhost6> <20110421124424.0a10ed0c.akpm@linux-foundation.org> <4DB0FE8F.9070407@parallels.com> <alpine.LSU.2.00.1105031223120.9845@sister.anvils> <4DC4D9A6.9070103@parallels.com>
 <alpine.LSU.2.00.1105071621330.3668@sister.anvils> <4DC691D0.6050104@parallels.com> <alpine.LSU.2.00.1105081238010.15963@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of igrab() in swapoff's shmem_unuse_inode() is just as vulnerable
to umount as that in shmem_writepage().

Fix this instance by extending the protection of shmem_swaplist_mutex
right across shmem_unuse_inode(): while it's on the list, the inode
cannot be evicted (and the filesystem cannot be unmounted) without
shmem_evict_inode() taking that mutex to remove it from the list.

But since shmem_writepage() might take that mutex, we should avoid
making memory allocations or memcg charges while holding it: prepare
them at the outer level in shmem_unuse().  When mem_cgroup_cache_charge()
was originally placed, we didn't know until that point that the page from
swap was actually a shmem page; but nowadays it's noted in the swap_map,
so we're safe to charge upfront.  For the radix_tree, do as is done in
shmem_getpage(): preload upfront, but don't pin to the cpu; so we make
a habit of refreshing the node pool, but might dip into GFP_NOWAIT
reserves on occasion if subsequently preempted.

With the allocation and charge moved out from shmem_unuse_inode(),
we can also hold index map and info->lock over from finding the entry.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: stable@kernel.org
---

 mm/shmem.c |   88 +++++++++++++++++++++++--------------------------
 1 file changed, 43 insertions(+), 45 deletions(-)

--- tmpfs1/mm/shmem.c	2011-05-07 17:38:00.648660817 -0700
+++ tmpfs2/mm/shmem.c	2011-05-07 17:39:00.656959448 -0700
@@ -852,7 +852,7 @@ static inline int shmem_find_swp(swp_ent
 
 static int shmem_unuse_inode(struct shmem_inode_info *info, swp_entry_t entry, struct page *page)
 {
-	struct inode *inode;
+	struct address_space *mapping;
 	unsigned long idx;
 	unsigned long size;
 	unsigned long limit;
@@ -875,8 +875,10 @@ static int shmem_unuse_inode(struct shme
 	if (size > SHMEM_NR_DIRECT)
 		size = SHMEM_NR_DIRECT;
 	offset = shmem_find_swp(entry, ptr, ptr+size);
-	if (offset >= 0)
+	if (offset >= 0) {
+		shmem_swp_balance_unmap();
 		goto found;
+	}
 	if (!info->i_indirect)
 		goto lost2;
 
@@ -914,11 +916,11 @@ static int shmem_unuse_inode(struct shme
 			if (size > ENTRIES_PER_PAGE)
 				size = ENTRIES_PER_PAGE;
 			offset = shmem_find_swp(entry, ptr, ptr+size);
-			shmem_swp_unmap(ptr);
 			if (offset >= 0) {
 				shmem_dir_unmap(dir);
 				goto found;
 			}
+			shmem_swp_unmap(ptr);
 		}
 	}
 lost1:
@@ -928,8 +930,7 @@ lost2:
 	return 0;
 found:
 	idx += offset;
-	inode = igrab(&info->vfs_inode);
-	spin_unlock(&info->lock);
+	ptr += offset;
 
 	/*
 	 * Move _head_ to start search for next from here.
@@ -940,37 +941,18 @@ found:
 	 */
 	if (shmem_swaplist.next != &info->swaplist)
 		list_move_tail(&shmem_swaplist, &info->swaplist);
-	mutex_unlock(&shmem_swaplist_mutex);
 
-	error = 1;
-	if (!inode)
-		goto out;
 	/*
-	 * Charge page using GFP_KERNEL while we can wait.
-	 * Charged back to the user(not to caller) when swap account is used.
-	 * add_to_page_cache() will be called with GFP_NOWAIT.
+	 * We rely on shmem_swaplist_mutex, not only to protect the swaplist,
+	 * but also to hold up shmem_evict_inode(): so inode cannot be freed
+	 * beneath us (pagelock doesn't help until the page is in pagecache).
 	 */
-	error = mem_cgroup_cache_charge(page, current->mm, GFP_KERNEL);
-	if (error)
-		goto out;
-	error = radix_tree_preload(GFP_KERNEL);
-	if (error) {
-		mem_cgroup_uncharge_cache_page(page);
-		goto out;
-	}
-	error = 1;
-
-	spin_lock(&info->lock);
-	ptr = shmem_swp_entry(info, idx, NULL);
-	if (ptr && ptr->val == entry.val) {
-		error = add_to_page_cache_locked(page, inode->i_mapping,
-						idx, GFP_NOWAIT);
-		/* does mem_cgroup_uncharge_cache_page on error */
-	} else	/* we must compensate for our precharge above */
-		mem_cgroup_uncharge_cache_page(page);
+	mapping = info->vfs_inode.i_mapping;
+	error = add_to_page_cache_locked(page, mapping, idx, GFP_NOWAIT);
+	/* which does mem_cgroup_uncharge_cache_page on error */
 
 	if (error == -EEXIST) {
-		struct page *filepage = find_get_page(inode->i_mapping, idx);
+		struct page *filepage = find_get_page(mapping, idx);
 		error = 1;
 		if (filepage) {
 			/*
@@ -990,14 +972,8 @@ found:
 		swap_free(entry);
 		error = 1;	/* not an error, but entry was found */
 	}
-	if (ptr)
-		shmem_swp_unmap(ptr);
+	shmem_swp_unmap(ptr);
 	spin_unlock(&info->lock);
-	radix_tree_preload_end();
-out:
-	unlock_page(page);
-	page_cache_release(page);
-	iput(inode);		/* allows for NULL */
 	return error;
 }
 
@@ -1009,6 +985,26 @@ int shmem_unuse(swp_entry_t entry, struc
 	struct list_head *p, *next;
 	struct shmem_inode_info *info;
 	int found = 0;
+	int error;
+
+	/*
+	 * Charge page using GFP_KERNEL while we can wait, before taking
+	 * the shmem_swaplist_mutex which might hold up shmem_writepage().
+	 * Charged back to the user (not to caller) when swap account is used.
+	 * add_to_page_cache() will be called with GFP_NOWAIT.
+	 */
+	error = mem_cgroup_cache_charge(page, current->mm, GFP_KERNEL);
+	if (error)
+		goto out;
+	/*
+	 * Try to preload while we can wait, to not make a habit of
+	 * draining atomic reserves; but don't latch on to this cpu,
+	 * it's okay if sometimes we get rescheduled after this.
+	 */
+	error = radix_tree_preload(GFP_KERNEL);
+	if (error)
+		goto uncharge;
+	radix_tree_preload_end();
 
 	mutex_lock(&shmem_swaplist_mutex);
 	list_for_each_safe(p, next, &shmem_swaplist) {
@@ -1016,17 +1012,19 @@ int shmem_unuse(swp_entry_t entry, struc
 		found = shmem_unuse_inode(info, entry, page);
 		cond_resched();
 		if (found)
-			goto out;
+			break;
 	}
 	mutex_unlock(&shmem_swaplist_mutex);
-	/*
-	 * Can some race bring us here?  We've been holding page lock,
-	 * so I think not; but would rather try again later than BUG()
-	 */
+
+uncharge:
+	if (!found)
+		mem_cgroup_uncharge_cache_page(page);
+	if (found < 0)
+		error = found;
+out:
 	unlock_page(page);
 	page_cache_release(page);
-out:
-	return (found < 0) ? found : 0;
+	return error;
 }
 
 /*
