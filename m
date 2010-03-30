Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321Ab0C3Xti (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:49:38 -0400
Received: from kroah.org ([198.145.64.141]:45864 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932467Ab0C3XTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:19:44 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:47:43 2010
Message-Id: <20100330224742.413478285@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:41:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Michael S. Tsirkin" <mst@redhat.com>,
       Anthony Liguori <aliguori@us.ibm.com>, Shirley Ma <xma@us.ibm.com>,
       Amit Shah <amit.shah@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [034/156] virtio: fix out of range array access
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael S. Tsirkin <mst@redhat.com>

commit 3119815912a220bdac943dfbdfee640414c0c611 upstream.

I have observed the following error on virtio-net module unload:

------------[ cut here ]------------
WARNING: at kernel/irq/manage.c:858 __free_irq+0xa0/0x14c()
Hardware name: Bochs
Trying to free already-free IRQ 0
Modules linked in: virtio_net(-) virtio_blk virtio_pci virtio_ring
virtio af_packet e1000 shpchp aacraid uhci_hcd ohci_hcd ehci_hcd [last
unloaded: scsi_wait_scan]
Pid: 1957, comm: rmmod Not tainted 2.6.33-rc8-vhost #24
Call Trace:
 [<ffffffff8103e195>] warn_slowpath_common+0x7c/0x94
 [<ffffffff8103e204>] warn_slowpath_fmt+0x41/0x43
 [<ffffffff810a7a36>] ? __free_pages+0x5a/0x70
 [<ffffffff8107cc00>] __free_irq+0xa0/0x14c
 [<ffffffff8107cceb>] free_irq+0x3f/0x65
 [<ffffffffa0081424>] vp_del_vqs+0x81/0xb1 [virtio_pci]
 [<ffffffffa0091d29>] virtnet_remove+0xda/0x10b [virtio_net]
 [<ffffffffa0075200>] virtio_dev_remove+0x22/0x4a [virtio]
 [<ffffffff812709ee>] __device_release_driver+0x66/0xac
 [<ffffffff81270ab7>] driver_detach+0x83/0xa9
 [<ffffffff8126fc66>] bus_remove_driver+0x91/0xb4
 [<ffffffff81270fcf>] driver_unregister+0x6c/0x74
 [<ffffffffa0075418>] unregister_virtio_driver+0xe/0x10 [virtio]
 [<ffffffffa0091c4d>] fini+0x15/0x17 [virtio_net]
 [<ffffffff8106997b>] sys_delete_module+0x1c3/0x230
 [<ffffffff81007465>] ? old_ich_force_enable_hpet+0x117/0x164
 [<ffffffff813bb720>] ? do_page_fault+0x29c/0x2cc
 [<ffffffff81028e58>] sysenter_dispatch+0x7/0x27
---[ end trace 15e88e4c576cc62b ]---

The bug is in virtio-pci: we use msix_vector as array index to get irq
entry, but some vqs do not have a dedicated vector so this causes an out
of bounds access.  By chance, we seem to often get 0 value, which
results in this error.

Fix by verifying that vector is legal before using it as index.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Anthony Liguori <aliguori@us.ibm.com>
Acked-by: Shirley Ma <xma@us.ibm.com>
Acked-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/virtio/virtio_pci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -473,7 +473,8 @@ static void vp_del_vqs(struct virtio_dev
 
 	list_for_each_entry_safe(vq, n, &vdev->vqs, list) {
 		info = vq->priv;
-		if (vp_dev->per_vq_vectors)
+		if (vp_dev->per_vq_vectors &&
+			info->msix_vector != VIRTIO_MSI_NO_VECTOR)
 			free_irq(vp_dev->msix_entries[info->msix_vector].vector,
 				 vq);
 		vp_del_vq(vq);


