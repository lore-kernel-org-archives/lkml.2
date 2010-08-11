Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758802Ab0HLAnt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:43:49 -0400
Received: from kroah.org ([198.145.64.141]:40082 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758777Ab0HKX5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:57:42 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:54:57 2010
Message-Id: <20100811235457.156336316@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:53:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Subject: [017/111] ecryptfs: release reference to lower mount if interpose fails
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Lino Sanfilippo <LinoSanfilippo@gmx.de>

commit 31f73bee3e170b7cabb35db9e2f4bf7919b9d036 upstream.

In ecryptfs_lookup_and_interpose_lower() the lower mount is not decremented
if allocation of a dentry info struct failed. As a result the lower filesystem
cant be unmounted any more (since it is considered busy). This patch corrects
the reference counting.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ecryptfs/inode.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -272,7 +272,7 @@ int ecryptfs_lookup_and_interpose_lower(
 		printk(KERN_ERR "%s: Out of memory whilst attempting "
 		       "to allocate ecryptfs_dentry_info struct\n",
 			__func__);
-		goto out_dput;
+		goto out_put;
 	}
 	ecryptfs_set_dentry_lower(ecryptfs_dentry, lower_dentry);
 	ecryptfs_set_dentry_lower_mnt(ecryptfs_dentry, lower_mnt);
@@ -345,8 +345,9 @@ int ecryptfs_lookup_and_interpose_lower(
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


