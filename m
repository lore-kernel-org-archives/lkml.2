Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935341Ab1IOXJA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 19:09:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:39227 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935280Ab1IOXHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 19:07:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,389,1312182000"; 
   d="scan'208";a="49349833"
From: Andi Kleen <andi@firstfloor.org>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Trond.Myklebust@netapp.com
Subject: [PATCH 6/7] LSEEK: NFS: Drop unnecessary locking in llseek
Date: Thu, 15 Sep 2011 16:06:52 -0700
Message-Id: <1316128013-21980-7-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316128013-21980-1-git-send-email-andi@firstfloor.org>
References: <1316128013-21980-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

This makes NFS follow the standard generic_file_llseek locking scheme.

Cc: Trond.Myklebust@netapp.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/nfs/file.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 12623ab..91c01f0 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -180,8 +180,6 @@ force_reval:
 
 static loff_t nfs_file_llseek(struct file *filp, loff_t offset, int origin)
 {
-	loff_t loff;
-
 	dprintk("NFS: llseek file(%s/%s, %lld, %d)\n",
 			filp->f_path.dentry->d_parent->d_name.name,
 			filp->f_path.dentry->d_name.name,
@@ -197,14 +195,9 @@ static loff_t nfs_file_llseek(struct file *filp, loff_t offset, int origin)
 		int retval = nfs_revalidate_file_size(inode, filp);
 		if (retval < 0)
 			return (loff_t)retval;
+	}
 
-		/* AK: should drop this lock. Unlikely to be needed. */
-		spin_lock(&inode->i_lock);
-		loff = generic_file_llseek(filp, offset, origin);
-		spin_unlock(&inode->i_lock);
-	} else
-		loff = generic_file_llseek(filp, offset, origin);
-	return loff;
+	return generic_file_llseek(filp, offset, origin);
 }
 
 /*
-- 
1.7.4.4

