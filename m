Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965920Ab2B1RVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 12:21:52 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52683 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965899Ab2B1RVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 12:21:48 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of ohad@wizery.com designates 10.216.82.141 as permitted sender) smtp.mail=ohad@wizery.com
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
        Omar Ramirez Luna <omar.luna@linaro.org>
Subject: [PATCH 4/5] rpmsg: validate incoming message length before propagating
Date: Tue, 28 Feb 2012 19:21:11 +0200
Message-Id: <1330449672-18191-6-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1330449672-18191-1-git-send-email-ohad@wizery.com>
References: <1330449672-18191-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When an inbound message arrives, validate its reported length before
propagating it, otherwise buggy (or malicious) remote processors might
trick us into accessing memory which we really shouldn't.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Grosen <mgrosen@ti.com>
Cc: Suman Anna <s-anna@ti.com>
Cc: Fernando Guzman Lugo <fernando.lugo@ti.com>
Cc: Rob Clark <rob@ti.com>
Cc: Ludovic BARRE <ludovic.barre@stericsson.com>
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>
Cc: Omar Ramirez Luna <omar.luna@linaro.org>
---
 drivers/rpmsg/virtio_rpmsg_bus.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
index 4db9cf8..1e8b8b6 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -778,6 +778,16 @@ static void rpmsg_recv_done(struct virtqueue *rvq)
 	print_hex_dump(KERN_DEBUG, "rpmsg_virtio RX: ", DUMP_PREFIX_NONE, 16, 1,
 					msg, sizeof(*msg) + msg->len, true);
 
+	/*
+	 * We currently use fixed-sized buffers, so trivially sanitize
+	 * the reported payload length.
+	 */
+	if (len > RPMSG_BUF_SIZE ||
+		msg->len > (len - sizeof(struct rpmsg_hdr))) {
+		dev_warn(dev, "inbound msg too big: (%d, %d)\n", len, msg->len);
+		return;
+	}
+
 	/* use the dst addr to fetch the callback of the appropriate user */
 	mutex_lock(&vrp->endpoints_lock);
 	ept = idr_find(&vrp->endpoints, msg->dst);
-- 
1.7.5.4

