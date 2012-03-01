Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588Ab2CAIMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 03:12:42 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:43029 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757887Ab2CAIMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 03:12:38 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of ohad@wizery.com designates 10.180.82.227 as permitted sender) smtp.mail=ohad@wizery.com
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
Subject: [PATCH 3/7] remoteproc: safer boot/shutdown order
Date: Thu,  1 Mar 2012 10:11:33 +0200
Message-Id: <1330589497-4139-4-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1330589497-4139-1-git-send-email-ohad@wizery.com>
References: <1330589497-4139-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boot the remote processor only after setting up the virtqueues,
and shut it down before deleting them.

Remote processors should obey virtio status changes, and
therefore not manipulate/trigger the virtqueues while the virtio
driver isn't ready, but it's just safer not to rely on that
(plus a vq access might already be inflight while a vdev
status is changed).

We also don't have yet status change notifications, but that's
a temporary limitation.

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
 drivers/remoteproc/remoteproc_virtio.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/remoteproc_virtio.c
index 4f73e81..78d8527 100644
--- a/drivers/remoteproc/remoteproc_virtio.c
+++ b/drivers/remoteproc/remoteproc_virtio.c
@@ -123,14 +123,14 @@ static void rproc_virtio_del_vqs(struct virtio_device *vdev)
 	struct virtqueue *vq, *n;
 	struct rproc *rproc = vdev_to_rproc(vdev);
 
+	/* power down the remote processor before deleting vqs */
+	rproc_shutdown(rproc);
+
 	list_for_each_entry_safe(vq, n, &vdev->vqs, list) {
 		struct rproc_virtio_vq_info *rpvq = vq->priv;
 		vring_del_virtqueue(vq);
 		kfree(rpvq);
 	}
-
-	/* power down the remote processor */
-	rproc_shutdown(rproc);
 }
 
 static int rproc_virtio_find_vqs(struct virtio_device *vdev, unsigned nvqs,
@@ -145,13 +145,6 @@ static int rproc_virtio_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 	if (nvqs != 2)
 		return -EINVAL;
 
-	/* boot the remote processor */
-	ret = rproc_boot(rproc);
-	if (ret) {
-		dev_err(rproc->dev, "rproc_boot() failed %d\n", ret);
-		goto error;
-	}
-
 	for (i = 0; i < nvqs; ++i) {
 		vqs[i] = rp_find_vq(vdev, i, callbacks[i], names[i]);
 		if (IS_ERR(vqs[i])) {
@@ -160,6 +153,13 @@ static int rproc_virtio_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 		}
 	}
 
+	/* now that the vqs are all set, boot the remote processor */
+	ret = rproc_boot(rproc);
+	if (ret) {
+		dev_err(rproc->dev, "rproc_boot() failed %d\n", ret);
+		goto error;
+	}
+
 	return 0;
 
 error:
-- 
1.7.5.4

