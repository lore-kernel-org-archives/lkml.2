Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab3ACQyE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 11:54:04 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:50921 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab3ACQyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 11:54:00 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] dib0700: do not lock interruptible on tear-down paths
Date: Thu,  3 Jan 2013 17:53:53 +0100
Message-Id: <1357232033-7152-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When mutex_lock_interruptible is used on paths where a signal can be
pending, the device is not closed properly and cannot be reused.

This usually happens when you start tzap for example and send it a
TERM signal. The signal is pending while tear-down routines are
called. Hence streaming is not properly stopped in that case. And
the device stops working from that moment on.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/media/usb/dvb-usb/dib0700_core.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dib0700_core.c b/drivers/media/usb/dvb-usb/dib0700_core.c
index 19b5ed2..bf2a908 100644
--- a/drivers/media/usb/dvb-usb/dib0700_core.c
+++ b/drivers/media/usb/dvb-usb/dib0700_core.c
@@ -561,10 +561,7 @@ int dib0700_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 		}
 	}
 
-	if (mutex_lock_interruptible(&adap->dev->usb_mutex) < 0) {
-		err("could not acquire lock");
-		return -EINTR;
-	}
+	mutex_lock(&adap->dev->usb_mutex);
 
 	st->buf[0] = REQUEST_ENABLE_VIDEO;
 	/* this bit gives a kind of command,
-- 
1.8.1


