Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760194Ab0EDSVg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 14:21:36 -0400
Received: from LION.seas.upenn.edu ([158.130.12.194]:55443 "EHLO
	lion.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760145Ab0EDSVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 14:21:22 -0400
From: Rafi Rubin <rafi@seas.upenn.edu>
To: linux-input@vger.kernel.org, jkosina@suse.cz, chatty@enac.fr
Cc: dmitry.torokhov@gmail.com, micki@n-trig.com, linux-kernel@vger.kernel.org,
       guy.paradis@n-trig.com, Rafi Rubin <rafi@seas.upenn.edu>
Subject: [PATCH 1/3] N-Trig sensitivity and responsiveness
Date: Tue,  4 May 2010 14:20:15 -0400
Message-Id: <1272997217-15335-2-git-send-email-rafi@seas.upenn.edu>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1272997217-15335-1-git-send-email-rafi@seas.upenn.edu>
References: <1272997217-15335-1-git-send-email-rafi@seas.upenn.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old rejection size thresholds were too high for the 12" devices.
Larger surfaces like the Dell Studio17 exacerbated the problem since
contact size is reported on the same logical scale, making a contact
look smaller to the larger screen.

Since we have observed erroneous ghost events from these devices we
still need to filter the incoming stream.

The prior size threshold filter is still in place, though with
defaults set to leave it off.

This patch adds the two new classes of filters, those that reject
live frames before activation, and those that reject empty frames
until deactivation.  These filters are expressed in terms of a
simple state machine for clarity (I hope).

The activation filter has two components, slack and size, events
are discarded until either is satisfied.  Slack is defined as
the number of seemingly good contacts to read before accepting the
stream as valid (if the threshold is reached in the middle of a frame
the remainder of that frame is still discarded).

The deactivation filter discards empty frames until hitting a
deactivate slack.  This time measured in frames.  N-Trig devices
emit 5-8 (observed so far) empty frames at the end of multitouch
activity.  Ignoring the first few enables us to safely and gracefully
handle erroneous empty frames, thus preventing a change in the tool
state which would otherwise result in things like broken lines or
dragged objects being dropped in bad places.

Also, now that devices with different logical densities have
been observed, the aforementioned sizes are scaled from physical
to logical scales once those scales are identified.  Hopefully this
should mean that a given threshold value means the same thing across
differing devices.

Signed-off-by: Rafi Rubin <rafi@seas.upenn.edu>

---
Module parameters and sysfs nodes to adjust these filters will be
submitted in a separate patch.  For now I think its important that users
can easily tune these parameters, since I can't be sure that I've picked
optimal values.
---
 drivers/hid/hid-ntrig.c |  220 +++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 211 insertions(+), 9 deletions(-)

diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
index 4777bbf..227d015 100644
--- a/drivers/hid/hid-ntrig.c
+++ b/drivers/hid/hid-ntrig.c
@@ -24,6 +24,13 @@
 
 #define NTRIG_DUPLICATE_USAGES	0x001
 
+static unsigned int min_width;
+static unsigned int min_height;
+static unsigned int activate_slack = 1;
+static unsigned int deactivate_slack = 4;
+static unsigned int activation_width = 64;
+static unsigned int activation_height = 32;
+
 struct ntrig_data {
 	/* Incoming raw values for a single contact */
 	__u16 x, y, w, h;
@@ -37,6 +44,28 @@ struct ntrig_data {
 
 	__u8 mt_footer[4];
 	__u8 mt_foot_count;
+
+	/* The current activation state. */
+	__s8 act_state;
+
+	/* Empty frames to ignore before recognizing the end of activity */
+	__s8 deactivate_slack;
+
+	/* Frames to ignore before acknowledging the start of activity */
+	__s8 activate_slack;
+
+	/* Minimum size contact to accept */
+	__u16 min_width;
+	__u16 min_height;
+
+	/* Threshold to override activation slack */
+	__u16 activation_width;
+	__u16 activation_height;
+
+	__u16 sensor_logical_width;
+	__u16 sensor_logical_height;
+	__u16 sensor_physical_width;
+	__u16 sensor_physical_height;
 };
 
 /*
@@ -49,6 +78,8 @@ static int ntrig_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
 		unsigned long **bit, int *max)
 {
+	struct ntrig_data *nd = hid_get_drvdata(hdev);
+
 	/* No special mappings needed for the pen and single touch */
 	if (field->physical)
 		return 0;
@@ -62,6 +93,21 @@ static int ntrig_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			input_set_abs_params(hi->input, ABS_X,
 					field->logical_minimum,
 					field->logical_maximum, 0, 0);
+
+			if (!nd->sensor_logical_width) {
+				nd->sensor_logical_width =
+					field->logical_maximum -
+					field->logical_minimum;
+				nd->sensor_physical_width =
+					field->physical_maximum -
+					field->physical_minimum;
+				nd->activation_width = activation_width *
+					nd->sensor_logical_width /
+					nd->sensor_physical_width;
+				nd->min_width = min_width *
+					nd->sensor_logical_width /
+					nd->sensor_physical_width;
+			}
 			return 1;
 		case HID_GD_Y:
 			hid_map_usage(hi, usage, bit, max,
@@ -69,6 +115,21 @@ static int ntrig_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			input_set_abs_params(hi->input, ABS_Y,
 					field->logical_minimum,
 					field->logical_maximum, 0, 0);
+
+			if (!nd->sensor_logical_height) {
+				nd->sensor_logical_height =
+					field->logical_maximum -
+					field->logical_minimum;
+				nd->sensor_physical_height =
+					field->physical_maximum -
+					field->physical_minimum;
+				nd->activation_height = activation_height *
+					nd->sensor_logical_height /
+					nd->sensor_physical_height;
+				nd->min_height = min_height *
+					nd->sensor_logical_height /
+					nd->sensor_physical_height;
+			}
 			return 1;
 		}
 		return 0;
@@ -201,20 +262,68 @@ static int ntrig_event (struct hid_device *hid, struct hid_field *field,
 			if (nd->mt_foot_count != 4)
 				break;
 
-			/* Pen activity signal, trigger end of touch. */
+			/* Pen activity signal. */
 			if (nd->mt_footer[2]) {
+				/*
+				 * When the pen deactivates touch, we see a
+				 * bogus frame with ContactCount > 0.
+				 * We can
+				 * save a bit of work by ensuring act_state < 0
+				 * even if deactivation slack is turned off.
+				 */
+				nd->act_state = deactivate_slack - 1;
 				nd->confidence = 0;
 				break;
 			}
 
-			/* If the contact was invalid */
-			if (!(nd->confidence && nd->mt_footer[0])
-					|| nd->w <= 250
-					|| nd->h <= 190) {
-				nd->confidence = 0;
+			/*
+			 * The first footer value indicates the presence of a
+			 * finger.
+			 */
+			if (nd->mt_footer[0]) {
+				/*
+				 * We do not want to process contacts under
+				 * the size threshold, but do not want to
+				 * ignore them for activation state
+				 */
+				if (nd->w < nd->min_width ||
+				    nd->h < nd->min_height)
+					nd->confidence = 0;
+			} else
 				break;
+
+			if (nd->act_state > 0) {
+				/*
+				 * Contact meets the activation size threshold
+				 */
+				if (nd->w >= nd->activation_width &&
+				    nd->h >= nd->activation_height) {
+					if (nd->id)
+						/*
+						 * first contact, activate now
+						 */
+						nd->act_state = 0;
+					else {
+						/*
+						 * avoid corrupting this frame
+						 * but ensure next frame will
+						 * be active
+						 */
+						nd->act_state = 1;
+						break;
+					}
+				} else
+					/*
+					 * Defer adjusting the activation state
+					 * until the end of the frame.
+					 */
+					break;
 			}
 
+			/* Discarding this contact */
+			if (!nd->confidence)
+				break;
+
 			/* emit a normal (X, Y) for the first point only */
 			if (nd->id == 0) {
 				/*
@@ -227,8 +336,15 @@ static int ntrig_event (struct hid_device *hid, struct hid_field *field,
 				input_event(input, EV_ABS, ABS_X, nd->x);
 				input_event(input, EV_ABS, ABS_Y, nd->y);
 			}
+
+			/* Emit MT events */
 			input_event(input, EV_ABS, ABS_MT_POSITION_X, nd->x);
 			input_event(input, EV_ABS, ABS_MT_POSITION_Y, nd->y);
+
+			/*
+			 * Translate from height and width to size
+			 * and orientation.
+			 */
 			if (nd->w > nd->h) {
 				input_event(input, EV_ABS,
 						ABS_MT_ORIENTATION, 1);
@@ -248,12 +364,88 @@ static int ntrig_event (struct hid_device *hid, struct hid_field *field,
 			break;
 
 		case HID_DG_CONTACTCOUNT: /* End of a multitouch group */
-			if (!nd->reading_mt)
+			if (!nd->reading_mt) /* Just to be sure */
 				break;
 
 			nd->reading_mt = 0;
 
-			if (nd->first_contact_touch) {
+
+			/*
+			 * Activation state machine logic:
+			 *
+			 * Fundamental states:
+			 *	state >  0: Inactive
+			 *	state <= 0: Active
+			 *	state <  -deactivate_slack:
+			 *		 Pen termination of touch
+			 *
+			 * Specific values of interest
+			 *	state == activate_slack
+			 *		 no valid input since the last reset
+			 *
+			 *	state == 0
+			 *		 general operational state
+			 *
+			 *	state == -deactivate_slack
+			 *		 read sufficient empty frames to accept
+			 *		 the end of input and reset
+			 */
+
+			if (nd->act_state > 0) { /* Currently inactive */
+				if (value)
+					/*
+					 * Consider each live contact as
+					 * evidence of intentional activity.
+					 */
+					nd->act_state = (nd->act_state > value)
+							? nd->act_state - value
+							: 0;
+				else
+					/*
+					 * Empty frame before we hit the
+					 * activity threshold, reset.
+					 */
+					nd->act_state = nd->activate_slack;
+
+				/*
+				 * Entered this block inactive and no
+				 * coordinates sent this frame, so hold off
+				 * on button state.
+				 */
+				break;
+			} else { /* Currently active */
+				if (value && nd->act_state >=
+					     nd->deactivate_slack)
+					/*
+					 * Live point: clear accumulated
+					 * deactivation count.
+					 */
+					nd->act_state = 0;
+				else if (nd->act_state <= nd->deactivate_slack)
+					/*
+					 * We've consumed the deactivation
+					 * slack, time to deactivate and reset.
+					 */
+					nd->act_state =
+						nd->activate_slack;
+				else { /* Move towards deactivation */
+					nd->act_state--;
+					break;
+				}
+			}
+
+			if (nd->first_contact_touch && nd->act_state <= 0) {
+				/*
+				 * Check to see if we're ready to start
+				 * emitting touch events.
+				 *
+				 * Note: activation slack will decrease over
+				 * the course of the frame, and it will be
+				 * inconsistent from the start to the end of
+				 * the frame.  However if the frame starts
+				 * with slack, first_contact_touch will still
+				 * be 0 and we will not get to this point.
+				 */
 				input_report_key(input, BTN_TOOL_DOUBLETAP, 1);
 				input_report_key(input, BTN_TOUCH, 1);
 			} else {
@@ -263,7 +455,7 @@ static int ntrig_event (struct hid_device *hid, struct hid_field *field,
 			break;
 
 		default:
-			/* fallback to the generic hidinput handling */
+			/* fall-back to the generic hidinput handling */
 			return 0;
 		}
 	}
@@ -293,6 +485,16 @@ static int ntrig_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	}
 
 	nd->reading_mt = 0;
+	nd->min_width = 0;
+	nd->min_height = 0;
+	nd->activate_slack = activate_slack;
+	nd->act_state = activate_slack;
+	nd->deactivate_slack = -deactivate_slack;
+	nd->sensor_logical_width = 0;
+	nd->sensor_logical_height = 0;
+	nd->sensor_physical_width = 0;
+	nd->sensor_physical_height = 0;
+
 	hid_set_drvdata(hdev, nd);
 
 	ret = hid_parse(hdev);
-- 
1.7.1

