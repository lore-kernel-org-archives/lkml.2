Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab2BWObl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 09:31:41 -0500
Received: from static-68-179-122-211.ptr.terago.net ([68.179.122.211]:59925
	"EHLO localhost.localdomain" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756139Ab2BWObi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 09:31:38 -0500
X-Greylist: delayed 3680 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Feb 2012 09:31:38 EST
From: Steven Truelove <steven.truelove@utoronto.ca>
To: wli@holomorphy.com
Cc: steven.truelove@utoronto.ca, linux-kernel@vger.kernel.org
Subject: [PATCH] Round up huge page count to avoid allocating too little memory when 'size' argument is not a multiple of the huge page size.
Date: Thu, 23 Feb 2012 08:28:27 -0500
Message-Id: <1330003707-31739-1-git-send-email-steven.truelove@utoronto.ca>
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

