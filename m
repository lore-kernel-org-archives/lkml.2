Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759292Ab0I0NO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 09:14:59 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41090 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896Ab0I0NO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 09:14:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=trQwqsjVCVmgq+Q3ApHWRY89wtNXjKSOLrIKk2gOf4/ZC5hCM/NjBS1F5KTi2fPDdI
         aJIPfmET/uteAnYZFNiw98buj0vUWhRt/o/Zb0krKo6DM4+MZHvrZRpPmWW5A1S5+GjU
         4SwPGmdFmdRmcDu1NX71NNjcMaij92bx9noIk=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jarek Poplawski <jarkao2@gmail.com>,
        "All since 2.6.32" <stable@kernel.org>
Subject: [PATCH 1/2] reiserfs: Fix dependency inversion between inode and reiserfs mutexes
Date: Mon, 27 Sep 2010 15:14:50 +0200
Message-Id: <1285593291-11527-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reiserfs mutex already depends on the inode mutex, so we can't
lock the inode mutex in reiserfs_unpack() without using the safe
locking API, because reiserfs_unpack() is always called with
the reiserfs mutex locked.

This fixes:

[   92.766639] =======================================================
[   92.767222] [ INFO: possible circular locking dependency detected ]
[   92.767222] 2.6.35c #13
[   92.767222] -------------------------------------------------------
[   92.767222] lilo/1606 is trying to acquire lock:
[   92.767222]  (&sb->s_type->i_mutex_key#8){+.+.+.}, at: [<d0329450>] reiserfs_unpack+0x60/0x110 [reiserfs]
[   92.767222]
[   92.767222] but task is already holding lock:
[   92.767222]  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<d032a268>] reiserfs_write_lock+0x28/0x40 [reiserfs]
[   92.767222]
[   92.767222] which lock already depends on the new lock.
[   92.767222]
[   92.767222]
[   92.767222] the existing dependency chain (in reverse order) is:
[   92.767222]
[   92.767222] -> #1 (&REISERFS_SB(s)->lock){+.+.+.}:
[   92.767222]        [<c1056347>] lock_acquire+0x67/0x80
[   92.767222]        [<c12f083d>] __mutex_lock_common+0x4d/0x410
[   92.767222]        [<c12f0c58>] mutex_lock_nested+0x18/0x20
[   92.767222]        [<d032a268>] reiserfs_write_lock+0x28/0x40 [reiserfs]
[   92.767222]        [<d0329e9a>] reiserfs_lookup_privroot+0x2a/0x90 [reiserfs]
[   92.767222]        [<d0316b81>] reiserfs_fill_super+0x941/0xe60 [reiserfs]
[   92.767222]        [<c10b7d17>] get_sb_bdev+0x117/0x170
[   92.767222]        [<d0313e21>] get_super_block+0x21/0x30 [reiserfs]
[   92.767222]        [<c10b74ba>] vfs_kern_mount+0x6a/0x1b0
[   92.767222]        [<c10b7659>] do_kern_mount+0x39/0xe0
[   92.767222]        [<c10cebe0>] do_mount+0x340/0x790
[   92.767222]        [<c10cf0b4>] sys_mount+0x84/0xb0
[   92.767222]        [<c12f25cd>] syscall_call+0x7/0xb
[   92.767222]
[   92.767222] -> #0 (&sb->s_type->i_mutex_key#8){+.+.+.}:
[   92.767222]        [<c1056186>] __lock_acquire+0x1026/0x1180
[   92.767222]        [<c1056347>] lock_acquire+0x67/0x80
[   92.767222]        [<c12f083d>] __mutex_lock_common+0x4d/0x410
[   92.767222]        [<c12f0c58>] mutex_lock_nested+0x18/0x20
[   92.767222]        [<d0329450>] reiserfs_unpack+0x60/0x110 [reiserfs]
[   92.767222]        [<d0329772>] reiserfs_ioctl+0x272/0x320 [reiserfs]
[   92.767222]        [<c10c3228>] vfs_ioctl+0x28/0xa0
[   92.767222]        [<c10c3c5d>] do_vfs_ioctl+0x32d/0x5c0
[   92.767222]        [<c10c3f53>] sys_ioctl+0x63/0x70
[   92.767222]        [<c12f25cd>] syscall_call+0x7/0xb
[   92.767222]
[   92.767222] other info that might help us debug this:
[   92.767222]
[   92.767222] 1 lock held by lilo/1606:
[   92.767222]  #0:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<d032a268>] reiserfs_write_lock+0x28/0x40 [reiserfs]
[   92.767222]
[   92.767222] stack backtrace:
[   92.767222] Pid: 1606, comm: lilo Not tainted 2.6.35c #13
[   92.767222] Call Trace:
[   92.767222]  [<c12ef64a>] ? printk+0x18/0x1e
[   92.767222]  [<c1054212>] print_circular_bug+0xd2/0xe0
[   92.767222]  [<c1056186>] __lock_acquire+0x1026/0x1180
[   92.767222]  [<c1089489>] ? __generic_file_aio_write+0x1c9/0x550
[   92.767222]  [<c1056347>] lock_acquire+0x67/0x80
[   92.767222]  [<d0329450>] ? reiserfs_unpack+0x60/0x110 [reiserfs]
[   92.767222]  [<c12f083d>] __mutex_lock_common+0x4d/0x410
[   92.767222]  [<d0329450>] ? reiserfs_unpack+0x60/0x110 [reiserfs]
[   92.767222]  [<c12f0b08>] ? __mutex_lock_common+0x318/0x410
[   92.767222]  [<d032a268>] ? reiserfs_write_lock+0x28/0x40 [reiserfs]
[   92.767222]  [<c12f0c58>] mutex_lock_nested+0x18/0x20
[   92.767222]  [<d0329450>] ? reiserfs_unpack+0x60/0x110 [reiserfs]
[   92.767222]  [<d0329450>] reiserfs_unpack+0x60/0x110 [reiserfs]
[   92.767222]  [<c12f0c58>] ? mutex_lock_nested+0x18/0x20
[   92.767222]  [<d0329772>] reiserfs_ioctl+0x272/0x320 [reiserfs]
[   92.767222]  [<d0329500>] ? reiserfs_ioctl+0x0/0x320 [reiserfs]
[   92.767222]  [<c10c3228>] vfs_ioctl+0x28/0xa0
[   92.767222]  [<c10c3c5d>] do_vfs_ioctl+0x32d/0x5c0
[   92.767222]  [<c109a428>] ? might_fault+0x88/0x90
[   92.767222]  [<c109a3e2>] ? might_fault+0x42/0x90
[   92.767222]  [<c10b6638>] ? fget_light+0xf8/0x2f0
[   92.767222]  [<c10c3f53>] sys_ioctl+0x63/0x70
[   92.767222]  [<c12f25cd>] syscall_call+0x7/0xb

Reported-by: Jarek Poplawski <jarkao2@gmail.com>
Tested-by: Jarek Poplawski <jarkao2@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: All since 2.6.32 <stable@kernel.org>
---
 fs/reiserfs/ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/reiserfs/ioctl.c b/fs/reiserfs/ioctl.c
index f53505d..679d502 100644
--- a/fs/reiserfs/ioctl.c
+++ b/fs/reiserfs/ioctl.c
@@ -188,7 +188,7 @@ int reiserfs_unpack(struct inode *inode, struct file *filp)
 	/* we need to make sure nobody is changing the file size beneath
 	 ** us
 	 */
-	mutex_lock(&inode->i_mutex);
+	reiserfs_mutex_lock_safe(&inode->i_mutex, inode->i_sb);
 	reiserfs_write_lock(inode->i_sb);
 
 	write_from = inode->i_size & (blocksize - 1);
-- 
1.6.2.3

