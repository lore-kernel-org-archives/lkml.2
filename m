Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab2ALV5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 16:57:24 -0500
Received: from mail-ww0-f74.google.com ([74.125.82.74]:50046 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755798Ab2ALV5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 16:57:22 -0500
From: Paul Taysom <taysom@chromium.org>
Cc: Paul Taysom <taysom@chromium.org>, Mandeep Baines <msb@chromium.org>,
        Greg KH <greg@kroah.com>, Jens Axboe <axboe@kernel.dk>,
        Theodore Tso <tytso@google.com>, Andrew Morton <akpm@google.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        <linux-fsdevel@vger.kernel.org>, <stable@kernel.org>
Subject: [PATCH] fs: Fix mod_timer crash when removing USB sticks
Date: Thu, 12 Jan 2012 13:57:11 -0800
Message-Id: <1326405431-988-1-git-send-email-taysom@chromium.org>
X-Mailer: git-send-email 1.7.7.3
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A USB stick with a ext file system on it, would occasionally crash
when the stick was pulled.

The problem was a timer was being set on the Backing Device Interface,
bdi, after the USB device had been removed and the bdi had been
unregistered. The bdi would then be later reinitialized by zeroing
the timer without removing from the timer from the timer queue.
This would eventually result in a kernel crash (NULL ptr dereference).

When the bdi is unregistered, the dev field is set to NULL. This
indication is used by bdi_unregister to only unregister the device
once.

Fix: When the backing device is invalidated, the mapping backing_dev_info
should be redirected to the default_backing_dev_info.

Created 3 USB sticks with ext2, ext4 and one with both apple and DOS
file systems on it. Inserted and removed USB sticks many times in random
order. With out the bug fix, the kernel would soon crash. With the fix,
it did not. Ran on both stumpy and amd64-generic.

Signed-off-by: Paul Taysom <taysom@chromium.org>
Cc: Mandeep Baines <msb@chromium.org>
Cc: Greg KH <greg@kroah.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Theodore Tso <tytso@google.com>
Cc: Andrew Morton <akpm@google.com>
Cc: <linux-usb@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: <linux-fsdevel@vger.kernel.org>
Cc: <stable@kernel.org>
---
 fs/block_dev.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index afe74dd..322cd05 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -110,6 +110,7 @@ void invalidate_bdev(struct block_device *bdev)
 	 * But, for the strange corners, lets be cautious
 	 */
 	cleancache_flush_inode(mapping);
+	mapping->backing_dev_info = &default_backing_dev_info;
 }
 EXPORT_SYMBOL(invalidate_bdev);
 
-- 
1.7.7.3

