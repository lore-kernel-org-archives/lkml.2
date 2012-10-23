Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933345Ab2JWT6b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 15:58:31 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:62157 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757452Ab2JWT63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 15:58:29 -0400
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>
Cc: Julia.Lawall@lip6.fr, kernel-janitors@vger.kernel.org,
        Ezequiel Garcia <elezegarcia@gmail.com>,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 02/23] cx231xx: Replace memcpy with struct assignment
Date: Tue, 23 Oct 2012 16:57:05 -0300
Message-Id: <1351022246-8201-2-git-send-email-elezegarcia@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1351022246-8201-1-git-send-email-elezegarcia@gmail.com>
References: <1351022246-8201-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This kind of memcpy() is error-prone. Its replacement with a struct
assignment is prefered because it's type-safe and much easier to read.

Found by coccinelle. Hand patched and reviewed.
Tested by compilation only.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier struct_name;
struct struct_name to;
struct struct_name from;
expression E;
@@
-memcpy(&(to), &(from), E);
+to = from;
// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/usb/cx231xx/cx231xx-cards.c |    2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index b84ebc5..352d676 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -705,7 +705,7 @@ void cx231xx_sleep_s5h1432(struct cx231xx *dev)
 
 static inline void cx231xx_set_model(struct cx231xx *dev)
 {
-	memcpy(&dev->board, &cx231xx_boards[dev->model], sizeof(dev->board));
+	dev->board = cx231xx_boards[dev->model];
 }
 
 /* Since cx231xx_pre_card_setup() requires a proper dev->model,
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index fedf785..c5109ba 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -2627,8 +2627,7 @@ int cx231xx_register_analog_devices(struct cx231xx *dev)
 		     dev->name, video_device_node_name(dev->vdev));
 
 	/* Initialize VBI template */
-	memcpy(&cx231xx_vbi_template, &cx231xx_video_template,
-	       sizeof(cx231xx_vbi_template));
+	cx231xx_vbi_template = cx231xx_video_template;
 	strcpy(cx231xx_vbi_template.name, "cx231xx-vbi");
 
 	/* Allocate and fill vbi video_device struct */
-- 
1.7.4.4

