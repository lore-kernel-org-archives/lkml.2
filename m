Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357Ab0IUWGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 18:06:46 -0400
Received: from core.signal11.us ([64.251.29.136]:56972 "EHLO core.signal11.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013Ab0IUWGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 18:06:45 -0400
From: Alan Ott <alan@signal11.us>
To: Jiri Kosina <jkosina@suse.cz>, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>, Alan Ott <alan@signal11.us>,
        =?UTF-8?q?Bruno=20Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Alan Ott <alan@signal11.us>
Subject: [PATCH v3 1/1] Don't Send Feature Reports on Interrupt Endpoint
Date: Tue, 21 Sep 2010 18:06:32 -0400
Message-Id: <1285106792-5818-1-git-send-email-alan@signal11.us>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <4C98EAAE.3020409@signal11.us>
References: <4C98EAAE.3020409@signal11.us>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Sep 21 18:06:44 2010
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4c992c7411161992021194
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Feature reports should only be sent on the control endpoint.

The USB HID standard is unclear and confusing on this issue. It seems to
suggest that Feature reports can be sent on a HID device's Interrupt OUT
endpoint.  This cannot be the case because the report type is not encoded in
transfers sent out the Interrput OUT endpoint.  If Feature reports were sent
on the Interrupt OUT endpint, they would be indistinguishable from Output
reports in the case where Report IDs were not used.

Further, Windows and Mac OS X do not send Feature reports out the interrupt
OUT Endpoint.  They will only go out the Control Endpoint.

In addition, many devices simply do not hande Feature reports sent out the Interrupt OUT endpoint.

Reported-by: simon@mungewell.org
Signed-off-by: Alan Ott <alan@signal11.us>
---
 drivers/hid/usbhid/hid-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index b729c02..b0ccc42 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -807,7 +807,7 @@ static int usbhid_output_raw_report(struct hid_device *hid, __u8 *buf, size_t co
 	struct usb_host_interface *interface = intf->cur_altsetting;
 	int ret;
 
-	if (usbhid->urbout) {
+	if (usbhid->urbout && report_type != HID_FEATURE_REPORT) {
 		int actual_length;
 		int skipped_report_id = 0;
 		if (buf[0] == 0x0) {
-- 
1.7.0.4


