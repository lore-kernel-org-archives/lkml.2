Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab2KNTwu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 14:52:50 -0500
Received: from smtprelay-h31.telenor.se ([213.150.131.4]:48336 "EHLO
	smtprelay-h31.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573Ab2KNTwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 14:52:49 -0500
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuSeADH2o1BV5h1yPGdsb2JhbABEile3YAOBARkBAQEBHxkNJ4IeAQEEAScTHBMBDwULCAMRAwECLxQNGAoMDhOHeAMJCrFdDYlUFIswaXKEWWEDlCeBVIV7g06BaogB
X-IronPort-AV: E=Sophos;i="4.83,252,1352070000"; 
   d="scan'208";a="225562709"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 14 Nov 2012 20:58:52 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 14/14] HID: hid-multitouch: forwards MSC_TIMESTAMP
Message-ID: <20121114195852.GA14840@polaris.bitmath.org>
References: <1352908766-4492-1-git-send-email-benjamin.tissoires@gmail.com>
 <1352908766-4492-15-git-send-email-benjamin.tissoires@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352908766-4492-15-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> Computes the device timestamp according to the specification.
> It also ensures that if the time between two events is greater
> than MAX_TIMESTAMP_INTERVAL, the timestamp will be reset.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> ---

This was not what I envisioned from the discussion yesterday, I was
probably too vague. Firstly, the absolute time interval checked seems
to be 500 ms, which is arbitrary. Second, the wrap should probably use
(logical_maximum + 1). Third, we are still not sure whether we should
take the 'time = 0 means reset' logic literally, I think it needs to
be tested.

In light of this, I would like to suggest the patch below instead. It
should follow the current interpretation of the definition to the
letter. I imagine very few devices will actually do anything but wrap
the counter, but that remains to be seen. In that case, we could
simplify the code further, since we will have no hope of detecting
large intervals properly anyways.

Thanks,
Henrik

>From 448808dd988e96d58b79148292fde147935305ab Mon Sep 17 00:00:00 2001
From: Henrik Rydberg <rydberg@euromail.se>
Date: Wed, 14 Nov 2012 20:53:17 +0100
Subject: [PATCH] HID: hid-multitouch: send the device timestamp when present

Compute and relay the device timestamp when present. The counter
value range varies between devices, but the MSC_TIMESTAMP event
is always 32 bits long. A value of zero means the time since the
previous event is unknown.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hid/hid-multitouch.c | 36 +++++++++++++++++++++++++++++++++---
 include/linux/hid.h          |  1 +
 2 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 61543c0..586f9c6 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -98,6 +98,8 @@ struct mt_device {
 	bool serial_maybe;	/* need to check for serial protocol */
 	bool curvalid;		/* is the current contact valid? */
 	unsigned mt_flags;	/* flags to pass to input-mt */
+	unsigned dev_time;	/* device scan time in units of 100 us */
+	unsigned timestamp;	/* the timestamp to be sent */
 };
 
 /* classes of device behavior */
@@ -458,12 +460,19 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			mt_store_field(usage, td, hi);
 			td->last_field_index = field->index;
 			return 1;
+		case HID_DG_SCANTIME:
+			hid_map_usage(hi, usage, bit, max,
+				EV_MSC, MSC_TIMESTAMP);
+			set_bit(MSC_TIMESTAMP, hi->input->mscbit);
+			td->last_field_index = field->index;
+			return 1;
 		case HID_DG_CONTACTCOUNT:
 			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_CONTACTMAX:
-			/* we don't set td->last_slot_field as contactcount and
-			 * contact max are global to the report */
+			/* we don't set td->last_slot_field as scan time,
+			 * contactcount and contact max are global to the
+			 * report */
 			td->last_field_index = field->index;
 			return -1;
 		case HID_DG_TOUCH:
@@ -492,7 +501,8 @@ static int mt_input_mapped(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
 		unsigned long **bit, int *max)
 {
-	if (usage->type == EV_KEY || usage->type == EV_ABS)
+	if (usage->type == EV_KEY || usage->type == EV_ABS ||
+	    usage->type == EV_MSC)
 		set_bit(usage->type, hi->input->evbit);
 
 	return -1;
@@ -571,10 +581,27 @@ static void mt_complete_slot(struct mt_device *td, struct input_dev *input)
 static void mt_sync_frame(struct mt_device *td, struct input_dev *input)
 {
 	input_mt_sync_frame(input);
+	input_event(input, EV_MSC, MSC_TIMESTAMP, td->timestamp);
 	input_sync(input);
 	td->num_received = 0;
 }
 
+static void mt_compute_timestamp(struct mt_device *td, struct hid_field *field,
+				 unsigned value)
+{
+	unsigned dt;
+
+	if (value) {
+		dt = (value - td->dev_time) % (field->logical_maximum + 1);
+		td->timestamp += 100 * dt;
+		td->timestamp += !td->timestamp;
+	} else {
+		td->timestamp = 0;
+	}
+
+	td->dev_time = value;
+}
+
 static int mt_event(struct hid_device *hid, struct hid_field *field,
 				struct hid_usage *usage, __s32 value)
 {
@@ -622,6 +649,9 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
 		case HID_DG_HEIGHT:
 			td->curdata.h = value;
 			break;
+		case HID_DG_SCANTIME:
+			mt_compute_timestamp(td, field, value);
+			break;
 		case HID_DG_CONTACTCOUNT:
 			/*
 			 * Includes multi-packet support where subsequent
diff --git a/include/linux/hid.h b/include/linux/hid.h
index d2c42dd..eb7ec6c 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -242,6 +242,7 @@ struct hid_item {
 #define HID_DG_DEVICEINDEX	0x000d0053
 #define HID_DG_CONTACTCOUNT	0x000d0054
 #define HID_DG_CONTACTMAX	0x000d0055
+#define HID_DG_SCANTIME		0x000d0056
 
 /*
  * HID report types --- Ouch! HID spec says 1 2 3!
-- 
1.8.0

