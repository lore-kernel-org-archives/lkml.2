Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047Ab1JWGhE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 02:37:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40102 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754756Ab1JWGeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 02:34:15 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Sun Oct 23 08:25:38 2011
Message-Id: <20111023062538.555116756@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Sun, 23 Oct 2011 08:24:36 +0200
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable-review@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Miklos Szeredi <mszeredi@suse.cz>, Josh Boyer <jwboyer@redhat.com>
Subject: [08/27] fuse: fix memory leak
In-Reply-To: <20111023062833.GA8126@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

commit 5dfcc87fd79dfb96ed155b524337dbd0da4f5993 upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/fuse/dev.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
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
 


