Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab1KVGEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 01:04:44 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35232 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab1KVGEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 01:04:43 -0500
From: Sasha Levin <levinsasha928@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: jic23@cam.ac.uk, Sasha Levin <levinsasha928@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH v2] iio: Don't OOPS if dummy evgen failed init
Date: Tue, 22 Nov 2011 08:02:21 +0200
Message-Id: <1321941741-7838-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the dummy evgen failed init, the irq allocation functions which assume
init succeeded may still be called - causing an OOPS due to wrong assumption.

Here's the oops:

[    3.914332] BUG: unable to handle kernel NULL pointer dereference at 0000000000000148
[    3.915310] IP: [<ffffffff810b3008>] __lock_acquire+0xac/0xe50
[    3.915310] PGD 0
[    3.915310] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[    3.915310] CPU 1
[    3.915310] Pid: 1, comm: swapper Not tainted 3.2.0-rc2-sasha-00279-gd7bfb12-dirty #20
[    3.915310] RIP: 0010:[<ffffffff810b3008>]  [<ffffffff810b3008>] __lock_acquire+0xac/0xe50
[    3.915310] RSP: 0018:ffff880012499bc0  EFLAGS: 00010046
[    3.915310] RAX: 0000000000000086 RBX: ffff880012490000 RCX: 0000000000000000
[    3.915310] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000148
[    3.915310] RBP: ffff880012499c90 R08: 0000000000000002 R09: 0000000000000000
[    3.915310] R10: 0000000000000148 R11: 0000000000000000 R12: 0000000000000148
[    3.915310] R13: 0000000000000002 R14: 0000000000000000 R15: 0000000000000000
[    3.915310] FS:  0000000000000000(0000) GS:ffff880013c00000(0000) knlGS:0000000000000000
[    3.915310] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    3.915310] CR2: 0000000000000148 CR3: 0000000002605000 CR4: 00000000000406e0
[    3.915310] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    3.915310] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    3.915310] Process swapper (pid: 1, threadinfo ffff880012498000, task ffff880012490000)
[    3.915310] Stack:
[    3.915310]  ffff880012490000 ffffffff81e6fd38 ffffffff00000000 0000000000000000
[    3.915310]  0000000000000148 0000000012499c08 ffffffff00000000 000000000000002e
[    3.915310]  0000000000000001 ffff880012499ce0 ffffffff8161620e 0000000000000000
[    3.915310] Call Trace:
[    3.915310]  [<ffffffff81e6fd38>] ? retint_restore_args+0x13/0x13
[    3.915310]  [<ffffffff8161620e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[    3.915310]  [<ffffffff81e6fd38>] ? retint_restore_args+0x13/0x13
[    3.915310]  [<ffffffff81af8883>] ? iio_dummy_evgen_get_irq+0x33/0x8a
[    3.915310]  [<ffffffff810b4255>] lock_acquire+0x8a/0xa7
[    3.915310]  [<ffffffff81af8883>] ? iio_dummy_evgen_get_irq+0x33/0x8a
[    3.915310]  [<ffffffff81e6db81>] __mutex_lock_common+0x63/0x491
[    3.915310]  [<ffffffff81af8883>] ? iio_dummy_evgen_get_irq+0x33/0x8a
[    3.915310]  [<ffffffff810b474d>] ? debug_check_no_locks_freed+0x135/0x14a
[    3.915310]  [<ffffffff810b2c3a>] ? lock_is_held+0x92/0x9d
[    3.915310]  [<ffffffff81e6dfe5>] mutex_lock_nested+0x36/0x3b
[    3.915310]  [<ffffffff81af8883>] iio_dummy_evgen_get_irq+0x33/0x8a
[    3.915310]  [<ffffffff81af8594>] iio_simple_dummy_events_register+0x1b/0x69
[    3.915310]  [<ffffffff82ad4a91>] iio_dummy_init+0x105/0x18d
[    3.915310]  [<ffffffff82ad498c>] ? iio_init+0x7d/0x7d
[    3.915310]  [<ffffffff82a8dc02>] do_one_initcall+0x7a/0x135
[    3.915310]  [<ffffffff82a8dda7>] kernel_init+0xea/0x16f
[    3.915310]  [<ffffffff81e727c4>] kernel_thread_helper+0x4/0x10
[    3.915310]  [<ffffffff81e6fd38>] ? retint_restore_args+0x13/0x13
[    3.915310]  [<ffffffff82a8dcbd>] ? do_one_initcall+0x135/0x135
[    3.915310]  [<ffffffff81e727c0>] ? gs_change+0x13/0x13
[    3.915310] Code: 95 50 ff ff ff 74 24 e8 1f 3f 56 00 85 c0 0f 84 4e 0d 00 00 be cf 0b 00 00 83 3d 63 7c 58 02 00 0f 85 3c 0d 00 00 e9 c1 0c 00 00
[    3.915310]  81 3a a0 17 ca 82 b8 01 00 00 00 44 0f 44 e8 83 fe 01 77 0c
[    3.915310] RIP  [<ffffffff810b3008>] __lock_acquire+0xac/0xe50
[    3.915310]  RSP <ffff880012499bc0>
[    3.915310] CR2: 0000000000000148

Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-iio@vger.kernel.org
Cc: devel@driverdev.osuosl.org
Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 drivers/staging/iio/iio_dummy_evgen.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/iio/iio_dummy_evgen.c b/drivers/staging/iio/iio_dummy_evgen.c
index da657d1..74d8d94 100644
--- a/drivers/staging/iio/iio_dummy_evgen.c
+++ b/drivers/staging/iio/iio_dummy_evgen.c
@@ -102,6 +102,10 @@ static int iio_dummy_evgen_create(void)
 int iio_dummy_evgen_get_irq(void)
 {
 	int i, ret = 0;
+
+	if (iio_evgen == NULL)
+		return -ENODEV;
+
 	mutex_lock(&iio_evgen->lock);
 	for (i = 0; i < IIO_EVENTGEN_NO; i++)
 		if (iio_evgen->inuse[i] == false) {
-- 
1.7.8.rc1

