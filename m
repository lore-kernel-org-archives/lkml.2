Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab0FMKlc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 06:41:32 -0400
Received: from smtp.nokia.com ([192.100.122.233]:26723 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab0FMKla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 06:41:30 -0400
Message-ID: <4C14B5C1.4040005@nokia.com>
Date: Sun, 13 Jun 2010 13:41:05 +0300
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: "hch@lst.de" <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>,
       Kyungmin Park <kmpark@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
       Madhusudhan Chikkature <madhu.cr@ti.com>
Subject: [PATCH V2 1/4] block: Add BLKSECDISCARD
References: <4C14AC83.8070305@nokia.com>
In-Reply-To: <4C14AC83.8070305@nokia.com>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Jun 2010 10:41:05.0671 (UTC) FILETIME=[ED16D970:01CB0AE4]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2bca77333187190bacb3e8b6f79a51ee11be62b5 Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@nokia.com>
Date: Thu, 3 Jun 2010 10:46:04 +0300
Subject: [PATCH 1/4] block: Add BLKSECDISCARD

eMMC v4.4 cards can provide a secure erase operation
which guarantees that all copies of the discarded sectors (for
example created by garbage collection) will also be erased.  For
this a new ioctl BLKSECDISCARD is added.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 block/compat_ioctl.c |    1 +
 block/ioctl.c        |    5 +++++
 include/linux/fs.h   |    1 +
 3 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/block/compat_ioctl.c b/block/compat_ioctl.c
index f26051f..24a146d 100644
--- a/block/compat_ioctl.c
+++ b/block/compat_ioctl.c
@@ -753,6 +753,7 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 	case BLKFLSBUF:
 	case BLKROSET:
 	case BLKDISCARD:
+	case BLKSECDISCARD:
 	/*
 	 * the ones below are implemented in blkdev_locked_ioctl,
 	 * but we call blkdev_ioctl, which gets the lock for us
diff --git a/block/ioctl.c b/block/ioctl.c
index e8eb679..bc5c19c 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -238,6 +238,11 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 		return blk_ioctl_discard(bdev, range[0], range[1]);
 	}
 
+	case BLKSECDISCARD:
+		if (!(mode & FMODE_WRITE))
+			return -EBADF;
+		return __blkdev_driver_ioctl(bdev, mode, cmd, arg);
+
 	case HDIO_GETGEO: {
 		struct hd_geometry geo;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 471e1ff..ed06568 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -309,6 +309,7 @@ struct inodes_stat_t {
 #define BLKALIGNOFF _IO(0x12,122)
 #define BLKPBSZGET _IO(0x12,123)
 #define BLKDISCARDZEROES _IO(0x12,124)
+#define BLKSECDISCARD _IO(0x12,125)
 
 #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
 #define FIBMAP	   _IO(0x00,1)	/* bmap access */
-- 
1.6.3.3
