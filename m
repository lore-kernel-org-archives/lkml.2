Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab2LOK6F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 05:58:05 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:51295 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588Ab2LOK6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 05:58:02 -0500
Message-ID: <50CC561F.9020806@gmail.com>
Date: Sat, 15 Dec 2012 11:51:11 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 07/21] adfs: drop vmtruncate
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed vmtruncate

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
 fs/adfs/inode.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/adfs/inode.c b/fs/adfs/inode.c
index e9bad50..5f95d1e 100644
--- a/fs/adfs/inode.c
+++ b/fs/adfs/inode.c
@@ -45,6 +45,14 @@ static int adfs_readpage(struct file *file, struct page *page)
 	return block_read_full_page(page, adfs_get_block);
 }
 
+static void adfs_write_failed(struct address_space *mapping, loff_t to)
+{
+	struct inode *inode = mapping->host;
+
+	if (to > inode->i_size)
+		truncate_pagecache(inode, to, inode->i_size);
+}
+
 static int adfs_write_begin(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned flags,
 			struct page **pagep, void **fsdata)
@@ -55,11 +63,8 @@ static int adfs_write_begin(struct file *file, struct address_space *mapping,
 	ret = cont_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
 				adfs_get_block,
 				&ADFS_I(mapping->host)->mmu_private);
-	if (unlikely(ret)) {
-		loff_t isize = mapping->host->i_size;
-		if (pos + len > isize)
-			vmtruncate(mapping->host, isize);
-	}
+	if (unlikely(ret))
+		adfs_write_failed(mapping, pos + len);
 
 	return ret;
 }
-- 
1.7.3.4
