Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab1A1XeW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 18:34:22 -0500
Received: from nitrogen.linux2go.dk ([178.63.73.81]:50385 "EHLO
	nitrogen.linux2go.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258Ab1A1XeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 18:34:20 -0500
X-Greylist: delayed 629 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Jan 2011 18:34:20 EST
From: Soren Hansen <soren@linux2go.dk>
To: linux-kernel@vger.kernel.org
Cc: Soren Hansen <soren@linux2go.dk>
Subject: [PATCH] nbd: Remove module-level ioctl mutex
Date: Sat, 29 Jan 2011 00:23:48 +0100
Message-Id: <1296257028-14748-1-git-send-email-soren@linux2go.dk>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <AANLkTimP=5A-BNHUwV0qhvjw8y4HevMvXtOBpRr6vFYR@mail.gmail.com>
References: <AANLkTimP=5A-BNHUwV0qhvjw8y4HevMvXtOBpRr6vFYR@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2a48fc0ab24241755dc93bfd4f01d68efab47f5a replaced uses of the BKL in
the nbd driver with mutex operations. Since then, I've been been seeing
these lock ups:

 INFO: task qemu-nbd:16115 blocked for more than 120 seconds.
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 qemu-nbd      D 0000000000000001     0 16115  16114 0x00000004
  ffff88007d775d98 0000000000000082 ffff88007d775fd8 ffff88007d774000
  0000000000013a80 ffff8800020347e0 ffff88007d775fd8 0000000000013a80
  ffff880133730000 ffff880002034440 ffffea0004333db8 ffffffffa071c020
 Call Trace:
  [<ffffffff815b9997>] __mutex_lock_slowpath+0xf7/0x180
  [<ffffffff81132f13>] ? handle_mm_fault+0x1c3/0x410
  [<ffffffff815b93eb>] mutex_lock+0x2b/0x50
  [<ffffffffa071a21c>] nbd_ioctl+0x6c/0x1c0 [nbd]
  [<ffffffff812cb970>] blkdev_ioctl+0x230/0x730
  [<ffffffff811967a1>] block_ioctl+0x41/0x50
  [<ffffffff81175c03>] do_vfs_ioctl+0x93/0x370
  [<ffffffff8116fa83>] ? putname+0x33/0x50
  [<ffffffff81175f61>] sys_ioctl+0x81/0xa0
  [<ffffffff8100c0c2>] system_call_fastpath+0x16/0x1b

Instrumenting the nbd module's ioctl handler with some extra logging
clearly shows the NBD_DO_IT ioctl being invoked which is a long-lived
ioctl in the sense that it doesn't return until another ioctl asks the
driver to disconnect. However, that other ioctl blocks, waiting for the
module-level mutex that replaced the BKL, and then we're stuck.

This patch removes the module-level mutex altogether. It's clearly
wrong, and as far as I can see, it's entirely unnecessary, since the
nbd driver maintains per-device mutexes, and I don't see anything that
would require a module-level (or kernel-level, for that matter) mutex.

Signed-off-by: Soren Hansen <soren@linux2go.dk>
---
 drivers/block/nbd.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index a32fb41..e6fc716 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -53,7 +53,6 @@
 #define DBG_BLKDEV      0x0100
 #define DBG_RX          0x0200
 #define DBG_TX          0x0400
-static DEFINE_MUTEX(nbd_mutex);
 static unsigned int debugflags;
 #endif /* NDEBUG */
 
@@ -718,11 +717,9 @@ static int nbd_ioctl(struct block_device *bdev, fmode_t mode,
 	dprintk(DBG_IOCTL, "%s: nbd_ioctl cmd=%s(0x%x) arg=%lu\n",
 			lo->disk->disk_name, ioctl_cmd_to_ascii(cmd), cmd, arg);
 
-	mutex_lock(&nbd_mutex);
 	mutex_lock(&lo->tx_lock);
 	error = __nbd_ioctl(bdev, lo, cmd, arg);
 	mutex_unlock(&lo->tx_lock);
-	mutex_unlock(&nbd_mutex);
 
 	return error;
 }
-- 
1.7.2.3

