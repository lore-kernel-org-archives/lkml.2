Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758732Ab2JAXgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:36:48 -0400
Received: from 1wt.eu ([62.212.114.60]:35071 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932582Ab2JAXAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:00:01 -0400
Message-Id: <20121001225158.675739100@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:52:22 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Tyler Hicks <tyhicks@canonical.com>,
        John Johansen <john.johansen@canonical.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Andy Whitcroft <apw@canonical.com>,
        Colin Ian King <colin.king@canonical.com>, Willy Tarreau <w@1wt.eu>
Subject: [ 025/180] eCryptfs: Copy up lower inode attrs after setting lower xattr
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.king@canonical.com>

commit 545d680938be1e86a6c5250701ce9abaf360c495 upstream.

After passing through a ->setxattr() call, eCryptfs needs to copy the
inode attributes from the lower inode to the eCryptfs inode, as they
may have changed in the lower filesystem's ->setxattr() path.

One example is if an extended attribute containing a POSIX Access
Control List is being set. The new ACL may cause the lower filesystem to
modify the mode of the lower inode and the eCryptfs inode would need to
be updated to reflect the new mode.

https://launchpad.net/bugs/926292

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Reported-by: Sebastien Bacher <seb128@ubuntu.com>
Cc: John Johansen <john.johansen@canonical.com>
Cc: <stable@vger.kernel.org>
Acked-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Acked-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/ecryptfs/inode.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 90a6087..645da17 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -1035,6 +1035,8 @@ ecryptfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 	rc = lower_dentry->d_inode->i_op->setxattr(lower_dentry, name, value,
 						   size, flags);
 	mutex_unlock(&lower_dentry->d_inode->i_mutex);
+	if (!rc)
+		fsstack_copy_attr_all(dentry->d_inode, lower_dentry->d_inode, NULL);
 out:
 	return rc;
 }
-- 
1.7.2.1.45.g54fbc



