Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759725Ab2FGGBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 02:01:32 -0400
Received: from mail-qa0-f74.google.com ([209.85.216.74]:60536 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab2FGGBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 02:01:31 -0400
From: Ben Chan <benchan@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ben Chan <benchan@chromium.org>, Sage Ahn <syahn@gctsemi.com>
Subject: [PATCH] staging: gdm72xx: Fix spinlock recursion on gdm_usb_send_complete
Date: Wed,  6 Jun 2012 23:01:26 -0700
Message-Id: <1339048886-11956-1-git-send-email-benchan@chromium.org>
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
 drivers/staging/gdm72xx/gdm_usb.c |   24 ++++++++++++++++++------
 1 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_usb.c b/drivers/staging/gdm72xx/gdm_usb.c
index 1e9dc0d..a362e0c 100644
--- a/drivers/staging/gdm72xx/gdm_usb.c
+++ b/drivers/staging/gdm72xx/gdm_usb.c
@@ -270,7 +270,7 @@ static void release_usb(struct usbwm_dev *udev)
 	}
 }
 
-static void gdm_usb_send_complete(struct urb *urb)
+static void gdm_usb_send_complete_impl(struct urb *urb, bool need_lock)
 {
 	struct usb_tx *t = urb->context;
 	struct tx_cxt *tx = t->tx_cxt;
@@ -282,7 +282,8 @@ static void gdm_usb_send_complete(struct urb *urb)
 	if (urb->status == -ECONNRESET)
 		return;
 
-	spin_lock_irqsave(&tx->lock, flags);
+	if (need_lock)
+		spin_lock_irqsave(&tx->lock, flags);
 
 	if (t->callback)
 		t->callback(t->cb_data);
@@ -296,7 +297,18 @@ static void gdm_usb_send_complete(struct urb *urb)
 	else
 		free_tx_struct(t);
 
-	spin_unlock_irqrestore(&tx->lock, flags);
+	if (need_lock)
+		spin_unlock_irqrestore(&tx->lock, flags);
+}
+
+static void gdm_usb_send_complete(struct urb *urb)
+{
+	gdm_usb_send_complete_impl(urb, true);
+}
+
+static void gdm_usb_send_complete_no_lock(struct urb *urb)
+{
+	gdm_usb_send_complete_impl(urb, false);
 }
 
 static int gdm_usb_send(void *priv_dev, void *data, int len,
@@ -411,7 +423,7 @@ out:
 
 send_fail:
 	t->callback = NULL;
-	gdm_usb_send_complete(t->urb);
+	gdm_usb_send_complete_no_lock(t->urb);
 	spin_unlock_irqrestore(&tx->lock, flags);
 	return ret;
 }
@@ -540,7 +552,7 @@ static void do_pm_control(struct work_struct *work)
 
 			if (ret) {
 				t->callback = NULL;
-				gdm_usb_send_complete(t->urb);
+				gdm_usb_send_complete_no_lock(t->urb);
 			}
 		}
 	}
@@ -742,7 +754,7 @@ static int k_mode_thread(void *arg)
 
 				if (ret) {
 					t->callback = NULL;
-					gdm_usb_send_complete(t->urb);
+					gdm_usb_send_complete_no_lock(t->urb);
 				}
 			}
 
-- 
1.7.7.3

