Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757Ab2CHBGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 20:06:52 -0500
Received: from bureau85.ns.utoronto.ca ([128.100.132.185]:36937 "EHLO
	bureau85.ns.utoronto.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab2CHBGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 20:06:51 -0500
From: Steven Truelove <steven.truelove@utoronto.ca>
To: wli@holomorphy.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
        Steven Truelove <steven.truelove@utoronto.ca>
Subject: [PATCH] Correct alignment of huge page requests.
Date: Wed,  7 Mar 2012 20:06:36 -0500
Message-Id: <1331168796-17833-1-git-send-email-steven.truelove@utoronto.ca>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When calling shmget() with SHM_HUGETLB, shmget aligns the request size to PAGE_SIZE, but this is not sufficient.  Modified hugetlb_file_setup() to align requests to the huge page size, and to accept an address argument so that all alignment checks can be performed in hugetlb_file_setup(), rather than in its callers.  Changed newseg and mmap_pgoff to match new prototype and eliminated a now redundant alignment check.

Signed-off-by: Steven Truelove <steven.truelove@utoronto.ca>
---
 fs/hugetlbfs/inode.c    |   14 +++++++++-----
 include/linux/hugetlb.h |    3 ++-
 ipc/shm.c               |    2 +-
 mm/mmap.c               |    6 +++---
 4 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 1e85a7a..815be2f 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -928,8 +928,8 @@ static int can_do_hugetlb_shm(void)
 	return capable(CAP_IPC_LOCK) || in_group_p(sysctl_hugetlb_shm_group);
 }
 
-struct file *hugetlb_file_setup(const char *name, size_t size,
-				vm_flags_t acctflag,
+struct file *hugetlb_file_setup(const char *name, unsigned long addr,
+				size_t size, vm_flags_t acctflag,
 				struct user_struct **user, int creat_flags)
 {
 	int error = -ENOMEM;
@@ -938,6 +938,8 @@ struct file *hugetlb_file_setup(const char *name, size_t size,
 	struct path path;
 	struct dentry *root;
 	struct qstr quick_string;
+	struct hstate *hstate;
+	unsigned long num_pages;
 
 	*user = NULL;
 	if (!hugetlbfs_vfsmount)
@@ -967,10 +969,12 @@ struct file *hugetlb_file_setup(const char *name, size_t size,
 	if (!inode)
 		goto out_dentry;
 
+	hstate = hstate_inode(inode);
+	size += addr & ~huge_page_mask(hstate);
+	num_pages = ALIGN(size, huge_page_size(hstate)) >>
+			huge_page_shift(hstate);
 	error = -ENOMEM;
-	if (hugetlb_reserve_pages(inode, 0,
-			size >> huge_page_shift(hstate_inode(inode)), NULL,
-			acctflag))
+	if (hugetlb_reserve_pages(inode, 0, num_pages, NULL, acctflag))
 		goto out_inode;
 
 	d_instantiate(path.dentry, inode);
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index d9d6c86..4b9e59d 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -164,7 +164,8 @@ static inline struct hugetlbfs_sb_info *HUGETLBFS_SB(struct super_block *sb)
 
 extern const struct file_operations hugetlbfs_file_operations;
 extern const struct vm_operations_struct hugetlb_vm_ops;
-struct file *hugetlb_file_setup(const char *name, size_t size, vm_flags_t acct,
+struct file *hugetlb_file_setup(const char *name, unsigned long addr,
+				size_t size, vm_flags_t acct,
 				struct user_struct **user, int creat_flags);
 int hugetlb_get_quota(struct address_space *mapping, long delta);
 void hugetlb_put_quota(struct address_space *mapping, long delta);
diff --git a/ipc/shm.c b/ipc/shm.c
index b76be5b..406c5b2 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -482,7 +482,7 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 		/* hugetlb_file_setup applies strict accounting */
 		if (shmflg & SHM_NORESERVE)
 			acctflag = VM_NORESERVE;
-		file = hugetlb_file_setup(name, size, acctflag,
+		file = hugetlb_file_setup(name, 0, size, acctflag,
 					&shp->mlock_user, HUGETLB_SHMFS_INODE);
 	} else {
 		/*
diff --git a/mm/mmap.c b/mm/mmap.c
index da15a79..e21abf7 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1099,9 +1099,9 @@ SYSCALL_DEFINE6(mmap_pgoff, unsigned long, addr, unsigned long, len,
 		 * A dummy user value is used because we are not locking
 		 * memory so no accounting is necessary
 		 */
-		len = ALIGN(len, huge_page_size(&default_hstate));
-		file = hugetlb_file_setup(HUGETLB_ANON_FILE, len, VM_NORESERVE,
-						&user, HUGETLB_ANONHUGE_INODE);
+		file = hugetlb_file_setup(HUGETLB_ANON_FILE, addr, len,
+						VM_NORESERVE, &user,
+						HUGETLB_ANONHUGE_INODE);
 		if (IS_ERR(file))
 			return PTR_ERR(file);
 	}
-- 
1.7.3.4

