Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965904Ab2B1RVs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 12:21:48 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:41420 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965155Ab2B1RVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 12:21:44 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of ohad@wizery.com designates 10.180.100.228 as permitted sender) smtp.mail=ohad@wizery.com
MIME-Version: 1.0
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Arnd Bergmann <arnd@arndb.de>, Mark Grosen <mgrosen@ti.com>,
        Suman Anna <s-anna@ti.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>, Rob Clark <rob@ti.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        Loic PALLARDY <loic.pallardy@stericsson.com>,
        Omar Ramirez Luna <omar.ramirez@ti.com>
Subject: [PATCH 3/5] rpmsg: fix name service endpoint leak
Date: Tue, 28 Feb 2012 19:21:10 +0200
Message-Id: <1330449672-18191-5-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1330449672-18191-1-git-send-email-ohad@wizery.com>
References: <1330449672-18191-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The name service endpoint wasn't destroyed, so fix it.

This is achieved by introducing an internal __rpmsg_destroy_ept
function which doesn't assume the given ept is bound to an rpmsg
channel (much like the existing __rpmsg_create_ept).

This is needed because the name service ept belongs to the rpmsg bus,
and is never bound with a specific rpdev.

Reported-by: Omar Ramirez Luna <omar.ramirez@ti.com>
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Grosen <mgrosen@ti.com>
Cc: Suman Anna <s-anna@ti.com>
Cc: Fernando Guzman Lugo <fernando.lugo@ti.com>
Cc: Rob Clark <rob@ti.com>
Cc: Ludovic BARRE <ludovic.barre@stericsson.com>
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>
Cc: Omar Ramirez Luna <omar.ramirez@ti.com>
---
 drivers/rpmsg/virtio_rpmsg_bus.c |   29 +++++++++++++++++++++++------
 1 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
index 8980ac2..4db9cf8 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -290,22 +290,36 @@ struct rpmsg_endpoint *rpmsg_create_ept(struct rpmsg_channel *rpdev,
 EXPORT_SYMBOL(rpmsg_create_ept);
 
 /**
- * rpmsg_destroy_ept() - destroy an existing rpmsg endpoint
+ * __rpmsg_destroy_ept() - destroy an existing rpmsg endpoint
+ * @vrp: virtproc which owns this ept
  * @ept: endpoing to destroy
  *
- * Should be used by drivers to destroy an rpmsg endpoint previously
- * created with rpmsg_create_ept().
+ * An internal function which destroy an ept without assuming it is
+ * bound to an rpmsg channel. This is needed for handling the internal
+ * name service endpoint, which isn't bound to an rpmsg channel.
+ * See also __rpmsg_create_ept().
  */
-void rpmsg_destroy_ept(struct rpmsg_endpoint *ept)
+static void
+__rpmsg_destroy_ept(struct virtproc_info *vrp, struct rpmsg_endpoint *ept)
 {
-	struct virtproc_info *vrp = ept->rpdev->vrp;
-
 	mutex_lock(&vrp->endpoints_lock);
 	idr_remove(&vrp->endpoints, ept->addr);
 	mutex_unlock(&vrp->endpoints_lock);
 
 	kfree(ept);
 }
+
+/**
+ * rpmsg_destroy_ept() - destroy an existing rpmsg endpoint
+ * @ept: endpoing to destroy
+ *
+ * Should be used by drivers to destroy an rpmsg endpoint previously
+ * created with rpmsg_create_ept().
+ */
+void rpmsg_destroy_ept(struct rpmsg_endpoint *ept)
+{
+	__rpmsg_destroy_ept(ept->rpdev->vrp, ept);
+}
 EXPORT_SYMBOL(rpmsg_destroy_ept);
 
 /*
@@ -964,6 +978,9 @@ static void __devexit rpmsg_remove(struct virtio_device *vdev)
 	if (ret)
 		dev_warn(&vdev->dev, "can't remove rpmsg device: %d\n", ret);
 
+	if (vrp->ns_ept)
+		__rpmsg_destroy_ept(vrp, vrp->ns_ept);
+
 	idr_remove_all(&vrp->endpoints);
 	idr_destroy(&vrp->endpoints);
 
-- 
1.7.5.4

