Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab2HMUsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:48:23 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:34520 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab2HMUUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:20:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Asias He <asias@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: [ 01/82] virtio-blk: Call del_gendisk() before disable guest kick
Date: Mon, 13 Aug 2012 13:18:37 -0700
Message-Id: <20120813201746.577719372@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813201746.448504360@linuxfoundation.org>
References: <20120813201746.448504360@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asias He <asias@redhat.com>

commit 02e2b124943648fba0a2ccee5c3656a5653e0151 upstream.

del_gendisk() might not return due to failing to remove the
/sys/block/vda/serial sysfs entry when another thread (udev) is
trying to read it.

virtblk_remove()
  vdev->config->reset() : guest will not kick us through interrupt
    del_gendisk()
      device_del()
        kobject_del(): got stuck, sysfs entry ref count non zero

sysfs_open_file(): user space process read /sys/block/vda/serial
   sysfs_get_active() : got sysfs entry ref count
      dev_attr_show()
        virtblk_serial_show()
           blk_execute_rq() : got stuck, interrupt is disabled
                              request cannot be finished

This patch fixes it by calling del_gendisk() before we disable guest's
interrupt so that the request sent in virtblk_serial_show() will be
finished and del_gendisk() will success.

This fixes another race in hot-unplug process.

It is save to call del_gendisk(vblk->disk) before
flush_work(&vblk->config_work) which might access vblk->disk, because
vblk->disk is not freed until put_disk(vblk->disk).

Signed-off-by: Asias He <asias@redhat.com>
Cc: virtualization@lists.linux-foundation.org
Cc: kvm@vger.kernel.org
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/virtio_blk.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -584,13 +584,13 @@ static void __devexit virtblk_remove(str
 	vblk->config_enable = false;
 	mutex_unlock(&vblk->config_lock);
 
+	del_gendisk(vblk->disk);
+
 	/* Stop all the virtqueues. */
 	vdev->config->reset(vdev);
 
 	flush_work(&vblk->config_work);
 
-	del_gendisk(vblk->disk);
-
 	/* Abort requests dispatched to driver. */
 	spin_lock_irqsave(&vblk->lock, flags);
 	while ((vbr = virtqueue_detach_unused_buf(vblk->vq))) {


