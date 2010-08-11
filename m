Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932995Ab0HLAd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:33:57 -0400
Received: from kroah.org ([198.145.64.141]:43506 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759150Ab0HKX6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:58:50 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:55:02 2010
Message-Id: <20100811235502.218625489@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:54:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Josef Bacik <josef@redhat.com>, Chris Mason <chris.mason@oracle.com>,
        Jeff Mahoney <jeffm@suse.com>
Subject: [073/111] Btrfs: check total number of devices when removing missing
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Josef Bacik <josef@redhat.com>

commit 035fe03a7ad56982b30ab3a522b7b08d58feccd0 upstream.

If you have a disk failure in RAID1 and then add a new disk to the
array, and then try to remove the missing volume, it will fail.  The
reason is the sanity check only looks at the total number of rw devices,
which is just 2 because we have 2 good disks and 1 bad one.  Instead
check the total number of devices in the array to make sure we can
actually remove the device.  Tested this with a failed disk setup and
with this test we can now run

btrfs-vol -r missing /mount/point

and it works fine.

Signed-off-by: Josef Bacik <josef@redhat.com>
Signed-off-by: Chris Mason <chris.mason@oracle.com>
Acked-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 fs/btrfs/volumes.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1135,7 +1135,7 @@ int btrfs_rm_device(struct btrfs_root *r
 		root->fs_info->avail_metadata_alloc_bits;
 
 	if ((all_avail & BTRFS_BLOCK_GROUP_RAID10) &&
-	    root->fs_info->fs_devices->rw_devices <= 4) {
+	    root->fs_info->fs_devices->num_devices <= 4) {
 		printk(KERN_ERR "btrfs: unable to go below four devices "
 		       "on raid10\n");
 		ret = -EINVAL;
@@ -1143,7 +1143,7 @@ int btrfs_rm_device(struct btrfs_root *r
 	}
 
 	if ((all_avail & BTRFS_BLOCK_GROUP_RAID1) &&
-	    root->fs_info->fs_devices->rw_devices <= 2) {
+	    root->fs_info->fs_devices->num_devices <= 2) {
 		printk(KERN_ERR "btrfs: unable to go below two "
 		       "devices on raid1\n");
 		ret = -EINVAL;


