Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab0KGWOm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 17:14:42 -0500
Received: from fox.seas.upenn.edu ([158.130.68.12]:49201 "EHLO
	fox.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab0KGWOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 17:14:40 -0500
Message-ID: <4CD724BC.8020702@seas.upenn.edu>
Date: Sun, 07 Nov 2010 17:14:20 -0500
From: Rafi Rubin <rafi@seas.upenn.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Bagwell <chris@cnpbagwell.com>,
        Chase Douglas <chasedouglas@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        =?ISO-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>
Subject: Re: [PATCH] input: Introduce light-weight contact tracking
References: <1289161108-32309-1-git-send-email-rydberg@euromail.se>
In-Reply-To: <1289161108-32309-1-git-send-email-rydberg@euromail.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2010-11-07_07:2010-11-05,2010-11-07,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=2
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1005130000 definitions=main-1011070126
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2010 03:18 PM, Henrik Rydberg wrote:
> The synaptics patches are currently cooking at Bagwell's, and we
> already discussed the API a bit. Something ntrig-ish is cooking at
> Rubin's, and there is also the ntrig driver in Ubuntu 10.10 to
> consider. All-in-all, it is my hope that posting this patch will
> simplify the synchronization of our efforts.

Since Henrik brought it up, here's the tracking code I've been working on.  I 
have not run performance tests.  My goals for this code are perhaps a little 
different.

- efficient for the common case where contact ordering stays consistent
- arbitrary number of contacts
- motion estimation to improve tracking
- leveraging tracking for error filtering

Also for fun, I was playing with smoothing in this particular version of the code.

For now, I'm sending this just for review and discussion.

Rafi

---
diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
index 69169ef..d163b9b 100644
--- a/drivers/hid/hid-ntrig.c
+++ b/drivers/hid/hid-ntrig.c
@@ -19,10 +19,25 @@
  #include "usbhid/usbhid.h"
  #include <linux/module.h>
  #include <linux/slab.h>
+#include <linux/list.h>

  #include "hid-ids.h"

  #define NTRIG_DUPLICATE_USAGES	0x001
+/**
+ * list_rotate_left - rotate the list to the left
+ * @head: the head of the list
+ */
+static inline void list_rotate_right(struct list_head *head)
+{
+	struct list_head *last;
+
+	if (!list_empty(head)) {
+		last = head->prev;
+		list_move(last, head);
+	}
+}
+

  static unsigned int min_width;
  module_param(min_width, uint, 0644);
@@ -52,10 +67,45 @@ module_param(activation_height, uint, 0644);
  MODULE_PARM_DESC(activation_height, "Height threshold to immediately start "
  		 "processing touch events.");

+struct ntrig_slot {
+	__u16 id;
+	struct list_head list;
+};
+
+struct ntrig_contact {
+	__u16 x, y, w, h;
+	__s16 est_x_min, est_x_max, est_y_min, est_y_max;
+	__s16 dx, dy;
+	__s16 id;
+
+	/* An age factor for counting frames since a track was last seen.
+	 * This enables drop compensation and delayed termination. */
+	__u8 inactive;
+
+	struct ntrig_slot *slot;
+
+	struct list_head list;
+
+	/* List of tracks sorted by first seen order */
+	struct list_head active_tracks;
+};
+
+struct ntrig_frame {
+
+	/* Items that represent physical contacts which have been mapped
+	 * to contacts from previous frames. */
+	struct list_head tracked;
+
+	/* Contacts that have yet to be matched and might be ghosts. */
+	struct list_head pending;
+	struct list_head list;
+};
+
  struct ntrig_data {
  	/* Incoming raw values for a single contact */
  	__u16 x, y, w, h;
  	__u16 id;
+	int slots;

  	bool tipswitch;
  	bool confidence;
@@ -63,6 +113,8 @@ struct ntrig_data {

  	bool reading_mt;

+	__u8 max_contacts;
+
  	__u8 mt_footer[4];
  	__u8 mt_foot_count;

@@ -87,8 +139,24 @@ struct ntrig_data {
  	__u16 sensor_logical_height;
  	__u16 sensor_physical_width;
  	__u16 sensor_physical_height;
-};

+	__u16 r_y;
+	__u16 r_x;
+
+	/* Circular list of frames used to maintain state of contacts */
+	struct list_head frames;
+
+	/* Contacts representing the last input from lost tracks and
+	 * old contacts to be recycled */
+	struct list_head old_contacts;
+
+	struct list_head available_slots;
+	struct list_head active_tracks;
+
+	struct ntrig_frame *first_frame;
+	struct ntrig_slot *first_slot;
+	struct ntrig_contact *first_contact;
+};

  /*
   * This function converts the 4 byte raw firmware code into
@@ -439,6 +507,7 @@ static int ntrig_input_mapping(struct hid_device *hdev, 
struct hid_input *hi,
  	case HID_UP_GENDESK:
  		switch (usage->hid) {
  		case HID_GD_X:
+			nd->max_contacts++;
  			hid_map_usage(hi, usage, bit, max,
  					EV_ABS, ABS_MT_POSITION_X);
  			input_set_abs_params(hi->input, ABS_X,
@@ -505,6 +574,8 @@ static int ntrig_input_mapping(struct hid_device *hdev, 
struct hid_input *hi,
  			input_set_abs_params(hi->input, ABS_MT_ORIENTATION,
  					     0, 1, 0, 0);
  			return 1;
+		case HID_DG_CONTACTCOUNT:
+			break;
  		}
  		return 0;

@@ -531,6 +602,299 @@ static int ntrig_input_mapped(struct hid_device *hdev, 
struct hid_input *hi,
  	return 0;
  }

+static void ntrig_store_contact(struct ntrig_data *nd)
+{
+	struct ntrig_contact *contact;
+	struct ntrig_frame *frame;
+
+	if (list_empty(&nd->old_contacts))
+		printk(KERN_ERR "Ran out of contacts\n");
+
+	if (list_empty(&nd->old_contacts) || list_empty(&nd->frames))
+		return;
+
+	frame = list_first_entry(&nd->frames, struct ntrig_frame, list);
+
+	contact = list_entry(nd->old_contacts.prev, struct ntrig_contact,
+			     list);
+	contact->inactive = 0;
+	contact->x = nd->x;
+	contact->y = nd->y;
+	contact->w = nd->w;
+	contact->h = nd->h;
+	contact->id = nd->max_contacts;
+
+	contact->est_y_min = nd->y - nd->r_y;
+	contact->est_y_max = nd->y + nd->r_y;
+	contact->est_x_min = nd->x - nd->r_x;
+	contact->est_x_max = nd->x + nd->r_x;
+
+	list_move_tail(&contact->list, &frame->pending);
+}
+
+/* Update the state of a track to the most recent matched contact */
+static inline void ntrig_update_track(struct ntrig_data *nd,
+				      struct ntrig_contact *old,
+				      struct ntrig_contact *cur,
+				      struct ntrig_frame *frame)
+{
+	/* Simple motion estimation */
+	cur->dx = cur->x - old->x;
+	cur->dy = cur->y - old->y;
+	cur->est_x_min = cur->x + cur->dx - nd->r_x;
+	cur->est_x_max = cur->x + cur->dx + nd->r_x;
+	cur->est_y_min = cur->y + cur->dy - nd->r_y;
+	cur->est_y_max = cur->y + cur->dy + nd->r_y;
+
+	/* Update the state of the contact in the frame */
+	list_move_tail(&cur->list, &frame->tracked);
+
+	/* Recycle the old contact.  At the moment only the
+	 * most recent contact of a track is used. */
+	old->inactive = nd->deactivate_slack;
+	list_move_tail(&old->list, &nd->old_contacts);
+
+	/* move the slot pointer to the new contact */
+	cur->slot = old->slot;
+	old->slot = NULL;
+
+	/* Update the pointer in the active tracks list to the new
+	 * contact.  If this track doesn't have a slot, assign it one
+	 * and add to the tail of the list.  If we run out of slots
+	 * we can assign one when a slot opens up. */
+	if (cur->slot) {
+		cur->id = cur->slot->id;
+		list_replace(&old->active_tracks, &cur->active_tracks);
+	} else if (!list_empty(&nd->available_slots)) {
+		cur->slot = list_first_entry(&nd->available_slots,
+				struct ntrig_slot, list);
+		nd->slots--;
+		cur->id = cur->slot->id;
+		list_del(&cur->slot->list);
+		list_add_tail(&cur->active_tracks, &nd->active_tracks);
+	}
+}
+
+static inline bool ntrig_match(struct ntrig_data *nd, struct ntrig_contact *a,
+			       struct ntrig_contact *b,
+			       struct ntrig_frame *frame)
+{
+	if (b->y >= a->est_y_min && b->y <= a->est_y_max &&
+		b->x >= a->est_x_min && b->x <= a->est_x_max) {
+		ntrig_update_track(nd, a, b, frame);
+		a->inactive = nd->deactivate_slack;
+		list_move_tail(&a->list, &nd->old_contacts);
+		return true;
+	}
+
+	return false;
+}
+
+static inline bool ntrig_match_three(struct ntrig_data *nd,
+				     struct ntrig_contact *a,
+				     struct ntrig_contact *b,
+				     struct ntrig_contact *c,
+				     struct ntrig_frame *frame)
+{
+	int est_y = b->y * 2 - a->y;
+	int est_x = b->x * 2 - a->x;
+
+	if (c->y >= est_y - nd->r_y && c->y <= est_y + nd->r_y &&
+	    c->x >= est_x - nd->r_x && c->x <= est_x + nd->r_x) {
+		ntrig_update_track(nd, b, c, frame);
+		return true;
+	}
+
+	return false;
+}
+
+static inline void ntrig_terminate_track(struct ntrig_data *nd,
+					 struct ntrig_contact *contact)
+{
+	/* slot should not be NULL here, but checking to be sure */
+	if (contact->slot) {
+		/* return the slot to the available pool */
+		list_add_tail(&contact->slot->list, &nd->available_slots);
+		nd->slots++;
+		contact->slot = NULL;
+		list_del(&contact->active_tracks);
+	}
+
+	/* mark this contact as expired */
+	contact->inactive = nd->deactivate_slack;
+}
+
+/* Shift and increase the size of the region of the estimated position
+ * for a lost track */
+static inline bool ntrig_age_contact(struct ntrig_data *nd,
+				     struct ntrig_contact *contact)
+{
+	contact->inactive++;
+	if (contact->inactive >= nd->deactivate_slack) {
+		contact->inactive++;
+		ntrig_terminate_track(nd, contact);
+		return true;
+	} else {
+		contact->est_x_min += contact->dx -
+				      (nd->r_x >> contact->inactive);
+		contact->est_x_max += contact->dx +
+				      (nd->r_x >> contact->inactive);
+		contact->est_y_min += contact->dy -
+				      (nd->r_y >> contact->inactive);
+		contact->est_y_max += contact->dy +
+				      (nd->r_y >> contact->inactive);
+	}
+	return false;
+}
+
+static void track(struct ntrig_data *nd)
+{
+	struct ntrig_frame *prev_frame, *cur_frame, *older_frame;
+	struct ntrig_contact *old, *old_tmp, *cur, *cur_tmp, *older, *older_tmp;
+
+	if (list_empty(&nd->frames))
+		return;
+
+	older_frame = list_first_entry(nd->frames.next->next,
+				       struct ntrig_frame, list);
+	prev_frame = list_first_entry(nd->frames.next, struct ntrig_frame,
+				      list);
+	cur_frame = list_first_entry(&nd->frames, struct ntrig_frame, list);
+
+	list_for_each_entry_safe(cur, cur_tmp, &cur_frame->pending, list) {
+		/* First look for a match in current active tracks.
+		 * By far the most common case is that this will
+		 * match the first element in the list */
+		list_for_each_entry_safe(old, old_tmp, &prev_frame->tracked,
+					 list) {
+			if (ntrig_match(nd, old, cur, cur_frame))
+				goto found;
+		}
+
+		/* Compare against retiring, but not yet deactivated tracks */
+		list_for_each_entry_safe(old, old_tmp, &nd->old_contacts,
+					 list) {
+			if (old->inactive >= nd->deactivate_slack &&
+			    old->inactive)
+				break;
+
+			if (ntrig_match(nd, old, cur, cur_frame))
+				goto found;
+		}
+
+		/* Search for a match among unmatch contacts in the previous
+		 * frame.  This is where new tracks are found */
+		list_for_each_entry_safe(old, old_tmp, &prev_frame->pending,
+					 list) {
+			if (ntrig_match(nd, old, cur, cur_frame))
+				goto found;
+		}
+
+		list_for_each_entry_safe(old, old_tmp, &prev_frame->pending,
+					 list) {
+			list_for_each_entry_safe(older, older_tmp,
+						 &older_frame->pending,
+						 list) {
+				if (ntrig_match_three(nd, older, old, cur,
+						      cur_frame))
+					goto found;
+			}
+		}
+
+found:;
+	}
+
+	/* Traces that were active last frame but absent from the current frame
+	 * are dropped to the old_contacts list for aging and possible recovery
+	 */
+	list_for_each_entry_safe(old, old_tmp, &prev_frame->tracked, list) {
+		if (nd->deactivate_slack <= 0) {
+			ntrig_terminate_track(nd, old);
+			old->inactive = 1;
+		}
+	}
+	list_splice_init(&prev_frame->tracked, &nd->old_contacts);
+}
+
+static void emit_frame(struct input_dev *input, struct ntrig_data *nd)
+{
+	struct ntrig_contact *contact, *contact_tmp;
+	struct ntrig_frame *frame;
+
+	if (list_empty(&nd->frames))
+		return;
+
+	/* Age old contacts and terminate expired tracks */
+	list_for_each_entry_safe(contact, contact_tmp, &nd->old_contacts,
+				 list) {
+		/* Potentially interesting contacts should be
+		 * sorted by the number of frames since they
+		 * were last seen.  We can stop iterating with the
+		 * first expired contact. */
+		if (contact->inactive >= nd->deactivate_slack &&
+		    contact->inactive)
+			break;
+
+		ntrig_age_contact(nd, contact);
+	}
+
+	frame = list_first_entry(&nd->frames, struct ntrig_frame, list);
+
+	if (!list_empty(&frame->tracked)) {
+		if (!list_empty(&nd->active_tracks)) {
+			/* Emit the position of the oldest active track as
+			 * normal events. */
+			contact = list_first_entry(&nd->active_tracks,
+						   struct ntrig_contact,
+						   active_tracks);
+			input_report_key(input, BTN_TOUCH, 1);
+			input_event(input, EV_ABS, ABS_X,
+				    contact->x - (contact->dx/2));
+			input_event(input, EV_ABS, ABS_Y,
+				    contact->y - (contact->dy/2));
+		}
+	} else if (list_empty(&nd->active_tracks)) {
+		input_report_key(input, BTN_TOUCH, 0);
+	}
+
+	/* Emit MT events */
+	list_for_each_entry(contact, &frame->tracked, list) {
+		input_event(input, EV_ABS, ABS_MT_POSITION_X,
+			    contact->x - (contact->dx/2));
+		input_event(input, EV_ABS, ABS_MT_POSITION_Y,
+			    contact->y - (contact->dy/2));
+		/*
+		 * Translate from height and width to size
+		 * and orientation.
+		 */
+		if (contact->w > contact->h) {
+			input_event(input, EV_ABS, ABS_MT_ORIENTATION, 1);
+			input_event(input, EV_ABS, ABS_MT_TOUCH_MAJOR,
+				    contact->w);
+			input_event(input, EV_ABS, ABS_MT_TOUCH_MINOR,
+				    contact->h);
+		} else {
+			input_event(input, EV_ABS, ABS_MT_ORIENTATION, 0);
+			input_event(input, EV_ABS, ABS_MT_TOUCH_MAJOR,
+				    contact->h);
+			input_event(input, EV_ABS, ABS_MT_TOUCH_MINOR,
+				    contact->w);
+		}
+		input_mt_sync(input);
+	}
+
+	list_rotate_right(&nd->frames);
+	frame = list_first_entry(&nd->frames, struct ntrig_frame, list);
+
+	/* Recycle the old conacts to prepare the frame for reuse */
+	list_splice_init(&frame->tracked, &frame->pending);
+
+	list_for_each_entry(contact, &frame->pending, list) {
+		contact->inactive = nd->deactivate_slack;
+	}
+	list_splice_tail_init(&frame->pending, &nd->old_contacts);
+}
+
  /*
   * this function is called upon all reports
   * so that we can filter contact point information,
@@ -631,87 +995,11 @@ static int ntrig_event (struct hid_device *hid, struct 
hid_field *field,
  			 * The first footer value indicates the presence of a
  			 * finger.
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
-					/*
-					 * Defer adjusting the activation state
-					 * until the end of the frame.
-					 */
-					break;
-			}
-
-			/* Discarding this contact */
-			if (!nd->confidence)
+			if (!nd->mt_footer[0])
  				break;

-			/* emit a normal (X, Y) for the first point only */
-			if (nd->id == 0) {
-				/*
-				 * TipSwitch is superfluous in multitouch
-				 * mode.  The footer events tell us
-				 * if there is a finger on the screen or
-				 * not.
-				 */
-				nd->first_contact_touch = nd->confidence;
-				input_event(input, EV_ABS, ABS_X, nd->x);
-				input_event(input, EV_ABS, ABS_Y, nd->y);
-			}
-
-			/* Emit MT events */
-			input_event(input, EV_ABS, ABS_MT_POSITION_X, nd->x);
-			input_event(input, EV_ABS, ABS_MT_POSITION_Y, nd->y);
-
-			/*
-			 * Translate from height and width to size
-			 * and orientation.
-			 */
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
+			if (nd->confidence)
+				ntrig_store_contact(nd);
  			break;

  		case HID_DG_CONTACTCOUNT: /* End of a multitouch group */
@@ -720,89 +1008,9 @@ static int ntrig_event (struct hid_device *hid, struct 
hid_field *field,

  			nd->reading_mt = 0;

+			track(nd);
+			emit_frame(input, nd);

-			/*
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
-			 */
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
-				/*
-				 * Entered this block inactive and no
-				 * coordinates sent this frame, so hold off
-				 * on button state.
-				 */
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
-				/*
-				 * Check to see if we're ready to start
-				 * emitting touch events.
-				 *
-				 * Note: activation slack will decrease over
-				 * the course of the frame, and it will be
-				 * inconsistent from the start to the end of
-				 * the frame.  However if the frame starts
-				 * with slack, first_contact_touch will still
-				 * be 0 and we will not get to this point.
-				 */
-				input_report_key(input, BTN_TOOL_DOUBLETAP, 1);
-				input_report_key(input, BTN_TOUCH, 1);
-			} else {
-				input_report_key(input, BTN_TOOL_DOUBLETAP, 0);
-				input_report_key(input, BTN_TOUCH, 0);
-			}
  			break;

  		default:
@@ -818,33 +1026,93 @@ static int ntrig_event (struct hid_device *hid, struct 
hid_field *field,
  	return 1;
  }

+static int ntrig_alloc_mt_structures(struct ntrig_data *nd, int contact_count)
+{
+	struct ntrig_frame *frames;
+	struct ntrig_slot *slots;
+	struct ntrig_contact *contacts;
+	int i, num_frames, num_slots, num_contacts;
+
+	num_frames = 3;
+	num_slots = contact_count * 2;
+	num_contacts = (num_frames + 1) * contact_count;
+
+	frames = kcalloc(num_frames, sizeof(*frames), GFP_KERNEL);
+	if (!frames)
+		goto err;
+	nd->first_frame = frames;
+
+	contacts = kcalloc(num_contacts, sizeof(*contacts),
+			GFP_KERNEL);
+	if (!contacts)
+		goto err_free_frames;
+	nd->first_contact = contacts;
+
+	slots = kcalloc(num_slots, sizeof(*slots), GFP_KERNEL);
+	if (!slots)
+		goto err_free_contacts;
+	nd->first_slot = slots;
+
+	nd->slots = num_slots;
+
+	/* Stuff the structures into their initial lists */
+	for (i = 0; i < num_frames; i++) {
+		INIT_LIST_HEAD(&frames[i].tracked);
+		INIT_LIST_HEAD(&frames[i].pending);
+		list_add(&frames[i].list, &nd->frames);
+	}
+
+	for (i = 0; i < num_slots; i++) {
+		slots[i].id = i;
+		list_add_tail(&slots[i].list, &nd->available_slots);
+	}
+
+	for (i = 0; i < num_contacts; i++) {
+		/* Tag as expired */
+		contacts[i].inactive = nd->deactivate_slack;
+		list_add(&contacts[i].list, &nd->old_contacts);
+	}
+
+	return 0;
+
+err_free_contacts:
+	kfree(contacts);
+err_free_frames:
+	kfree(frames);
+err:
+	return -ENOMEM;
+}
+
  static int ntrig_probe(struct hid_device *hdev, const struct hid_device_id *id)
  {
-	int ret;
+	int ret, i, j, contacts;
  	struct ntrig_data *nd;
  	struct hid_input *hidinput;
  	struct input_dev *input;
  	struct hid_report *report;
+	struct hid_field *field;

  	if (id->driver_data)
  		hdev->quirks |= HID_QUIRK_MULTI_INPUT;

-	nd = kmalloc(sizeof(struct ntrig_data), GFP_KERNEL);
+	nd = kzalloc(sizeof(*nd), GFP_KERNEL);
  	if (!nd) {
  		dev_err(&hdev->dev, "cannot allocate N-Trig data\n");
  		return -ENOMEM;
  	}

-	nd->reading_mt = 0;
-	nd->min_width = 0;
-	nd->min_height = 0;
  	nd->activate_slack = activate_slack;
  	nd->act_state = activate_slack;
  	nd->deactivate_slack = -deactivate_slack;
-	nd->sensor_logical_width = 0;
-	nd->sensor_logical_height = 0;
-	nd->sensor_physical_width = 0;
-	nd->sensor_physical_height = 0;
+	nd->r_x = 500;
+	nd->r_y = 500;
+
+
+	/* Initialize tracking structures */
+	INIT_LIST_HEAD(&nd->frames);
+	INIT_LIST_HEAD(&nd->old_contacts);
+	INIT_LIST_HEAD(&nd->available_slots);
+	INIT_LIST_HEAD(&nd->active_tracks);

  	hid_set_drvdata(hdev, nd);

@@ -865,8 +1133,9 @@ static int ntrig_probe(struct hid_device *hdev, const 
struct hid_device_id *id)
  		if (hidinput->report->maxfield < 1)
  			continue;

+		report = hidinput->report;
  		input = hidinput->input;
-		switch (hidinput->report->field[0]->application) {
+		switch (report->field[0]->application) {
  		case HID_DG_PEN:
  			input->name = "N-Trig Pen";
  			break;
@@ -877,26 +1146,30 @@ static int ntrig_probe(struct hid_device *hdev, const 
struct hid_device_id *id)
  			__clear_bit(BTN_TOOL_FINGER, input->keybit);
  			__clear_bit(BTN_0, input->keybit);
  			__set_bit(BTN_TOOL_DOUBLETAP, input->keybit);
-			/*
-			 * The physical touchscreen (single touch)
-			 * input has a value for physical, whereas
-			 * the multitouch only has logical input
-			 * fields.
-			 */
-			input->name =
-				(hidinput->report->field[0]
-				 ->physical) ?
-				"N-Trig Touchscreen" :
-				"N-Trig MultiTouch";
+
+			contacts = 0;
+			for (i = 0; i < report->maxfield; i++) {
+				field = report->field[i];
+				for (j = 0; j <= field->maxusage; j++) {
+					if (field->usage[j].hid ==
+					    HID_DG_CONTACTID)
+						contacts++;
+				}
+			}
+
+			/* Only MT devices have contact id */
+			if (contacts) {
+				input->name = "N-Trig MultiTouch";
+				nd->max_contacts = contacts;
+				ret = ntrig_alloc_mt_structures(nd, contacts);
+				if (ret)
+					goto err_free;
+			} else
+				input->name = "N-Trig Touchscreen";
  			break;
  		}
  	}

-	/* This is needed for devices with more recent firmware versions */
-	report = hdev->report_enum[HID_FEATURE_REPORT].report_id_hash[0x0a];
-	if (report)
-		usbhid_submit_report(hdev, report, USB_DIR_OUT);
-
  	ntrig_report_version(hdev);

  	ret = sysfs_create_group(&hdev->dev.kobj,
@@ -910,10 +1183,16 @@ err_free:

  static void ntrig_remove(struct hid_device *hdev)
  {
+	struct ntrig_data *nd = hid_get_drvdata(hdev);
+
  	sysfs_remove_group(&hdev->dev.kobj,
  			   &ntrig_attribute_group);
  	hid_hw_stop(hdev);
-	kfree(hid_get_drvdata(hdev));
+
+	kfree(nd->first_frame);
+	kfree(nd->first_slot);
+	kfree(nd->first_contact);
+	kfree(nd);
  }

  static const struct hid_device_id ntrig_devices[] = {
