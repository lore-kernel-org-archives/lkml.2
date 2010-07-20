Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761197Ab0GTKKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 06:10:05 -0400
Received: from mail.gmx.net ([213.165.64.20]:39587 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1761151Ab0GTKKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 06:10:01 -0400
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX19ceOZ4gvNcsPyViwLc3Z+GzRgrclygVxs7QWU1fw
	7EXiWpq4VtafAz
Date: Tue, 20 Jul 2010 12:09:57 +0200
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: tyhicks@linux.vnet.ibm.com
Cc: kirkland@canonical.com, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject: [PATCH] ecryptfs: release reference to lower mount if interpose
	fails
Message-ID: <20100720100957.GB2908@lsanfilippo.unix.rd.tt.avira.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In ecrpytfs_lookup_and_interpose_lower() the lower mount is not decremented if allocation of a dentry info struct failed. As a result the lower filesystem cant be unmounted any more (since it is considered busy). This patch corrects the reference counting.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
This patch is against 2.6.35-rc5.

--- a/fs/ecryptfs/inode.c	2010-07-12 23:55:33.000000000 +0200
+++ b/fs/ecryptfs/inode.c	2010-07-19 19:21:16.000000000 +0200
@@ -264,7 +264,7 @@ int ecryptfs_lookup_and_interpose_lower(
 		printk(KERN_ERR "%s: Out of memory whilst attempting "
 		       "to allocate ecryptfs_dentry_info struct\n",
 			__func__);
-		goto out_dput;
+		goto out_put;
 	}
 	ecryptfs_set_dentry_lower(ecryptfs_dentry, lower_dentry);
 	ecryptfs_set_dentry_lower_mnt(ecryptfs_dentry, lower_mnt);
@@ -339,8 +339,9 @@ int ecryptfs_lookup_and_interpose_lower(
 out_free_kmem:
 	kmem_cache_free(ecryptfs_header_cache_2, page_virt);
 	goto out;
-out_dput:
+out_put:
 	dput(lower_dentry);
+	mntput(lower_mnt);
 	d_drop(ecryptfs_dentry);
 out:
 	return rc;
