Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab1AZKwa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 05:52:30 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46964 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab1AZKw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 05:52:29 -0500
MIME-Version: 1.0
X-Originating-IP: [95.166.159.124]
Date: Wed, 26 Jan 2011 11:52:27 +0100
Message-ID: <AANLkTimP=5A-BNHUwV0qhvjw8y4HevMvXtOBpRr6vFYR@mail.gmail.com>
Subject: nbd locking problems
From: Soren Hansen <soren@linux2go.dk>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing the following lockup on a current kernel:

[117360.880311] INFO: task qemu-nbd:16115 blocked for more than 120 seconds.
[117360.880319] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[117360.880326] qemu-nbd      D 0000000000000001     0 16115  16114 0x00000004
[117360.880337]  ffff88007d775d98 0000000000000082 ffff88007d775fd8
ffff88007d774000
[117360.880348]  0000000000013a80 ffff8800020347e0 ffff88007d775fd8
0000000000013a80
[117360.880359]  ffff880133730000 ffff880002034440 ffffea0004333db8
ffffffffa071c020
[117360.880369] Call Trace:
[117360.880389]  [<ffffffff815b9997>] __mutex_lock_slowpath+0xf7/0x180
[117360.880400]  [<ffffffff81132f13>] ? handle_mm_fault+0x1c3/0x410
[117360.880408]  [<ffffffff815b93eb>] mutex_lock+0x2b/0x50
[117360.880419]  [<ffffffffa071a21c>] nbd_ioctl+0x6c/0x1c0 [nbd]
[117360.880429]  [<ffffffff812cb970>] blkdev_ioctl+0x230/0x730
[117360.880438]  [<ffffffff811967a1>] block_ioctl+0x41/0x50
[117360.880447]  [<ffffffff81175c03>] do_vfs_ioctl+0x93/0x370
[117360.880455]  [<ffffffff8116fa83>] ? putname+0x33/0x50
[117360.880463]  [<ffffffff81175f61>] sys_ioctl+0x81/0xa0
[117360.880473]  [<ffffffff8100c0c2>] system_call_fastpath+0x16/0x1b

It seems to be caused by 2a48fc0ab24241755dc93bfd4f01d68efab47f5a which
replaced lock_kernel() with mutex operations.

In my attempts to debug this problem, I reverted that commit.

There's a printk statement that logs each ioctl call right before the
lock_kernel call. I extended it to log the pid of the caller, and added
a similar printk statement after unlock_kernel.

This worked for me, and I saw something like this in my dmesg:

[122322.650443] nbd9: in: nbd_ioctl pid=(24396) cmd=set-blksize(0xab01) arg=1024
[122322.650454] nbd9: out: nbd_ioctl pid=(24396)
cmd=set-blksize(0xab01) arg=1024
[122322.650462] nbd9: in: nbd_ioctl pid=(24396)
cmd=set-size-blocks(0xab07) arg=153600
[122322.650469] nbd9: out: nbd_ioctl pid=(24396)
cmd=set-size-blocks(0xab07) arg=153600
[122322.650476] nbd9: in: nbd_ioctl pid=(24396) cmd=clear-sock(0xab04)
arg=153600
[122322.650483] nbd9: out: nbd_ioctl pid=(24396)
cmd=clear-sock(0xab04) arg=153600
[122322.650490] nbd9: in: nbd_ioctl pid=(24396) cmd=set-sock(0xab00) arg=3
[122322.650497] nbd9: out: nbd_ioctl pid=(24396) cmd=set-sock(0xab00) arg=3
[122322.651178] nbd9: in: nbd_ioctl pid=(24396) cmd=do-it(0xab03)
arg=139925697560832
[122322.652454]  nbd9: unknown partition table
[122323.070522] nbd9: in: nbd_ioctl pid=(24427) cmd=clear-que(0xab05)
arg=140267460190640
[122323.070527] nbd9: out: nbd_ioctl pid=(24427) cmd=clear-que(0xab05)
arg=140267460190640
[122323.070530] nbd9: in: nbd_ioctl pid=(24427) cmd=disconnect(0xab08)
arg=140267460190640
[122323.070532] nbd9: NBD_DISCONNECT
[122323.070555] nbd9: out: nbd_ioctl pid=(24427)
cmd=disconnect(0xab08) arg=140267460190640
[122323.070558] nbd9: in: nbd_ioctl pid=(24427) cmd=clear-sock(0xab04)
arg=140267460190640
[122323.070561] nbd9: out: nbd_ioctl pid=(24427)
cmd=clear-sock(0xab04) arg=140267460190640
[122323.070667] nbd9: Receive control failed (result -32)
[122323.070710] nbd9: queue cleared
[122323.071186] nbd9: out: nbd_ioctl pid=(24396) cmd=do-it(0xab03)
arg=139925697560832
[122323.071194] nbd9: in: nbd_ioctl pid=(24396) cmd=clear-que(0xab05) arg=32
[122323.071197] nbd9: out: nbd_ioctl pid=(24396) cmd=clear-que(0xab05) arg=32
[122323.071200] nbd9: in: nbd_ioctl pid=(24396) cmd=clear-sock(0xab04) arg=32
[122323.071203] nbd9: out: nbd_ioctl pid=(24396) cmd=clear-sock(0xab04) arg=32

As I understand it, lock_kernel is implemented using a semaphore which
allows a single process to invoke lock_kernel more than once without
locking up. However, as can be seen above (timestamp 122322.651178), pid
24396 invokes the NBD_DO_IT ioctl. This calls lock_kernel and starts a
kernel thread to do the heavy lifting of nbd. Later on, pid 24427 comes
along, wanting to shut down the connection. It works. I don't understand
how it makes it past the lock_kernel() call. There's only one instance
of each of lock_kernel and unlock_kernel in the nbd driver, so I'm
fairly certain unlock_kernel isn't being called (at least not by nbd
directly).

With the mutex code introduced by
2a48fc0ab24241755dc93bfd4f01d68efab47f5a but with my extra printk's, this
is what I get:

[125474.139952] nbd9: in: nbd_ioctl pid=(26015) cmd=set-blksize(0xab01) arg=1024
[125474.139963] nbd9: out: nbd_ioctl pid=(26015)
cmd=set-blksize(0xab01) arg=1024
[125474.139971] nbd9: in: nbd_ioctl pid=(26015)
cmd=set-size-blocks(0xab07) arg=153600
[125474.139979] nbd9: out: nbd_ioctl pid=(26015)
cmd=set-size-blocks(0xab07) arg=153600
[125474.139986] nbd9: in: nbd_ioctl pid=(26015) cmd=clear-sock(0xab04)
arg=153600
[125474.139994] nbd9: out: nbd_ioctl pid=(26015)
cmd=clear-sock(0xab04) arg=153600
[125474.140001] nbd9: in: nbd_ioctl pid=(26015) cmd=set-sock(0xab00) arg=3
[125474.140036] nbd9: out: nbd_ioctl pid=(26015) cmd=set-sock(0xab00) arg=3
[125474.140660] nbd9: in: nbd_ioctl pid=(26015) cmd=do-it(0xab03)
arg=140041726828800
[125474.142255]  nbd9: unknown partition table
[125475.604613] nbd9: in: nbd_ioctl pid=(26047) cmd=clear-que(0xab05)
arg=139640717427120

...and then it sits there until I kill -9 26015.  This makes sense to
me, though. The mutex is held by 26015, so of course 26047 can't grab
it, too. The mystery is why it works with lock_kernel. It doesn't
release the kernel explicitly, and it doesn't (explicitly, at least)
call schedule().

All this aside, it appears to me that this locking is superfluous to
begin with. The driver already has a per-device mutex that should
suffice, as far as I can tell. Removing this extra mutex works for me,
and I've not yet noticed any ill side effects, but I'll try to run some
better stress tests to make sure.

-- 
Soren Hansen <soren@linux2go.dk>
Ubuntu Developer
OpenStack Developer
