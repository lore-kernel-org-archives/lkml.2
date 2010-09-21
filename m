Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046Ab0IUR0L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 13:26:11 -0400
Received: from core.signal11.us ([64.251.29.136]:55410 "EHLO core.signal11.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754034Ab0IUR0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 13:26:08 -0400
Message-ID: <4C98EAAE.3020409@signal11.us>
Date: Tue, 21 Sep 2010 13:26:06 -0400
From: Alan Ott <alan@signal11.us>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100528 Thunderbird/3.0.5
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>, Alan Ott <alan@signal11.us>,
        Marcel Holtmann <marcel@holtmann.org>, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Alan Ott <alan@signal11.us>
Subject: [PATCH v2 1/1] Don't Send Feature Reports on Interrupt Endpoint
References: <ba7172472e7fa92f305c16ab3456da18.squirrel@host171.canaca.com>
In-Reply-To: <ba7172472e7fa92f305c16ab3456da18.squirrel@host171.canaca.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Sep 21 13:26:07 2010
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4c98eaaf315672140186450
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Feature reports should only be sent on the control endpoint.

The USB HID standard is unclear and confusing on this issue. It seems to
suggest that Feature reports can be sent on a HID device's Interrupt OUT
endpoint. This cannot be the case because the report type is not
encoded in transfers sent out the Interrput OUT endpoint. If Feature 
reports were sent on the Interrupt OUT endpint, they would be 
indistinguishable from Output reports in the case where Report IDs were 
not used.

Further, Windows and Mac OS X do not send Feature reports out the 
interrupt OUT Endpoint. They will only go out the Control Endpoint.

In addition, many devices simply do not hande Feature reports sent out 
the Interrupt OUT endpoint.

Reported-by: simon@mungewell.org
Signed-off-by: Alan Ott <alan@signal11.us>
---
  drivers/hid/usbhid/hid-core.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index b729c02..b0ccc42 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -807,7 +807,7 @@ static int usbhid_output_raw_report(struct 
hid_device *hid, __u8 *buf, size_t co
  	struct usb_host_interface *interface = intf->cur_altsetting;
  	int ret;
  -	if (usbhid->urbout) {
+	if (usbhid->urbout && report_type != HID_FEATURE_REPORT) {
  		int actual_length;
  		int skipped_report_id = 0;
  		if (buf[0] == 0x0) {
-- 
1.7.0.4



