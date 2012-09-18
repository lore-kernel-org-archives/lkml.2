Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab2IRSdp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 14:33:45 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:34765 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751470Ab2IRSdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 14:33:43 -0400
From: sjur.brandeland@stericsson.com
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PATCHv3] remtoteproc: Export notification id range
Date: Tue, 18 Sep 2012 20:32:45 +0200
Message-Id: <1347993165-4394-1-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
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

Changes since v2:
Use idr_for_each() instead of nested loops.

 drivers/remoteproc/remoteproc_core.c |   15 +++++++++++++++
 include/linux/remoteproc.h           |    2 ++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index d5c2dbf..b368797 100644
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
 
@@ -256,13 +259,25 @@ rproc_parse_vring(struct rproc_vdev *rvdev, struct fw_rsc_vdev *rsc, int i)
 	return 0;
 }
 
+static int rproc_max_notifyid(int id, void *p, void *data)
+{
+	int *maxid = data;
+	*maxid = max(*maxid, id);
+	return 0;
+}
+
 void rproc_free_vring(struct rproc_vring *rvring)
 {
+	int maxid = 0;
 	int size = PAGE_ALIGN(vring_size(rvring->len, rvring->align));
 	struct rproc *rproc = rvring->rvdev->rproc;
 
 	dma_free_coherent(rproc->dev.parent, size, rvring->va, rvring->dma);
 	idr_remove(&rproc->notifyids, rvring->notifyid);
+
+	/* Find the largest remaining ID*/
+	idr_for_each(&rproc->notifyids, rproc_max_notifyid, &maxid);
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
1.7.5.4

