Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031735Ab2CIUDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:03:33 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:36444 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031698Ab2CITwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:52:54 -0500
Message-Id: <20120309190217.852452267@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:50 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stanislaw Gruszka <sgruszka@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Tim Gardner <tim.gardner@canonical.com>
Subject: [ 36/68] bsg: fix sysfs link remove warning
In-Reply-To: <20120309194409.GA2069@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 37b40adf2d1b4a5e51323be73ccf8ddcf3f15dd3 upstream.

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
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/bsg.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/block/bsg.c
+++ b/block/bsg.c
@@ -985,7 +985,8 @@ void bsg_unregister_queue(struct request
 
 	mutex_lock(&bsg_mutex);
 	idr_remove(&bsg_minor_idr, bcd->minor);
-	sysfs_remove_link(&q->kobj, "bsg");
+	if (q->kobj.sd)
+		sysfs_remove_link(&q->kobj, "bsg");
 	device_unregister(bcd->class_dev);
 	bcd->class_dev = NULL;
 	kref_put(&bcd->ref, bsg_kref_release_function);


