Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431Ab0DVU2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:28:00 -0400
Received: from kroah.org ([198.145.64.141]:59546 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757942Ab0DVT75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:59:57 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:07 2010
Message-Id: <20100422195407.702747955@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:53:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jiri Kosina <jkosina@suse.cz>
Subject: [030/139] HID: fix oops in gyration_event()
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Kosina <jkosina@suse.cz>

commit d8e4ebf8b603bdcd091540e6b5bddf0dec10d516 upstream.

Fix oops caused by dereferencing field->hidinput in cases where
the device hasn't been claimed by hid-input.

Reported-by: Andreas Demmer <mail@andreas-demmer.de>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/hid-gyration.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/hid/hid-gyration.c
+++ b/drivers/hid/hid-gyration.c
@@ -53,10 +53,13 @@ static int gyration_input_mapping(struct
 static int gyration_event(struct hid_device *hdev, struct hid_field *field,
 		struct hid_usage *usage, __s32 value)
 {
-	struct input_dev *input = field->hidinput->input;
+
+	if (!(hdev->claimed & HID_CLAIMED_INPUT) || !field->hidinput)
+		return 0;
 
 	if ((usage->hid & HID_USAGE_PAGE) == HID_UP_GENDESK &&
 			(usage->hid & 0xff) == 0x82) {
+		struct input_dev *input = field->hidinput->input;
 		input_event(input, usage->type, usage->code, 1);
 		input_sync(input);
 		input_event(input, usage->type, usage->code, 0);


