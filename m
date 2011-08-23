Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979Ab1HWEj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 00:39:28 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61402 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab1HWEjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 00:39:20 -0400
MIME-Version: 1.0
Date: Tue, 23 Aug 2011 00:39:19 -0400
Message-ID: <CAHFgRy_7XQkoU3uY72Eve_X-FfXOuUm2Ydhyheo4bf53P3K=zQ@mail.gmail.com>
Subject: 3.1.0-rc3 -- INFO: possible circular locking dependency detected
From: Miles Lane <miles.lane@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ INFO: possible circular locking dependency detected ]
3.1.0-rc3 #2
-------------------------------------------------------
dconf-service/1836 is trying to acquire lock:
 (&sb->s_type->i_mutex_key#12){+.+.+.}, at: [<ffffffff8116df1a>]
ext4_evict_inode+0x88/0x32b

 but task is already holding lock:
 (&mm->mmap_sem){++++++}, at: [<ffffffff810d4393>] sys_munmap+0x36/0x5b

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #1 (&mm->mmap_sem){++++++}:
       [<ffffffff8106933a>] lock_acquire+0x129/0x14e
       [<ffffffff810cddbd>] might_fault+0x68/0x8b
       [<ffffffff810fcf5e>] filldir+0x6a/0xc2
       [<ffffffff811651a1>] call_filldir+0x91/0xb8
       [<ffffffff811654bf>] ext4_readdir+0x1af/0x510
       [<ffffffff810fd1a4>] vfs_readdir+0x76/0xac
       [<ffffffff810fd2b6>] sys_getdents+0x79/0xc9
       [<ffffffff814162fb>] system_call_fastpath+0x16/0x1b

-> #0 (&sb->s_type->i_mutex_key#12){+.+.+.}:
       [<ffffffff81068b10>] __lock_acquire+0xa5e/0xd52
       [<ffffffff8106933a>] lock_acquire+0x129/0x14e
       [<ffffffff8140f1a2>] __mutex_lock_common+0x64/0x413
       [<ffffffff8140f5b0>] mutex_lock_nested+0x16/0x18
       [<ffffffff8116df1a>] ext4_evict_inode+0x88/0x32b
       [<ffffffff81102d8a>] evict+0x94/0x14e
       [<ffffffff81102fd0>] iput+0x18c/0x195
       [<ffffffff810ffdd4>] dentry_kill+0x11e/0x140
       [<ffffffff8110019b>] dput+0xd4/0xe4
       [<ffffffff810efac3>] fput+0x1a5/0x1bd
       [<ffffffff810d3214>] remove_vma+0x37/0x5f
       [<ffffffff810d4239>] do_munmap+0x2ed/0x306
       [<ffffffff810d43a1>] sys_munmap+0x44/0x5b
       [<ffffffff814162fb>] system_call_fastpath+0x16/0x1b

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&mm->mmap_sem);
                               lock(&sb->s_type->i_mutex_key);
                               lock(&mm->mmap_sem);
  lock(&sb->s_type->i_mutex_key);

 *** DEADLOCK ***

1 lock held by dconf-service/1836:
 #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff810d4393>] sys_munmap+0x36/0x5b

stack backtrace:
Pid: 1836, comm: dconf-service Tainted: G        W   3.1.0-rc3 #2
Call Trace:
 [<ffffffff81407d14>] print_circular_bug+0x1f8/0x209
 [<ffffffff81068b10>] __lock_acquire+0xa5e/0xd52
 [<ffffffff8116df1a>] ? ext4_evict_inode+0x88/0x32b
 [<ffffffff8106933a>] lock_acquire+0x129/0x14e
 [<ffffffff8116df1a>] ? ext4_evict_inode+0x88/0x32b
 [<ffffffff8140f1a2>] __mutex_lock_common+0x64/0x413
 [<ffffffff8116df1a>] ? ext4_evict_inode+0x88/0x32b
 [<ffffffff81102d5a>] ? evict+0x64/0x14e
 [<ffffffff8116df1a>] ? ext4_evict_inode+0x88/0x32b
 [<ffffffff8102fa1c>] ? get_parent_ip+0xe/0x3e
 [<ffffffff8140f5b0>] mutex_lock_nested+0x16/0x18
 [<ffffffff8116df1a>] ext4_evict_inode+0x88/0x32b
 [<ffffffff8116de92>] ? ext4_da_writepages+0x53f/0x53f
 [<ffffffff81102d8a>] evict+0x94/0x14e
 [<ffffffff81102fd0>] iput+0x18c/0x195
 [<ffffffff810ffdd4>] dentry_kill+0x11e/0x140
 [<ffffffff8110019b>] dput+0xd4/0xe4
 [<ffffffff810efac3>] fput+0x1a5/0x1bd
 [<ffffffff810d4393>] ? sys_munmap+0x36/0x5b
 [<ffffffff810d3214>] remove_vma+0x37/0x5f
 [<ffffffff810d4239>] do_munmap+0x2ed/0x306
 [<ffffffff810d43a1>] sys_munmap+0x44/0x5b
 [<ffffffff814162fb>] system_call_fastpath+0x16/0x1b
