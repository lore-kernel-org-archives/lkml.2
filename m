Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758466Ab2DZQhF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 12:37:05 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:57433 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757812Ab2DZQhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 12:37:04 -0400
From: Jim Meyering <jim@meyering.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: NUL-terminate path buffer in DEV_INFO ioctl result
Date: Thu, 26 Apr 2012 18:36:56 +0200
Message-ID: <87pqauwitz.fsf@rho.meyering.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A device with name of length BTRFS_DEVICE_PATH_NAME_MAX or longer
would not be NUL-terminated in the DEV_INFO ioctl result buffer.

Signed-off-by: Jim Meyering <meyering@redhat.com>
---
 fs/btrfs/ioctl.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 18cc23d..1578676 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2258,16 +2258,17 @@ static long btrfs_ioctl_dev_info(struct btrfs_root *root, void __user *arg)
 		goto out;
 	}

 	di_args->devid = dev->devid;
 	di_args->bytes_used = dev->bytes_used;
 	di_args->total_bytes = dev->total_bytes;
 	memcpy(di_args->uuid, dev->uuid, sizeof(di_args->uuid));
 	strncpy(di_args->path, dev->name, sizeof(di_args->path));
+	di_args->path[sizeof(di_args->path) - 1] = 0;

 out:
 	if (ret == 0 && copy_to_user(arg, di_args, sizeof(*di_args)))
 		ret = -EFAULT;

 	kfree(di_args);
 	return ret;
 }
--
1.7.10.336.gc5e31
