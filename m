Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759312Ab0I0NPE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 09:15:04 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41090 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896Ab0I0NPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 09:15:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=fn0GBu8WckT9nGQOm5wZjk4cp9ve6kZGHW4OQjuwmqRcqPHBtVr5fP6tZJZMnmPBTr
         VPEaiF15wxKCp3mgTC2z+Lb3iw7RBA0HnMWoqDK2m3GrHZ1BlJ6W3IF8jl/k4SJh1QDA
         Iq0EO+WZaOamNwLZg3FRk7mxe5iwOTASeIMdM=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jarek Poplawski <jarkao2@gmail.com>,
        "All since 2.6.32" <stable@kernel.org>
Subject: [PATCH 2/2] reiserfs: Fix unwanted reiserfs lock recursion
Date: Mon, 27 Sep 2010 15:14:51 +0200
Message-Id: <1285593291-11527-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1285593291-11527-1-git-send-regression-fweisbec@gmail.com>
References: <1285593291-11527-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prevent from recursively locking the reiserfs lock in
reiserfs_unpack() because we may call journal_begin()
that requires the lock to be taken only once, otherwise
it won't be able to release the lock while taking other
mutexes, ending up in inverted dependencies between
the journal mutex and the reiserfs lock for example.

This fixes:

[   67.110273] =======================================================
[   67.110313] [ INFO: possible circular locking dependency detected ]
[   67.110313] 2.6.35.4.4a #3
[   67.110313] -------------------------------------------------------
[   67.110313] lilo/1620 is trying to acquire lock:
[   67.110313]  (&journal->j_mutex){+.+...}, at: [<d0325bff>] do_journal_begin_r+0x7f/0x340 [reiserfs]
[   67.110313]
[   67.110313] but task is already holding lock:
[   67.110313]  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<d032a278>] reiserfs_write_lock+0x28/0x40 [reiserfs]
[   67.110313]
[   67.110313] which lock already depends on the new lock.
[   67.110313]
[   67.110313]
[   67.110313] the existing dependency chain (in reverse order) is:
[   67.110313]
[   67.110313] -> #1 (&REISERFS_SB(s)->lock){+.+.+.}:
[   67.110313]        [<c10562b7>] lock_acquire+0x67/0x80
[   67.110313]        [<c12facad>] __mutex_lock_common+0x4d/0x410
[   67.110313]        [<c12fb0c8>] mutex_lock_nested+0x18/0x20
[   67.110313]        [<d032a278>] reiserfs_write_lock+0x28/0x40 [reiserfs]
[   67.110313]        [<d0325c06>] do_journal_begin_r+0x86/0x340 [reiserfs]
[   67.110313]        [<d0325f77>] journal_begin+0x77/0x140 [reiserfs]
[   67.110313]        [<d0315be4>] reiserfs_remount+0x224/0x530 [reiserfs]
[   67.110313]        [<c10b6a20>] do_remount_sb+0x60/0x110
[   67.110313]        [<c10cee25>] do_mount+0x625/0x790
[   67.110313]        [<c10cf014>] sys_mount+0x84/0xb0
[   67.110313]        [<c12fca3d>] syscall_call+0x7/0xb
[   67.110313]
[   67.110313] -> #0 (&journal->j_mutex){+.+...}:
[   67.110313]        [<c10560f6>] __lock_acquire+0x1026/0x1180
[   67.110313]        [<c10562b7>] lock_acquire+0x67/0x80
[   67.110313]        [<c12facad>] __mutex_lock_common+0x4d/0x410
[   67.110313]        [<c12fb0c8>] mutex_lock_nested+0x18/0x20
[   67.110313]        [<d0325bff>] do_journal_begin_r+0x7f/0x340 [reiserfs]
[   67.110313]        [<d0325f77>] journal_begin+0x77/0x140 [reiserfs]
[   67.110313]        [<d0326271>] reiserfs_persistent_transaction+0x41/0x90 [reiserfs]
[   67.110313]        [<d030d06c>] reiserfs_get_block+0x22c/0x1530 [reiserfs]
[   67.110313]        [<c10db9db>] __block_prepare_write+0x1bb/0x3a0
[   67.110313]        [<c10dbbe6>] block_prepare_write+0x26/0x40
[   67.110313]        [<d030b738>] reiserfs_prepare_write+0x88/0x170 [reiserfs]
[   67.110313]        [<d03294d6>] reiserfs_unpack+0xe6/0x120 [reiserfs]
[   67.110313]        [<d0329782>] reiserfs_ioctl+0x272/0x320 [reiserfs]
[   67.110313]        [<c10c3188>] vfs_ioctl+0x28/0xa0
[   67.110313]        [<c10c3bbd>] do_vfs_ioctl+0x32d/0x5c0
[   67.110313]        [<c10c3eb3>] sys_ioctl+0x63/0x70
[   67.110313]        [<c12fca3d>] syscall_call+0x7/0xb
[   67.110313]
[   67.110313] other info that might help us debug this:
[   67.110313]
[   67.110313] 2 locks held by lilo/1620:
[   67.110313]  #0:  (&sb->s_type->i_mutex_key#8){+.+.+.}, at: [<d032945a>] reiserfs_unpack+0x6a/0x120 [reiserfs]
[   67.110313]  #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<d032a278>] reiserfs_write_lock+0x28/0x40 [reiserfs]
[   67.110313]
[   67.110313] stack backtrace:
[   67.110313] Pid: 1620, comm: lilo Not tainted 2.6.35.4.4a #3
[   67.110313] Call Trace:
[   67.110313]  [<c12f9aba>] ? printk+0x18/0x1e
[   67.110313]  [<c1054182>] print_circular_bug+0xd2/0xe0
[   67.110313]  [<c10560f6>] __lock_acquire+0x1026/0x1180
[   67.110313]  [<c10562b7>] lock_acquire+0x67/0x80
[   67.110313]  [<d0325bff>] ? do_journal_begin_r+0x7f/0x340 [reiserfs]
[   67.110313]  [<c12facad>] __mutex_lock_common+0x4d/0x410
[   67.110313]  [<d0325bff>] ? do_journal_begin_r+0x7f/0x340 [reiserfs]
[   67.110313]  [<c1055275>] ? __lock_acquire+0x1a5/0x1180
[   67.110313]  [<c10897ae>] ? mempool_alloc_slab+0xe/0x10
[   67.110313]  [<c12fb0c8>] mutex_lock_nested+0x18/0x20
[   67.110313]  [<d0325bff>] ? do_journal_begin_r+0x7f/0x340 [reiserfs]
[   67.110313]  [<d0325bff>] do_journal_begin_r+0x7f/0x340 [reiserfs]
[   67.110313]  [<c1054bd2>] ? mark_held_locks+0x62/0x80
[   67.110313]  [<c10b163d>] ? kmem_cache_alloc+0x7d/0xb0
[   67.110313]  [<c1054e5c>] ? trace_hardirqs_on_caller+0x11c/0x160
[   67.110313]  [<d0325f77>] journal_begin+0x77/0x140 [reiserfs]
[   67.110313]  [<d0326262>] ? reiserfs_persistent_transaction+0x32/0x90 [reiserfs]
[   67.110313]  [<d0326271>] reiserfs_persistent_transaction+0x41/0x90 [reiserfs]
[   67.110313]  [<d030d06c>] reiserfs_get_block+0x22c/0x1530 [reiserfs]
[   67.110313]  [<c1055275>] ? __lock_acquire+0x1a5/0x1180
[   67.110313]  [<c12fc672>] ? _raw_spin_unlock_irq+0x22/0x50
[   67.110313]  [<c10b163d>] ? kmem_cache_alloc+0x7d/0xb0
[   67.110313]  [<c1054e5c>] ? trace_hardirqs_on_caller+0x11c/0x160
[   67.110313]  [<c102789b>] ? sub_preempt_count+0x7b/0xb0
[   67.110313]  [<c12fc457>] ? _raw_spin_unlock+0x27/0x40
[   67.110313]  [<c10db9db>] __block_prepare_write+0x1bb/0x3a0
[   67.110313]  [<c10dbbe6>] block_prepare_write+0x26/0x40
[   67.110313]  [<d030ce40>] ? reiserfs_get_block+0x0/0x1530 [reiserfs]
[   67.110313]  [<d030b738>] reiserfs_prepare_write+0x88/0x170 [reiserfs]
[   67.110313]  [<d030ce40>] ? reiserfs_get_block+0x0/0x1530 [reiserfs]
[   67.110313]  [<d03294d6>] reiserfs_unpack+0xe6/0x120 [reiserfs]
[   67.110313]  [<d0329782>] reiserfs_ioctl+0x272/0x320 [reiserfs]
[   67.110313]  [<d0329510>] ? reiserfs_ioctl+0x0/0x320 [reiserfs]
[   67.110313]  [<c10c3188>] vfs_ioctl+0x28/0xa0
[   67.110313]  [<c10c3bbd>] do_vfs_ioctl+0x32d/0x5c0
[   67.110313]  [<c109a228>] ? might_fault+0x88/0x90
[   67.110313]  [<c109a1e2>] ? might_fault+0x42/0x90
[   67.110313]  [<c10b6588>] ? fget_light+0xf8/0x2f0
[   67.110313]  [<c10c3eb3>] sys_ioctl+0x63/0x70
[   67.110313]  [<c12fca3d>] syscall_call+0x7/0xb
[   67.110313]  [<c12f007b>] ? cookie_v6_check+0x44b/0x630

Reported-by: Jarek Poplawski <jarkao2@gmail.com>
Tested-by: Jarek Poplawski <jarkao2@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: All since 2.6.32 <stable@kernel.org>
---
 fs/reiserfs/ioctl.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/reiserfs/ioctl.c b/fs/reiserfs/ioctl.c
index 679d502..5cbb81e 100644
--- a/fs/reiserfs/ioctl.c
+++ b/fs/reiserfs/ioctl.c
@@ -170,6 +170,7 @@ int reiserfs_prepare_write(struct file *f, struct page *page,
 int reiserfs_unpack(struct inode *inode, struct file *filp)
 {
 	int retval = 0;
+	int depth;
 	int index;
 	struct page *page;
 	struct address_space *mapping;
@@ -189,7 +190,7 @@ int reiserfs_unpack(struct inode *inode, struct file *filp)
 	 ** us
 	 */
 	reiserfs_mutex_lock_safe(&inode->i_mutex, inode->i_sb);
-	reiserfs_write_lock(inode->i_sb);
+	depth = reiserfs_write_lock_once(inode->i_sb);
 
 	write_from = inode->i_size & (blocksize - 1);
 	/* if we are on a block boundary, we are already unpacked.  */
@@ -224,6 +225,6 @@ int reiserfs_unpack(struct inode *inode, struct file *filp)
 
       out:
 	mutex_unlock(&inode->i_mutex);
-	reiserfs_write_unlock(inode->i_sb);
+	reiserfs_write_unlock_once(inode->i_sb, depth);
 	return retval;
 }
-- 
1.6.2.3

