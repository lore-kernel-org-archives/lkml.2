Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab2FLRk6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 13:40:58 -0400
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:55810 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751729Ab2FLRk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 13:40:57 -0400
From: Ben Chan <benchan@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ben Chan <benchan@chromium.org>, Sage Ahn <syahn@gctsemi.com>
Subject: [PATCH v2] staging: gdm72xx: Fix spinlock recursion on gdm_usb_send_complete
Date: Tue, 12 Jun 2012 10:40:52 -0700
Message-Id: <1339522852-28066-1-git-send-email-benchan@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a spinlock recursion bug on several call sites of
gdm_usb_send_complete by not calling spin_lock_irqsave on
urb->context->tx_cxt->lock when the lock has already been acquired.

Signed-off-by: Ben Chan <benchan@chromium.org>
Cc: Sage Ahn <syahn@gctsemi.com>
---
This revised patch simplifies the previous patch.

 drivers/staging/gdm72xx/gdm_usb.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_usb.c b/drivers/staging/gdm72xx/gdm_usb.c
index 1e9dc0d..a5313fc 100644
--- a/drivers/staging/gdm72xx/gdm_usb.c
+++ b/drivers/staging/gdm72xx/gdm_usb.c
@@ -270,20 +270,17 @@ static void release_usb(struct usbwm_dev *udev)
 	}
 }
 
-static void gdm_usb_send_complete(struct urb *urb)
+static void __gdm_usb_send_complete(struct urb *urb)
 {
 	struct usb_tx *t = urb->context;
 	struct tx_cxt *tx = t->tx_cxt;
 	u8 *pkt = t->buf;
 	u16 cmd_evt;
-	unsigned long flags;
 
 	/* Completion by usb_unlink_urb */
 	if (urb->status == -ECONNRESET)
 		return;
 
-	spin_lock_irqsave(&tx->lock, flags);
-
 	if (t->callback)
 		t->callback(t->cb_data);
 
@@ -295,7 +292,16 @@ static void gdm_usb_send_complete(struct urb *urb)
 		put_tx_struct(tx, t);
 	else
 		free_tx_struct(t);
+}
+
+static void gdm_usb_send_complete(struct urb *urb)
+{
+	struct usb_tx *t = urb->context;
+	struct tx_cxt *tx = t->tx_cxt;
+	unsigned long flags;
 
+	spin_lock_irqsave(&tx->lock, flags);
+	__gdm_usb_send_complete(urb);
 	spin_unlock_irqrestore(&tx->lock, flags);
 }
 
@@ -411,7 +417,7 @@ out:
 
 send_fail:
 	t->callback = NULL;
-	gdm_usb_send_complete(t->urb);
+	__gdm_usb_send_complete(t->urb);
 	spin_unlock_irqrestore(&tx->lock, flags);
 	return ret;
 }
@@ -540,7 +546,7 @@ static void do_pm_control(struct work_struct *work)
 
 			if (ret) {
 				t->callback = NULL;
-				gdm_usb_send_complete(t->urb);
+				__gdm_usb_send_complete(t->urb);
 			}
 		}
 	}
@@ -742,7 +748,7 @@ static int k_mode_thread(void *arg)
 
 				if (ret) {
 					t->callback = NULL;
-					gdm_usb_send_complete(t->urb);
+					__gdm_usb_send_complete(t->urb);
 				}
 			}
 
-- 
1.7.7.3

