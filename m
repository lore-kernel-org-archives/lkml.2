Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab2B1EBE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 23:01:04 -0500
Received: from bureau60.ns.utoronto.ca ([128.100.132.147]:50969 "EHLO
	bureau60.ns.utoronto.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab2B1EBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 23:01:03 -0500
From: Steven Truelove <steven.truelove@utoronto.ca>
To: wli@holomorphy.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Steven Truelove <steven.truelove@utoronto.ca>
Subject: [PATCH] Correct alignment of huge page requests.
Date: Mon, 27 Feb 2012 23:00:28 -0500
Message-Id: <1330401628-30818-1-git-send-email-steven.truelove@utoronto.ca>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When calling shmget() with SHM_HUGETLB, shmget aligns the request size to PAGE_SIZE, but this is not sufficient.  Modified hugetlb_file_setup() to align requests to the huge page size.  Also modified mmap_pgoff() to avoid duplicating this check and to align against the start address.

Signed-off-by: Steven Truelove <steven.truelove@utoronto.ca>
---
 fs/hugetlbfs/inode.c |    9 ++++++---
 mm/mmap.c            |    6 +++++-
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 1e85a7a..b4bed46 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -938,6 +938,8 @@ struct file *hugetlb_file_setup(const char *name, size_t size,
 	struct path path;
 	struct dentry *root;
 	struct qstr quick_string;
+	struct hstate *hstate;
+	int num_pages;
 
 	*user = NULL;
 	if (!hugetlbfs_vfsmount)
@@ -967,10 +969,11 @@ struct file *hugetlb_file_setup(const char *name, size_t size,
 	if (!inode)
 		goto out_dentry;
 
+	hstate = hstate_inode(inode);
+	num_pages = ALIGN(size, huge_page_size(hstate)) >>
+			huge_page_shift(hstate);
 	error = -ENOMEM;
-	if (hugetlb_reserve_pages(inode, 0,
-			size >> huge_page_shift(hstate_inode(inode)), NULL,
-			acctflag))
+	if (hugetlb_reserve_pages(inode, 0, num_pages, NULL, acctflag))
 		goto out_inode;
 
 	d_instantiate(path.dentry, inode);
diff --git a/mm/mmap.c b/mm/mmap.c
index 3f758c7..1f44ccf 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1098,8 +1098,12 @@ SYSCALL_DEFINE6(mmap_pgoff, unsigned long, addr, unsigned long, len,
 		 * taken when vm_ops->mmap() is called
 		 * A dummy user value is used because we are not locking
 		 * memory so no accounting is necessary
+		 * Length is increased by the amount necessary to align
+		 * the base address to the huge page size.
+		 * hugetlb_file_setup() aligns the end of the buffer to
+		 * the huge page size.
 		 */
-		len = ALIGN(len, huge_page_size(&default_hstate));
+		len += ALIGN(addr, huge_page_size(&default_hstate)) - addr;
 		file = hugetlb_file_setup(HUGETLB_ANON_FILE, len, VM_NORESERVE,
 						&user, HUGETLB_ANONHUGE_INODE);
 		if (IS_ERR(file))
-- 
1.7.3.4

