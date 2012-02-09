Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871Ab2BIRrP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 12:47:15 -0500
Received: from bureau59.ns.utoronto.ca ([128.100.132.146]:50413 "EHLO
	bureau59.ns.utoronto.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757197Ab2BIRrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 12:47:14 -0500
X-Greylist: delayed 5332 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Feb 2012 12:47:14 EST
From: Steven Truelove <steven.truelove@utoronto.ca>
To: wli@holomorphy.com
Cc: linux-kernel@vger.kernel.org,
        Steven Truelove <steven.truelove@utoronto.ca>
Subject: [PATCH] Round up huge page count to avoid allocating too little memory when 'size' argument is not a multiple of the huge page size.
Date: Thu,  9 Feb 2012 11:16:03 -0500
Message-Id: <1328804163-24134-1-git-send-email-steven.truelove@utoronto.ca>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Steven Truelove <steven.truelove@utoronto.ca>
---
 fs/hugetlbfs/inode.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 1e85a7a..fce2527 100644
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
@@ -967,10 +969,10 @@ struct file *hugetlb_file_setup(const char *name, size_t size,
 	if (!inode)
 		goto out_dentry;
 
+	hstate = hstate_inode(inode);
+	num_pages = (size + huge_page_size(hstate) - 1) >> huge_page_shift(hstate);
 	error = -ENOMEM;
-	if (hugetlb_reserve_pages(inode, 0,
-			size >> huge_page_shift(hstate_inode(inode)), NULL,
-			acctflag))
+	if (hugetlb_reserve_pages(inode, 0, num_pages, NULL, acctflag))
 		goto out_inode;
 
 	d_instantiate(path.dentry, inode);
-- 
1.7.3.4

