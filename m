Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317Ab1I1Wk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:40:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53829 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932275Ab1I1Wkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:40:51 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:33 2011
Message-Id: <20110928220133.310706786@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:00:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Christoph Hellwig <hch@lst.de>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, NeilBrown <neilb@suse.de>
Subject: [076/244] Avoid dereferencing a request_queue after last close.
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: NeilBrown <neilb@suse.de>

commit 94007751bb02797ba87bac7aacee2731ac2039a3 upstream.

On the last close of an 'md' device which as been stopped, the device
is destroyed and in particular the request_queue is freed.  The free
is done in a separate thread so it might happen a short time later.

__blkdev_put calls bdev_inode_switch_bdi *after* ->release has been
called.

Since commit f758eeabeb96f878c860e8f110f94ec8820822a9
bdev_inode_switch_bdi will dereference the 'old' bdi, which lives
inside a request_queue, to get a spin lock.  This causes the last
close on an md device to sometime take a spin_lock which lives in
freed memory - which results in an oops.

So move the called to bdev_inode_switch_bdi before the call to
->release.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Acked-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/block_dev.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1419,6 +1419,11 @@ static int __blkdev_put(struct block_dev
 		WARN_ON_ONCE(bdev->bd_holders);
 		sync_blockdev(bdev);
 		kill_bdev(bdev);
+		/* ->release can cause the old bdi to disappear,
+		 * so must switch it out first
+		 */
+		bdev_inode_switch_bdi(bdev->bd_inode,
+					&default_backing_dev_info);
 	}
 	if (bdev->bd_contains == bdev) {
 		if (disk->fops->release)
@@ -1432,8 +1437,6 @@ static int __blkdev_put(struct block_dev
 		disk_put_part(bdev->bd_part);
 		bdev->bd_part = NULL;
 		bdev->bd_disk = NULL;
-		bdev_inode_switch_bdi(bdev->bd_inode,
-					&default_backing_dev_info);
 		if (bdev != bdev->bd_contains)
 			victim = bdev->bd_contains;
 		bdev->bd_contains = NULL;


