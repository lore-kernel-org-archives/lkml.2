Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab2FLSXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 14:23:37 -0400
Received: from mail-bk0-f74.google.com ([209.85.214.74]:34271 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab2FLSXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 14:23:36 -0400
From: Ben Chan <benchan@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ben Chan <benchan@chromium.org>, Sage Ahn <syahn@gctsemi.com>
Subject: [PATCH] staging: gdm72xx: Simplify spinlock fix for gdm_usb_send_complete
Date: Tue, 12 Jun 2012 11:23:32 -0700
Message-Id: <1339525412-20542-1-git-send-email-benchan@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch simplifies the previous patch (commit
dd13c86b0dae86efdde98119ffd7348e80719ade) for fixing the spinlock
recursion issue on several call sites of gdm_usb_send_complete.

Signed-off-by: Ben Chan <benchan@chromium.org>
Cc: Sage Ahn <syahn@gctsemi.com>
---
 drivers/staging/gdm72xx/gdm_usb.c |   26 ++++++++++----------------
 1 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_usb.c b/drivers/staging/gdm72xx/gdm_usb.c
index 646e0ac..89268c7 100644
--- a/drivers/staging/gdm72xx/gdm_usb.c
+++ b/drivers/staging/gdm72xx/gdm_usb.c
@@ -270,21 +270,17 @@ static void release_usb(struct usbwm_dev *udev)
 	}
 }
 
-static void gdm_usb_send_complete_impl(struct urb *urb, bool need_lock)
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
 
-	if (need_lock)
-		spin_lock_irqsave(&tx->lock, flags);
-
 	if (t->callback)
 		t->callback(t->cb_data);
 
@@ -296,19 +292,17 @@ static void gdm_usb_send_complete_impl(struct urb *urb, bool need_lock)
 		put_tx_struct(tx, t);
 	else
 		free_tx_struct(t);
-
-	if (need_lock)
-		spin_unlock_irqrestore(&tx->lock, flags);
 }
 
 static void gdm_usb_send_complete(struct urb *urb)
 {
-	gdm_usb_send_complete_impl(urb, true);
-}
+	struct usb_tx *t = urb->context;
+	struct tx_cxt *tx = t->tx_cxt;
+	unsigned long flags;
 
-static void gdm_usb_send_complete_no_lock(struct urb *urb)
-{
-	gdm_usb_send_complete_impl(urb, false);
+	spin_lock_irqsave(&tx->lock, flags);
+	__gdm_usb_send_complete(urb);
+	spin_unlock_irqrestore(&tx->lock, flags);
 }
 
 static int gdm_usb_send(void *priv_dev, void *data, int len,
@@ -423,7 +417,7 @@ out:
 
 send_fail:
 	t->callback = NULL;
-	gdm_usb_send_complete_no_lock(t->urb);
+	__gdm_usb_send_complete(t->urb);
 	spin_unlock_irqrestore(&tx->lock, flags);
 	return ret;
 }
@@ -552,7 +546,7 @@ static void do_pm_control(struct work_struct *work)
 
 			if (ret) {
 				t->callback = NULL;
-				gdm_usb_send_complete_no_lock(t->urb);
+				__gdm_usb_send_complete(t->urb);
 			}
 		}
 	}
@@ -754,7 +748,7 @@ static int k_mode_thread(void *arg)
 
 				if (ret) {
 					t->callback = NULL;
-					gdm_usb_send_complete_no_lock(t->urb);
+					__gdm_usb_send_complete(t->urb);
 				}
 			}
 
-- 
1.7.7.3

