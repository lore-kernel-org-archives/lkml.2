Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263Ab2AWF6M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 00:58:12 -0500
Received: from home.keithp.com ([63.227.221.253]:44084 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995Ab2AWF6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 00:58:11 -0500
From: Keith Packard <keithp@keithp.com>
To: linux-kernel@vger.kernel.org
Cc: Keith Packard <keithp@keithp.com>, linux-usb@vger.kernel.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH] Regression: Revert "Bluetooth: use buffer priority to mark URB_ISO_ASAP flag"
Date: Sun, 22 Jan 2012 21:58:01 -0800
Message-Id: <1327298281-2502-1-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit b8aabfc92249b239c425da7e4ca85b7e4855e984.

URB_ISO_ASAP may only be used with iso end points, but this patch was
attempting to use it with a bulk endpoint. When DEBUG is defined in
the USB stack, it checks for invalid flags and returns -EINVAL instead
of actually transmitting the data.

Signed-off-by: Keith Packard <keithp@keithp.com>
---

Ok, so this is a comedy of errors. The Bluetooth code is trying to use
an iso-specific flag (URB_ISO_ASAP) on a bulk endpoint, which is
invalid, but normally harmless. Unless the USB code is compiled for
debugging, in which case it checks a bunch for incorrect usage and
discards URBs which are wrong.

As far as I'm concerned, #ifdef DEBUG code should never ever change
the behaviour of the code, and so I'd say the USB code is even more
broken than the bluetooth code...

In any case, to reproduce this issue, enable CONFIG_USB_DEBUG and then
try to use bluetooth (sdptool browse). You'll get error messages from
the USB stack:

	usb 1-1.1.3: BOGUS urb flags, 2 --> 0

Apply this patch and bluetooth starts working again.

 drivers/bluetooth/btusb.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index f00f596..b7c4f4e 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -726,9 +726,6 @@ static int btusb_send_frame(struct sk_buff *skb)
 		usb_fill_bulk_urb(urb, data->udev, pipe,
 				skb->data, skb->len, btusb_tx_complete, skb);
 
-		if (skb->priority >= HCI_PRIO_MAX - 1)
-			urb->transfer_flags  = URB_ISO_ASAP;
-
 		hdev->stat.acl_tx++;
 		break;
 
-- 
1.7.8.3

