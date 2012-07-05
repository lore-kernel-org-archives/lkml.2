Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024Ab2GEGz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 02:55:29 -0400
Received: from mailout10.t-online.de ([194.25.134.21]:35959 "EHLO
	mailout10.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab2GEGzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 02:55:05 -0400
X-Greylist: delayed 972 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jul 2012 02:55:05 EDT
Message-ID: <4FF53671.5000400@t-online.de>
Date: Thu, 05 Jul 2012 08:38:41 +0200
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org
CC: Linus Torvalds <torvalds@linux-foundation.org>
Subject: reiserfs: possible circular locking dependency detected
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ID: EXrwacZbrhJ0AEMO4iBnb89Pfo9sqJYuofh2XYQq2Cl+yTIsK1BGUE+Ubsk1JwaQcS
X-TOI-MSGID: 5e87f7bb-638f-408f-a017-a17428e724de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don´t know if this problem is fixed in the current kernel, so have a look at the
following messsage about a possible locking problem I got on a spare machine
during heavy disk activity:

Jul 1 10:49:50 linux-iffr kernel: [73168.724207]
Jul 1 10:49:50 linux-iffr kernel: [73168.725665] ======================================================
Jul 1 10:49:50 linux-iffr kernel: [73168.727179] [ INFO: possible circular locking dependency detected ]
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] 3.3.5-main #17 Not tainted
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] -------------------------------------------------------
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] mv/17705 is trying to acquire lock:
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] (&type->i_mutex_dir_key#3/2){+.+.+.}, at: [<c022000d>] delete_one_xattr+0x51/0x9c
Jul 1 10:49:50 linux-iffr kernel: [73168.728028]
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] but task is already holding lock:
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] (&type->i_mutex_dir_key#3/3){+.+.+.}, at: [<c02204bd>] reiserfs_for_each_xattr+0x1d3/0x225
Jul 1 10:49:50 linux-iffr kernel: [73168.728028]
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] which lock already depends on the new lock.
Jul 1 10:49:50 linux-iffr kernel: [73168.728028]
Jul 1 10:49:50 linux-iffr kernel: [73168.728028]
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] the existing dependency chain (in reverse order) is:
Jul 1 10:49:50 linux-iffr kernel: [73168.728028]
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] -> #1 (&type->i_mutex_dir_key#3/3){+.+.+.}:
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c0153b87>] lock_acquire+0xaf/0xcd
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c049508d>] mutex_lock_nested+0x3a/0x27a
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c0220106>] open_xa_dir+0x42/0x155
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c0220347>] reiserfs_for_each_xattr+0x5d/0x225
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c0220527>] reiserfs_delete_xattrs+0x18/0x42
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c02085f6>] reiserfs_evict_inode+0x87/0x11d
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c01c9c3f>] evict+0x8d/0x134
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c01ca0c7>] iput+0x15c/0x161
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c01c7000>] d_kill+0xc5/0xe0
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c01c7611>] dput+0x12a/0x135
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c01c2a18>] sys_renameat+0x19e/0x1e3
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c01c2a74>] sys_rename+0x17/0x1b
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c0497305>] syscall_call+0x7/0xb
Jul 1 10:49:50 linux-iffr kernel: [73168.728028]
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] -> #0 (&type->i_mutex_dir_key#3/2){+.+.+.}:
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c0153224>] __lock_acquire+0xd88/0x12b8
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c0153b87>] lock_acquire+0xaf/0xcd
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c049508d>] mutex_lock_nested+0x3a/0x27a
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c022000d>] delete_one_xattr+0x51/0x9c
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c02204cc>] reiserfs_for_each_xattr+0x1e2/0x225
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c0220527>] reiserfs_delete_xattrs+0x18/0x42
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c02085f6>] reiserfs_evict_inode+0x87/0x11d
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c01c9c3f>] evict+0x8d/0x134
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c01ca0c7>] iput+0x15c/0x161
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c01c12ff>] do_unlinkat+0xde/0x118
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c01c268e>] sys_unlinkat+0x32/0x35
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c0497305>] syscall_call+0x7/0xb
Jul 1 10:49:50 linux-iffr kernel: [73168.728028]
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] other info that might help us debug this:
Jul 1 10:49:50 linux-iffr kernel: [73168.728028]
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] Possible unsafe locking scenario:
Jul 1 10:49:50 linux-iffr kernel: [73168.728028]
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] CPU0 CPU1
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] ---- ----
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] lock(&type->i_mutex_dir_key#3/3);
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] lock(&type->i_mutex_dir_key#3/2);
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] lock(&type->i_mutex_dir_key#3/3);
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] lock(&type->i_mutex_dir_key#3/2);
Jul 1 10:49:50 linux-iffr kernel: [73168.728028]
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] *** DEADLOCK ***
Jul 1 10:49:50 linux-iffr kernel: [73168.728028]
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] 1 lock held by mv/17705:
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] #0: (&type->i_mutex_dir_key#3/3){+.+.+.}, at: [<c02204bd>] reiserfs_for_each_xattr+0x1d3/0x225
Jul 1 10:49:50 linux-iffr kernel: [73168.728028]
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] stack backtrace:
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] Pid: 17705, comm: mv Not tainted 3.3.5-main #17
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] Call Trace:
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c012096f>] ? console_unlock+0x1bc/0x1e2
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c0490d9c>] print_circular_bug+0x215/0x222
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c0153224>] __lock_acquire+0xd88/0x12b8
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c022000d>] ? delete_one_xattr+0x51/0x9c
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c0153b87>] lock_acquire+0xaf/0xcd
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c022000d>] ? delete_one_xattr+0x51/0x9c
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c022000d>] ? delete_one_xattr+0x51/0x9c
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c049508d>] mutex_lock_nested+0x3a/0x27a
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c022000d>] ? delete_one_xattr+0x51/0x9c
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c015428c>] ? trace_hardirqs_on+0xb/0xd
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c022000d>] delete_one_xattr+0x51/0x9c
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c02204cc>] reiserfs_for_each_xattr+0x1e2/0x225
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c021ffbc>] ? xattr_unlink+0x70/0x70
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c0220527>] reiserfs_delete_xattrs+0x18/0x42
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c02085f6>] reiserfs_evict_inode+0x87/0x11d
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c0496f9a>] ? _raw_spin_unlock+0x2c/0x42
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c0499816>] ? sub_preempt_count+0x90/0x9d
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c01c9c3f>] evict+0x8d/0x134
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c01ca0c7>] iput+0x15c/0x161
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c01c12ff>] do_unlinkat+0xde/0x118
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c01e5224>] ? dnotify_flush+0x2f/0xa6
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c0497338>] ? restore_all+0xf/0xf
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c01c268e>] sys_unlinkat+0x32/0x35
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c0497305>] syscall_call+0x7/0xb
Jul 1 10:49:50 linux-iffr kernel: [73168.728028] [<c0490000>] ? no_context+0x6f/0x1a3

