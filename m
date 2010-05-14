Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934Ab0ENHki (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 03:40:38 -0400
Received: from sous-sol.org ([216.99.217.87]:33235 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757476Ab0ENHkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 03:40:36 -0400
Date: Fri, 14 May 2010 00:40:03 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>,
       Christoph Hellwig <hch@infradead.org>
Cc: "Daniel P. Berrange" <berrange@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] blkdev: cgroup whitelist permission fix
Message-ID: <20100514074003.GK28034@sequoia.sous-sol.org>
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

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 fs/block_dev.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 6dcee88..d4d19ac 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1192,10 +1192,12 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
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
