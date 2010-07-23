Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab0GWAES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 20:04:18 -0400
Received: from sous-sol.org ([216.99.217.87]:60469 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751820Ab0GWAEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 20:04:16 -0400
Date: Thu, 22 Jul 2010 17:03:48 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Andrew Morton <akpm@linux-foundataion.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Christoph Hellwig <hch@infradead.org>
Cc: "Daniel P. Berrange" <berrange@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] blkdev: cgroup whitelist permission fix
Message-ID: <20100723000348.GD24905@sequoia.sous-sol.org>
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
partition.  This bug describes the details.  

https://bugzilla.redhat.com/show_bug.cgi?id=589662

Basically, the only ways to reliably allow a cgroup access to a partition
on a block device when using the whitelist are to 1) also give it access
to the whole block device or 2) make sure the partition is already open
in a different context.

Seems valid for 2.6.35 and -stable to me, as it's currently broken and
causes libvirt's container support to fail.

Acked-by: Serge E. Hallyn <serue@us.ibm.com>
Tested-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: stable@kernel.org
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
