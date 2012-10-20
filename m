Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120Ab2JTMWS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 08:22:18 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62102 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab2JTMWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 08:22:16 -0400
Message-ID: <508295EB.1060401@gmail.com>
Date: Sat, 20 Oct 2012 14:15:39 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Evgeniy Dushistov <dushistov@mail.ru>, linux-kernel@vger.kernel.org
Subject: [PATCH 01/21] ufs: drop vmtruncate
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed vmtruncate

Signed-off-by: Marco <marco.stornelli@gmail.com>
---
 fs/ufs/inode.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/ufs/inode.c b/fs/ufs/inode.c
index eb6d0b7..ff24e44 100644
--- a/fs/ufs/inode.c
+++ b/fs/ufs/inode.c
@@ -526,6 +526,14 @@ int ufs_prepare_chunk(struct page *page, loff_t pos, unsigned len)
 	return __block_write_begin(page, pos, len, ufs_getfrag_block);
 }
 
+static void ufs_write_failed(struct address_space *mapping, loff_t to)
+{
+	struct inode *inode = mapping->host;
+
+	if (to > inode->i_size)
+		truncate_pagecache(inode, to, inode->i_size);
+}
+
 static int ufs_write_begin(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned flags,
 			struct page **pagep, void **fsdata)
@@ -534,11 +542,8 @@ static int ufs_write_begin(struct file *file, struct address_space *mapping,
 
 	ret = block_write_begin(mapping, pos, len, flags, pagep,
 				ufs_getfrag_block);
-	if (unlikely(ret)) {
-		loff_t isize = mapping->host->i_size;
-		if (pos + len > isize)
-			vmtruncate(mapping->host, isize);
-	}
+	if (unlikely(ret))
+		ufs_write_failed(mapping, pos + len);
 
 	return ret;
 }
-- 
1.7.3.4
