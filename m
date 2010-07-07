Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab0GGOw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 10:52:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:65458 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756370Ab0GGOv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 10:51:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       John Kacur <jkacur@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org,
       Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6/7] block: remove BKL from partition ioctls
Date: Wed,  7 Jul 2010 16:51:28 +0200
Message-Id: <1278514289-21054-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1278514289-21054-1-git-send-email-arnd@arndb.de>
References: <1278514289-21054-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:9EzgxELnM5TBCs9Qitzd8co+lO+m1HuH8tQ6hU9QVZA
 55m2SGQWolZvYHnTH+Bs4H8Ecy6ucA00ATSAlNV06xAX4hPuH7
 Ox95/2nUmS/BnP2Fw9eIskOkrH+ql9Wm2AUFzQxdLMvrF7E0yl
 RossbDW5mfauE6HeSm1apTi0aFUI5Mal7jp4IeqTJz7E63B+gH
 py9VLhZOEQbu9LDX1vKdA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The blkpg_ioctl and blkdev_reread_part access fields of
the bdev and gendisk structures, yet they always do so
under the protection of bdev->bd_mutex, which seems
sufficient.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 block/ioctl.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index 60f477c..09fd7f1 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -296,14 +296,10 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 			bd_release(bdev);
 		return ret;
 	case BLKPG:
-		lock_kernel();
 		ret = blkpg_ioctl(bdev, (struct blkpg_ioctl_arg __user *) arg);
-		unlock_kernel();
 		break;
 	case BLKRRPART:
-		lock_kernel();
 		ret = blkdev_reread_part(bdev);
-		unlock_kernel();
 		break;
 	case BLKGETSIZE:
 		size = bdev->bd_inode->i_size;
-- 
1.7.0.4

