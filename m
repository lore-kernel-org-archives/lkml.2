Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291Ab2FJVkp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 17:40:45 -0400
Received: from smarthost02.digicable.hu ([94.21.128.7]:45954 "EHLO
	smarthost02.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab2FJVko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 17:40:44 -0400
Message-ID: <4FD5142B.2080809@freemail.hu>
Date: Sun, 10 Jun 2012 23:39:55 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: David Airlie <airlied@linux.ie>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>, dri-devel@lists.freedesktop.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] drm via: initialize object_idr
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Original: 84.236.6.17
X-Original: 92.249.128.185
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

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
---
diff --git a/drivers/gpu/drm/via/via_map.c b/drivers/gpu/drm/via/via_map.c
index 1f18225..c126182 100644
--- a/drivers/gpu/drm/via/via_map.c
+++ b/drivers/gpu/drm/via/via_map.c
@@ -100,12 +100,11 @@ int via_driver_load(struct drm_device *dev, unsigned long chipset)
 	if (dev_priv == NULL)
 		return -ENOMEM;

+	idr_init(&dev_priv->object_idr);
 	dev->dev_private = (void *)dev_priv;

 	dev_priv->chipset = chipset;

-	idr_init(&dev->object_name_idr);
-
 	pci_set_master(dev->pdev);

 	ret = drm_vblank_init(dev, 1);
