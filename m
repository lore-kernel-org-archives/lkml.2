Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab2CLAt3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 20:49:29 -0400
Received: from 1wt.eu ([62.212.114.60]:63045 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754577Ab2CLAsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 20:48:18 -0400
Message-Id: <20120312002046.121573243@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 Mar 2012 01:20:49 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Tim Gardner <tim.gardner@canonical.com>
Subject: [ 04/12] bsg: fix sysfs link remove warning
In-Reply-To: <feb44625a10a45049eddf27890e95d54@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

BugLink: http://bugs.launchpad.net/bugs/946928

We create "bsg" link if q->kobj.sd is not NULL, so remove it only
when the same condition is true.

Fixes:

WARNING: at fs/sysfs/inode.c:323 sysfs_hash_and_remove+0x2b/0x77()
sysfs: can not remove 'bsg', no directory
Call Trace:
  [<c0429683>] warn_slowpath_common+0x6a/0x7f
  [<c0537a68>] ? sysfs_hash_and_remove+0x2b/0x77
  [<c042970b>] warn_slowpath_fmt+0x2b/0x2f
  [<c0537a68>] sysfs_hash_and_remove+0x2b/0x77
  [<c053969a>] sysfs_remove_link+0x20/0x23
  [<c05d88f1>] bsg_unregister_queue+0x40/0x6d
  [<c0692263>] __scsi_remove_device+0x31/0x9d
  [<c069149f>] scsi_forget_host+0x41/0x52
  [<c0689fa9>] scsi_remove_host+0x71/0xe0
  [<f7de5945>] quiesce_and_remove_host+0x51/0x83 [usb_storage]
  [<f7de5a1e>] usb_stor_disconnect+0x18/0x22 [usb_storage]
  [<c06c29de>] usb_unbind_interface+0x4e/0x109
  [<c067a80f>] __device_release_driver+0x6b/0xa6
  [<c067a861>] device_release_driver+0x17/0x22
  [<c067a46a>] bus_remove_device+0xd6/0xe6
  [<c06785e2>] device_del+0xf2/0x137
  [<c06c101f>] usb_disable_device+0x94/0x1a0

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
(cherry picked from commit 37b40adf2d1b4a5e51323be73ccf8ddcf3f15dd3)

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 block/bsg.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 7154a7a..e3e3241 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -977,7 +977,8 @@ void bsg_unregister_queue(struct request_queue *q)
 
 	mutex_lock(&bsg_mutex);
 	idr_remove(&bsg_minor_idr, bcd->minor);
-	sysfs_remove_link(&q->kobj, "bsg");
+	if (q->kobj.sd)
+		sysfs_remove_link(&q->kobj, "bsg");
 	device_unregister(bcd->class_dev);
 	bcd->class_dev = NULL;
 	kref_put(&bcd->ref, bsg_kref_release_function);
-- 
1.7.2.1.45.g54fbc



