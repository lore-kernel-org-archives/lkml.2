Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667Ab1EZM4N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 08:56:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61452 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab1EZM4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 08:56:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=fX5wqeybcqxx25h08CfIU5Z1BM6ojRc4K030JmXZpFhzZES71uo1RtNAYPTvhtpc/q
         ERgmwzVoGWYUkIr68XqO+dPJGxDJljJWV7zm/CvwbjhufQ3J0qyH5GKLOqczAKwc+1+u
         a1p86yfT2aPUjUWb7hWU7KtsxOYSTUUwU7Kdc=
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Laurent Vivier <Laurent.Vivier@bull.net>,
        stable@kernel.org
Subject: [PATCH 2/5] brd: limit 'max_part' module param to DISK_MAX_PARTS
Date: Thu, 26 May 2011 21:55:54 +0900
Message-Id: <1306414557-2441-3-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <1306414557-2441-1-git-send-email-namhyung@gmail.com>
References: <1306414557-2441-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'max_part' parameter controls the number of maximum partition
a brd device can have. However if a user specifies very large
value it would exceed the limitation of device minor number and
can cause a kernel panic (or, at least, produce invalid device
nodes in some cases).

On my desktop system, following command kills the kernel. On qemu,
it triggers similar oops but the kernel was alive:

$ sudo modprobe brd max_part=100000
 BUG: unable to handle kernel NULL pointer dereference at 0000000000000058
 IP: [<ffffffff81110a9a>] sysfs_create_dir+0x2d/0xae
 PGD 7af1067 PUD 7b19067 PMD 0
 Oops: 0000 [#1] SMP
 last sysfs file:
 CPU 0
 Modules linked in: brd(+)

 Pid: 44, comm: insmod Tainted: G        W   2.6.39-qemu+ #158 Bochs Bochs
 RIP: 0010:[<ffffffff81110a9a>]  [<ffffffff81110a9a>] sysfs_create_dir+0x2d/0xae
 RSP: 0018:ffff880007b15d78  EFLAGS: 00000286
 RAX: ffff880007b05478 RBX: ffff880007a52760 RCX: ffff880007b15dc8
 RDX: ffff880007a4f900 RSI: ffff880007b15e48 RDI: ffff880007a52760
 RBP: ffff880007b15da8 R08: 0000000000000002 R09: 0000000000000000
 R10: ffff880007b15e48 R11: ffff880007b05478 R12: 0000000000000000
 R13: ffff880007b05478 R14: 0000000000400920 R15: 0000000000000063
 FS:  0000000002160880(0063) GS:ffff880007c00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000058 CR3: 0000000007b1c000 CR4: 00000000000006b0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
 Process insmod (pid: 44, threadinfo ffff880007b14000, task ffff880007acb980)
 Stack:
  ffff880007b15dc8 ffff880007b05478 ffff880007b15da8 00000000fffffffe
  ffff880007a52760 ffff880007b05478 ffff880007b15de8 ffffffff81143c0a
  0000000000400920 ffff880007a52760 ffff880007b05478 0000000000000000
 Call Trace:
  [<ffffffff81143c0a>] kobject_add_internal+0xdf/0x1a0
  [<ffffffff81143da1>] kobject_add_varg+0x41/0x50
  [<ffffffff81143e6b>] kobject_add+0x64/0x66
  [<ffffffff8113bbe7>] blk_register_queue+0x5f/0xb8
  [<ffffffff81140f72>] add_disk+0xdf/0x289
  [<ffffffffa00040df>] brd_init+0xdf/0x1aa [brd]
  [<ffffffffa0004000>] ? 0xffffffffa0003fff
  [<ffffffffa0004000>] ? 0xffffffffa0003fff
  [<ffffffff8100020a>] do_one_initcall+0x7a/0x12e
  [<ffffffff8108516c>] sys_init_module+0x9c/0x1dc
  [<ffffffff812ff4bb>] system_call_fastpath+0x16/0x1b
 Code: 89 e5 41 55 41 54 53 48 89 fb 48 83 ec 18 48 85 ff 75 04 0f 0b eb fe 48 8b 47 18 49 c7 c4 70 1e 4d 81 48 85 c0 74 04 4c 8b 60 30
  8b 44 24 58 45 31 ed 0f b6 c4 85 c0 74 0d 48 8b 43 28 48 89
 RIP  [<ffffffff81110a9a>] sysfs_create_dir+0x2d/0xae
  RSP <ffff880007b15d78>
 CR2: 0000000000000058
 ---[ end trace aebb1175ce1f6739 ]---

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Laurent Vivier <Laurent.Vivier@bull.net>
Cc: stable@kernel.org
---
 drivers/block/brd.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index bae9a3d4e15b..e9a19d99f928 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -581,6 +581,9 @@ static int __init brd_init(void)
 	if (max_part > 0)
 		part_shift = fls(max_part);
 
+	if ((1UL << part_shift) > DISK_MAX_PARTS)
+		return -EINVAL;
+
 	if (rd_nr > 1UL << (MINORBITS - part_shift))
 		return -EINVAL;
 
-- 
1.7.5.2

