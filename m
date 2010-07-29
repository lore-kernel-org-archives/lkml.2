Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068Ab0G2LBw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 07:01:52 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:32824 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1757051Ab0G2LBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 07:01:50 -0400
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX19xVZtqdpRxjQfdPWFkQAn8U15QGg/7G3VN/3hLSi
	I1AgefUgFGn6OS
Date: Thu, 29 Jul 2010 13:01:36 +0200
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: tyhicks@linux.vnet.ibm.com
Cc: kirkland@canonical.com, ecryptfs-devel@lists.launchpad.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ecryptfs (repost): release reference to lower mount if
	interpose fails
Message-ID: <20100729110136.GC8337@lsanfilippo.unix.rd.tt.avira.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In ecryptfs_lookup_and_interpose_lower() the lower mount is not decremented
if allocation of a dentry info struct failed. As a result the lower filesystem
cant be unmounted any more (since it is considered busy). This patch corrects
the reference counting.

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
