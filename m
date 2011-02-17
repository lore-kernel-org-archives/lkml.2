Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547Ab1BQSFh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 13:05:37 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:50796 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757442Ab1BQSCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 13:02:19 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 01/14] fs/9p: Fix inode i_size update in file_write
Date: Thu, 17 Feb 2011 23:31:52 +0530
Message-Id: <1297965725-25603-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297965725-25603-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1297965725-25603-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only update inode i_size when we write towards end of file.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/vfs_file.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index e9cd277..a56a33b 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -451,6 +451,7 @@ v9fs_file_write_internal(struct inode *inode, struct p9_fid *fid, char *data,
 			 size_t count, loff_t *offset)
 {
 	int n;
+	loff_t i_size;
 	size_t total = 0;
 	struct p9_client *clnt;
 	loff_t origin = *offset;
@@ -475,10 +476,12 @@ v9fs_file_write_internal(struct inode *inode, struct p9_fid *fid, char *data,
 			invalidate_inode_pages2_range(inode->i_mapping,
 						      pg_start, pg_end);
 		*offset += total;
-		i_size_write(inode, i_size_read(inode) + total);
-		inode->i_blocks = (i_size_read(inode) + 512 - 1) >> 9;
+		i_size = i_size_read(inode);
+		if (*offset > i_size) {
+			inode_add_bytes(inode, *offset - i_size);
+			i_size_write(inode, *offset);
+		}
 	}
-
 	if (n < 0)
 		return n;
 
-- 
1.7.1

