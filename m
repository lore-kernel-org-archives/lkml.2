Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab2B0OJn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 09:09:43 -0500
Received: from bureau85.ns.utoronto.ca ([128.100.132.185]:42163 "EHLO
	bureau85.ns.utoronto.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab2B0OJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 09:09:41 -0500
From: Steven Truelove <steven.truelove@utoronto.ca>
To: wli@holomorphy.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
        Steven Truelove <steven.truelove@utoronto.ca>
Subject: [PATCH] HUGETLBFS: Align memory request to multiple of huge page size to avoid underallocating.
Date: Mon, 27 Feb 2012 09:09:28 -0500
Message-Id: <1330351768-14874-1-git-send-email-steven.truelove@utoronto.ca>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When calling shmget with SHM_HUGETLB, shmget aligns the request size to PAGE_SIZE, but this is not sufficient.  Modified hugetlb_file_setup to align requests to the huge page size.

Signed-off-by: Steven Truelove <steven.truelove@utoronto.ca>
---
 fs/hugetlbfs/inode.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 1e85a7a..6c23f09 100644
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
+	num_pages = (size + huge_page_size(hstate) - 1) >>
+			huge_page_shift(hstate);
 	error = -ENOMEM;
-	if (hugetlb_reserve_pages(inode, 0,
-			size >> huge_page_shift(hstate_inode(inode)), NULL,
-			acctflag))
+	if (hugetlb_reserve_pages(inode, 0, num_pages, NULL, acctflag))
 		goto out_inode;
 
 	d_instantiate(path.dentry, inode);
-- 
1.7.3.4

