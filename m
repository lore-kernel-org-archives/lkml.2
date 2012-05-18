Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967758Ab2ERVOV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 17:14:21 -0400
Received: from mga14.intel.com ([143.182.124.37]:53018 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967427Ab2ERVOS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 17:14:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="101772096"
From: "Drews, Paul" <paul.drews@intel.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: RE: [PATCH 1/5] HID: hid-multitouch: fix wrong protocol detection
Thread-Topic: [PATCH 1/5] HID: hid-multitouch: fix wrong protocol detection
Thread-Index: AQHNNTU0HwFTV9GtN0C5LQg7UL6NKZbQB/NA
Date: Fri, 18 May 2012 21:14:08 +0000
Message-ID: <6008DE3C35C7C04D85C2A4C813D36515481E5D29@ORSMSX101.amr.corp.intel.com>
References: <1336136030-18503-1-git-send-email-benjamin.tissoires@gmail.com>
 <1336136030-18503-2-git-send-email-benjamin.tissoires@gmail.com>
 <20120506190146.GA12571@polaris.bitmath.org>
 <CAN+gG=G9y_0Le-Mja2z68r76nBmz0De95Lc6671EkrrMZRSEHw@mail.gmail.com>
In-Reply-To: <CAN+gG=G9y_0Le-Mja2z68r76nBmz0De95Lc6671EkrrMZRSEHw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Benjamin Tissoires
> Sent: Wednesday, May 09, 2012 12:04 PM
> To: Henrik Rydberg
> Cc: Dmitry Torokhov; Jiri Kosina; Stephane Chatty; linux-input@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 1/5] HID: hid-multitouch: fix wrong protocol detection
> 

> On Sun, May 6, 2012 at 9:01 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> > Hi Benjamin,
> >
> >> The previous implementation introduced a randomness in the splitting
> >> of the different touches reported by the device. This version is more
> >> robust as we don't rely on hi->input->absbit, but on our own structure.
> >>

> >> +
> >>  struct mt_device {
> >>       struct mt_slot curdata; /* placeholder of incoming data */
> >>       struct mt_class mtclass;        /* our mt device class */
> >> +     struct mt_fields *fields;       /* temporary placeholder for storing the
> >> +                                        multitouch fields */
> >
> > Why not skip the pointer here?
> 
> well, the idea was to keep the memory footprint low. As these values
> are only needed at init, then I freed them once I finished using them.
> I can of course skip the pointer, but in that case, wouldn't the
> struct declaration be worthless?
> 
> >

> >>
> >> +static void mt_post_parse(struct mt_device *td)
> >> +{
> >> +     struct mt_fields *f = td->fields;
> >> +
> >> +     if (td->touches_by_report > 0) {
> >> +             int field_count_per_touch = f->length / td->touches_by_report;
> >> +             td->last_slot_field = f->usages[field_count_per_touch - 1]->hid;
> >> +     }
> >> +}
> >> +

It sounds as though:

() Reviewers are a little uncomfortable with the memory footprint and
    allocation/free
() The patch as it stands relies on the pattern of "usage" values repeating
    for each touch, and deeming the last one in the repetition pattern to
    be the last-slot-field marker.

If this is the case, how about avoiding storing all the slot-field values
and just detecting the point of repetition to use the most-recently-seen
usage value as the last-slot-field marker.  I have been successfully using
the patch below based on this notion.  It took the failure rate from about
1-per-10 boots to 250+ boots with no failures on an Atmel MaXTouch.
I don't have others to try it with, including the "buggy" one that led
to all this trouble in the first place.

Patch follows:
==========================================================
>From 242f6773babe0fc0215764abbeeeff6510f3ca92 Mon Sep 17 00:00:00 2001
From: Paul Drews <paul.drews@intel.com>
Date: Wed, 16 May 2012 11:15:00 -0700
Subject: [PATCH] Repair detection of last slot in multitouch reports

The logic for detecting the last per-touch slot in a
multitouch report erroneously used hid usage values (large
numbers such as 0xd0032) as indices into the smaller absbit
bitmap (with bit indexes up to 0x3f).  This caused
intermittent failures in the configuration of the last-slot
value leading to stale x,y coordinates being reported in
multi-touch input events.  It also carried the risk of a
segmentation fault due to the out-of-range bitmap index.

This patch takes a different approach of detecting the last
per-touch slot:  when the hid usage value wraps around to
the first hid usage value we have seen already, we must be
looking at the slots for the next touch of a multi-touch
report, so the last hid usage value we have seen so far must
be the last per-touch value.

Issue: AIA-446
Change-Id: Ic1872998502874298bb60705df9bd2fc70de1738
Signed-off-by: Paul Drews <paul.drews@intel.com>
---
 drivers/hid/hid-multitouch.c |   39 ++++++++++++++++++++++++++-------------
 1 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 2e6d187..226f828 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -75,6 +75,9 @@ struct mt_device {
 	struct mt_class mtclass;	/* our mt device class */
 	unsigned last_field_index;	/* last field index of the report */
 	unsigned last_slot_field;	/* the last field of a slot */
+	bool last_slot_field_found;	/* last_slot_field has full init */
+	unsigned first_slot_field;
+	bool first_slot_field_found;	/* for detecting wrap to next touch */
 	__s8 inputmode;		/* InputMode HID feature, -1 if non-existent */
 	__s8 maxcontact_report_id;	/* Maximum Contact Number HID feature,
 				   -1 if non-existent */
@@ -275,11 +278,21 @@ static void set_abs(struct input_dev *input, unsigned int code,
 	input_set_abs_params(input, code, fmin, fmax, fuzz, 0);
 }
 
-static void set_last_slot_field(struct hid_usage *usage, struct mt_device *td,
-		struct hid_input *hi)
+static void update_last_slot_field(struct hid_usage *usage,
+		struct mt_device *td)
 {
-	if (!test_bit(usage->hid, hi->input->absbit))
-		td->last_slot_field = usage->hid;
+	if (!td->last_slot_field_found) {
+		if (td->first_slot_field_found) {
+			if (td->last_slot_field == usage->hid)
+				td->last_slot_field_found = true; /* wrapped */
+			else
+				td->last_slot_field = usage->hid;
+		} else {
+			td->first_slot_field = usage->hid;
+			td->first_slot_field_found = true;
+			td->last_slot_field = usage->hid;
+		}
+	}
 }
 
 static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
@@ -340,7 +353,7 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 				cls->sn_move);
 			/* touchscreen emulation */
 			set_abs(hi->input, ABS_X, field, cls->sn_move);
-			set_last_slot_field(usage, td, hi);
+			update_last_slot_field(usage, td);
 			td->last_field_index = field->index;
 			return 1;
 		case HID_GD_Y:
@@ -350,7 +363,7 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 				cls->sn_move);
 			/* touchscreen emulation */
 			set_abs(hi->input, ABS_Y, field, cls->sn_move);
-			set_last_slot_field(usage, td, hi);
+			update_last_slot_field(usage, td);
 			td->last_field_index = field->index;
 			return 1;
 		}
@@ -359,24 +372,24 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 	case HID_UP_DIGITIZER:
 		switch (usage->hid) {
 		case HID_DG_INRANGE:
-			set_last_slot_field(usage, td, hi);
+			update_last_slot_field(usage, td);
 			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_CONFIDENCE:
-			set_last_slot_field(usage, td, hi);
+			update_last_slot_field(usage, td);
 			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_TIPSWITCH:
 			hid_map_usage(hi, usage, bit, max, EV_KEY, BTN_TOUCH);
 			input_set_capability(hi->input, EV_KEY, BTN_TOUCH);
-			set_last_slot_field(usage, td, hi);
+			update_last_slot_field(usage, td);
 			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_CONTACTID:
 			if (!td->maxcontacts)
 				td->maxcontacts = MT_DEFAULT_MAXCONTACT;
 			input_mt_init_slots(hi->input, td->maxcontacts);
-			td->last_slot_field = usage->hid;
+			update_last_slot_field(usage, td);
 			td->last_field_index = field->index;
 			td->touches_by_report++;
 			return 1;
@@ -385,7 +398,7 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 					EV_ABS, ABS_MT_TOUCH_MAJOR);
 			set_abs(hi->input, ABS_MT_TOUCH_MAJOR, field,
 				cls->sn_width);
-			set_last_slot_field(usage, td, hi);
+			update_last_slot_field(usage, td);
 			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_HEIGHT:
@@ -395,7 +408,7 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 				cls->sn_height);
 			input_set_abs_params(hi->input,
 					ABS_MT_ORIENTATION, 0, 1, 0, 0);
-			set_last_slot_field(usage, td, hi);
+			update_last_slot_field(usage, td);
 			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_TIPPRESSURE:
@@ -406,7 +419,7 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			/* touchscreen emulation */
 			set_abs(hi->input, ABS_PRESSURE, field,
 				cls->sn_pressure);
-			set_last_slot_field(usage, td, hi);
+			update_last_slot_field(usage, td);
 			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_CONTACTCOUNT:
-- 
1.7.3.4
==========================================================
