Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933131Ab0LTUfH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 15:35:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933077Ab0LTUfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 15:35:06 -0500
Subject: Re: VFS scalability + cgroups == panic
From: Eric Paris <eparis@redhat.com>
To: npiggin@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <1292873163.26771.15.camel@localhost.localdomain>
References: <1292873163.26771.15.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Dec 2010 15:35:02 -0500
Message-ID: <1292877302.26771.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-20 at 14:26 -0500, Eric Paris wrote:
> [   46.337486] systemd[1]: readahead-collect.service: main process exited, code=exited, status=1
> [   46.339544] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [   46.340232] IP: [<          (null)>]           (null)
> [   46.340232] PGD 3a885067 PUD 3b2ad067 PMD 0
> [   46.340232] Oops: 0010 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [   46.340232] last sysfs file: /sys/module/ipv6/parameters/disable
> [   46.340232] CPU 1
> [   46.340232] Modules linked in: ipv6 autofs4 ext4 jbd2 crc16 usbhid
> [   46.340232]
> [   46.340232] Pid: 1, comm: systemd Tainted: G        W   2.6.37-rc6-kernel1-next-20101220+ #149 /KVM
> [   46.340232] RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
> [   46.340232] RSP: 0018:ffff88003de09d40  EFLAGS: 00010206
> [   46.340232] RAX: ffffffff81612080 RBX: ffff88003d8fdd20 RCX: 0000000000000000
> [   46.340232] RDX: ffffffff8154d737 RSI: ffff88003d8fdd98 RDI: ffff88003d8fdd20
> [   46.340232] RBP: ffff88003de09d78 R08: 0000000000000000 R09: 0000000000000000
> [   46.340232] R10: 0000000000000001 R11: 0000000000000001 R12: ffff88003d8fdd80
> [   46.340232] R13: ffff88003d8fd300 R14: ffff88003d8fd388 R15: ffff88003d8fddf8
> [   46.340232] FS:  00007f53e84b87c0(0000) GS:ffff88003e200000(0000) knlGS:0000000000000000
> [   46.340232] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   46.340232] CR2: 0000000000000000 CR3: 000000003b21f000 CR4: 00000000000006e0
> [   46.340232] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   46.340232] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   46.340232] Process systemd (pid: 1, threadinfo ffff88003de08000, task ffff88003de00000)
> [   46.340232] Stack:
> [   46.340232]  ffffffff81146570 ffff88003de09d78 ffff88003d8fdd20 ffff88003d8fd2a0
> [   46.340232]  ffff88003d8fd300 ffff88003d8fd388 ffff88003d8fddf8 ffff88003de09dc8
> [   46.340232]  ffffffff810ad273 ffff88003de09da8 ffff88003d8fdd80 ffff88003ac0b7c8
> [   46.340232] Call Trace:
> [   46.340232]  [<ffffffff81146570>] ? dput+0xd0/0x220
> [   46.340232]  [<ffffffff810ad273>] cgroup_clear_directory+0x93/0x130
> [   46.340232]  [<ffffffff810af7f6>] cgroup_rmdir+0x3b6/0x550
> [   46.340232]  [<ffffffff8107d720>] ? autoremove_wake_function+0x0/0x40
> [   46.340232]  [<ffffffff8113ac14>] vfs_rmdir+0xa4/0xe0
> [   46.340232]  [<ffffffff8114cd0d>] ? mnt_want_write+0x4d/0x90
> [   46.340232]  [<ffffffff8113d18b>] do_rmdir+0x10b/0x120
> [   46.340232]  [<ffffffff81093188>] ? lockdep_sys_exit+0x28/0x80
> [   46.340232]  [<ffffffff8154d479>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [   46.340232]  [<ffffffff8113d1f1>] sys_rmdir+0x11/0x20
> [   46.340232]  [<ffffffff8100bf12>] system_call_fastpath+0x16/0x1b
> 

Best bisection I could do (numerous bisect unsafe problems with your
patch series.  undefined dget_locked_dlock() and
security_inode_exec_permission() has broken arguments for a while.)

So best I could do is:
good=6eb3bdc9cf47642d439ffdfb0d1caa105f151a2c
fs: avoid inode RCU freeing for pseudo fs

bad=0c259f9c9ee263a5d907030e29c52fd8d206c631
fs: provide rcu-walk aware permission i_ops

-Eric

