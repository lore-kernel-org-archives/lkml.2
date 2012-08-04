Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832Ab2HDK7J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 06:59:09 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49155 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab2HDK7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 06:59:06 -0400
Message-ID: <501D0093.2090108@gmail.com>
Date: Sat, 04 Aug 2012 12:59:31 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120730 Thunderbird/14.0
MIME-Version: 1.0
To: viro@zeniv.linux.org.uk
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: mq: INFO: possible circular locking dependency detected
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest, using latest -next kernel, I've stumbled on the dump below.

I think this is the result of commit 765927b2 ("switch dentry_open() to struct path, make it grab references itself").

[   62.090519] ======================================================
[   62.091016] [ INFO: possible circular locking dependency detected ]
[   62.091016] 3.6.0-rc1-next-20120803-sasha #544 Tainted: G        W
[   62.091016] -------------------------------------------------------
[   62.091016] trinity-child0/6077 is trying to acquire lock:
[   62.091016]  (&sb->s_type->i_mutex_key#14){+.+.+.}, at: [<ffffffff8127c074>] vfs_unlink+0x54/0x100
[   62.091016]
[   62.091016] but task is already holding lock:
sb_writers#8){.+.+.+}, at: [<ffffffff812900bf>] mnt_want_write+0x1f/0x50
[   62.097920]
[   62.097920] which lock already depends on the new lock.
[   62.097920]
[   62.097920]
[   62.097920] the existing dependency chain (in reverse order) is:
[   62.097920]
-> #1 (sb_writers#8){.+.+.+}:
[   62.097920]        [<ffffffff8117b58e>] validate_chain+0x69e/0x790
[   62.097920]        [<ffffffff8117baa3>] __lock_acquire+0x423/0x4c0
[   62.097920]        [<ffffffff8117bcca>] lock_acquire+0x18a/0x1e0
[   62.097920]        [<ffffffff81271282>] __sb_start_write+0x192/0x1f0
[   62.097920]        [<ffffffff812900bf>] mnt_want_write+0x1f/0x50
[   62.097920]        [<ffffffff818de4f8>] do_create+0xe8/0x160
[   62.097920]        [<ffffffff818de79b>] sys_mq_open+0x1ab/0x2a0
[   62.097920]        [<ffffffff83749379>] system_call_fastpath+0x16/0x1b
[   62.097920]
-> #0 (&sb->s_type->i_mutex_key#14){+.+.+.}:
[   62.097920]        [<ffffffff8117ab3f>] check_prev_add+0x11f/0x4d0
[   62.097920]        [<ffffffff8117b58e>] validate_chain+0x69e/0x790
[   62.097920]        [<ffffffff8117baa3>] __lock_acquire+0x423/0x4c0
[   62.097920]        [<ffffffff8117bcca>] lock_acquire+0x18a/0x1e0
[   62.097920]        [<ffffffff83744db0>] __mutex_lock_common+0x60/0x590
[   62.097920]        [<ffffffff83745410>] mutex_lock_nested+0x40/0x50
[   62.097920]        [<ffffffff8127c074>] vfs_unlink+0x54/0x100
[   62.097920]        [<ffffffff818de3ab>] sys_mq_unlink+0xfb/0x160
[   62.097920]        [<ffffffff83749379>] system_call_fastpath+0x16/0x1b
[   62.097920]
[   62.097920] other info that might help us debug this:
[   62.097920]
[   62.097920]  Possible unsafe locking scenario:
[   62.097920]
[   62.097920]        CPU0                    CPU1
[   62.097920]        ----                    ----
[   62.097920]   lock(sb_writers#8);
[   62.097920]                                lock(&sb->s_type->i_mutex_key#14);
[   62.097920]                                lock(sb_writers#8);
[   62.097920]   lock(&sb->s_type->i_mutex_key#14);
[   62.097920]
[   62.097920]  *** DEADLOCK ***
[   62.097920]
[   62.097920] 2 locks held by trinity-child0/6077:
[   62.097920]  #0:  (&sb->s_type->i_mutex_key#13/1){+.+.+.}, at: [<ffffffff818de31f>] sys_mq_unlink+0x6f/0x160
[   62.097920]  #1:  (sb_writers#8){.+.+.+}, at: [<ffffffff812900bf>] mnt_want_write+0x1f/0x50
[   62.097920]
[   62.097920] stack backtrace:
[   62.097920] Pid: 6077, comm: trinity-child0 Tainted: G        W    3.6.0-rc1-next-20120803-sasha #544
[   62.097920] Call Trace:
[   62.097920]  [<ffffffff81178b25>] print_circular_bug+0x105/0x120
[   62.097920]  [<ffffffff8117ab3f>] check_prev_add+0x11f/0x4d0
[   62.097920]  [<ffffffff8117b58e>] validate_chain+0x69e/0x790
[   62.097920]  [<ffffffff8114ed58>] ? sched_clock_cpu+0x108/0x120
[   62.097920]  [<ffffffff8117baa3>] __lock_acquire+0x423/0x4c0
[   62.097920]  [<ffffffff8117bcca>] lock_acquire+0x18a/0x1e0
[   62.097920]  [<ffffffff8127c074>] ? vfs_unlink+0x54/0x100
[   62.097920]  [<ffffffff83744db0>] __mutex_lock_common+0x60/0x590
[   62.097920]  [<ffffffff8127c074>] ? vfs_unlink+0x54/0x100
[   62.097920]  [<ffffffff81271296>] ? __sb_start_write+0x1a6/0x1f0
[   62.097920]  [<ffffffff8127b2ad>] ? generic_permission+0x2d/0x140
[   62.097920]  [<ffffffff8127c074>] ? vfs_unlink+0x54/0x100
[   62.097920]  [<ffffffff83745410>] mutex_lock_nested+0x40/0x50
[   62.097920]  [<ffffffff8127c074>] vfs_unlink+0x54/0x100
[   62.097920]  [<ffffffff818de3ab>] sys_mq_unlink+0xfb/0x160
[   62.097920]  [<ffffffff83749379>] system_call_fastpath+0x16/0x1b
