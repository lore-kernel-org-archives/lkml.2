Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030677Ab2CNHUK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 03:20:10 -0400
Received: from mail-fa0-f74.google.com ([209.85.161.74]:52609 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab2CNHTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 03:19:51 -0400
From: Greg Thelen <gthelen@google.com>
To: linux-mm <linux-mm@kvack.org>, Zheng Liu <gnehzuil.liu@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: Control page reclaim granularity
References: <20120308161318.GA9904@gmail.com>
Date: Wed, 14 Mar 2012 00:19:43 -0700
Message-ID: <xr93wr6n7ipc.fsf@gthelen.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zheng Liu <gnehzuil.liu@gmail.com> writes:
> Hi Greg,
>
> Sorry, I forgot to say that I don't subscribe linux-mm and linux-kernel
> mailing list.  So please Cc me.
>
> I am glad to receive your reply and I am very interesting for your
> approach.  Actually I am not very familiar with CGroup.  So would you
> please send your patch to me if you can?  Thank you all the same.
>
> Regards,
> Zheng

Sorry for the delay, I had trouble finding my old prototype patch.  The
patch below is based on v2.6.34.  The patch is just an idea not a
complete solution.

>From b1b127e0e1443446d51353b0d7a776bddc046009 Mon Sep 17 00:00:00 2001
From: Greg Thelen <gthelen@google.com>
Date: Sat, 5 Jun 2010 17:26:06 -0700
Subject: [PATCH] memcg: prototype of dentry/cgroup binding.

JUST A PROTOTYPE: DO NOT SUBMIT

This creates a /dev/cgroup/memory/X/memory.dir_roots file which one can
use to register a directory file descriptors.  The idea is that future
charges to registered directories, including child inodes, will be
billed to memcg X rather than whatever memcg the faulting process runs
within.
---
 fs/dcache.c                |    4 +++
 include/linux/dcache.h     |    1 +
 include/linux/memcontrol.h |    2 +-
 mm/filemap.c               |    3 ++
 mm/memcontrol.c            |   64 ++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 73 insertions(+), 1 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index f1358e5..dda48d7 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -70,6 +70,7 @@ struct dentry_stat_t dentry_stat = {
 static void __d_free(struct dentry *dentry)
 {
 	WARN_ON(!list_empty(&dentry->d_alias));
+	BUG_ON(dentry->d_mem);
 	if (dname_external(dentry))
 		kfree(dentry->d_name.name);
 	kmem_cache_free(dentry_cache, dentry); 
@@ -172,6 +173,7 @@ static struct dentry *d_kill(struct dentry *dentry)
 	struct dentry *parent;
 
 	list_del(&dentry->d_u.d_child);
+	mem_cgroup_disassociate_from_dentry(dentry);
 	dentry_stat.nr_dentry--;	/* For d_free, below */
 	/*drops the locks, at that point nobody can reach this dentry */
 	dentry_iput(dentry);
@@ -953,6 +955,7 @@ struct dentry *d_alloc(struct dentry * parent, const struct qstr *name)
 	dentry->d_inode = NULL;
 	dentry->d_parent = NULL;
 	dentry->d_sb = NULL;
+	dentry->d_mem = NULL;
 	dentry->d_op = NULL;
 	dentry->d_fsdata = NULL;
 	dentry->d_mounted = 0;
@@ -964,6 +967,7 @@ struct dentry *d_alloc(struct dentry * parent, const struct qstr *name)
 	if (parent) {
 		dentry->d_parent = dget(parent);
 		dentry->d_sb = parent->d_sb;
+		dentry->d_mem = parent->d_mem;
 	} else {
 		INIT_LIST_HEAD(&dentry->d_u.d_child);
 	}
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index eebb617..523d58b 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -114,6 +114,7 @@ struct dentry {
 	unsigned long d_time;		/* used by d_revalidate */
 	const struct dentry_operations *d_op;
 	struct super_block *d_sb;	/* The root of the dentry tree */
+	struct mem_cgroup *d_mem;	/* Optional memcg */
 	void *d_fsdata;			/* fs-specific data */
 
 	unsigned char d_iname[DNAME_INLINE_LEN_MIN];	/* small names */
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 44301c6..a8b54f9 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -71,6 +71,7 @@ extern unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
 					struct mem_cgroup *mem_cont,
 					int active, int file);
 extern void mem_cgroup_out_of_memory(struct mem_cgroup *mem, gfp_t gfp_mask);
+void mem_cgroup_disassociate_from_dentry(struct dentry *dentry);
 int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *mem);
 
 extern struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page);
@@ -309,4 +310,3 @@ unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
 #endif /* CONFIG_CGROUP_MEM_CONT */
 
 #endif /* _LINUX_MEMCONTROL_H */
-
diff --git a/mm/filemap.c b/mm/filemap.c
index 140ebda..a9a525b 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -400,8 +400,11 @@ int add_to_page_cache_locked(struct page *page, struct address_space *mapping,
 
 	VM_BUG_ON(!PageLocked(page));
 
+	VM_BUG_ON(page->mapping != NULL);
+	page->mapping = mapping; /* XXX: hack? */
 	error = mem_cgroup_cache_charge(page, current->mm,
 					gfp_mask & GFP_RECLAIM_MASK);
+	page->mapping = NULL; /* XXX: hack? */
 	if (error)
 		goto out;
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8a79a6f..de9f150 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -793,6 +793,23 @@ void mem_cgroup_move_lists(struct page *page,
 	mem_cgroup_add_lru_list(page, to);
 }
 
+static void mem_cgroup_associate_dentry(struct mem_cgroup *mem,
+					struct dentry *dentry)
+{
+	css_get(&mem->css);
+	BUG_ON(dentry->d_mem);
+	dentry->d_mem = mem;
+}
+
+void mem_cgroup_disassociate_from_dentry(struct dentry *dentry)
+{
+	if (!dentry->d_mem)
+		return;
+
+	css_put(&dentry->d_mem->css);
+	dentry->d_mem = NULL;
+}
+
 int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *mem)
 {
 	int ret;
@@ -1914,6 +1931,29 @@ static int mem_cgroup_charge_common(struct page *page, struct mm_struct *mm,
 		return 0;
 	prefetchw(pc);
 
+	/*
+	 * If the page is inode and related dentry indicates a cgroup, then
+	 * charge that cgroup.  Otherwise fallback on the mm's cgroup.
+	 *
+	 * TODO(gthelen): this needs more thought.
+	 */
+	if ((memcg == NULL) && !PageAnon(page)) {
+		struct address_space *as;
+		struct inode *inode;
+		struct dentry *dentry;
+
+		/* what kind of locking is needed to walk this?  dcache_lock (gulp)? */
+		as = (struct address_space *)page_rmapping(page);
+		if (as != NULL) {
+			inode = as->host;
+			BUG_ON(inode == NULL);
+			list_for_each_entry(dentry, &inode->i_dentry, d_alias) {
+				memcg = dentry->d_mem;
+				break;
+			}
+		}
+	}
+
 	mem = memcg;
 	ret = __mem_cgroup_try_charge(mm, gfp_mask, &mem, true);
 	if (ret || !mem)
@@ -3539,6 +3579,26 @@ unlock:
 	return ret;
 }
 
+static int mem_cgroup_dir_roots_write(struct cgroup *cgrp, struct cftype *cft,
+				      u64 dir_fd)
+{
+	struct mem_cgroup *mem = mem_cgroup_from_cont(cgrp);
+	struct file *dir;
+	int status = 0;
+
+	dir = fget(dir_fd);
+	if (!dir)
+		return -EINVAL;
+
+	if (dir->f_dentry->d_mem)
+		status = -EINVAL;
+	else
+		mem_cgroup_associate_dentry(mem, dir->f_dentry);
+
+	fput(dir);
+	return status;
+}
+
 static struct cftype mem_cgroup_files[] = {
 	{
 		.name = "usage_in_bytes",
@@ -3594,6 +3654,10 @@ static struct cftype mem_cgroup_files[] = {
 		.read_u64 = mem_cgroup_move_charge_read,
 		.write_u64 = mem_cgroup_move_charge_write,
 	},
+	{
+		.name = "dir_roots",
+		.write_u64  = mem_cgroup_dir_roots_write,
+	},
 };
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
-- 
1.7.7.3

