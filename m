Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab2LOK7Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 05:59:25 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:40965 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588Ab2LOK7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 05:59:23 -0500
Message-ID: <50CC5671.9030207@gmail.com>
Date: Sat, 15 Dec 2012 11:52:33 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: "Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/21] bfs: drop vmtruncate
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed vmtruncate

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/bfs/file.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/bfs/file.c b/fs/bfs/file.c
index f20e8a7..ad3ea14 100644
--- a/fs/bfs/file.c
+++ b/fs/bfs/file.c
@@ -161,6 +161,14 @@ static int bfs_readpage(struct file *file, struct page *page)
 	return block_read_full_page(page, bfs_get_block);
 }
 
+static void bfs_write_failed(struct address_space *mapping, loff_t to)
+{
+	struct inode *inode = mapping->host;
+
+	if (to > inode->i_size)
+		truncate_pagecache(inode, to, inode->i_size);
+}
+
 static int bfs_write_begin(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned flags,
 			struct page **pagep, void **fsdata)
@@ -169,11 +177,8 @@ static int bfs_write_begin(struct file *file, struct address_space *mapping,
 
 	ret = block_write_begin(mapping, pos, len, flags, pagep,
 				bfs_get_block);
-	if (unlikely(ret)) {
-		loff_t isize = mapping->host->i_size;
-		if (pos + len > isize)
-			vmtruncate(mapping->host, isize);
-	}
+	if (unlikely(ret))
+		bfs_write_failed(mapping, pos + len);
 
 	return ret;
 }
-- 
1.7.3.4
