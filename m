Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab0JBH7Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 03:59:24 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:53355 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab0JBH7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 03:59:23 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: airlied@redhat.com
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH 1/1] nouveau: ratelimit IRQ messages
Date: Sat,  2 Oct 2010 09:58:56 +0200
Message-Id: <1286006336-24651-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two messages in the ISR of nouvea which might be printed out
hundred times in a second. Ratelimit them.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Ben Skeggs <bskeggs@redhat.com>
---
 drivers/gpu/drm/nouveau/nouveau_irq.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_irq.c b/drivers/gpu/drm/nouveau/nouveau_irq.c
index 794b0ee..c6d57eb 100644
--- a/drivers/gpu/drm/nouveau/nouveau_irq.c
+++ b/drivers/gpu/drm/nouveau/nouveau_irq.c
@@ -200,7 +200,9 @@ nouveau_fifo_irq_handler(struct drm_device *dev)
 		}
 
 		if (status & NV_PFIFO_INTR_DMA_PUSHER) {
-			NV_INFO(dev, "PFIFO_DMA_PUSHER - Ch %d\n", chid);
+			if (printk_ratelimit())
+				NV_INFO(dev, "PFIFO_DMA_PUSHER - Ch %d\n",
+						chid);
 
 			status &= ~NV_PFIFO_INTR_DMA_PUSHER;
 			nv_wr32(dev, NV03_PFIFO_INTR_0,
@@ -227,8 +229,9 @@ nouveau_fifo_irq_handler(struct drm_device *dev)
 		}
 
 		if (status) {
-			NV_INFO(dev, "PFIFO_INTR 0x%08x - Ch %d\n",
-				status, chid);
+			if (printk_ratelimit())
+				NV_INFO(dev, "PFIFO_INTR 0x%08x - Ch %d\n",
+					status, chid);
 			nv_wr32(dev, NV03_PFIFO_INTR_0, status);
 			status = 0;
 		}
-- 
1.7.3.1


