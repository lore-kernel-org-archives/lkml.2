Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030658Ab2CTQpM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 12:45:12 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:34860 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab2CTQpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 12:45:10 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>,
        Andrea Righi <andrea@betterlinux.com>
Subject: Re: [PATCH 1/2] [RFC] Range tree implementation
In-Reply-To: <1331938267-13583-2-git-send-email-john.stultz@linaro.org>
References: <1331938267-13583-1-git-send-email-john.stultz@linaro.org> <1331938267-13583-2-git-send-email-john.stultz@linaro.org>User-Agent: Notmuch/0.11.1+346~g13d19c3 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 20 Mar 2012 22:14:51 +0530
Message-ID: <87sjh3rzlo.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12032016-8256-0000-0000-000001B955DF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Stultz <john.stultz@linaro.org> writes:


....

> +/**
> + * range_tree_in_range - Returns the first node that overlaps with the
> + *                       given range
> + * @root: range_tree root
> + * @start: range start
> + * @end: range end
> + *
> + */
> +struct range_tree_node *range_tree_in_range(struct range_tree_root *root,
> +						u64 start, u64 end)
> +{
> +	struct rb_node **p = &root->head.rb_node;
> +	struct range_tree_node *candidate;
> +
> +	while (*p) {
> +		candidate = rb_entry(*p, struct range_tree_node, rb);
> +		if (end < candidate->start)
> +			p = &(*p)->rb_left;
> +		else if (start > candidate->end)
> +			p = &(*p)->rb_right;
> +		else
> +			return candidate;
> +	}
> +
> +	return 0;


return NULL ?

> +}
> +
> +
> +/**
> + * range_tree_in_range - Returns the first node that overlaps or is adjacent
> + *                       with the given range
> + * @root: range_tree root
> + * @start: range start
> + * @end: range end
> + *
> + */


The comment needs update 

> +struct range_tree_node *range_tree_in_range_adjacent(
> +					struct range_tree_root *root,
> +					u64 start, u64 end)
> +{
> +	struct rb_node **p = &root->head.rb_node;
> +	struct range_tree_node *candidate;
> +
> +	while (*p) {
> +		candidate = rb_entry(*p, struct range_tree_node, rb);
> +		if (end+1 < candidate->start)
> +			p = &(*p)->rb_left;
> +		else if (start > candidate->end + 1)
> +			p = &(*p)->rb_right;
> +		else
> +			return candidate;
> +	}
> +	return 0;
> +}
> +


Below is my hack to get hugetlbfs code converted. The patch compiles.
Will test and send a signed-off-by version later.

not-signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

 fs/hugetlbfs/inode.c    |    3 +-
 include/linux/hugetlb.h |    2 +
 mm/hugetlb.c            |  291 ++++++++++++++++++++++-------------------------
 3 files changed, 139 insertions(+), 157 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index ca4fa70..8309f5e 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -455,6 +455,7 @@ static struct inode *hugetlbfs_get_root(struct super_block *sb,
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 		info = HUGETLBFS_I(inode);
 		mpol_shared_policy_init(&info->policy, NULL);
+		range_tree_init(&info->rg_root);
 		inode->i_op = &hugetlbfs_dir_inode_operations;
 		inode->i_fop = &simple_dir_operations;
 		/* directory inodes start off with i_nlink == 2 (for "." entry) */
@@ -478,7 +479,6 @@ static struct inode *hugetlbfs_get_inode(struct super_block *sb,
 		inode->i_mapping->a_ops = &hugetlbfs_aops;
 		inode->i_mapping->backing_dev_info =&hugetlbfs_backing_dev_info;
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
-		INIT_LIST_HEAD(&inode->i_mapping->private_list);
 		info = HUGETLBFS_I(inode);
 		/*
 		 * The policy is initialized here even if we are creating a
@@ -488,6 +488,7 @@ static struct inode *hugetlbfs_get_inode(struct super_block *sb,
 		 * the rb tree will still be empty.
 		 */
 		mpol_shared_policy_init(&info->policy, NULL);
+		range_tree_init(&info->rg_root);
 		switch (mode & S_IFMT) {
 		default:
 			init_special_inode(inode, mode, dev);
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 32e948c..b785541a 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -5,6 +5,7 @@
 #include <linux/fs.h>
 #include <linux/hugetlb_inline.h>
 #include <linux/cgroup.h>
+#include <linux/rangetree.h>
 
 struct ctl_table;
 struct user_struct;
@@ -150,6 +151,7 @@ struct hugetlbfs_sb_info {
 
 struct hugetlbfs_inode_info {
 	struct shared_policy policy;
+	struct range_tree_root rg_root;
 	struct inode vfs_inode;
 };
 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4e1462d..a83727d 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -69,148 +69,94 @@ static DEFINE_SPINLOCK(hugetlb_lock);
  *	down_read(&mm->mmap_sem);
  *	mutex_lock(&hugetlb_instantiation_mutex);
  */
-struct file_region {
-	struct list_head link;
-	long from;
-	long to;
-};
-
-static long region_add(struct list_head *head, long f, long t)
+static long region_chg(struct range_tree_root *rg_root, long start, long end,
+		       struct range_tree_node **rg_nodep)
 {
-	struct file_region *rg, *nrg, *trg;
+	long chg = 0;
+	struct range_tree_node *rg_node;
 
-	/* Locate the region we are either in or before. */
-	list_for_each_entry(rg, head, link)
-		if (f <= rg->to)
-			break;
+	rg_node = range_tree_in_range_adjacent(rg_root, start, end);
+	/*
+	 * If we need to allocate a new range_tree_node, we return a charge
+	 * with NULL *rg_node;
+	 */
+	if (rg_node == NULL)
+		return end - start;
 
-	/* Round our left edge to the current segment if it encloses us. */
-	if (f > rg->from)
-		f = rg->from;
+	if (start < rg_node->start)
+		chg +=  rg_node->start - start;
+	if (rg_node->end < end)
+		chg += end - rg_node->end;
 
-	/* Check for and consume any regions we now overlap with. */
-	nrg = rg;
-	list_for_each_entry_safe(rg, trg, rg->link.prev, link) {
-		if (&rg->link == head)
-			break;
-		if (rg->from > t)
-			break;
-
-		/* If this area reaches higher then extend our area to
-		 * include it completely.  If this is not the first area
-		 * which we intend to reuse, free it. */
-		if (rg->to > t)
-			t = rg->to;
-		if (rg != nrg) {
-			list_del(&rg->link);
-			kfree(rg);
-		}
-	}
-	nrg->from = f;
-	nrg->to = t;
-	return 0;
+	*rg_nodep = rg_node;
+	return chg;
 }
 
-static long region_chg(struct list_head *head, long f, long t)
+static void region_add(struct range_tree_root *rg_root, long start, long end,
+		       struct range_tree_node *rg_node)
 {
-	struct file_region *rg, *nrg;
-	long chg = 0;
-
-	/* Locate the region we are before or in. */
-	list_for_each_entry(rg, head, link)
-		if (f <= rg->to)
-			break;
+	if (rg_node == NULL)
+		return;
 
-	/* If we are below the current region then a new region is required.
-	 * Subtle, allocate a new region at the position but make it zero
-	 * size such that we can guarantee to record the reservation. */
-	if (&rg->link == head || t < rg->from) {
-		nrg = kmalloc(sizeof(*nrg), GFP_KERNEL);
-		if (!nrg)
-			return -ENOMEM;
-		nrg->from = f;
-		nrg->to   = f;
-		INIT_LIST_HEAD(&nrg->link);
-		list_add(&nrg->link, rg->link.prev);
+	if (start < rg_node->start)
+		rg_node->start = start;
 
-		return t - f;
-	}
+	if (end > rg_node->end)
+		rg_node->end = end;
 
-	/* Round our left edge to the current segment if it encloses us. */
-	if (f > rg->from)
-		f = rg->from;
-	chg = t - f;
-
-	/* Check for and consume any regions we now overlap with. */
-	list_for_each_entry(rg, rg->link.prev, link) {
-		if (&rg->link == head)
-			break;
-		if (rg->from > t)
-			return chg;
-
-		/* We overlap with this area, if it extends further than
-		 * us then we must extend ourselves.  Account for its
-		 * existing reservation. */
-		if (rg->to > t) {
-			chg += rg->to - t;
-			t = rg->to;
-		}
-		chg -= rg->to - rg->from;
-	}
-	return chg;
+	range_tree_add(rg_root, rg_node);
 }
 
-static long region_truncate(struct list_head *head, long end)
+static long region_truncate(struct range_tree_root *rg_root, long off)
 {
-	struct file_region *rg, *trg;
 	long chg = 0;
-
-	/* Locate the region we are either in or before. */
-	list_for_each_entry(rg, head, link)
-		if (end <= rg->to)
-			break;
-	if (&rg->link == head)
-		return 0;
-
-	/* If we are in the middle of a region then adjust it. */
-	if (end > rg->from) {
-		chg = rg->to - end;
-		rg->to = end;
-		rg = list_entry(rg->link.next, typeof(*rg), link);
-	}
-
-	/* Drop any remaining regions. */
-	list_for_each_entry_safe(rg, trg, rg->link.prev, link) {
-		if (&rg->link == head)
-			break;
-		chg += rg->to - rg->from;
-		list_del(&rg->link);
-		kfree(rg);
+	struct rb_node *rb_node;
+
+restart:
+	rb_node = rb_first(&rg_root->head);
+	while (rb_node) {
+		struct range_tree_node *rg_node;
+		rg_node = rb_entry(rb_node, struct range_tree_node, rb);
+		if (rg_node->end <= off) {
+			rb_node = rb_next(rb_node);
+			continue;
+		}
+		if (rg_node->start < off) {
+			chg += rg_node->end - off;
+			rg_node->end = off;
+			rb_node = rb_next(rb_node);
+			continue;
+		}
+		chg += rg_node->end - rg_node->start;
+		rb_erase(rb_node, &rg_root->head);
+		goto restart;
 	}
 	return chg;
 }
 
-static long region_count(struct list_head *head, long f, long t)
+static long region_count(struct range_tree_root *rg_root, long start, long end)
 {
-	struct file_region *rg;
 	long chg = 0;
+	struct rb_node *rb_node;
 
-	/* Locate each segment we overlap with, and count that overlap. */
-	list_for_each_entry(rg, head, link) {
-		int seg_from;
-		int seg_to;
+	rb_node = rb_first(&rg_root->head);
+	while (rb_node) {
+		int seg_from, seg_to;
+		struct range_tree_node *rg_node;
 
-		if (rg->to <= f)
+		rg_node = rb_entry(rb_node, struct range_tree_node, rb);
+		if (rg_node->end <= start) {
+			rb_node = rb_next(rb_node);
 			continue;
-		if (rg->from >= t)
+		}
+		if (rg_node->start >= end)
 			break;
-
-		seg_from = max(rg->from, f);
-		seg_to = min(rg->to, t);
+		seg_from = max(rg_node->start, (u64)start);
+		seg_to = min(rg_node->end, (u64)end);
 
 		chg += seg_to - seg_from;
+		rb_node = rb_next(rb_node);
 	}
-
 	return chg;
 }
 
@@ -302,7 +248,7 @@ static void set_vma_private_data(struct vm_area_struct *vma,
 
 struct resv_map {
 	struct kref refs;
-	struct list_head regions;
+	struct range_tree_root rg_root;
 };
 
 static struct resv_map *resv_map_alloc(void)
@@ -312,7 +258,7 @@ static struct resv_map *resv_map_alloc(void)
 		return NULL;
 
 	kref_init(&resv_map->refs);
-	INIT_LIST_HEAD(&resv_map->regions);
+	range_tree_init(&resv_map->rg_root);
 
 	return resv_map;
 }
@@ -322,7 +268,7 @@ static void resv_map_release(struct kref *ref)
 	struct resv_map *resv_map = container_of(ref, struct resv_map, refs);
 
 	/* Clear out any active regions before we release the map. */
-	region_truncate(&resv_map->regions, 0);
+	region_truncate(&resv_map->rg_root, 0);
 	kfree(resv_map);
 }
 
@@ -980,16 +926,19 @@ static void return_unused_surplus_pages(struct hstate *h,
  * No action is required on failure.
  */
 static long vma_needs_reservation(struct hstate *h,
-			struct vm_area_struct *vma, unsigned long addr)
+				  struct vm_area_struct *vma,
+				  unsigned long addr,
+				  struct range_tree_node **rg_node)
 {
 	struct address_space *mapping = vma->vm_file->f_mapping;
 	struct inode *inode = mapping->host;
+	struct hugetlbfs_inode_info *hinfo = HUGETLBFS_I(inode);
 
+	*rg_node = NULL;
 	if (vma->vm_flags & VM_MAYSHARE) {
 		pgoff_t idx = vma_hugecache_offset(h, vma, addr);
-		return region_chg(&inode->i_mapping->private_list,
-							idx, idx + 1);
 
+		return region_chg(&hinfo->rg_root, idx, idx + 1, rg_node);
 	} else if (!is_vma_resv_set(vma, HPAGE_RESV_OWNER)) {
 		return 1;
 
@@ -998,28 +947,34 @@ static long vma_needs_reservation(struct hstate *h,
 		pgoff_t idx = vma_hugecache_offset(h, vma, addr);
 		struct resv_map *reservations = vma_resv_map(vma);
 
-		err = region_chg(&reservations->regions, idx, idx + 1);
+		err = region_chg(&reservations->rg_root, idx, idx + 1, rg_node);
 		if (err < 0)
 			return err;
 		return 0;
 	}
 }
 static void vma_commit_reservation(struct hstate *h,
-			struct vm_area_struct *vma, unsigned long addr)
+				   struct vm_area_struct *vma,
+				   unsigned long addr,
+				   struct range_tree_node *rg_node)
 {
 	struct address_space *mapping = vma->vm_file->f_mapping;
 	struct inode *inode = mapping->host;
+	struct hugetlbfs_inode_info *hinfo = HUGETLBFS_I(inode);
+
+	if (rg_node == NULL)
+		return;
 
 	if (vma->vm_flags & VM_MAYSHARE) {
 		pgoff_t idx = vma_hugecache_offset(h, vma, addr);
-		region_add(&inode->i_mapping->private_list, idx, idx + 1);
+		region_add(&hinfo->rg_root, idx, idx + 1, rg_node);
 
 	} else if (is_vma_resv_set(vma, HPAGE_RESV_OWNER)) {
 		pgoff_t idx = vma_hugecache_offset(h, vma, addr);
 		struct resv_map *reservations = vma_resv_map(vma);
 
 		/* Mark this page used in the map. */
-		region_add(&reservations->regions, idx, idx + 1);
+		region_add(&reservations->rg_root, idx, idx + 1, rg_node);
 	}
 }
 
@@ -1027,6 +982,7 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
 				    unsigned long addr, int avoid_reserve)
 {
 	int ret, idx;
+	struct range_tree_node *rg_node;
 	struct hstate *h = hstate_vma(vma);
 	struct page *page;
 	struct mem_cgroup *memcg;
@@ -1042,18 +998,24 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
 	 * MAP_NORESERVE mappings may also need pages and quota allocated
 	 * if no reserve mapping overlaps.
 	 */
-	chg = vma_needs_reservation(h, vma, addr);
-	if (chg < 0)
-		return ERR_PTR(-ENOMEM);
-	if (chg)
-		if (hugetlb_get_quota(inode->i_mapping, chg))
-			return ERR_PTR(-ENOSPC);
+	chg = vma_needs_reservation(h, vma, addr, &rg_node);
+	if (chg > 0 && rg_node == NULL) {
+		rg_node = kzalloc(sizeof(*rg_node), GFP_KERNEL);
+		if (rg_node == NULL)
+			return ERR_PTR(-ENOMEM);
+	}
 
+	if (chg) {
+		if (hugetlb_get_quota(inode->i_mapping, chg)) {
+			ret = -ENOSPC;
+			goto err_out;
+		}
+	}
 	ret = mem_cgroup_hugetlb_charge_page(idx, pages_per_huge_page(h),
 					     &memcg);
 	if (ret) {
-		hugetlb_put_quota(inode->i_mapping, chg);
-		return ERR_PTR(-ENOSPC);
+		ret = -ENOSPC;
+		goto err_out_quota;
 	}
 	spin_lock(&hugetlb_lock);
 	page = dequeue_huge_page_vma(h, vma, addr, avoid_reserve);
@@ -1062,21 +1024,26 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
 	if (!page) {
 		page = alloc_buddy_huge_page(h, NUMA_NO_NODE);
 		if (!page) {
-			mem_cgroup_hugetlb_uncharge_memcg(idx,
-							 pages_per_huge_page(h),
-							 memcg);
-			hugetlb_put_quota(inode->i_mapping, chg);
-			return ERR_PTR(-ENOSPC);
+			ret = -ENOSPC;
+			goto err_out_uncharge;
 		}
 	}
 
 	set_page_private(page, (unsigned long) mapping);
 
-	vma_commit_reservation(h, vma, addr);
+	vma_commit_reservation(h, vma, addr, rg_node);
 	/* update page cgroup details */
 	mem_cgroup_hugetlb_commit_charge(idx, pages_per_huge_page(h),
 					 memcg, page);
 	return page;
+
+err_out_uncharge:
+	mem_cgroup_hugetlb_uncharge_memcg(idx, pages_per_huge_page(h), memcg);
+err_out_quota:
+	hugetlb_put_quota(inode->i_mapping, chg);
+err_out:
+	kfree(rg_node);
+	return ERR_PTR(ret);
 }
 
 int __weak alloc_bootmem_huge_page(struct hstate *h)
@@ -2170,7 +2137,7 @@ static void hugetlb_vm_op_close(struct vm_area_struct *vma)
 		end = vma_hugecache_offset(h, vma, vma->vm_end);
 
 		reserve = (end - start) -
-			region_count(&reservations->regions, start, end);
+			region_count(&reservations->rg_root, start, end);
 
 		kref_put(&reservations->refs, resv_map_release);
 
@@ -2697,11 +2664,13 @@ retry:
 	 * any allocations necessary to record that reservation occur outside
 	 * the spinlock.
 	 */
-	if ((flags & FAULT_FLAG_WRITE) && !(vma->vm_flags & VM_SHARED))
-		if (vma_needs_reservation(h, vma, address) < 0) {
+	if ((flags & FAULT_FLAG_WRITE) && !(vma->vm_flags & VM_SHARED)) {
+		struct range_tree_node *rg_node;
+		if (vma_needs_reservation(h, vma, address, &rg_node) < 0) {
 			ret = VM_FAULT_OOM;
 			goto backout_unlocked;
 		}
+	}
 
 	spin_lock(&mm->page_table_lock);
 	size = i_size_read(mapping->host) >> huge_page_shift(h);
@@ -2789,7 +2758,8 @@ int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	 * consumed.
 	 */
 	if ((flags & FAULT_FLAG_WRITE) && !pte_write(entry)) {
-		if (vma_needs_reservation(h, vma, address) < 0) {
+		struct range_tree_node *rg_node;
+		if (vma_needs_reservation(h, vma, address, &rg_node) < 0) {
 			ret = VM_FAULT_OOM;
 			goto out_mutex;
 		}
@@ -2975,7 +2945,9 @@ int hugetlb_reserve_pages(struct inode *inode,
 					vm_flags_t vm_flags)
 {
 	long ret, chg;
+	struct range_tree_node *rg_node;
 	struct hstate *h = hstate_inode(inode);
+	struct hugetlbfs_inode_info *hinfo = HUGETLBFS_I(inode);
 
 	/*
 	 * Only apply hugepage reservation if asked. At fault time, an
@@ -2992,25 +2964,27 @@ int hugetlb_reserve_pages(struct inode *inode,
 	 * called to make the mapping read-write. Assume !vma is a shm mapping
 	 */
 	if (!vma || vma->vm_flags & VM_MAYSHARE)
-		chg = region_chg(&inode->i_mapping->private_list, from, to);
+		chg = region_chg(&hinfo->rg_root, from, to, &rg_node);
 	else {
 		struct resv_map *resv_map = resv_map_alloc();
 		if (!resv_map)
 			return -ENOMEM;
 
-		chg = to - from;
-
+		chg = region_chg(&resv_map->rg_root, from, to, &rg_node);
 		set_vma_resv_map(vma, resv_map);
 		set_vma_resv_flags(vma, HPAGE_RESV_OWNER);
 	}
-
-	if (chg < 0)
-		return chg;
-
+	if (chg > 0 && rg_node == NULL ) {
+		/* We need allocate a new node */
+		rg_node = kzalloc(sizeof(*rg_node), GFP_KERNEL);
+		if (rg_node == NULL)
+			return -ENOMEM;
+	}
 	/* There must be enough filesystem quota for the mapping */
-	if (hugetlb_get_quota(inode->i_mapping, chg))
-		return -ENOSPC;
-
+	if (hugetlb_get_quota(inode->i_mapping, chg)) {
+		ret = -ENOSPC;
+		goto err_out;
+	}
 	/*
 	 * Check enough hugepages are available for the reservation.
 	 * Hand back the quota if there are not
@@ -3018,7 +2992,7 @@ int hugetlb_reserve_pages(struct inode *inode,
 	ret = hugetlb_acct_memory(h, chg);
 	if (ret < 0) {
 		hugetlb_put_quota(inode->i_mapping, chg);
-		return ret;
+		goto err_out;
 	}
 
 	/*
@@ -3033,14 +3007,19 @@ int hugetlb_reserve_pages(struct inode *inode,
 	 * else has to be done for private mappings here
 	 */
 	if (!vma || vma->vm_flags & VM_MAYSHARE)
-		region_add(&inode->i_mapping->private_list, from, to);
+		region_add(&hinfo->rg_root, from, to, rg_node);
 	return 0;
+err_out:
+	kfree(rg_node);
+	return ret;
 }
 
 void hugetlb_unreserve_pages(struct inode *inode, long offset, long freed)
 {
 	struct hstate *h = hstate_inode(inode);
-	long chg = region_truncate(&inode->i_mapping->private_list, offset);
+	struct hugetlbfs_inode_info *hinfo = HUGETLBFS_I(inode);
+
+	long chg = region_truncate(&hinfo->rg_root, offset);
 
 	spin_lock(&inode->i_lock);
 	inode->i_blocks -= (blocks_per_huge_page(h) * freed);

