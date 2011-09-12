Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab1ILHiR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 03:38:17 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48792 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab1ILHiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 03:38:16 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] fuse: fix memory leak
References: <877h5ez07p.fsf@tucsk.pomaz.szeredi.hu>
Date: Mon, 12 Sep 2011 09:38:03 +0200
In-Reply-To: <877h5ez07p.fsf@tucsk.pomaz.szeredi.hu> (Miklos Szeredi's message
	of "Mon, 12 Sep 2011 09:30:50 +0200")
Message-ID: <87y5xuxlb8.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

kmemleak is reporting that 32 bytes are being leaked by FUSE:

unreferenced object 0xe373b270 (size 32):
  comm "fusermount", pid 1207, jiffies 4294707026 (age 2675.187s)
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<b05517d7>] kmemleak_alloc+0x27/0x50
    [<b0196435>] kmem_cache_alloc+0xc5/0x180
    [<b02455be>] fuse_alloc_forget+0x1e/0x20
    [<b0245670>] fuse_alloc_inode+0xb0/0xd0
    [<b01b1a8c>] alloc_inode+0x1c/0x80
    [<b01b290f>] iget5_locked+0x8f/0x1a0
    [<b0246022>] fuse_iget+0x72/0x1a0
    [<b02461da>] fuse_get_root_inode+0x8a/0x90
    [<b02465cf>] fuse_fill_super+0x3ef/0x590
    [<b019e56f>] mount_nodev+0x3f/0x90
    [<b0244e95>] fuse_mount+0x15/0x20
    [<b019d1bc>] mount_fs+0x1c/0xc0
    [<b01b5811>] vfs_kern_mount+0x41/0x90
    [<b01b5af9>] do_kern_mount+0x39/0xd0
    [<b01b7585>] do_mount+0x2e5/0x660
    [<b01b7966>] sys_mount+0x66/0xa0

This leak report is consistent and happens once per boot on
3.1.0-rc5-dirty.

This happens if a FORGET request is queued after the fuse device was
released.

Reported-by: Sitsofe Wheeler <sitsofe@yahoo.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>
---
 fs/fuse/dev.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

Index: linux-2.6/fs/fuse/dev.c
===================================================================
--- linux-2.6.orig/fs/fuse/dev.c	2011-09-07 10:19:29.000000000 +0200
+++ linux-2.6/fs/fuse/dev.c	2011-09-07 10:42:58.000000000 +0200
@@ -258,10 +258,14 @@ void fuse_queue_forget(struct fuse_conn
 	forget->forget_one.nlookup = nlookup;
 
 	spin_lock(&fc->lock);
-	fc->forget_list_tail->next = forget;
-	fc->forget_list_tail = forget;
-	wake_up(&fc->waitq);
-	kill_fasync(&fc->fasync, SIGIO, POLL_IN);
+	if (fc->connected) {
+		fc->forget_list_tail->next = forget;
+		fc->forget_list_tail = forget;
+		wake_up(&fc->waitq);
+		kill_fasync(&fc->fasync, SIGIO, POLL_IN);
+	} else {
+		kfree(forget);
+	}
 	spin_unlock(&fc->lock);
 }
 
