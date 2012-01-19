Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab2ASJNo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 04:13:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54009 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071Ab2ASJNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 04:13:40 -0500
From: Tyler Hicks <tyhicks@canonical.com>
To: Li Wang <liwang@nudt.edu.cn>
Cc: ecryptfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Yunchuan Wen <wenyunchuan@kylinos.com.cn>
Subject: [PATCH] eCryptfs: infinite loop due to overflow in ecryptfs_write()
Date: Thu, 19 Jan 2012 03:13:33 -0600
Message-Id: <1326964413-8529-1-git-send-email-tyhicks@canonical.com>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <12011909443668a7a65ff897afc93db177848236f08f@nudt.edu.cn>
References: <12011909443668a7a65ff897afc93db177848236f08f@nudt.edu.cn>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Wang <liwang@nudt.edu.cn>

ecryptfs_write() can enter an infinite loop when truncating a file to a
size larger than 4G. This only happens on architectures where size_t is
represented by 32 bits.

This was caused by a size_t overflow due to it incorrectly being used to
store the result of a calculation which uses potentially large values of
type loff_t.

[tyhicks@canonical.com: rewrite subject and commit message]
Signed-off-by: Li Wang <liwang@nudt.edu.cn>
Signed-off-by: Yunchuan Wen <wenyunchuan@kylinos.com.cn>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
---
 fs/ecryptfs/read_write.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ecryptfs/read_write.c b/fs/ecryptfs/read_write.c
index 3745f7c..ec3d936 100644
--- a/fs/ecryptfs/read_write.c
+++ b/fs/ecryptfs/read_write.c
@@ -130,13 +130,13 @@ int ecryptfs_write(struct inode *ecryptfs_inode, char *data, loff_t offset,
 		pgoff_t ecryptfs_page_idx = (pos >> PAGE_CACHE_SHIFT);
 		size_t start_offset_in_page = (pos & ~PAGE_CACHE_MASK);
 		size_t num_bytes = (PAGE_CACHE_SIZE - start_offset_in_page);
-		size_t total_remaining_bytes = ((offset + size) - pos);
+		loff_t total_remaining_bytes = ((offset + size) - pos);
 
 		if (num_bytes > total_remaining_bytes)
 			num_bytes = total_remaining_bytes;
 		if (pos < offset) {
 			/* remaining zeros to write, up to destination offset */
-			size_t total_remaining_zeros = (offset - pos);
+			loff_t total_remaining_zeros = (offset - pos);
 
 			if (num_bytes > total_remaining_zeros)
 				num_bytes = total_remaining_zeros;
-- 
1.7.8.3

