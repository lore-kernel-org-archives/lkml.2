Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729Ab1FPVIs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 17:08:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:27178 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758209Ab1FPVIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 17:08:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,377,1304319600"; 
   d="scan'208";a="19127483"
From: Andi Kleen <andi@firstfloor.org>
To: viro@zeniv.linux.org.uk
Cc: hch@infradead.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Trond.Myklebust@netapp.com
Subject: [PATCH 5/5] NFS: Drop unnecessary locking in llseek
Date: Thu, 16 Jun 2011 14:07:22 -0700
Message-Id: <1308258442-19804-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308258442-19804-1-git-send-email-andi@firstfloor.org>
References: <1308258442-19804-1-git-send-email-andi@firstfloor.org>
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
index 6b52b09..371f33f 100644
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
@@ -194,14 +192,9 @@ static loff_t nfs_file_llseek(struct file *filp, loff_t offset, int origin)
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

