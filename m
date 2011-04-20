Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab1DTKIE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 06:08:04 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65500 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753850Ab1DTKIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 06:08:01 -0400
Message-ID: <4DAEB0AF.6030306@cn.fujitsu.com>
Date: Wed, 20 Apr 2011 18:08:47 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: LKML <linux-kernel@vger.kernel.org>, BTRFS <linux-btrfs@vger.kernel.org>
Subject: [PATCH 4/5] Btrfs: drop unnecessary device lock
References: <4DAEB030.1070303@cn.fujitsu.com>
In-Reply-To: <4DAEB030.1070303@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-20 18:08:33,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-20 18:08:34,
	Serialize complete at 2011-04-20 18:08:34
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop device_list_mutex for the reader side  on clone_fs_devices and
btrfs_rm_device pathes since the fs_info->volume_mutex can ensure the device
list is not updated

btrfs_close_extra_devices is the initialized path, we can not add or remove
device at this time, so we can simply drop the mutex safely, like other
initialized function does(add_missing_dev, __find_device, __btrfs_open_devices
...).

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 fs/btrfs/volumes.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d20351f..f43b946 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -440,7 +440,7 @@ static struct btrfs_fs_devices *clone_fs_devices(struct btrfs_fs_devices *orig)
 	fs_devices->latest_trans = orig->latest_trans;
 	memcpy(fs_devices->fsid, orig->fsid, sizeof(fs_devices->fsid));
 
-	mutex_lock(&orig->device_list_mutex);
+	/* We have held the volume lock, it is safe to get the devices. */
 	list_for_each_entry(orig_dev, &orig->devices, dev_list) {
 		device = kzalloc(sizeof(*device), GFP_NOFS);
 		if (!device)
@@ -463,10 +463,8 @@ static struct btrfs_fs_devices *clone_fs_devices(struct btrfs_fs_devices *orig)
 		device->fs_devices = fs_devices;
 		fs_devices->num_devices++;
 	}
-	mutex_unlock(&orig->device_list_mutex);
 	return fs_devices;
 error:
-	mutex_unlock(&orig->device_list_mutex);
 	free_fs_devices(fs_devices);
 	return ERR_PTR(-ENOMEM);
 }
@@ -477,7 +475,7 @@ int btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices)
 
 	mutex_lock(&uuid_mutex);
 again:
-	mutex_lock(&fs_devices->device_list_mutex);
+	/* This is the initialized path, it is safe to release the devices. */
 	list_for_each_entry_safe(device, next, &fs_devices->devices, dev_list) {
 		if (device->in_fs_metadata)
 			continue;
@@ -497,7 +495,6 @@ again:
 		kfree(device->name);
 		kfree(device);
 	}
-	mutex_unlock(&fs_devices->device_list_mutex);
 
 	if (fs_devices->seed) {
 		fs_devices = fs_devices->seed;
@@ -1276,14 +1273,16 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 
 		device = NULL;
 		devices = &root->fs_info->fs_devices->devices;
-		mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
+		/*
+		 * It is safe to read the devices since the volume_mutex
+		 * is held.
+		 */
 		list_for_each_entry(tmp, devices, dev_list) {
 			if (tmp->in_fs_metadata && !tmp->bdev) {
 				device = tmp;
 				break;
 			}
 		}
-		mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
 		bdev = NULL;
 		bh = NULL;
 		disk_super = NULL;
-- 
1.7.4.4

