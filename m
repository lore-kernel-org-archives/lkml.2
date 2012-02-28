Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965911Ab2B1RV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 12:21:57 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:53787 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965912Ab2B1RVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 12:21:52 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of ohad@wizery.com designates 10.180.83.70 as permitted sender) smtp.mail=ohad@wizery.com
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
Subject: [PATCH 5/5] rpmsg: fix published buffer length in rpmsg_recv_done
Date: Tue, 28 Feb 2012 19:21:12 +0200
Message-Id: <1330449672-18191-7-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1330449672-18191-1-git-send-email-ohad@wizery.com>
References: <1330449672-18191-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After processing an incoming message, always publish the real size
of its containing buffer when putting it back on the available rx ring.

Using any different value might erroneously limit the remote processor
(leading it to think the buffer is smaller than it really is).

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
 drivers/rpmsg/virtio_rpmsg_bus.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
index 1e8b8b6..f93ca3b 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -798,7 +798,8 @@ static void rpmsg_recv_done(struct virtqueue *rvq)
 	else
 		dev_warn(dev, "msg received with no recepient\n");
 
-	sg_init_one(&sg, msg, sizeof(*msg) + len);
+	/* publish the real size of the buffer */
+	sg_init_one(&sg, msg, RPMSG_BUF_SIZE);
 
 	/* add the buffer back to the remote processor's virtqueue */
 	err = virtqueue_add_buf(vrp->rvq, &sg, 0, 1, msg, GFP_KERNEL);
-- 
1.7.5.4

