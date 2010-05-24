Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837Ab0EXK56 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 06:57:58 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:53478 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755542Ab0EXK54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 06:57:56 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Wolfram Sang <w.sang@pengutronix.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Jiri Slaby <jslaby@suse.cz>, Dmitry Torokhov <dtor@mail.ru>,
       Devin Heitmueller <dheitmueller@kernellabs.com>,
       linux-media@vger.kernel.org
Subject: [PATCH 1/2] drivers/media/dvb/dvb-usb/dib0700: fix return values
Date: Mon, 24 May 2010 12:57:14 +0200
Message-Id: <1274698635-19512-1-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <AANLkTikffmoWofbIo2h6zw-VW5aKEH8T_b0vMfKdo3KJ@mail.gmail.com>
References: <AANLkTikffmoWofbIo2h6zw-VW5aKEH8T_b0vMfKdo3KJ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Propagte correct error values instead of returning -1 which just means
-EPERM ("Permission denied")

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/dvb/dvb-usb/dib0700_core.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dib0700_core.c b/drivers/media/dvb/dvb-usb/dib0700_core.c
index 4f961d2..d2dabac 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_core.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_core.c
@@ -640,10 +640,10 @@ int dib0700_rc_setup(struct dvb_usb_device *d)
 		return 0;
 
 	/* Set the IR mode */
-	i = dib0700_ctrl_wr(d, rc_setup, 3);
-	if (i<0) {
+	i = dib0700_ctrl_wr(d, rc_setup, sizeof(rc_setup));
+	if (i < 0) {
 		err("ir protocol setup failed");
-		return -1;
+		return i;
 	}
 
 	if (st->fw_version < 0x10200)
@@ -653,14 +653,14 @@ int dib0700_rc_setup(struct dvb_usb_device *d)
 	purb = usb_alloc_urb(0, GFP_KERNEL);
 	if (purb == NULL) {
 		err("rc usb alloc urb failed\n");
-		return -1;
+		return -ENOMEM;
 	}
 
 	purb->transfer_buffer = kzalloc(RC_MSG_SIZE_V1_20, GFP_KERNEL);
 	if (purb->transfer_buffer == NULL) {
 		err("rc kzalloc failed\n");
 		usb_free_urb(purb);
-		return -1;
+		return -ENOMEM;
 	}
 
 	purb->status = -EINPROGRESS;
@@ -669,12 +669,10 @@ int dib0700_rc_setup(struct dvb_usb_device *d)
 			  dib0700_rc_urb_completion, d);
 
 	ret = usb_submit_urb(purb, GFP_ATOMIC);
-	if (ret != 0) {
+	if (ret)
 		err("rc submit urb failed\n");
-		return -1;
-	}
 
-	return 0;
+	return ret;
 }
 
 static int dib0700_probe(struct usb_interface *intf,
-- 
1.7.1

