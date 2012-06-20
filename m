Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428Ab2FTSmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:42:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43050 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537Ab2FTSVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:21:09 -0400
Message-Id: <20120620173021.518580540@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Date: Wed, 20 Jun 2012 10:30:26 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?M=C3=A1rton=20N=C3=A9meth?= <nm127@freemail.hu>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 06/61] drm via: initialize object_idr
In-Reply-To: <20120620173033.GA5634@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Márton Németh <nm127@freemail.hu>

commit ce020ea53264f1460ae619cfc12f968dbd0b8974 upstream.

The field obejct_idr of struct drm_via_private was introduced with the
commit http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=77ee8f3825054f23b17e9c8f728f061defd86cdc .
In that patch idr_init(&dev->object_name_idr) was called instead of
idr_init(&dev_priv->object_idr) by mistake, leaving the dev_priv->object_idr
uninitialized. To be more exact, the object_idr buffer is filled with zeros
because of kzalloc(), but the dev_priv->object_idr.lock spinlock can cause
system freeze at lib/idr.c:move_to_free_list() when spin_lock_irqsave()
is called on this spinlock.

The patch was tested on Clevo D4J, model D410J laptop, on the following
hardware, without AGP kernel module loaded:

  # lspci -s 01:00.0 -n
  01:00.0 0300: 1106:3108 (rev 01)
  # lspci -s 01:00.0 -v
  01:00.0 VGA compatible controller: VIA Technologies, Inc. K8M800/K8N800/K8N800A [S3 UniChrome Pro] (rev 01) (prog-if 00 [VGA controller])
          Subsystem: CLEVO/KAPOK Computer Device 4702
          Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 16
          Memory at f0000000 (32-bit, prefetchable) [size=64M]
          Memory at d1000000 (32-bit, non-prefetchable) [size=16M]
          Expansion ROM at <unassigned> [disabled]
          Capabilities: [60] Power Management version 2
          Capabilities: [70] AGP version 3.0

Signed-off-by: Márton Németh <nm127@freemail.hu>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/via/via_map.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/gpu/drm/via/via_map.c
+++ b/drivers/gpu/drm/via/via_map.c
@@ -100,12 +100,11 @@ int via_driver_load(struct drm_device *d
 	if (dev_priv == NULL)
 		return -ENOMEM;
 
+	idr_init(&dev_priv->object_idr);
 	dev->dev_private = (void *)dev_priv;
 
 	dev_priv->chipset = chipset;
 
-	idr_init(&dev->object_name_idr);
-
 	pci_set_master(dev->pdev);
 
 	ret = drm_vblank_init(dev, 1);


