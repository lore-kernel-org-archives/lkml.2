Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530Ab2JWUEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:04:20 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:61542 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933417Ab2JWT7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 15:59:02 -0400
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>
Cc: Julia.Lawall@lip6.fr, kernel-janitors@vger.kernel.org,
        Ezequiel Garcia <elezegarcia@gmail.com>,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 11/23] au0828: Replace memcpy with struct assignment
Date: Tue, 23 Oct 2012 16:57:14 -0300
Message-Id: <1351022246-8201-11-git-send-email-elezegarcia@gmail.com>
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
 drivers/media/usb/au0828/au0828-cards.c |    2 +-
 drivers/media/usb/au0828/au0828-i2c.c   |    9 +++------
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-cards.c b/drivers/media/usb/au0828/au0828-cards.c
index 448361c..8830d6d 100644
--- a/drivers/media/usb/au0828/au0828-cards.c
+++ b/drivers/media/usb/au0828/au0828-cards.c
@@ -192,7 +192,7 @@ void au0828_card_setup(struct au0828_dev *dev)
 
 	dprintk(1, "%s()\n", __func__);
 
-	memcpy(&dev->board, &au0828_boards[dev->boardnr], sizeof(dev->board));
+	dev->board = au0828_boards[dev->boardnr];
 
 	if (dev->i2c_rc == 0) {
 		dev->i2c_client.addr = 0xa0 >> 1;
diff --git a/drivers/media/usb/au0828/au0828-i2c.c b/drivers/media/usb/au0828/au0828-i2c.c
index 4ded17f..71fbe59 100644
--- a/drivers/media/usb/au0828/au0828-i2c.c
+++ b/drivers/media/usb/au0828/au0828-i2c.c
@@ -364,12 +364,9 @@ int au0828_i2c_register(struct au0828_dev *dev)
 {
 	dprintk(1, "%s()\n", __func__);
 
-	memcpy(&dev->i2c_adap, &au0828_i2c_adap_template,
-	       sizeof(dev->i2c_adap));
-	memcpy(&dev->i2c_algo, &au0828_i2c_algo_template,
-	       sizeof(dev->i2c_algo));
-	memcpy(&dev->i2c_client, &au0828_i2c_client_template,
-	       sizeof(dev->i2c_client));
+	dev->i2c_adap = au0828_i2c_adap_template;
+	dev->i2c_algo = au0828_i2c_algo_template;
+	dev->i2c_client = au0828_i2c_client_template;
 
 	dev->i2c_adap.dev.parent = &dev->usbdev->dev;
 
-- 
1.7.4.4

