Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620Ab2CAIMw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 03:12:52 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:36719 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758606Ab2CAIMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 03:12:49 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of ohad@wizery.com designates 10.216.133.151 as permitted sender) smtp.mail=ohad@wizery.com
MIME-Version: 1.0
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Brian Swetland <swetland@google.com>,
        Iliyan Malchev <malchev@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rusty Russell <rusty@rustcorp.com.au>, Mark Grosen <mgrosen@ti.com>,
        John Williams <john.williams@petalogix.com>,
        Michal Simek <monstr@monstr.eu>,
        Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        Omar Ramirez Luna <omar.luna@linaro.org>,
        Guzman Lugo Fernando <fernando.lugo@ti.com>,
        Anna Suman <s-anna@ti.com>, Clark Rob <rob@ti.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Kieran Bingham <kieranbingham@gmail.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 6/7] remoteproc: remove the hardcoded vring alignment
Date: Thu,  1 Mar 2012 10:11:36 +0200
Message-Id: <1330589497-4139-7-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1330589497-4139-1-git-send-email-ohad@wizery.com>
References: <1330589497-4139-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the hardcoded vring alignment of 4096 bytes,
and instead utilize tha vring alignment as specified in
the resource table.

This is needed for remote processors that have rigid
memory requirement, and which have found the alignment of
4096 bytes to be excessively big.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Brian Swetland <swetland@google.com>
Cc: Iliyan Malchev <malchev@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mark Grosen <mgrosen@ti.com>
Cc: John Williams <john.williams@petalogix.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>
Cc: Ludovic BARRE <ludovic.barre@stericsson.com>
Cc: Omar Ramirez Luna <omar.luna@linaro.org>
Cc: Guzman Lugo Fernando <fernando.lugo@ti.com>
Cc: Anna Suman <s-anna@ti.com>
Cc: Clark Rob <rob@ti.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Saravana Kannan <skannan@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>
Cc: Kieran Bingham <kieranbingham@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>
---
 drivers/remoteproc/remoteproc_core.c   |   12 +++++++-----
 drivers/remoteproc/remoteproc_virtio.c |    2 +-
 include/linux/remoteproc.h             |    9 ++-------
 3 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index ca02f12..9be5dad 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -298,14 +298,15 @@ __rproc_handle_vring(struct rproc_vdev *rvdev, struct fw_rsc_vdev *rsc, int i)
 		return -EINVAL;
 	}
 
-	/* the firmware must provide the expected queue size */
-	if (!vring->num) {
-		dev_err(dev, "invalid qsz (%d)\n", vring->num);
+	/* verify queue size and vring alignment are sane */
+	if (!vring->num || !vring->align) {
+		dev_err(dev, "invalid qsz (%d) or alignment (%d)\n",
+						vring->num, vring->align);
 		return -EINVAL;
 	}
 
 	/* actual size of vring (in bytes) */
-	size = PAGE_ALIGN(vring_size(vring->num, AMP_VRING_ALIGN));
+	size = PAGE_ALIGN(vring_size(vring->num, vring->align));
 
 	if (!idr_pre_get(&rproc->notifyids, GFP_KERNEL)) {
 		dev_err(dev, "idr_pre_get failed\n");
@@ -340,6 +341,7 @@ __rproc_handle_vring(struct rproc_vdev *rvdev, struct fw_rsc_vdev *rsc, int i)
 					dma, size, notifyid);
 
 	rvdev->vring[i].len = vring->num;
+	rvdev->vring[i].align = vring->align;
 	rvdev->vring[i].va = va;
 	rvdev->vring[i].dma = dma;
 	rvdev->vring[i].notifyid = notifyid;
@@ -354,7 +356,7 @@ static void __rproc_free_vrings(struct rproc_vdev *rvdev, int i)
 
 	for (i--; i > 0; i--) {
 		struct rproc_vring *rvring = &rvdev->vring[i];
-		int size = PAGE_ALIGN(vring_size(rvring->len, AMP_VRING_ALIGN));
+		int size = PAGE_ALIGN(vring_size(rvring->len, rvring->align));
 
 		dma_free_coherent(rproc->dev, size, rvring->va, rvring->dma);
 		idr_remove(&rproc->notifyids, rvring->notifyid);
diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/remoteproc_virtio.c
index 0700410..ecf6121 100644
--- a/drivers/remoteproc/remoteproc_virtio.c
+++ b/drivers/remoteproc/remoteproc_virtio.c
@@ -99,7 +99,7 @@ static struct virtqueue *rp_find_vq(struct virtio_device *vdev,
 	 * Create the new vq, and tell virtio we're not interested in
 	 * the 'weak' smp barriers, since we're talking with a real device.
 	 */
-	vq = vring_new_virtqueue(len, AMP_VRING_ALIGN, vdev, false, addr,
+	vq = vring_new_virtqueue(len, rvring->align, vdev, false, addr,
 					rproc_virtio_notify, callback, name);
 	if (!vq) {
 		dev_err(rproc->dev, "vring_new_virtqueue %s failed\n", name);
diff --git a/include/linux/remoteproc.h b/include/linux/remoteproc.h
index 7750d8a..f1ffabb 100644
--- a/include/linux/remoteproc.h
+++ b/include/linux/remoteproc.h
@@ -43,13 +43,6 @@
 #include <linux/completion.h>
 #include <linux/idr.h>
 
-/*
- * The alignment between the consumer and producer parts of the vring.
- * Note: this is part of the "wire" protocol. If you change this, you need
- * to update your peers too.
- */
-#define AMP_VRING_ALIGN	(4096)
-
 /**
  * struct resource_table - firmware resource table header
  * @ver: version number
@@ -423,6 +416,7 @@ struct rproc {
  * @dma: dma address
  * @len: length, in bytes
  * @da: device address
+ * @align: vring alignment
  * @notifyid: rproc-specific unique vring index
  * @rvdev: remote vdev
  * @vq: the virtqueue of this vring
@@ -432,6 +426,7 @@ struct rproc_vring {
 	dma_addr_t dma;
 	int len;
 	u32 da;
+	u32 align;
 	int notifyid;
 	struct rproc_vdev *rvdev;
 	struct virtqueue *vq;
-- 
1.7.5.4

