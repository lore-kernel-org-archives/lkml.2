Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758692Ab2IMSEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 14:04:16 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:43705 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165Ab2IMSEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 14:04:12 -0400
From: sjur.brandeland@stericsson.com
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Subject: [PATCHv2] remoteproc: Export notification id range
Date: Thu, 13 Sep 2012 20:03:59 +0200
Message-Id: <1347559440-6668-2-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347559440-6668-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1347559440-6668-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Some of the rproc drivers needs to know the range
of the notification IDs used for notifying the device.
Export a variable in struct rproc holding the
largest allocated notification id.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
cc: Linus Walleij <linus.walleij@linaro.org>
cc: linux-kernel@vger.kernel.org

>For completeness, I think we probably also want to update max_notifyid
>when a notifyid is removed (i.e. on rproc_free_vring).

I've added a scan through the vrings to find the new max_notifyid after
removing a notifyid.

Thanks,
Sjur

 drivers/remoteproc/remoteproc_core.c |   13 +++++++++++++
 include/linux/remoteproc.h           |    2 ++
 2 files changed, 15 insertions(+)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index d5c2dbf..741242d 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -215,6 +215,9 @@ int rproc_alloc_vring(struct rproc_vdev *rvdev, int i)
 		return ret;
 	}
 
+	/* Store largest notifyid */
+	rproc->max_notifyid = max(rproc->max_notifyid, notifyid);
+
 	dev_dbg(dev, "vring%d: va %p dma %x size %x idr %d\n", i, va,
 					dma, size, notifyid);
 
@@ -258,11 +261,21 @@ rproc_parse_vring(struct rproc_vdev *rvdev, struct fw_rsc_vdev *rsc, int i)
 
 void rproc_free_vring(struct rproc_vring *rvring)
 {
+	int i, maxid = 0;
+	struct rproc_vdev *rvdev, *tmp;
 	int size = PAGE_ALIGN(vring_size(rvring->len, rvring->align));
 	struct rproc *rproc = rvring->rvdev->rproc;
 
 	dma_free_coherent(rproc->dev.parent, size, rvring->va, rvring->dma);
 	idr_remove(&rproc->notifyids, rvring->notifyid);
+
+	/* Iterate over the new set of rings to find the largest id */
+	rvring->notifyid = 0;
+	list_for_each_entry_safe(rvdev, tmp, &rproc->rvdevs, node)
+		for (i = 0; i < RVDEV_NUM_VRINGS; i++)
+			maxid = max(maxid, rvdev->vring[i].notifyid);
+
+	rproc->max_notifyid = maxid;
 }
 
 /**
diff --git a/include/linux/remoteproc.h b/include/linux/remoteproc.h
index 131b539..c37e359 100644
--- a/include/linux/remoteproc.h
+++ b/include/linux/remoteproc.h
@@ -382,6 +382,7 @@ enum rproc_state {
  * @bootaddr: address of first instruction to boot rproc with (optional)
  * @rvdevs: list of remote virtio devices
  * @notifyids: idr for dynamically assigning rproc-wide unique notify ids
+ * @max_notifyid: Largest allocated notify id.
  * @index: index of this rproc device
  */
 struct rproc {
@@ -406,6 +407,7 @@ struct rproc {
 	struct list_head rvdevs;
 	struct idr notifyids;
 	int index;
+	int max_notifyid;
 };
 
 /* we currently support only two vrings per rvdev */
-- 
1.7.9.5

