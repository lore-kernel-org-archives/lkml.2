Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab0FDUP4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 16:15:56 -0400
Received: from sous-sol.org ([216.99.217.87]:42079 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755631Ab0FDUPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 16:15:54 -0400
Date: Fri, 4 Jun 2010 13:15:35 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Al Viro <viro@ZenIV.linux.org.uk>, "Serge E. Hallyn" <serue@us.ibm.com>,
       Christoph Hellwig <hch@infradead.org>
Cc: "Daniel P. Berrange" <berrange@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] blkdev: cgroup whitelist permission fix
Message-ID: <20100604201535.GB8301@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cgroup device whitelist code gets confused when trying to grant
permission to a disk partition that is not currently open.  Part of
blkdev_open() includes __blkdev_get() on the whole disk.  This simply
avoids the cgroup check for the whole disk case when opening a
partition.

https://bugzilla.redhat.com/show_bug.cgi?id=589662

Acked-by: Serge E. Hallyn <serue@us.ibm.com>
Tested-by: Serge E. Hallyn <serue@us.ibm.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 fs/block_dev.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 7346c96..09b107e 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1315,10 +1315,12 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 	/*
 	 * hooks: /n/, see "layering violations".
 	 */
-	ret = devcgroup_inode_permission(bdev->bd_inode, perm);
-	if (ret != 0) {
-		bdput(bdev);
-		return ret;
+	if (!for_part) {
+		ret = devcgroup_inode_permission(bdev->bd_inode, perm);
+		if (ret != 0) {
+			bdput(bdev);
+			return ret;
+		}
 	}
 
 	lock_kernel();
