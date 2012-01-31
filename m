Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab2AaUm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 15:42:27 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:38254 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898Ab2AaUm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 15:42:26 -0500
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, Mark Grosen <mgrosen@ti.com>,
        Jack Stone <jwjstone@fastmail.fm>, Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v2 2/2] remoteproc: s/big switch/lookup table/
Date: Tue, 31 Jan 2012 22:41:59 +0200
Message-Id: <1328042519-21995-1-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A lookup table would be easier to extend, and the resulting
code is a bit cleaner.

Reported-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
v1->v2: C99 array initialization (thanks, Jack!)

 drivers/remoteproc/remoteproc_core.c |   45 +++++++++++++++++----------------
 include/linux/remoteproc.h           |    7 +++++
 2 files changed, 30 insertions(+), 22 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 567a3c5..729911b 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -64,6 +64,8 @@ static DEFINE_KLIST(rprocs, klist_rproc_get, klist_rproc_put);
 
 typedef int (*rproc_handle_resources_t)(struct rproc *rproc,
 				struct fw_resource *rsc, int len);
+typedef int (*rproc_handle_resource_t)(struct rproc *rproc,
+				struct fw_resource *rsc);
 
 /*
  * This is the IOMMU fault handler we register with the IOMMU API
@@ -658,44 +660,43 @@ free_mapping:
 	return ret;
 }
 
+/*
+ * A lookup table for resource handlers. The indices are defined in
+ * enum fw_resource_type.
+ */
+static rproc_handle_resource_t rproc_handle_rsc[] = {
+	[RSC_CARVEOUT] = rproc_handle_carveout,
+	[RSC_DEVMEM] = rproc_handle_devmem,
+	[RSC_TRACE] = rproc_handle_trace,
+	[RSC_VRING] = rproc_handle_vring,
+	[RSC_VIRTIO_DEV] = NULL, /* handled early upon registration */
+};
+
 /* handle firmware resource entries before booting the remote processor */
 static int
 rproc_handle_boot_rsc(struct rproc *rproc, struct fw_resource *rsc, int len)
 {
 	struct device *dev = rproc->dev;
+	rproc_handle_resource_t handler;
 	int ret = 0;
 
-	while (len >= sizeof(*rsc)) {
+	for (; len >= sizeof(*rsc); rsc++, len -= sizeof(*rsc)) {
 		dev_dbg(dev, "rsc: type %d, da 0x%llx, pa 0x%llx, len 0x%x, "
 			"id %d, name %s, flags %x\n", rsc->type, rsc->da,
 			rsc->pa, rsc->len, rsc->id, rsc->name, rsc->flags);
 
-		switch (rsc->type) {
-		case RSC_CARVEOUT:
-			ret = rproc_handle_carveout(rproc, rsc);
-			break;
-		case RSC_DEVMEM:
-			ret = rproc_handle_devmem(rproc, rsc);
-			break;
-		case RSC_TRACE:
-			ret = rproc_handle_trace(rproc, rsc);
-			break;
-		case RSC_VRING:
-			ret = rproc_handle_vring(rproc, rsc);
-			break;
-		case RSC_VIRTIO_DEV:
-			/* this one is handled early upon registration */
-			break;
-		default:
+		if (rsc->type >= RSC_LAST) {
 			dev_warn(dev, "unsupported resource %d\n", rsc->type);
-			break;
+			continue;
 		}
 
+		handler = rproc_handle_rsc[rsc->type];
+		if (!handler)
+			continue;
+
+		ret = handler(rproc, rsc);
 		if (ret)
 			break;
-
-		rsc++;
-		len -= sizeof(*rsc);
 	}
 
 	return ret;
diff --git a/include/linux/remoteproc.h b/include/linux/remoteproc.h
index b52f784..ada4cb0 100644
--- a/include/linux/remoteproc.h
+++ b/include/linux/remoteproc.h
@@ -103,6 +103,7 @@ struct fw_resource {
  *		    the virtio device features, 'pa' holds the virtio guest
  *		    features, 'len' holds the virtio status, and 'flags' holds
  *		    the virtio id (currently only VIRTIO_ID_RPMSG is supported).
+ * @RSC_LAST:       just keep this one at the end
  *
  * Most of the resource entries share the basic idea of address/length
  * negotiation with the host: the firmware usually asks (on behalf of the
@@ -115,6 +116,11 @@ struct fw_resource {
  * will contain the expected device addresses (today we actually only support
  * this scheme, as there aren't yet any use cases for dynamically allocated
  * device addresses).
+ *
+ * Please note that these values are used as indices to the rproc_handle_rsc
+ * lookup table, so please keep them sane. Moreover, @RSC_LAST is used to
+ * check the validity of an index before the lookup table is accessed, so
+ * please update it as needed.
  */
 enum fw_resource_type {
 	RSC_CARVEOUT	= 0,
@@ -122,6 +128,7 @@ enum fw_resource_type {
 	RSC_TRACE	= 2,
 	RSC_VRING	= 3,
 	RSC_VIRTIO_DEV	= 4,
+	RSC_LAST	= 5,
 };
 
 /**
-- 
1.7.5.4

