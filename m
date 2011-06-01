Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760016Ab1FAV2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 17:28:19 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57935 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516Ab1FAV2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 17:28:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=VbAp4OVndG43nz31EPGeAR7htBRh5ZJBSsAOoJ0nuR2GSKfsBSi2zdyASXSW+LPwQL
         Q/IXmLtmH2jGnAs+Zc6B2TzJqNLkcVktLxbVevvOyywx6g2fIqX3xWD/6C51QCPiKy7v
         ynmjwffjKSaokMyUKoVkNt5riU4xKq7yiIbps=
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>
Subject: [PATCH 2/2] xhci: Do not issue device reset when device is not setup
Date: Wed,  1 Jun 2011 23:27:50 +0200
Message-Id: <1306963670-6344-2-git-send-email-m.b.lankhorst@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1306963670-6344-1-git-send-email-m.b.lankhorst@gmail.com>
References: <1306963670-6344-1-git-send-email-m.b.lankhorst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xhci controllers respond to this by returning an error. Instead of
issuing a command that will fail, just return.

This fixes the xhci driver not working on asrock P67 Pro/Extreme boards.

Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>
---
 drivers/usb/host/xhci.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index d9660eb..a1f32186 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -2467,6 +2467,7 @@ int xhci_discover_or_reset_device(struct usb_hcd *hcd, struct usb_device *udev)
 	struct xhci_command *reset_device_cmd;
 	int timeleft;
 	int last_freed_endpoint;
+	struct xhci_slot_ctx *slot_ctx;
 
 	ret = xhci_check_args(hcd, udev, NULL, 0, false, __func__);
 	if (ret <= 0)
@@ -2499,6 +2500,12 @@ int xhci_discover_or_reset_device(struct usb_hcd *hcd, struct usb_device *udev)
 			return -EINVAL;
 	}
 
+	/* If device is not setup, there is no point in resetting it */
+	slot_ctx = xhci_get_slot_ctx(xhci, virt_dev->out_ctx);
+	if (GET_SLOT_STATE(le32_to_cpu(slot_ctx->dev_state)) ==
+						SLOT_STATE_DISABLED)
+		return 0;
+
 	xhci_dbg(xhci, "Resetting device with slot ID %u\n", slot_id);
 	/* Allocate the command structure that holds the struct completion.
 	 * Assume we're in process context, since the normal device reset
-- 
1.7.4.1

