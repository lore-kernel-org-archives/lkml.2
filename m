Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932835Ab1AMVPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 16:15:51 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42581 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756691Ab1AMVPp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 16:15:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:user-agent;
        b=UmUCYr8yNOnR4Ujw4GjE1xH/kAb1yPlRDnEeu4zjQSdeVBqsn9JBmTOAvYSK/8oUYA
         3PBJYazeq4LMvoYmS30fwPKd4+8PGrWyFLmej1DRRhoozmoGzWWdXYBwva55t5rnhSbB
         GkDgZpLtA2T4xoKGnnzuulZYvVu41Go02xAC8=
Date: Thu, 13 Jan 2011 23:15:35 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Cc: Dustin Kirkland <kirkland@canonical.com>,
        ecryptfs-devel@lists.launchpad.net, linux-kernel@vger.kernel.org
Subject: ecryptfs build failure
Message-ID: <20110113211535.GB4044@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Recent kernel failed to build due to ecryptfs/main.
2 of 3 errors could be fixed with the following patch. The third is:
we make an assignment `lower_inode = lower_dentry->d_inode;' in
ecryptfs_get_inode, yet ecryptfs_get_inode knows nothing about lower_dentry.

---

 fs/ecryptfs/main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index 9ed4769..5694d65 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -141,7 +141,7 @@ int ecryptfs_init_persistent_file(struct dentry *ecryptfs_dentry)
 	return rc;
 }
 
-static inode *ecryptfs_get_inode(struct inode *lower_inode,
+static struct inode *ecryptfs_get_inode(struct inode *lower_inode,
 		       struct super_block *sb)
 {
 	struct inode *inode;
@@ -202,7 +202,7 @@ int ecryptfs_interpose(struct dentry *lower_dentry, struct dentry *dentry,
 {
 	struct inode *lower_inode = lower_dentry->d_inode;
 	struct inode *inode = ecryptfs_get_inode(lower_inode, sb);
-	if (IS_ERR(inode)
+	if (IS_ERR(inode))
 		return PTR_ERR(inode);
 	if (flags & ECRYPTFS_INTERPOSE_FLAG_D_ADD)
 		d_add(dentry, inode);

