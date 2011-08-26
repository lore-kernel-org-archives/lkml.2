Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab1H0PFM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 11:05:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46766 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754593Ab1H0O5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 10:57:47 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 26 14:50:54 2011
Message-Id: <20110826215054.120366895@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 26 Aug 2011 14:49:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Josef Bacik <josef@redhat.com>, Chris Mason <chris.mason@oracle.com>
Subject: [12/35] Btrfs: detect wether a device supports discard
In-Reply-To: <20110826215139.GA11498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Josef Bacik <josef@redhat.com>

commit d5e2003c2bcda93a8f2e668eb4642d70c9c38301 upstream.

We have a problem where if a user specifies discard but doesn't actually support
it we will return EOPNOTSUPP from btrfs_discard_extent.  This is a problem
because this gets called (in a fashion) from the tree log recovery code, which
has a nice little BUG_ON(ret) after it, which causes us to fail the tree log
replay.  So instead detect wether our devices support discard when we're adding
them and then don't issue discards if we know that the device doesn't support
it.  And just for good measure set ret = 0 in btrfs_issue_discard just in case
we still get EOPNOTSUPP so we don't screw anybody up like this again.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
Signed-off-by: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/btrfs/extent-tree.c |   12 ++++++++++--
 fs/btrfs/volumes.c     |   17 +++++++++++++++++
 fs/btrfs/volumes.h     |    2 ++
 3 files changed, 29 insertions(+), 2 deletions(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1784,6 +1784,9 @@ static int btrfs_discard_extent(struct b
 
 
 		for (i = 0; i < multi->num_stripes; i++, stripe++) {
+			if (!stripe->dev->can_discard)
+				continue;
+
 			ret = btrfs_issue_discard(stripe->dev->bdev,
 						  stripe->physical,
 						  stripe->length);
@@ -1791,11 +1794,16 @@ static int btrfs_discard_extent(struct b
 				discarded_bytes += stripe->length;
 			else if (ret != -EOPNOTSUPP)
 				break;
+
+			/*
+			 * Just in case we get back EOPNOTSUPP for some reason,
+			 * just ignore the return value so we don't screw up
+			 * people calling discard_extent.
+			 */
+			ret = 0;
 		}
 		kfree(multi);
 	}
-	if (discarded_bytes && ret == -EOPNOTSUPP)
-		ret = 0;
 
 	if (actual_bytes)
 		*actual_bytes = discarded_bytes;
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -500,6 +500,9 @@ static int __btrfs_close_devices(struct
 			fs_devices->rw_devices--;
 		}
 
+		if (device->can_discard)
+			fs_devices->num_can_discard--;
+
 		new_device = kmalloc(sizeof(*new_device), GFP_NOFS);
 		BUG_ON(!new_device);
 		memcpy(new_device, device, sizeof(*new_device));
@@ -508,6 +511,7 @@ static int __btrfs_close_devices(struct
 		new_device->bdev = NULL;
 		new_device->writeable = 0;
 		new_device->in_fs_metadata = 0;
+		new_device->can_discard = 0;
 		list_replace_rcu(&device->dev_list, &new_device->dev_list);
 
 		call_rcu(&device->rcu, free_device);
@@ -547,6 +551,7 @@ int btrfs_close_devices(struct btrfs_fs_
 static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 				fmode_t flags, void *holder)
 {
+	struct request_queue *q;
 	struct block_device *bdev;
 	struct list_head *head = &fs_devices->devices;
 	struct btrfs_device *device;
@@ -603,6 +608,12 @@ static int __btrfs_open_devices(struct b
 			seeding = 0;
 		}
 
+		q = bdev_get_queue(bdev);
+		if (blk_queue_discard(q)) {
+			device->can_discard = 1;
+			fs_devices->num_can_discard++;
+		}
+
 		device->bdev = bdev;
 		device->in_fs_metadata = 0;
 		device->mode = flags;
@@ -1542,6 +1553,7 @@ error:
 
 int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 {
+	struct request_queue *q;
 	struct btrfs_trans_handle *trans;
 	struct btrfs_device *device;
 	struct block_device *bdev;
@@ -1611,6 +1623,9 @@ int btrfs_init_new_device(struct btrfs_r
 
 	lock_chunks(root);
 
+	q = bdev_get_queue(bdev);
+	if (blk_queue_discard(q))
+		device->can_discard = 1;
 	device->writeable = 1;
 	device->work.func = pending_bios_fn;
 	generate_random_uuid(device->uuid);
@@ -1646,6 +1661,8 @@ int btrfs_init_new_device(struct btrfs_r
 	root->fs_info->fs_devices->num_devices++;
 	root->fs_info->fs_devices->open_devices++;
 	root->fs_info->fs_devices->rw_devices++;
+	if (device->can_discard)
+		root->fs_info->fs_devices->num_can_discard++;
 	root->fs_info->fs_devices->total_rw_bytes += device->total_bytes;
 
 	if (!blk_queue_nonrot(bdev_get_queue(bdev)))
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -48,6 +48,7 @@ struct btrfs_device {
 	int writeable;
 	int in_fs_metadata;
 	int missing;
+	int can_discard;
 
 	spinlock_t io_lock;
 
@@ -104,6 +105,7 @@ struct btrfs_fs_devices {
 	u64 rw_devices;
 	u64 missing_devices;
 	u64 total_rw_bytes;
+	u64 num_can_discard;
 	struct block_device *latest_bdev;
 
 	/* all of the devices in the FS, protected by a mutex


