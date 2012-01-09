Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933488Ab2AIWsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 17:48:21 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56064 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933258Ab2AIWsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 17:48:20 -0500
Date: Tue, 10 Jan 2012 01:44:36 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] block_dev: Suppress bdev_cache_init() kmemleak warninig
Message-ID: <20120109224436.GA3429@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

block_dev: Suppress bdev_cache_init() kmemleak warninig

Kmemleak reports the following warning in bdev_cache_init()
[    0.003738] kmemleak: Object 0xffff880153035200 (size 256):
[    0.003823] kmemleak:   comm "swapper/0", pid 0, jiffies 4294667299
[    0.003909] kmemleak:   min_count = 1
[    0.003988] kmemleak:   count = 0
[    0.004066] kmemleak:   flags = 0x1
[    0.004144] kmemleak:   checksum = 0
[    0.004224] kmemleak:   backtrace:
[    0.004303]      [<ffffffff814755ac>] kmemleak_alloc+0x21/0x3e
[    0.004446]      [<ffffffff811100ba>] kmem_cache_alloc+0xca/0x1dc
[    0.004592]      [<ffffffff811371b1>] alloc_vfsmnt+0x1f/0x198
[    0.004736]      [<ffffffff811375c5>] vfs_kern_mount+0x36/0xd2
[    0.004879]      [<ffffffff8113929a>] kern_mount_data+0x18/0x32
[    0.005025]      [<ffffffff81ab9075>] bdev_cache_init+0x51/0x81
[    0.005169]      [<ffffffff81ab8abf>] vfs_caches_init+0x101/0x10d
[    0.005313]      [<ffffffff81a9bae3>] start_kernel+0x344/0x383
[    0.005456]      [<ffffffff81a9b2a7>] x86_64_start_reservations+0xae/0xb2
[    0.005602]      [<ffffffff81a9b3ad>] x86_64_start_kernel+0x102/0x111
[    0.005747]      [<ffffffffffffffff>] 0xffffffffffffffff
[    0.008653] kmemleak: Trying to color unknown object at 0xffff880153035220 as Grey
[    0.008754] Pid: 0, comm: swapper/0 Not tainted 3.3.0-rc0-dbg-04200-g8180888-dirty #888
[    0.008856] Call Trace:
[    0.008934]  [<ffffffff81118704>] ? find_and_get_object+0x44/0x118
[    0.009023]  [<ffffffff81118fe6>] paint_ptr+0x57/0x8f
[    0.009109]  [<ffffffff81475935>] kmemleak_not_leak+0x23/0x42
[    0.009195]  [<ffffffff81ab9096>] bdev_cache_init+0x72/0x81
[    0.009282]  [<ffffffff81ab8abf>] vfs_caches_init+0x101/0x10d
[    0.009368]  [<ffffffff81a9bae3>] start_kernel+0x344/0x383
[    0.009466]  [<ffffffff81a9b2a7>] x86_64_start_reservations+0xae/0xb2
[    0.009555]  [<ffffffff81a9b140>] ? early_idt_handlers+0x140/0x140
[    0.009643]  [<ffffffff81a9b3ad>] x86_64_start_kernel+0x102/0x111

due to attempt to mark pointer to `struct vfsmount' as a gray object, which
is embedded into `struct mount' returned from alloc_vfsmnt(). Pass actual
allocated `struct mount' pointer to kmemleak_not_leak() instead.


Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 69a5b6f..60589ef 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -29,6 +29,7 @@
 #include <linux/cleancache.h>
 #include <asm/uaccess.h>
 #include "internal.h"
+#include "mount.h"
 
 struct bdev_inode {
 	struct block_device bdev;
@@ -522,6 +523,7 @@ void __init bdev_cache_init(void)
 {
 	int err;
 	struct vfsmount *bd_mnt;
+	struct mount *mnt;
 
 	bdev_cachep = kmem_cache_create("bdev_cache", sizeof(struct bdev_inode),
 			0, (SLAB_HWCACHE_ALIGN|SLAB_RECLAIM_ACCOUNT|
@@ -534,11 +536,12 @@ void __init bdev_cache_init(void)
 	if (IS_ERR(bd_mnt))
 		panic("Cannot create bdev pseudo-fs");
 	/*
-	 * This vfsmount structure is only used to obtain the
+	 * This mount structure is only used to obtain the
 	 * blockdev_superblock, so tell kmemleak not to report it.
 	 */
-	kmemleak_not_leak(bd_mnt);
-	blockdev_superblock = bd_mnt->mnt_sb;	/* For writeback */
+	mnt = container_of(bd_mnt, struct mount, mnt);
+	kmemleak_not_leak(mnt);
+	blockdev_superblock = bd_mnt->mnt_sb;   /* For writeback */
 }
 
 /*

