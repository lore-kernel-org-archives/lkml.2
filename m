Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab2BPImk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 03:42:40 -0500
Received: from mail.nudt.edu.cn ([61.187.54.11]:38323 "HELO eyou.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755758Ab2BPImf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 03:42:35 -0500
X-EYOU-SPAMVALUE: 0
X-EYOU-DEALDRC: 
X-EMDG-VER: 2011-01-28
Message-ID: <529380713.15452@eyou.net>
X-EYOUMAIL-SMTPAUTH: liwang@nudt.edu.cn
From: Li Wang <liwang@nudt.edu.cn>
To: Tyler Hicks <tyhicks@canonical.com>
Cc: <ecryptfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Li Wang <liwang@nudt.edu.cn>
Subject: [PATCH 3/3] eCryptfs: Remove unreached codes
Date: Fri, 17 Feb 2012 00:36:50 +0800
Message-Id: <1329410210-2712-3-git-send-email-liwang@nudt.edu.cn>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1329410210-2712-1-git-send-email-liwang@nudt.edu.cn>
References: <1329410210-2712-1-git-send-email-liwang@nudt.edu.cn>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code segment handles the ECRYPTFS_VIEW_AS_ENCRYPTED option in
ecryptfs_write_begin(mmap.c) is unreached, since this option is
enabled only when eCryptfs is mounted with RDONLY.

Signed-off-by: Li Wang <liwang@nudt.edu.cn>
---
 fs/ecryptfs/mmap.c |   29 +----------------------------
 1 files changed, 1 insertions(+), 28 deletions(-)

diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
index 59a8e57..a4802a6 100644
--- a/fs/ecryptfs/mmap.c
+++ b/fs/ecryptfs/mmap.c
@@ -320,35 +320,8 @@ static int ecryptfs_write_begin(struct file *file,
 				goto out;
 			} else
 				SetPageUptodate(page);
-		} else if (crypt_stat->flags & ECRYPTFS_VIEW_AS_ENCRYPTED) {
-			if (crypt_stat->flags & ECRYPTFS_METADATA_IN_XATTR) {
-				rc = ecryptfs_copy_up_encrypted_with_header(
-					page, crypt_stat);
-				if (rc) {
-					printk(KERN_ERR "%s: Error attempting "
-					       "to copy the encrypted content "
-					       "from the lower file whilst "
-					       "inserting the metadata from "
-					       "the xattr into the header; rc "
-					       "= [%d]\n", __func__, rc);
-					ClearPageUptodate(page);
-					goto out;
-				}
-				SetPageUptodate(page);
-			} else {
-				rc = ecryptfs_read_lower_page_segment(
-					page, index, 0, PAGE_CACHE_SIZE,
-					mapping->host);
-				if (rc) {
-					printk(KERN_ERR "%s: Error reading "
-					       "page; rc = [%d]\n",
-					       __func__, rc);
-					ClearPageUptodate(page);
-					goto out;
-				}
-				SetPageUptodate(page);
-			}
 		} else {
+			BUG_ON(crypt_stat->flags & ECRYPTFS_VIEW_AS_ENCRYPTED);
 			if (prev_page_end_size
 			    >= i_size_read(page->mapping->host)) {
 				zero_user(page, 0, PAGE_CACHE_SIZE);
-- 
1.7.6.5

