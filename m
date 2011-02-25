Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150Ab1BYFjD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 00:39:03 -0500
Received: from fox.seas.upenn.edu ([158.130.68.12]:49516 "EHLO
	fox.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab1BYFi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 00:38:59 -0500
From: Rafi Rubin <rafi@seas.upenn.edu>
To: jkosina@suse.cz, linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, micki@n-trig.com, rydberg@euromail.se,
        chatty@enac.fr, trivial@kernel.org, peter.hutterer@who-t.net,
        Rafi Rubin <rafi@seas.upenn.edu>
Subject: [PATCH 1/2] HID: ntrig don't dereference unclaimed hidinput
Date: Fri, 25 Feb 2011 00:15:31 -0500
Message-Id: <1298610932-21957-1-git-send-email-rafi@seas.upenn.edu>
X-Mailer: git-send-email 1.7.2.3
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2011-02-25_02:2011-02-25,2011-02-25,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moved the claimed input check before dereferencing field->hidinput to
fix a reported invalid deference bug.

Switched to a goto instead of an extra indent for most of the function.

Signed-off-by: Rafi Rubin <rafi@seas.upenn.edu>
---
Peter Hutterer reported seeing ntrig_event called when field->hidinput
is NULL.

Seems like a reasonable opportunity to adjust the whitespace a bit.
---
 drivers/hid/hid-ntrig.c |  466 ++++++++++++++++++++++++-----------------------
 1 files changed, 236 insertions(+), 230 deletions(-)

diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
index beb4034..616f091 100644
--- a/drivers/hid/hid-ntrig.c
+++ b/drivers/hid/hid-ntrig.c
@@ -539,277 +539,283 @@ static int ntrig_input_mapped(struct hid_device *hdev, struct hid_input *hi,
 static int ntrig_event (struct hid_device *hid, struct hid_field *field,
 			struct hid_usage *usage, __s32 value)
 {
-	struct input_dev *input = field->hidinput->input;
 	struct ntrig_data *nd = hid_get_drvdata(hid);
+	struct input_dev *input;
+
+	/* Skip processing if not a claimed input */
+	if (!(hid->claimed & HID_CLAIMED_INPUT))
+		goto not_claimed_input;
 
 	/* No special handling needed for the pen */
 	if (field->application == HID_DG_PEN)
 		return 0;
 
-        if (hid->claimed & HID_CLAIMED_INPUT) {
-		switch (usage->hid) {
-		case 0xff000001:
-			/* Tag indicating the start of a multitouch group */
-			nd->reading_mt = 1;
-			nd->first_contact_touch = 0;
-			break;
-		case HID_DG_TIPSWITCH:
-			nd->tipswitch = value;
-			/* Prevent emission of touch until validated */
-			return 1;
-		case HID_DG_CONFIDENCE:
-			nd->confidence = value;
-			break;
-		case HID_GD_X:
-			nd->x = value;
-			/* Clear the contact footer */
-			nd->mt_foot_count = 0;
-			break;
-		case HID_GD_Y:
-			nd->y = value;
-			break;
-		case HID_DG_CONTACTID:
-			nd->id = value;
-			break;
-		case HID_DG_WIDTH:
-			nd->w = value;
-			break;
-		case HID_DG_HEIGHT:
-			nd->h = value;
+	/* Delaying this to avoid invalid dereferences */
+	input = field->hidinput->input;
+
+	switch (usage->hid) {
+	case 0xff000001:
+		/* Tag indicating the start of a multitouch group */
+		nd->reading_mt = 1;
+		nd->first_contact_touch = 0;
+		break;
+	case HID_DG_TIPSWITCH:
+		nd->tipswitch = value;
+		/* Prevent emission of touch until validated */
+		return 1;
+	case HID_DG_CONFIDENCE:
+		nd->confidence = value;
+		break;
+	case HID_GD_X:
+		nd->x = value;
+		/* Clear the contact footer */
+		nd->mt_foot_count = 0;
+		break;
+	case HID_GD_Y:
+		nd->y = value;
+		break;
+	case HID_DG_CONTACTID:
+		nd->id = value;
+		break;
+	case HID_DG_WIDTH:
+		nd->w = value;
+		break;
+	case HID_DG_HEIGHT:
+		nd->h = value;
+		/*
+		 * when in single touch mode, this is the last
+		 * report received in a finger event. We want
+		 * to emit a normal (X, Y) position
+		 */
+		if (!nd->reading_mt) {
 			/*
-			 * when in single touch mode, this is the last
-			 * report received in a finger event. We want
-			 * to emit a normal (X, Y) position
+			 * TipSwitch indicates the presence of a
+			 * finger in single touch mode.
 			 */
-			if (!nd->reading_mt) {
-				/*
-				 * TipSwitch indicates the presence of a
-				 * finger in single touch mode.
-				 */
-				input_report_key(input, BTN_TOUCH,
-						 nd->tipswitch);
-				input_report_key(input, BTN_TOOL_DOUBLETAP,
-						 nd->tipswitch);
-				input_event(input, EV_ABS, ABS_X, nd->x);
-				input_event(input, EV_ABS, ABS_Y, nd->y);
-			}
+			input_report_key(input, BTN_TOUCH,
+					 nd->tipswitch);
+			input_report_key(input, BTN_TOOL_DOUBLETAP,
+					 nd->tipswitch);
+			input_event(input, EV_ABS, ABS_X, nd->x);
+			input_event(input, EV_ABS, ABS_Y, nd->y);
+		}
+		break;
+	case 0xff000002:
+		/*
+		 * we receive this when the device is in multitouch
+		 * mode. The first of the three values tagged with
+		 * this usage tells if the contact point is real
+		 * or a placeholder
+		 */
+
+		/* Shouldn't get more than 4 footer packets, so skip */
+		if (nd->mt_foot_count >= 4)
 			break;
-		case 0xff000002:
-			/*
-			 * we receive this when the device is in multitouch
-			 * mode. The first of the three values tagged with
-			 * this usage tells if the contact point is real
-			 * or a placeholder
-			 */
 
-			/* Shouldn't get more than 4 footer packets, so skip */
-			if (nd->mt_foot_count >= 4)
-				break;
+		nd->mt_footer[nd->mt_foot_count++] = value;
 
-			nd->mt_footer[nd->mt_foot_count++] = value;
+		/* if the footer isn't complete break */
+		if (nd->mt_foot_count != 4)
+			break;
 
-			/* if the footer isn't complete break */
-			if (nd->mt_foot_count != 4)
-				break;
+		/* Pen activity signal. */
+		if (nd->mt_footer[2]) {
+			/*
+			 * When the pen deactivates touch, we see a
+			 * bogus frame with ContactCount > 0.
+			 * We can
+			 * save a bit of work by ensuring act_state < 0
+			 * even if deactivation slack is turned off.
+			 */
+			nd->act_state = deactivate_slack - 1;
+			nd->confidence = 0;
+			break;
+		}
 
-			/* Pen activity signal. */
-			if (nd->mt_footer[2]) {
-				/*
-				 * When the pen deactivates touch, we see a
-				 * bogus frame with ContactCount > 0.
-				 * We can
-				 * save a bit of work by ensuring act_state < 0
-				 * even if deactivation slack is turned off.
-				 */
-				nd->act_state = deactivate_slack - 1;
+		/*
+		 * The first footer value indicates the presence of a
+		 * finger.
+		 */
+		if (nd->mt_footer[0]) {
+			/*
+			 * We do not want to process contacts under
+			 * the size threshold, but do not want to
+			 * ignore them for activation state
+			 */
+			if (nd->w < nd->min_width ||
+			    nd->h < nd->min_height)
 				nd->confidence = 0;
-				break;
-			}
+		} else
+			break;
 
+		if (nd->act_state > 0) {
 			/*
-			 * The first footer value indicates the presence of a
-			 * finger.
+			 * Contact meets the activation size threshold
 			 */
-			if (nd->mt_footer[0]) {
-				/*
-				 * We do not want to process contacts under
-				 * the size threshold, but do not want to
-				 * ignore them for activation state
-				 */
-				if (nd->w < nd->min_width ||
-				    nd->h < nd->min_height)
-					nd->confidence = 0;
-			} else
-				break;
-
-			if (nd->act_state > 0) {
-				/*
-				 * Contact meets the activation size threshold
-				 */
-				if (nd->w >= nd->activation_width &&
-				    nd->h >= nd->activation_height) {
-					if (nd->id)
-						/*
-						 * first contact, activate now
-						 */
-						nd->act_state = 0;
-					else {
-						/*
-						 * avoid corrupting this frame
-						 * but ensure next frame will
-						 * be active
-						 */
-						nd->act_state = 1;
-						break;
-					}
-				} else
+			if (nd->w >= nd->activation_width &&
+			    nd->h >= nd->activation_height) {
+				if (nd->id)
 					/*
-					 * Defer adjusting the activation state
-					 * until the end of the frame.
+					 * first contact, activate now
 					 */
+					nd->act_state = 0;
+				else {
+					/*
+					 * avoid corrupting this frame
+					 * but ensure next frame will
+					 * be active
+					 */
+					nd->act_state = 1;
 					break;
-			}
-
-			/* Discarding this contact */
-			if (!nd->confidence)
-				break;
-
-			/* emit a normal (X, Y) for the first point only */
-			if (nd->id == 0) {
+				}
+			} else
 				/*
-				 * TipSwitch is superfluous in multitouch
-				 * mode.  The footer events tell us
-				 * if there is a finger on the screen or
-				 * not.
+				 * Defer adjusting the activation state
+				 * until the end of the frame.
 				 */
-				nd->first_contact_touch = nd->confidence;
-				input_event(input, EV_ABS, ABS_X, nd->x);
-				input_event(input, EV_ABS, ABS_Y, nd->y);
-			}
+				break;
+		}
 
-			/* Emit MT events */
-			input_event(input, EV_ABS, ABS_MT_POSITION_X, nd->x);
-			input_event(input, EV_ABS, ABS_MT_POSITION_Y, nd->y);
+		/* Discarding this contact */
+		if (!nd->confidence)
+			break;
 
+		/* emit a normal (X, Y) for the first point only */
+		if (nd->id == 0) {
 			/*
-			 * Translate from height and width to size
-			 * and orientation.
+			 * TipSwitch is superfluous in multitouch
+			 * mode.  The footer events tell us
+			 * if there is a finger on the screen or
+			 * not.
 			 */
-			if (nd->w > nd->h) {
-				input_event(input, EV_ABS,
-						ABS_MT_ORIENTATION, 1);
-				input_event(input, EV_ABS,
-						ABS_MT_TOUCH_MAJOR, nd->w);
-				input_event(input, EV_ABS,
-						ABS_MT_TOUCH_MINOR, nd->h);
-			} else {
-				input_event(input, EV_ABS,
-						ABS_MT_ORIENTATION, 0);
-				input_event(input, EV_ABS,
-						ABS_MT_TOUCH_MAJOR, nd->h);
-				input_event(input, EV_ABS,
-						ABS_MT_TOUCH_MINOR, nd->w);
-			}
-			input_mt_sync(field->hidinput->input);
-			break;
+			nd->first_contact_touch = nd->confidence;
+			input_event(input, EV_ABS, ABS_X, nd->x);
+			input_event(input, EV_ABS, ABS_Y, nd->y);
+		}
 
-		case HID_DG_CONTACTCOUNT: /* End of a multitouch group */
-			if (!nd->reading_mt) /* Just to be sure */
-				break;
+		/* Emit MT events */
+		input_event(input, EV_ABS, ABS_MT_POSITION_X, nd->x);
+		input_event(input, EV_ABS, ABS_MT_POSITION_Y, nd->y);
+
+		/*
+		 * Translate from height and width to size
+		 * and orientation.
+		 */
+		if (nd->w > nd->h) {
+			input_event(input, EV_ABS,
+					ABS_MT_ORIENTATION, 1);
+			input_event(input, EV_ABS,
+					ABS_MT_TOUCH_MAJOR, nd->w);
+			input_event(input, EV_ABS,
+					ABS_MT_TOUCH_MINOR, nd->h);
+		} else {
+			input_event(input, EV_ABS,
+					ABS_MT_ORIENTATION, 0);
+			input_event(input, EV_ABS,
+					ABS_MT_TOUCH_MAJOR, nd->h);
+			input_event(input, EV_ABS,
+					ABS_MT_TOUCH_MINOR, nd->w);
+		}
+		input_mt_sync(field->hidinput->input);
+		break;
 
-			nd->reading_mt = 0;
+	case HID_DG_CONTACTCOUNT: /* End of a multitouch group */
+		if (!nd->reading_mt) /* Just to be sure */
+			break;
 
+		nd->reading_mt = 0;
+
+
+		/*
+		 * Activation state machine logic:
+		 *
+		 * Fundamental states:
+		 *	state >  0: Inactive
+		 *	state <= 0: Active
+		 *	state <  -deactivate_slack:
+		 *		 Pen termination of touch
+		 *
+		 * Specific values of interest
+		 *	state == activate_slack
+		 *		 no valid input since the last reset
+		 *
+		 *	state == 0
+		 *		 general operational state
+		 *
+		 *	state == -deactivate_slack
+		 *		 read sufficient empty frames to accept
+		 *		 the end of input and reset
+		 */
+
+		if (nd->act_state > 0) { /* Currently inactive */
+			if (value)
+				/*
+				 * Consider each live contact as
+				 * evidence of intentional activity.
+				 */
+				nd->act_state = (nd->act_state > value)
+						? nd->act_state - value
+						: 0;
+			else
+				/*
+				 * Empty frame before we hit the
+				 * activity threshold, reset.
+				 */
+				nd->act_state = nd->activate_slack;
 
 			/*
-			 * Activation state machine logic:
-			 *
-			 * Fundamental states:
-			 *	state >  0: Inactive
-			 *	state <= 0: Active
-			 *	state <  -deactivate_slack:
-			 *		 Pen termination of touch
-			 *
-			 * Specific values of interest
-			 *	state == activate_slack
-			 *		 no valid input since the last reset
-			 *
-			 *	state == 0
-			 *		 general operational state
-			 *
-			 *	state == -deactivate_slack
-			 *		 read sufficient empty frames to accept
-			 *		 the end of input and reset
+			 * Entered this block inactive and no
+			 * coordinates sent this frame, so hold off
+			 * on button state.
 			 */
-
-			if (nd->act_state > 0) { /* Currently inactive */
-				if (value)
-					/*
-					 * Consider each live contact as
-					 * evidence of intentional activity.
-					 */
-					nd->act_state = (nd->act_state > value)
-							? nd->act_state - value
-							: 0;
-				else
-					/*
-					 * Empty frame before we hit the
-					 * activity threshold, reset.
-					 */
-					nd->act_state = nd->activate_slack;
-
+			break;
+		} else { /* Currently active */
+			if (value && nd->act_state >=
+				     nd->deactivate_slack)
 				/*
-				 * Entered this block inactive and no
-				 * coordinates sent this frame, so hold off
-				 * on button state.
+				 * Live point: clear accumulated
+				 * deactivation count.
 				 */
-				break;
-			} else { /* Currently active */
-				if (value && nd->act_state >=
-					     nd->deactivate_slack)
-					/*
-					 * Live point: clear accumulated
-					 * deactivation count.
-					 */
-					nd->act_state = 0;
-				else if (nd->act_state <= nd->deactivate_slack)
-					/*
-					 * We've consumed the deactivation
-					 * slack, time to deactivate and reset.
-					 */
-					nd->act_state =
-						nd->activate_slack;
-				else { /* Move towards deactivation */
-					nd->act_state--;
-					break;
-				}
-			}
-
-			if (nd->first_contact_touch && nd->act_state <= 0) {
+				nd->act_state = 0;
+			else if (nd->act_state <= nd->deactivate_slack)
 				/*
-				 * Check to see if we're ready to start
-				 * emitting touch events.
-				 *
-				 * Note: activation slack will decrease over
-				 * the course of the frame, and it will be
-				 * inconsistent from the start to the end of
-				 * the frame.  However if the frame starts
-				 * with slack, first_contact_touch will still
-				 * be 0 and we will not get to this point.
+				 * We've consumed the deactivation
+				 * slack, time to deactivate and reset.
 				 */
-				input_report_key(input, BTN_TOOL_DOUBLETAP, 1);
-				input_report_key(input, BTN_TOUCH, 1);
-			} else {
-				input_report_key(input, BTN_TOOL_DOUBLETAP, 0);
-				input_report_key(input, BTN_TOUCH, 0);
+				nd->act_state =
+					nd->activate_slack;
+			else { /* Move towards deactivation */
+				nd->act_state--;
+				break;
 			}
-			break;
+		}
 
-		default:
-			/* fall-back to the generic hidinput handling */
-			return 0;
+		if (nd->first_contact_touch && nd->act_state <= 0) {
+			/*
+			 * Check to see if we're ready to start
+			 * emitting touch events.
+			 *
+			 * Note: activation slack will decrease over
+			 * the course of the frame, and it will be
+			 * inconsistent from the start to the end of
+			 * the frame.  However if the frame starts
+			 * with slack, first_contact_touch will still
+			 * be 0 and we will not get to this point.
+			 */
+			input_report_key(input, BTN_TOOL_DOUBLETAP, 1);
+			input_report_key(input, BTN_TOUCH, 1);
+		} else {
+			input_report_key(input, BTN_TOOL_DOUBLETAP, 0);
+			input_report_key(input, BTN_TOUCH, 0);
 		}
+		break;
+
+	default:
+		/* fall-back to the generic hidinput handling */
+		return 0;
 	}
 
+not_claimed_input:
 	/* we have handled the hidinput part, now remains hiddev */
 	if ((hid->claimed & HID_CLAIMED_HIDDEV) && hid->hiddev_hid_event)
 		hid->hiddev_hid_event(hid, field, usage, value);
-- 
1.7.2.3

