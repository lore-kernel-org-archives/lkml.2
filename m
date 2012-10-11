Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933794Ab2JKBZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 21:25:07 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48446 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934190Ab2JKBYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 21:24:50 -0400
X-Sasl-enc: ih6/265aEd+ILhD4+D3/CaVB+elX7LcDtjMdba+sNP05 1349918689
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "Theodore Tso" <tytso@mit.edu>
Subject: [ 067/120] ext4: fix potential deadlock in ext4_nonda_switch()
Date: Thu, 11 Oct 2012 10:00:19 +0900
Message-Id: <20121011005838.357274078@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011005825.364610894@linuxfoundation.org>
References: <20121011005825.364610894@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 00d4e7362ed01987183e9528295de3213031309c upstream.

In ext4_nonda_switch(), if the file system is getting full we used to
call writeback_inodes_sb_if_idle().  The problem is that we can be
holding i_mutex already, and this causes a potential deadlock when
writeback_inodes_sb_if_idle() when it tries to take s_umount.  (See
lockdep output below).

As it turns out we don't need need to hold s_umount; the fact that we
are in the middle of the write(2) system call will keep the superblock
pinned.  Unfortunately writeback_inodes_sb() checks to make sure
s_umount is taken, and the VFS uses a different mechanism for making
sure the file system doesn't get unmounted out from under us.  The
simplest way of dealing with this is to just simply grab s_umount
using a trylock, and skip kicking the writeback flusher thread in the
very unlikely case that we can't take a read lock on s_umount without
blocking.

Also, we now check the cirteria for kicking the writeback thread
before we decide to whether to fall back to non-delayed writeback, so
if there are any outstanding delayed allocation writes, we try to get
them resolved as soon as possible.

   [ INFO: possible circular locking dependency detected ]
   3.6.0-rc1-00042-gce894ca #367 Not tainted
   -------------------------------------------------------
   dd/8298 is trying to acquire lock:
    (&type->s_umount_key#18){++++..}, at: [<c02277d4>] writeback_inodes_sb_if_idle+0x28/0x46

   but task is already holding lock:
    (&sb->s_type->i_mutex_key#8){+.+...}, at: [<c01ddcce>] generic_file_aio_write+0x5f/0xd3

   which lock already depends on the new lock.

   2 locks held by dd/8298:
    #0:  (sb_writers#2){.+.+.+}, at: [<c01ddcc5>] generic_file_aio_write+0x56/0xd3
    #1:  (&sb->s_type->i_mutex_key#8){+.+...}, at: [<c01ddcce>] generic_file_aio_write+0x5f/0xd3

   stack backtrace:
   Pid: 8298, comm: dd Not tainted 3.6.0-rc1-00042-gce894ca #367
   Call Trace:
    [<c015b79c>] ? console_unlock+0x345/0x372
    [<c06d62a1>] print_circular_bug+0x190/0x19d
    [<c019906c>] __lock_acquire+0x86d/0xb6c
    [<c01999db>] ? mark_held_locks+0x5c/0x7b
    [<c0199724>] lock_acquire+0x66/0xb9
    [<c02277d4>] ? writeback_inodes_sb_if_idle+0x28/0x46
    [<c06db935>] down_read+0x28/0x58
    [<c02277d4>] ? writeback_inodes_sb_if_idle+0x28/0x46
    [<c02277d4>] writeback_inodes_sb_if_idle+0x28/0x46
    [<c026f3b2>] ext4_nonda_switch+0xe1/0xf4
    [<c0271ece>] ext4_da_write_begin+0x27/0x193
    [<c01dcdb0>] generic_file_buffered_write+0xc8/0x1bb
    [<c01ddc47>] __generic_file_aio_write+0x1dd/0x205
    [<c01ddce7>] generic_file_aio_write+0x78/0xd3
    [<c026d336>] ext4_file_write+0x480/0x4a6
    [<c0198c1d>] ? __lock_acquire+0x41e/0xb6c
    [<c0180944>] ? sched_clock_cpu+0x11a/0x13e
    [<c01967e9>] ? trace_hardirqs_off+0xb/0xd
    [<c018099f>] ? local_clock+0x37/0x4e
    [<c0209f2c>] do_sync_write+0x67/0x9d
    [<c0209ec5>] ? wait_on_retry_sync_kiocb+0x44/0x44
    [<c020a7b9>] vfs_write+0x7b/0xe6
    [<c020a9a6>] sys_write+0x3b/0x64
    [<c06dd4bd>] syscall_call+0x7/0xb

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/inode.c   |   17 ++++++++++-------
 fs/fs-writeback.c |    1 +
 2 files changed, 11 insertions(+), 7 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2386,6 +2386,16 @@ static int ext4_nonda_switch(struct supe
 	free_blocks  = EXT4_C2B(sbi,
 		percpu_counter_read_positive(&sbi->s_freeclusters_counter));
 	dirty_blocks = percpu_counter_read_positive(&sbi->s_dirtyclusters_counter);
+	/*
+	 * Start pushing delalloc when 1/2 of free blocks are dirty.
+	 */
+	if (dirty_blocks && (free_blocks < 2 * dirty_blocks) &&
+	    !writeback_in_progress(sb->s_bdi) &&
+	    down_read_trylock(&sb->s_umount)) {
+		writeback_inodes_sb(sb, WB_REASON_FS_FREE_SPACE);
+		up_read(&sb->s_umount);
+	}
+
 	if (2 * free_blocks < 3 * dirty_blocks ||
 		free_blocks < (dirty_blocks + EXT4_FREECLUSTERS_WATERMARK)) {
 		/*
@@ -2394,13 +2404,6 @@ static int ext4_nonda_switch(struct supe
 		 */
 		return 1;
 	}
-	/*
-	 * Even if we don't switch but are nearing capacity,
-	 * start pushing delalloc when 1/2 of free blocks are dirty.
-	 */
-	if (free_blocks < 2 * dirty_blocks)
-		writeback_inodes_sb_if_idle(sb, WB_REASON_FS_FREE_SPACE);
-
 	return 0;
 }
 
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -68,6 +68,7 @@ int writeback_in_progress(struct backing
 {
 	return test_bit(BDI_writeback_running, &bdi->state);
 }
+EXPORT_SYMBOL(writeback_in_progress);
 
 static inline struct backing_dev_info *inode_to_bdi(struct inode *inode)
 {


