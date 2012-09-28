Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758488Ab2I1PbZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 11:31:25 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46450 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758340Ab2I1PbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 11:31:23 -0400
From: Emil Goode <emilgoode@gmail.com>
To: ohad@wizery.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] remoteproc: Fix use of format specifyer
Date: Fri, 28 Sep 2012 17:35:06 +0200
Message-Id: <1348846506-9670-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dma_addr_t type can be eigher u32 or u64 depending on
the configuration. We should use a format specifyer for the
larges type and explicitly cast to it.

Sparse warnings:
drivers/remoteproc/remoteproc_core.c:234:2: warning:
	format ‘%x’ expects argument of type ‘unsigned int’,
	but argument 6 has type ‘dma_addr_t’ [-Wformat]

drivers/remoteproc/remoteproc_core.c:596:2: warning:
	format ‘%x’ expects argument of type ‘unsigned int’,
	but argument 5 has type ‘dma_addr_t’ [-Wformat]

drivers/remoteproc/remoteproc_core.c:634:3:
	warning: format ‘%x’ expects argument of type ‘unsigned int’,
	but argument 5 has type ‘dma_addr_t’ [-Wformat]

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 drivers/remoteproc/remoteproc_core.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index b6c6229..e05f153 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -231,8 +231,8 @@ int rproc_alloc_vring(struct rproc_vdev *rvdev, int i)
 	/* Store largest notifyid */
 	rproc->max_notifyid = max(rproc->max_notifyid, notifyid);
 
-	dev_dbg(dev, "vring%d: va %p dma %x size %x idr %d\n", i, va,
-					dma, size, notifyid);
+	dev_dbg(dev, "vring%d: va %p dma %llx size %x idr %d\n", i, va,
+				(unsigned long long)dma, size, notifyid);
 
 	rvring->va = va;
 	rvring->dma = dma;
@@ -593,7 +593,8 @@ static int rproc_handle_carveout(struct rproc *rproc,
 		goto free_carv;
 	}
 
-	dev_dbg(dev, "carveout va %p, dma %x, len 0x%x\n", va, dma, rsc->len);
+	dev_dbg(dev, "carveout va %p, dma %llx, len 0x%x\n", va,
+					(unsigned long long)dma, rsc->len);
 
 	/*
 	 * Ok, this is non-standard.
@@ -631,7 +632,8 @@ static int rproc_handle_carveout(struct rproc *rproc,
 		mapping->len = rsc->len;
 		list_add_tail(&mapping->node, &rproc->mappings);
 
-		dev_dbg(dev, "carveout mapped 0x%x to 0x%x\n", rsc->da, dma);
+		dev_dbg(dev, "carveout mapped 0x%x to 0x%llx\n",
+					rsc->da, (unsigned long long)dma);
 	}
 
 	/*
-- 
1.7.10.4

