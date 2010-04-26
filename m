Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042Ab0DZXGx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 19:06:53 -0400
Received: from core.signal11.us ([64.251.29.136]:36539 "EHLO core.signal11.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753245Ab0DZXGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 19:06:50 -0400
Message-ID: <4BD61506.1030301@signal11.us>
Date: Mon, 26 Apr 2010 18:34:46 -0400
From: Alan Ott <alan@signal11.us>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@enac.fr>,
       Marcel Holtmann <marcel@holtmann.org>, simon.windows@gmail.com,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] Bug in hidraw When a HID Device Contains Multiple Reports
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Mon Apr 26 18:34:48 2010
X-DSPAM-Confidence: 1.0000
X-DSPAM-Probability: 0.0023
X-DSPAM-Signature: 4bd6150885296397614705
X-DSPAM-Factors: 27,
	contains, 0.40000,
	reports, 0.40000,
	reports, 0.40000,
	reports+Signed, 0.40000,
	report+number, 0.40000,
	report+number, 0.40000,
	>transfer_buffer+to, 0.40000,
	void, 0.40000,
	Date*Apr, 0.40000,
	data+bytes), 0.40000,
	urb, 0.40000,
	urb, 0.40000,
	an+extra, 0.40000,
	an+extra, 0.40000,
	Date*46+0400, 0.40000,
	To*linux+input, 0.40000,
	HID_CLAIMED_HIDRAW)+hidraw_report_event(hid, 0.40000,
	an, 0.40000,
	an, 0.40000,
	a+<, 0.40000,
	>numbered), 0.40000,
	>numbered), 0.40000,
	up+Nothing, 0.40000,
	can+send, 0.40000,
	IN+transfer, 0.40000,
	from, 0.40000,
	from, 0.40000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Ott <alan@signal11.us>

Make hidraw not stick an extra byte on the beginning of an IN transfer
when a HID device contains multiple reports.

Signed-off-by: Alan Ott <alan@signal11.us>
---

In drivers/hid/hid-core.c, hid_report_raw_event() does the following to
pass the raw data to hidraw:

        if (hid->claimed & HID_CLAIMED_HIDRAW) {
                /* numbered reports need to be passed with the report num */
                if (report_enum->numbered)
                        hidraw_report_event(hid, data - 1, size + 1);
                else
                        hidraw_report_event(hid, data, size);
        }

The data-1 and size+1 add an extra byte to he beginning of the data
which is _not_ the report number. The report number is located at
data[0], not data[-1].

I followed the data all the way from its source in the urb:
 1. drivers/hid/usbhid/hid-core.c passes urb->transfer_buffer to
 2. hid_input_report() (drivers/hid/hid-core.c) who passes it to
 3. hid_report_raw_event() (drivers/hid/hid-core.c), who passes data-1 to
 4. hidraw_report_event() (drivers/hid/hidraw.c), which puts the data in
a buffer for hidraw_read() to pick up.

Nothing in the chain indicates that the data pointer which arrives in
hid_report_raw_event() is offset by one.

>From a multi-report HID device, I can send 4 bytes (report number + 3
data bytes) and see a return of 5 bytes from read() (hidraw_read())
which is the data I would expect with an extra byte (0x0) stuck to the
beginning of it.

I have attached a patch which seems to take care of this problem. Please
let me know if I have completely misjudged the situation.

Alan.

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 2e2aa75..0e4a6fb 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1043,13 +1043,8 @@ void hid_report_raw_event(struct hid_device *hid, int type, u8 *data, int size,
 
 	if ((hid->claimed & HID_CLAIMED_HIDDEV) && hid->hiddev_report_event)
 		hid->hiddev_report_event(hid, report);
-	if (hid->claimed & HID_CLAIMED_HIDRAW) {
-		/* numbered reports need to be passed with the report num */
-		if (report_enum->numbered)
-			hidraw_report_event(hid, data - 1, size + 1);
-		else
-			hidraw_report_event(hid, data, size);
-	}
+	if (hid->claimed & HID_CLAIMED_HIDRAW)
+		hidraw_report_event(hid, data, size);
 
 	for (a = 0; a < report->maxfield; a++)
 		hid_input_field(hid, report->field[a], cdata, interrupt);





