Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab0EVOwa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 10:52:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:41017 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754187Ab0EVOw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 10:52:29 -0400
Message-ID: <4BF7EFA4.4050901@kernel.org>
Date: Sat, 22 May 2010 16:52:20 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ciprian Docan <docan@eden.rutgers.edu>, linux-kernel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH] vfs: don't hold s_umount over close_bdev_exclusive() call
References: <Pine.SOC.4.64.1005201226440.1441@er1.rutgers.edu> <20100521141445.bae41292.akpm@linux-foundation.org>
In-Reply-To: <20100521141445.bae41292.akpm@linux-foundation.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 22 May 2010 14:52:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes an obscure AB-BA deadlock in get_sb_bdev().

When a superblock is mounted more than once get_sb_bdev() calls
close_bdev_exclusive() to drop the extra bdev reference while holding
s_umount.  However, sb->s_umount nests inside bd_mutex during
__invalidate_device() and close_bdev_exclusive() acquires bd_mutex
during blkdev_put(); thus creating an AB-BA deadlock.

This condition doesn't trigger frequently.  For this condition to be
visible to lockdep, the filesystem must occupy the whole device (as
__invalidate_device() only grabs bd_mutex for the whole device), the
FS must be mounted more than once and partition rescan should be
issued while the FS is still mounted.

Fix it by dropping s_umount over close_bdev_exclusive().

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Ciprian Docan <docan@eden.rutgers.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
I think this fix is safe and seems to work fine here but I dunno know
the locking too well, so it would be best not to push it w/o Al's ack.

Thanks.

 fs/super.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/super.c b/fs/super.c
index 1527e6a..667f706 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -821,7 +821,16 @@ int get_sb_bdev(struct file_system_type *fs_type,
 			goto error_bdev;
 		}

+		/*
+		 * s_umount nests inside bd_mutex during
+		 * __invalidate_device().  close_bdev_exclusive()
+		 * acquires bd_mutex and can't be called under
+		 * s_umount.  Drop s_umount temporarily.  This is safe
+		 * as we're holding an active reference.
+		 */
+		up_write(&s->s_umount);
 		close_bdev_exclusive(bdev, mode);
+		down_write(&s->s_umount);
 	} else {
 		char b[BDEVNAME_SIZE];

