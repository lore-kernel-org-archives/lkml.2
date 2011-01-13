Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289Ab1AMUqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 15:46:35 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60832 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757152Ab1AMUqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 15:46:30 -0500
Date: Thu, 13 Jan 2011 15:46:28 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] ECRYPT_FS
Message-ID: <20110113204628.GA9576@infradead.org>
References: <1294950181.3403.9.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294950181.3403.9.camel@edumazet-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 09:23:01PM +0100, Eric Dumazet wrote:
> Hi Al
> 
> FYI, current linux-2.6 is broken for CONFIG_ECRYPT_FS

The patch below fixes it:

Index: linux-2.6/fs/ecryptfs/main.c
===================================================================
--- linux-2.6.orig/fs/ecryptfs/main.c	2011-01-13 21:35:02.742004281 +0100
+++ linux-2.6/fs/ecryptfs/main.c	2011-01-13 21:42:05.032254595 +0100
@@ -141,13 +141,12 @@ int ecryptfs_init_persistent_file(struct
 	return rc;
 }
 
-static inode *ecryptfs_get_inode(struct inode *lower_inode,
+static struct inode *ecryptfs_get_inode(struct inode *lower_inode,
 		       struct super_block *sb)
 {
 	struct inode *inode;
 	int rc = 0;
 
-	lower_inode = lower_dentry->d_inode;
 	if (lower_inode->i_sb != ecryptfs_superblock_to_lower(sb)) {
 		rc = -EXDEV;
 		goto out;
@@ -202,7 +201,8 @@ int ecryptfs_interpose(struct dentry *lo
 {
 	struct inode *lower_inode = lower_dentry->d_inode;
 	struct inode *inode = ecryptfs_get_inode(lower_inode, sb);
-	if (IS_ERR(inode)
+
+	if (IS_ERR(inode))
 		return PTR_ERR(inode);
 	if (flags & ECRYPTFS_INTERPOSE_FLAG_D_ADD)
 		d_add(dentry, inode);
