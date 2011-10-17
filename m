Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab1JQBUq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 21:20:46 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50163 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643Ab1JQBUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 21:20:44 -0400
From: chris@cnpbagwell.com
To: linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
        pinglinux@gmail.com
Cc: Chris Bagwell <chris@cnpbagwell.com>
Subject: [PATCH 1/6] Input: wacom - cleanup feature report for bamboos
Date: Sun, 16 Oct 2011 20:20:25 -0500
Message-Id: <1318814430-30316-2-git-send-email-chris@cnpbagwell.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1318814430-30316-1-git-send-email-chris@cnpbagwell.com>
References: <1318814430-30316-1-git-send-email-chris@cnpbagwell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Bagwell <chris@cnpbagwell.com>

Only the stylus interface on Bamboo's has a feature report that can
be used to set to wacom mode.  The touch interface only has 1 report mode
and will return errors for those get/sets requests.

The get request was always erroring out because it was not marked as
an input request. Only down side of error was needlessly resending the
set request 5 times.

Signed-off-by: Chris Bagwell <chris@cnpbagwell.com>
---
 drivers/input/tablet/wacom_sys.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index a205055..4f35473 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -66,7 +66,8 @@ static int wacom_get_report(struct usb_interface *intf, u8 type, u8 id,
 	do {
 		retval = usb_control_msg(dev, usb_rcvctrlpipe(dev, 0),
 				USB_REQ_GET_REPORT,
-				USB_TYPE_CLASS | USB_RECIP_INTERFACE,
+				USB_DIR_IN | USB_TYPE_CLASS |
+				USB_RECIP_INTERFACE,
 				(type << 8) + id,
 				intf->altsetting[0].desc.bInterfaceNumber,
 				buf, size, 100);
@@ -362,7 +363,8 @@ static int wacom_query_tablet_data(struct usb_interface *intf, struct wacom_feat
 						WAC_HID_FEATURE_REPORT,
 						report_id, rep_data, 4, 1);
 		} while ((error < 0 || rep_data[1] != 4) && limit++ < WAC_MSG_RETRIES);
-	} else if (features->type != TABLETPC) {
+	} else if (features->type != TABLETPC &&
+		   features->device_type == BTN_TOOL_PEN) {
 		do {
 			rep_data[0] = 2;
 			rep_data[1] = 2;
-- 
1.7.6.4

