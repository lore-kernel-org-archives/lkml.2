Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933574Ab1C3VIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:08:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:61735 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933535Ab1C3VH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621237462"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: tyhicks@linux.vnet.ibm.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [135/275] eCryptfs: Copy up lower inode attrs in getattr
Message-Id: <20110330210615.D56C23E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>

commit 55f9cf6bbaa682958a7dd2755f883b768270c3ce upstream.

The lower filesystem may do some type of inode revalidation during a
getattr call. eCryptfs should take advantage of that by copying the
lower inode attributes to the eCryptfs inode after a call to
vfs_getattr() on the lower inode.

I originally wrote this fix while working on eCryptfs on nfsv3 support,
but discovered it also fixed an eCryptfs on ext4 nanosecond timestamp
bug that was reported.

https://bugs.launchpad.net/bugs/613873

Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/ecryptfs/inode.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.35.y/fs/ecryptfs/inode.c
===================================================================
--- linux-2.6.35.y.orig/fs/ecryptfs/inode.c	2011-03-29 22:51:13.546376551 -0700
+++ linux-2.6.35.y/fs/ecryptfs/inode.c	2011-03-29 23:03:01.080272529 -0700
@@ -1003,6 +1003,8 @@
 	rc = vfs_getattr(ecryptfs_dentry_to_lower_mnt(dentry),
 			 ecryptfs_dentry_to_lower(dentry), &lower_stat);
 	if (!rc) {
+		fsstack_copy_attr_all(dentry->d_inode,
+				      ecryptfs_inode_to_lower(dentry->d_inode));
 		generic_fillattr(dentry->d_inode, stat);
 		stat->blocks = lower_stat.blocks;
 	}
