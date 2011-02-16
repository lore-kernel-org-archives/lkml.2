Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab1BPAh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:37:57 -0500
Received: from kroah.org ([198.145.64.141]:49573 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932238Ab1BPAYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:24:00 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:46 2011
Message-Id: <20110216001446.045610704@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:14:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Soren Hansen <soren@linux2go.dk>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Paul Clements <paul.clements@steeleye.com>,
        Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>
Subject: [209/272] nbd: remove module-level ioctl mutex
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Soren Hansen <soren@linux2go.dk>

commit de1f016f882e52facc3c8609599f827bcdd14af9 upstream.

Commit 2a48fc0ab242417 ("block: autoconvert trivial BKL users to private
mutex") replaced uses of the BKL in the nbd driver with mutex
operations.  Since then, I've been been seeing these lock ups:

 INFO: task qemu-nbd:16115 blocked for more than 120 seconds.
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 qemu-nbd      D 0000000000000001     0 16115  16114 0x00000004
  ffff88007d775d98 0000000000000082 ffff88007d775fd8 ffff88007d774000
  0000000000013a80 ffff8800020347e0 ffff88007d775fd8 0000000000013a80
  ffff880133730000 ffff880002034440 ffffea0004333db8 ffffffffa071c020
 Call Trace:
  [<ffffffff815b9997>] __mutex_lock_slowpath+0xf7/0x180
  [<ffffffff815b93eb>] mutex_lock+0x2b/0x50
  [<ffffffffa071a21c>] nbd_ioctl+0x6c/0x1c0 [nbd]
  [<ffffffff812cb970>] blkdev_ioctl+0x230/0x730
  [<ffffffff811967a1>] block_ioctl+0x41/0x50
  [<ffffffff81175c03>] do_vfs_ioctl+0x93/0x370
  [<ffffffff81175f61>] sys_ioctl+0x81/0xa0
  [<ffffffff8100c0c2>] system_call_fastpath+0x16/0x1b

Instrumenting the nbd module's ioctl handler with some extra logging
clearly shows the NBD_DO_IT ioctl being invoked which is a long-lived
ioctl in the sense that it doesn't return until another ioctl asks the
driver to disconnect.  However, that other ioctl blocks, waiting for the
module-level mutex that replaced the BKL, and then we're stuck.

This patch removes the module-level mutex altogether.  It's clearly
wrong, and as far as I can see, it's entirely unnecessary, since the nbd
driver maintains per-device mutexes, and I don't see anything that would
require a module-level (or kernel-level, for that matter) mutex.

Signed-off-by: Soren Hansen <soren@linux2go.dk>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Acked-by: Paul Clements <paul.clements@steeleye.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/block/nbd.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -53,7 +53,6 @@
 #define DBG_BLKDEV      0x0100
 #define DBG_RX          0x0200
 #define DBG_TX          0x0400
-static DEFINE_MUTEX(nbd_mutex);
 static unsigned int debugflags;
 #endif /* NDEBUG */
 
@@ -718,11 +717,9 @@ static int nbd_ioctl(struct block_device
 	dprintk(DBG_IOCTL, "%s: nbd_ioctl cmd=%s(0x%x) arg=%lu\n",
 			lo->disk->disk_name, ioctl_cmd_to_ascii(cmd), cmd, arg);
 
-	mutex_lock(&nbd_mutex);
 	mutex_lock(&lo->tx_lock);
 	error = __nbd_ioctl(bdev, lo, cmd, arg);
 	mutex_unlock(&lo->tx_lock);
-	mutex_unlock(&nbd_mutex);
 
 	return error;
 }


