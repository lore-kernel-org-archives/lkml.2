Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965918Ab2EODEB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 23:04:01 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53192 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964922Ab2EOCQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:52 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 064/179] md: check ->hot_remove_disk when removing disk
Date: Mon, 14 May 2012 22:12:40 -0400
Message-ID: <1337048075-6132-65-git-send-email-paul.gortmaker@windriver.com>
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

commit 01393f3d5836b7d62e925e6f4658a7eb22b83a11 upstream.

Check pers->hot_remove_disk instead of pers->hot_add_disk in slot_store()
during disk removal. The linear personality only has ->hot_add_disk and
no ->hot_remove_disk, so that removing disk in the array resulted to
following kernel bug:

$ sudo mdadm --create /dev/md0 --level=linear --raid-devices=4 /dev/loop[0-3]
$ echo none | sudo tee /sys/block/md0/md/dev-loop2/slot
 BUG: unable to handle kernel NULL pointer dereference at           (null)
 IP: [<          (null)>]           (null)
 PGD c9f5d067 PUD 8575a067 PMD 0
 Oops: 0010 [#1] SMP
 CPU 2
 Modules linked in: linear loop bridge stp llc kvm_intel kvm asus_atk0110 sr_mod cdrom sg

 Pid: 10450, comm: tee Not tainted 3.0.0-rc1-leonard+ #173 System manufacturer System Product Name/P5G41TD-M PRO
 RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
 RSP: 0018:ffff880085757df0  EFLAGS: 00010282
 RAX: ffffffffa00168e0 RBX: ffff8800d1431800 RCX: 000000000000006e
 RDX: 0000000000000001 RSI: 0000000000000002 RDI: ffff88008543c000
 RBP: ffff880085757e48 R08: 0000000000000002 R09: 000000000000000a
 R10: 0000000000000000 R11: ffff88008543c2e0 R12: 00000000ffffffff
 R13: ffff8800b4641000 R14: 0000000000000005 R15: 0000000000000000
 FS:  00007fe8c9e05700(0000) GS:ffff88011fa00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
 CR2: 0000000000000000 CR3: 00000000b4502000 CR4: 00000000000406e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Process tee (pid: 10450, threadinfo ffff880085756000, task ffff8800c9f08000)
 Stack:
  ffffffff8138496a ffff8800b4641000 ffff88008543c268 0000000000000000
  ffff8800b4641000 ffff88008543c000 ffff8800d1431868 ffffffff81a78a90
  ffff8800b4641000 ffff88008543c000 ffff8800d1431800 ffff880085757e98
 Call Trace:
  [<ffffffff8138496a>] ? slot_store+0xaa/0x265
  [<ffffffff81384bae>] rdev_attr_store+0x89/0xa8
  [<ffffffff8115a96a>] sysfs_write_file+0x108/0x144
  [<ffffffff81106b87>] vfs_write+0xb1/0x10d
  [<ffffffff8106e6c0>] ? trace_hardirqs_on_caller+0x111/0x135
  [<ffffffff81106cac>] sys_write+0x4d/0x77
  [<ffffffff814fe702>] system_call_fastpath+0x16/0x1b
 Code:  Bad RIP value.
 RIP  [<          (null)>]           (null)
  RSP <ffff880085757df0>
 CR2: 0000000000000000
 ---[ end trace ba5fc64319a826fb ]---

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index f468ec6..1287b03 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2391,7 +2391,7 @@ slot_store(mdk_rdev_t *rdev, const char *buf, size_t len)
 		if (rdev->raid_disk == -1)
 			return -EEXIST;
 		/* personality does all needed checks */
-		if (rdev->mddev->pers->hot_add_disk == NULL)
+		if (rdev->mddev->pers->hot_remove_disk == NULL)
 			return -EINVAL;
 		err = rdev->mddev->pers->
 			hot_remove_disk(rdev->mddev, rdev->raid_disk);
-- 
1.7.9.6

