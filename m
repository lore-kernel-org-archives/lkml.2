Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759559Ab0HLAEZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:04:25 -0400
Received: from kroah.org ([198.145.64.141]:60160 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759489Ab0HLAEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:04:09 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:01:25 2010
Message-Id: <20100812000125.172406133@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:00:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Wright <chrisw@sous-sol.org>,
        "Serge E. Hallyn" <serue@us.ibm.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        "Daniel P. Berrange" <berrange@redhat.com>
Subject: [21/54] blkdev: cgroup whitelist permission fix
In-Reply-To: <20100812000249.GA30948@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Wright <chrisw@sous-sol.org>

commit b7300b78d1a87625975a799a109a2f98d77757c8 upstream.

The cgroup device whitelist code gets confused when trying to grant
permission to a disk partition that is not currently open.  Part of
blkdev_open() includes __blkdev_get() on the whole disk.

Basically, the only ways to reliably allow a cgroup access to a partition
on a block device when using the whitelist are to 1) also give it access
to the whole block device or 2) make sure the partition is already open in
a different context.

The patch avoids the cgroup check for the whole disk case when opening a
partition.

Addresses https://bugzilla.redhat.com/show_bug.cgi?id=589662

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Acked-by: Serge E. Hallyn <serue@us.ibm.com>
Tested-by: Serge E. Hallyn <serue@us.ibm.com>
Reported-by: Vivek Goyal <vgoyal@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: "Daniel P. Berrange" <berrange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/block_dev.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1192,10 +1192,12 @@ static int __blkdev_get(struct block_dev
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


