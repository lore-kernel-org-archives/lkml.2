Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab0JENWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 09:22:18 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:35093 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059Ab0JENWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 09:22:17 -0400
X-Greylist: delayed 860 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Oct 2010 09:22:16 EDT
From: Jiri Slaby <jslaby@suse.cz>
To: bskeggs@redhat.com
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH v3 1/1] nouveau: ratelimit IRQ messages
Date: Tue,  5 Oct 2010 15:07:33 +0200
Message-Id: <1286284053-2510-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.3.1
X-Muni-Spam-TestIP: 147.251.48.3
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Tue, 05 Oct 2010 15:07:35 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two messages in the ISR of nouveau which might be printed out
hundred times in a second. Ratelimit them. (We need to move
nouveau_ratelimit to the top of the file.)

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Ben Skeggs <bskeggs@redhat.com>
Reviewed-by: Marcin Slusarz <marcin.slusarz@gmail.com>
---


Rebased on the top of nouveau git.


 drivers/gpu/drm/nouveau/nouveau_irq.c |   26 ++++++++++++++------------
 1 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_irq.c b/drivers/gpu/drm/nouveau/nouveau_irq.c
index 6fd51a5..b9e1ffe 100644
--- a/drivers/gpu/drm/nouveau/nouveau_irq.c
+++ b/drivers/gpu/drm/nouveau/nouveau_irq.c
@@ -42,6 +42,13 @@
 #include "nouveau_connector.h"
 #include "nv50_display.h"
 
+static DEFINE_RATELIMIT_STATE(nouveau_ratelimit_state, 3 * HZ, 20);
+
+static int nouveau_ratelimit(void)
+{
+	return __ratelimit(&nouveau_ratelimit_state);
+}
+
 void
 nouveau_irq_preinstall(struct drm_device *dev)
 {
@@ -213,11 +220,12 @@ nouveau_fifo_irq_handler(struct drm_device *dev)
 				u32 ib_get = nv_rd32(dev, 0x003334);
 				u32 ib_put = nv_rd32(dev, 0x003330);
 
-				NV_INFO(dev, "PFIFO_DMA_PUSHER - Ch %d Get 0x%02x%08x "
+				if (nouveau_ratelimit())
+					NV_INFO(dev, "PFIFO_DMA_PUSHER - Ch %d Get 0x%02x%08x "
 					     "Put 0x%02x%08x IbGet 0x%08x IbPut 0x%08x "
 					     "State 0x%08x Push 0x%08x\n",
-					chid, ho_get, get, ho_put, put, ib_get, ib_put,
-					state, push);
+						chid, ho_get, get, ho_put, put,
+						ib_get, ib_put, state, push);
 
 				/* METHOD_COUNT, in DMA_STATE on earlier chipsets */
 				nv_wr32(dev, 0x003364, 0x00000000);
@@ -266,8 +274,9 @@ nouveau_fifo_irq_handler(struct drm_device *dev)
 		}
 
 		if (status) {
-			NV_INFO(dev, "PFIFO_INTR 0x%08x - Ch %d\n",
-				status, chid);
+			if (nouveau_ratelimit())
+				NV_INFO(dev, "PFIFO_INTR 0x%08x - Ch %d\n",
+					status, chid);
 			nv_wr32(dev, NV03_PFIFO_INTR_0, status);
 			status = 0;
 		}
@@ -544,13 +553,6 @@ nouveau_pgraph_intr_notify(struct drm_device *dev, uint32_t nsource)
 		nouveau_graph_dump_trap_info(dev, "PGRAPH_NOTIFY", &trap);
 }
 
-static DEFINE_RATELIMIT_STATE(nouveau_ratelimit_state, 3 * HZ, 20);
-
-static int nouveau_ratelimit(void)
-{
-	return __ratelimit(&nouveau_ratelimit_state);
-}
-
 
 static inline void
 nouveau_pgraph_intr_error(struct drm_device *dev, uint32_t nsource)
-- 
1.7.3.1

