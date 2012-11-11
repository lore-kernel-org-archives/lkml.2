Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab2KKMfm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 07:35:42 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33393 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab2KKMfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 07:35:37 -0500
From: Ming Lei <ming.lei@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oneukum@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-mm@kvack.org, Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v5 3/6] block/genhd.c: apply pm_runtime_set_memalloc_noio on block devices
Date: Sun, 11 Nov 2012 20:34:35 +0800
Message-Id: <1352637278-19968-4-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352637278-19968-1-git-send-email-ming.lei@canonical.com>
References: <1352637278-19968-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch applyes the introduced pm_runtime_set_memalloc_noio on
block device so that PM core will teach mm to not allocate memory with
GFP_IOFS when calling the runtime_resume and runtime_suspend callback
for block devices and its ancestors.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
v5:
	- fix code style and one typo
v4:
	- call pm_runtime_set_memalloc_noio(ddev, true) after device_add
---
 block/genhd.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/block/genhd.c b/block/genhd.c
index 9e02cd6..085cce4 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -18,6 +18,7 @@
 #include <linux/mutex.h>
 #include <linux/idr.h>
 #include <linux/log2.h>
+#include <linux/pm_runtime.h>
 
 #include "blk.h"
 
@@ -532,6 +533,14 @@ static void register_disk(struct gendisk *disk)
 			return;
 		}
 	}
+
+	/*
+	 * avoid probable deadlock caused by allocating memory with
+	 * GFP_KERNEL in runtime_resume callback of its all ancestor
+	 * devices
+	 */
+	pm_runtime_set_memalloc_noio(ddev, true);
+
 	disk->part0.holder_dir = kobject_create_and_add("holders", &ddev->kobj);
 	disk->slave_dir = kobject_create_and_add("slaves", &ddev->kobj);
 
@@ -661,6 +670,7 @@ void del_gendisk(struct gendisk *disk)
 	disk->driverfs_dev = NULL;
 	if (!sysfs_deprecated)
 		sysfs_remove_link(block_depr, dev_name(disk_to_dev(disk)));
+	pm_runtime_set_memalloc_noio(disk_to_dev(disk), false);
 	device_del(disk_to_dev(disk));
 }
 EXPORT_SYMBOL(del_gendisk);
-- 
1.7.9.5

