Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab1DTKHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 06:07:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63792 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753815Ab1DTKHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 06:07:31 -0400
Message-ID: <4DAEB090.20609@cn.fujitsu.com>
Date: Wed, 20 Apr 2011 18:08:16 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: LKML <linux-kernel@vger.kernel.org>, BTRFS <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/5] Btrfs: fix the race between remove dev and alloc chunk
References: <4DAEB030.1070303@cn.fujitsu.com>
In-Reply-To: <4DAEB030.1070303@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-20 18:08:02,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-20 18:08:02,
	Serialize complete at 2011-04-20 18:08:02
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On remove device path, it updates device->dev_alloc_list but does not hold
chunk lock

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 fs/btrfs/volumes.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a672249..d20351f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1325,7 +1325,9 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 	}
 
 	if (device->writeable) {
+		lock_chunks(root);
 		list_del_init(&device->dev_alloc_list);
+		unlock_chunks(root);
 		root->fs_info->fs_devices->rw_devices--;
 	}
 
@@ -1379,7 +1381,9 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 		}
 		fs_devices->seed = device->fs_devices->seed;
 		device->fs_devices->seed = NULL;
+		lock_chunks(root);
 		__btrfs_close_devices(device->fs_devices);
+		unlock_chunks(root);
 		free_fs_devices(device->fs_devices);
 	}
 
@@ -1411,8 +1415,10 @@ out:
 	return ret;
 error_undo:
 	if (device->writeable) {
+		lock_chunks(root);
 		list_add(&device->dev_alloc_list,
 			 &root->fs_info->fs_devices->alloc_list);
+		unlock_chunks(root);
 		root->fs_info->fs_devices->rw_devices++;
 	}
 	goto error_brelse;
-- 
1.7.4.4

