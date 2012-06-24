Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284Ab2FXIIO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 04:08:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:46621 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429Ab2FXIIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 04:08:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="169390185"
Date: Sun, 24 Jun 2012 16:07:40 +0800
From: wfg@linux.intel.com
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: vfs/for-next: NULL pointer dereference in sysfs_dentry_delete()
Message-ID: <20120624080740.GA8331@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

This commit

        commit 08eaca322cb2720f1730e46793dee9464ebd26f2
        Author: Al Viro <viro@zeniv.linux.org.uk>
        Date:   Thu Jun 7 20:51:39 2012 -0400

            sysfs: switch to ->s_d_op and ->d_release()
            
triggers the following bug:

[   21.848065] VFS: Mounted root (nfs filesystem) on device 0:12.
[   21.849412] debug: unmapping init [mem 0xffffffff81c96000-0xffffffff81f2bfff]
[   22.687531] modprobe (1905) used greatest stack depth: 3328 bytes left
[   23.776324] egrep (1978) used greatest stack depth: 3184 bytes left
[   23.778668] BUG: unable to handle kernel NULL pointer dereference at 0000000000000090
[   23.780021] IP: [<ffffffff81169005>] sysfs_dentry_delete+0x11/0x1f
[   23.780021] PGD 14da8067 PUD 13732067 PMD 0 
[   23.780021] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[   23.780021] CPU 0 
[   23.780021] Modules linked in:
[   23.780021] 
[   23.780021] Pid: 1974, comm: S03udev Not tainted 3.5.0-rc1+ #11 Bochs Bochs
[   23.780021] RIP: 0010:[<ffffffff81169005>]  [<ffffffff81169005>] sysfs_dentry_delete+0x11/0x1f
[   23.780021] RSP: 0018:ffff880013041c40  EFLAGS: 00010202
[   23.780021] RAX: 0000000000000000 RBX: ffff8800156e9030 RCX: 0000000000000100
[   23.780021] RDX: 0000000000000246 RSI: ffff8800156e90a8 RDI: ffff8800156e9030
[   23.780021] RBP: ffff880013041c68 R08: 0000000000000002 R09: 0000000000000000
[   23.780021] R10: 0000000000000002 R11: 0000000000000000 R12: fffffffffffffffe
[   23.780021] R13: ffff8800156e9090 R14: ffff880013041de8 R15: 0000000000000001
[   23.780021] FS:  00007f74f28d1700(0000) GS:ffff880017200000(0000) knlGS:0000000000000000
[   23.780021] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   23.780021] CR2: 0000000000000090 CR3: 0000000014d79000 CR4: 00000000000006f0
[   23.780021] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   23.780021] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   23.780021] Process S03udev (pid: 1974, threadinfo ffff880013040000, task ffff8800135ba340)
[   23.780021] Stack:
[   23.780021]  ffffffff8111fec9 fffffffffffffffe fffffffffffffffe ffff880015661030
[   23.780021]  ffff880013041de8 ffff880013041c88 ffffffff81115c76 0000000000000001
[   23.780021]  ffff880015661030 ffff880013041cb8 ffffffff811162df ffff880013041d38
[   23.780021] Call Trace:
[   23.780021]  [<ffffffff8111fec9>] ? dput+0x78/0x180
[   23.780021]  [<ffffffff81115c76>] lookup_real+0x3f/0x47
[   23.780021]  [<ffffffff811162df>] __lookup_hash+0x33/0x3a
[   23.780021]  [<ffffffff81116a8f>] lookup_slow+0x49/0xad
[   23.780021]  [<ffffffff81118218>] path_lookupat+0x115/0x64a
[   23.780021]  [<ffffffff81104743>] ? kmem_cache_alloc+0x72/0x14f
[   23.780021]  [<ffffffff81116606>] ? getname_flags+0x2a/0xa2
[   23.780021]  [<ffffffff81118770>] do_path_lookup+0x23/0x59
[   23.780021]  [<ffffffff8111a1d8>] user_path_at_empty+0x57/0x9c
[   23.780021]  [<ffffffff81057802>] ? lg_local_unlock+0x20/0x42
[   23.780021]  [<ffffffff81110a50>] ? cp_new_stat+0x120/0x134
[   23.780021]  [<ffffffff8111a22e>] user_path_at+0x11/0x13
[   23.780021]  [<ffffffff81110bed>] vfs_fstatat+0x35/0x66
[   23.780021]  [<ffffffff81110c59>] vfs_stat+0x1b/0x1d
[   23.780021]  [<ffffffff81110d6a>] sys_newstat+0x1a/0x35
[   23.780021]  [<ffffffff81080072>] ? trace_hardirqs_on_caller+0x120/0x17c
[   23.780021]  [<ffffffff812ea63e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   23.780021]  [<ffffffff817b40d2>] system_call_fastpath+0x16/0x1b
[   23.780021] Code: fc ff ff 8b 45 d8 ff cb 83 fb ff 75 e3 48 83 c4 18 5b 41 5c 41 5d 5d c3 90 90 55 48 89 e5 66 66 66 66 90 48 8b 87 c0 00 00 00 5d <8b> 80 90 00 00 00 66 c1 e8 0d 83 e0 01 c3 55 48 89 e5 66 66 66 
[   23.780021] RIP  [<ffffffff81169005>] sysfs_dentry_delete+0x11/0x1f
[   23.780021]  RSP <ffff880013041c40>
[   23.780021] CR2: 0000000000000090
[   23.847571] ---[ end trace e7e1845683b49296 ]---
[   23.849162] BUG: sleeping function called from invalid context at /c/kernel-tests/fs/kernel/rwsem.c:20
[   23.851339] in_atomic(): 1, irqs_disabled(): 0, pid: 1974, name: S03udev
[   23.852799] INFO: lockdep is turned off.
[   23.853875] Pid: 1974, comm: S03udev Tainted: G      D      3.5.0-rc1+ #11

Thanks,
Fengguang
