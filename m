Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab0F3NvE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 09:51:04 -0400
Received: from core.signal11.us ([64.251.29.136]:48587 "EHLO core.signal11.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756008Ab0F3NvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 09:51:00 -0400
From: Alan Ott <alan@signal11.us>
To: Jiri Kosina <jkosina@suse.cz>, Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>, Alan Ott <alan@signal11.us>,
       Marcel Holtmann <marcel@holtmann.org>,
       Antonio Ospite <ospite@studenti.unina.it>,
       Amit Nagal <helloin.amit@gmail.com>, linux-usb@vger.kernel.org,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Alan Ott <alan@signal11.us>
Subject: [PATCH 1/1] HID: Send Report ID when numbered reports are sent over the control endpoint.
Date: Wed, 30 Jun 2010 09:50:36 -0400
Message-Id: <1277905836-3949-2-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.LNX.2.00.1006301126130.13809@pobox.suse.cz>
References: <alpine.LNX.2.00.1006301126130.13809@pobox.suse.cz>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Jun 30 09:50:59 2010
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4c2b4bc3209491927612659
X-DSPAM-Factors: 27,
	reports, 0.01000,
	Received*26+177, 0.01000,
	control+endpoint, 0.01000,
	Cc*<alan, 0.01000,
	To*linux+input, 0.01000,
	usbhid_output_raw_report(struct, 0.01000,
	<<, 0.01000,
	bInterfaceNumber, 0.01000,
	bInterfaceNumber, 0.01000,
	To*Ospite+<ospite, 0.01000,
	To*suse.de>, 0.01000,
	10, 0.01000,
	>desc, 0.01000,
	>desc, 0.01000,
	interface, 0.01000,
	interface, 0.01000,
	of, 0.01000,
	of, 0.01000,
	the+control, 0.01000,
	(ret+>, 0.01000,
	(ret+>, 0.01000,
	c+|, 0.01000,
	interface+>desc, 0.01000,
	interface+>desc, 0.01000,
	send, 0.01000,
	Received*ESMTP, 0.01000,
	=+usb_control_msg(dev, 0.01000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Report ID wasn't sent as part of the payload for reports which were sent
over the control endpoint. This is required by section 8.1 of the HID spec.

Signed-off-by: Alan Ott <alan@signal11.us>
---
 drivers/hid/usbhid/hid-core.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index deef816..1697687 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -854,14 +854,21 @@ static int usbhid_output_raw_report(struct hid_device *hid, __u8 *buf, size_t co
 				ret++;
 		}
 	} else {
+		int skipped_report_id = 0;
+		if (buf[0] == 0x0) {
+			/* Don't send the Report ID */
+			buf++;
+			count--;
+			skipped_report_id = 1;
+		}
 		ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
 			HID_REQ_SET_REPORT,
 			USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
 			((report_type + 1) << 8) | *buf,
-			interface->desc.bInterfaceNumber, buf + 1, count - 1,
+			interface->desc.bInterfaceNumber, buf, count,
 			USB_CTRL_SET_TIMEOUT);
-		/* count also the report id */
-		if (ret > 0)
+		/* count also the report id, if this was a numbered report. */
+		if (ret > 0 && skipped_report_id)
 			ret++;
 	}
 
-- 
1.7.0.4


