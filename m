Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab1IPV02 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 17:26:28 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:38062 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755982Ab1IPV01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 17:26:27 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH] [media] hdpvr: fix null pointer dereference on error path in hdpvr_probe()
Date: Sat, 17 Sep 2011 01:26:14 +0400
Message-Id: <1316208374-4923-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev->free_buff_list and dev->rec_buff_list are zero initialized after
kzalloc of dev. If something goes wrong before INIT_LIST_HEAD for them,
goto error leads to call hdpvr_delete() and then to hdpvr_free_buffers(),
where the lists are dereferenced.

The patch moves INIT_LIST_HEAD before the first possible fail.

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/media/video/hdpvr/hdpvr-core.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/hdpvr/hdpvr-core.c b/drivers/media/video/hdpvr/hdpvr-core.c
index 441dacf..fe0a088 100644
--- a/drivers/media/video/hdpvr/hdpvr-core.c
+++ b/drivers/media/video/hdpvr/hdpvr-core.c
@@ -295,6 +295,10 @@ static int hdpvr_probe(struct usb_interface *interface,
 		goto error;
 	}
 
+	/* init video transfer queues */
+	INIT_LIST_HEAD(&dev->free_buff_list);
+	INIT_LIST_HEAD(&dev->rec_buff_list);
+
 	dev->workqueue = 0;
 
 	/* register v4l2_device early so it can be used for printks */
@@ -319,10 +323,6 @@ static int hdpvr_probe(struct usb_interface *interface,
 	if (!dev->workqueue)
 		goto error;
 
-	/* init video transfer queues */
-	INIT_LIST_HEAD(&dev->free_buff_list);
-	INIT_LIST_HEAD(&dev->rec_buff_list);
-
 	dev->options = hdpvr_default_options;
 
 	if (default_video_input < HDPVR_VIDEO_INPUTS)
-- 
1.7.4.1

