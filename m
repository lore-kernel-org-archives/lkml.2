Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab2LNQHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 11:07:47 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:41958 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756724Ab2LNQHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 11:07:43 -0500
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur@brendeland.net>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [RFCv2 07/11] remoteproc: Register virtio devices after vring allocation
Date: Fri, 14 Dec 2012 17:06:56 +0100
Message-Id: <1355501220-4572-8-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355501220-4572-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1355501220-4572-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Postpone the registration of virtio devices until all
vritio ring resource has been allocated.
This fixes the following bug: The driver's start callback
is called before all vring notify ids are allocated and
max_notifyid will be increased after starting the remoteproc.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/remoteproc/remoteproc_core.c |   26 ++++++++++++++++++++++++++
 include/linux/remoteproc.h           |    2 ++
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 2c78ea5..8a7de5c 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -367,6 +367,8 @@ static int rproc_handle_vdev(struct rproc *rproc, struct fw_rsc_vdev *rsc,
 	/* remember the device features */
 	rvdev->dfeatures = rsc->dfeatures;
 
+	/* remember the device resource entry number */
+	rvdev->rsc_seqno = seqno;
 	/* remember the resource entry */
 	rvdev->rsc = rsc;
 
@@ -384,6 +386,20 @@ free_rvdev:
 	return ret;
 }
 
+static int rproc_register_vdev(struct rproc *rproc, struct fw_rsc_vdev *rsc,
+							int avail, int seqno)
+{
+	struct rproc_vdev *rvdev, *rvtmp;
+
+	dev_dbg(&rproc->dev, "register device %s\n", rproc->name);
+
+	list_for_each_entry_safe(rvdev, rvtmp, &rproc->rvdevs, node)
+		if (seqno == rvdev->rsc_seqno)
+			return rproc_add_virtio_dev(rvdev, rsc->id);
+
+	return -ENODEV;
+}
+
 /**
  * rproc_handle_trace() - handle a shared trace buffer resource
  * @rproc: the remote processor
@@ -692,6 +708,10 @@ static rproc_handle_resource_t rproc_handle_rsc[RSC_LAST] = {
 	[RSC_VDEV] = (rproc_handle_resource_t)rproc_handle_vdev,
 };
 
+static rproc_handle_resource_t rproc_handle_reg[RSC_LAST] = {
+	[RSC_VDEV] = (rproc_handle_resource_t)rproc_register_vdev,
+};
+
 /* handle firmware resource entries */
 static int
 rproc_handle_resource(struct rproc *rproc, struct resource_table *table,
@@ -834,6 +854,12 @@ static void rproc_fw_load(const struct firmware *fw, void *context)
 		goto clean_up;
 	}
 
+	ret = rproc_handle_resource(rproc, table, tablesz, rproc_handle_reg);
+	if (ret) {
+		dev_err(dev, "Failed to process resources: %d\n", ret);
+		goto clean_up;
+	}
+
 	rproc->state = RPROC_LOADED;
 
 	dev_info(dev, "remote processor %s is loaded to memory\n", rproc->name);
diff --git a/include/linux/remoteproc.h b/include/linux/remoteproc.h
index 932edc7..60a1002 100644
--- a/include/linux/remoteproc.h
+++ b/include/linux/remoteproc.h
@@ -465,6 +465,7 @@ struct rproc_vring {
  * @vring: the vrings for this vdev
  * @dfeatures: virtio device features
  * @gfeatures: virtio guest features
+ * @rsc_seqno: sequence number in resource table
  * @rsc: vdev resource entry
  */
 struct rproc_vdev {
@@ -474,6 +475,7 @@ struct rproc_vdev {
 	struct rproc_vring vring[RVDEV_NUM_VRINGS];
 	unsigned long dfeatures;
 	unsigned long gfeatures;
+	u32 rsc_seqno;
 	struct fw_rsc_vdev *rsc;
 };
 
-- 
1.7.5.4

