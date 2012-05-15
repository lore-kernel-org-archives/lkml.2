Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965224Ab2EOCRd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:17:33 -0400
Received: from mail1.windriver.com ([147.11.146.13]:52901 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964880Ab2EOCQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:18 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 023/179] loop: limit 'max_part' module param to DISK_MAX_PARTS
Date: Mon, 14 May 2012 22:11:59 -0400
Message-ID: <1337048075-6132-24-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 78f4bb367fd147a0e7e3998ba6e47109999d8814 upstream.

The 'max_part' parameter controls the number of maximum partition
a loop block device can have. However if a user specifies very
large value it would exceed the limitation of device minor number
and can cause a kernel panic (or, at least, produce invalid
device nodes in some cases).

On my desktop system, following command kills the kernel. On qemu,
it triggers similar oops but the kernel was alive:

$ sudo modprobe loop max_part0000
 ------------[ cut here ]------------
 kernel BUG at /media/Linux_Data/project/linux/fs/sysfs/group.c:65!
 invalid opcode: 0000 [#1] SMP
 last sysfs file:
 CPU 0
 Modules linked in: loop(+)

 Pid: 43, comm: insmod Tainted: G        W   2.6.39-qemu+ #155 Bochs Bochs
 RIP: 0010:[<ffffffff8113ce61>]  [<ffffffff8113ce61>] internal_create_group=
+0x2a/0x170
 RSP: 0018:ffff880007b3fde8  EFLAGS: 00000246
 RAX: 00000000ffffffef RBX: ffff880007b3d878 RCX: 00000000000007b4
 RDX: ffffffff8152da50 RSI: 0000000000000000 RDI: ffff880007b3d878
 RBP: ffff880007b3fe38 R08: ffff880007b3fde8 R09: 0000000000000000
 R10: ffff88000783b4a8 R11: ffff880007b3d878 R12: ffffffff8152da50
 R13: ffff880007b3d868 R14: 0000000000000000 R15: ffff880007b3d800
 FS:  0000000002137880(0063) GS:ffff880007c00000(0000) knlGS:00000000000000=
00
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000422680 CR3: 0000000007b50000 CR4: 00000000000006b0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
 Process insmod (pid: 43, threadinfo ffff880007b3e000, task ffff880007afb9c=
0)
 Stack:
  ffff880007b3fe58 ffffffff811e66dd ffff880007b3fe58 ffffffff811e570b
  0000000000000010 ffff880007b3d800 ffff880007a7b390 ffff880007b3d868
  0000000000400920 ffff880007b3d800 ffff880007b3fe48 ffffffff8113cfc8
 Call Trace:
  [<ffffffff811e66dd>] ? device_add+0x4bc/0x5af
  [<ffffffff811e570b>] ? dev_set_name+0x3c/0x3e
  [<ffffffff8113cfc8>] sysfs_create_group+0xe/0x12
  [<ffffffff810b420e>] blk_trace_init_sysfs+0x14/0x16
  [<ffffffff8116a090>] blk_register_queue+0x47/0xf7
  [<ffffffff8116f527>] add_disk+0xdf/0x290
  [<ffffffffa00060eb>] loop_init+0xeb/0x1b8 [loop]
  [<ffffffffa0006000>] ? 0xffffffffa0005fff
  [<ffffffff8100020a>] do_one_initcall+0x7a/0x12e
  [<ffffffff81096804>] sys_init_module+0x9c/0x1e0
  [<ffffffff813329bb>] system_call_fastpath+0x16/0x1b
 Code: c3 55 48 89 e5 41 57 41 56 41 89 f6 41 55 41 54 49 89 d4 53 48 89 fb=
 48 83 ec 28 48 85 ff 74 0b 85 f6 75 0b 48 83 7f 30 00 75 14 <0f> 0b eb fe =
48 83 7f 30 00 b9 ea ff ff ff 0f 84 18 01 00 00 49
 RIP  [<ffffffff8113ce61>] internal_create_group+0x2a/0x170
  RSP <ffff880007b3fde8>
 ---[ end trace a123eb592043acad ]---

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Laurent Vivier <Laurent.Vivier@bull.net>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/block/loop.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 8546d12..bcd26d0 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1604,6 +1604,9 @@ static int __init loop_init(void)
 	if (max_part > 0)
 		part_shift = fls(max_part);
 
+	if ((1UL << part_shift) > DISK_MAX_PARTS)
+		return -EINVAL;
+
 	if (max_loop > 1UL << (MINORBITS - part_shift))
 		return -EINVAL;
 
-- 
1.7.9.6

