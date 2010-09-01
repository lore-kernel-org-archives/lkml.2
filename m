Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab0IAB1C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 21:27:02 -0400
Received: from adelie.canonical.com ([91.189.90.139]:35821 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157Ab0IAB1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 21:27:00 -0400
Subject: Re: [PATCH 5/6 v2] HID: magicmouse: enable Magic Trackpad support
From: Chase Douglas <chase.douglas@canonical.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>, Michael Poole <mdpoole@troilus.org>,
        Tejun Heo <tj@kernel.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <4C7D7B6F.2070206@euromail.se>
References: <1283280068-12285-1-git-send-email-chase.douglas@canonical.com>
	 <1283280068-12285-5-git-send-email-chase.douglas@canonical.com>
	 <4C7D7B6F.2070206@euromail.se>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Aug 2010 21:26:52 -0400
Message-ID: <1283304412.2255.340.camel@mini>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-01 at 00:00 +0200, Henrik Rydberg wrote:
> On 08/31/2010 08:41 PM, Chase Douglas wrote:
> 
> > The trackpad speaks a similar, but different, protocol from the magic
> > mouse. However, only small code tweaks here and there are needed to make
> > basic multitouch work.
> > 
> > Extra logic is required for single-touch emulation of the touchpad. The
> > changes made here take the approach that only one finger may emulate the
> > single pointer when multiple fingers have touched the screen. Once that
> > finger is raised, all touches must be raised before any further single
> > touch events can be sent.
> > 
> > Sometimes the magic trackpad sends two distinct touch reports as one big
> > report. Simply splitting the packet in two and resending them through
> > magicmouse_raw_event ensures they are handled properly.
> > 
> > I also added myself to the copyright statement.
> > 
> > Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
> 
> 
> Thanks for this driver. Comments inline.
> 
> [...]
> 
> > @@ -166,15 +170,29 @@ static void magicmouse_emit_buttons(struct magicmouse_sc *msc, int state)
> >  static void magicmouse_emit_touch(struct magicmouse_sc *msc, int raw_id, u8 *tdata)
> >  {
> >  	struct input_dev *input = msc->input;
> > -	int id = (tdata[6] << 2 | tdata[5] >> 6) & 0xf;
> > -	int x = (tdata[1] << 28 | tdata[0] << 20) >> 20;
> > -	int y = -((tdata[2] << 24 | tdata[1] << 16) >> 20);
> > -	int size = tdata[5] & 0x3f;
> > -	int orientation = (tdata[6] >> 2) - 32;
> > -	int touch_major = tdata[3];
> > -	int touch_minor = tdata[4];
> > -	int state = tdata[7] & TOUCH_STATE_MASK;
> > -	int down = state != TOUCH_STATE_NONE;
> > +	int id, x, y, size, orientation, touch_major, touch_minor, state, down;
> > +
> > +	if (input->id.product == USB_DEVICE_ID_APPLE_MAGICMOUSE) {
> > +		id = (tdata[6] << 2 | tdata[5] >> 6) & 0xf;
> > +		x = (tdata[1] << 28 | tdata[0] << 20) >> 20;
> > +		y = -((tdata[2] << 24 | tdata[1] << 16) >> 20);
> > +		size = tdata[5] & 0x3f;
> > +		orientation = (tdata[6] >> 2) - 32;
> > +		touch_major = tdata[3];
> > +		touch_minor = tdata[4];
> > +		state = tdata[7] & TOUCH_STATE_MASK;
> > +		down = state != TOUCH_STATE_NONE;
> > +	} else { /* USB_DEVICE_ID_APPLE_MAGICTRACKPAD */
> > +		id = (tdata[7] << 2 | tdata[6] >> 6) & 0xf;
> > +		x = (tdata[1] << 27 | tdata[0] << 19) >> 19;
> > +		y = -((tdata[3] << 30 | tdata[2] << 22 | tdata[1] << 14) >> 19);
> > +		size = tdata[6] & 0x3f;
> > +		orientation = (tdata[7] >> 2) - 32;
> > +		touch_major = tdata[4];
> > +		touch_minor = tdata[5];
> > +		state = tdata[8] & TOUCH_STATE_MASK;
> > +		down = state != TOUCH_STATE_NONE;
> > +	}
> >  
> >  	/* Store tracking ID and other fields. */
> >  	msc->tracking_ids[raw_id] = id;
> > @@ -225,10 +243,15 @@ static void magicmouse_emit_touch(struct magicmouse_sc *msc, int raw_id, u8 *tda
> >  		}
> >  	}
> >  
> > -	/* Generate the input events for this touch. */
> > -	if (report_touches && down) {
> > +	if (down) {
> >  		msc->touches[id].down = 1;
> > +		if (msc->single_touch_id == -1)
> > +			msc->single_touch_id = id;
> > +	} else if (msc->single_touch_id == id)
> > +		msc->single_touch_id = -2;
> 
> 
> The logic using single_touch_id seems complicated. Any chance you could get by
> with less code here?

The overall code for single touch handling is ~10 lines spread around
the driver. I've tried to condense the code as much as possible. Perhaps
someone could come up with something more elegant, but all this code
does is keep track of the touch that is tied to single touch emulation.

In my next submission I've added macros to make the -1 and -2 values
more obvious on inspection.

> > +	/* Generate the input events for this touch. */
> > +	if (report_touches && down) {
> >  		input_report_abs(input, ABS_MT_TRACKING_ID, id);
> 
> 
> The tracking id reported by the macpad is not ideal; it works more like a slot
> that a MT protocol tracking id. Perhaps it is a slot? I would recommend looking
> at the recent submissions for bamboo touch, 3m-pct and w8001 to see how the
> tracking id and slots could be handled.

Yes, I think it could be better handled. However, that handling probably
belongs in another patch when slots are implemented in this driver. I
just haven't had a chance to get to it yet :).

> >  		input_report_abs(input, ABS_MT_TOUCH_MAJOR, touch_major);
> >  		input_report_abs(input, ABS_MT_TOUCH_MINOR, touch_minor);
> > @@ -236,8 +259,12 @@ static void magicmouse_emit_touch(struct magicmouse_sc *msc, int raw_id, u8 *tda
> >  		input_report_abs(input, ABS_MT_POSITION_X, x);
> >  		input_report_abs(input, ABS_MT_POSITION_Y, y);
> >  
> > -		if (report_undeciphered)
> > -			input_event(input, EV_MSC, MSC_RAW, tdata[7]);
> > +		if (report_undeciphered) {
> > +			if (input->id.product == USB_DEVICE_ID_APPLE_MAGICMOUSE)
> > +				input_event(input, EV_MSC, MSC_RAW, tdata[7]);
> > +			else /* USB_DEVICE_ID_APPLE_MAGICTRACKPAD */
> > +				input_event(input, EV_MSC, MSC_RAW, tdata[8]);
> > +		}
> >  
> >  		input_mt_sync(input);
> >  	}
> > @@ -248,7 +275,7 @@ static int magicmouse_raw_event(struct hid_device *hdev,
> >  {
> >  	struct magicmouse_sc *msc = hid_get_drvdata(hdev);
> >  	struct input_dev *input = msc->input;
> > -	int x, y, ts, ii, clicks, last_up;
> > +	int x = 0, y = 0, ts, ii, clicks = 0, last_up;
> >  
> >  	switch (data[0]) {
> >  	case 0x10:
> > @@ -258,7 +285,19 @@ static int magicmouse_raw_event(struct hid_device *hdev,
> >  		y = (__s16)(data[4] | data[5] << 8);
> >  		clicks = data[1];
> >  		break;
> > -	case TOUCH_REPORT_ID:
> > +	case TRACKPAD_REPORT_ID:
> > +		/* Expect four bytes of prefix, and N*9 bytes of touch data. */
> > +		if (size < 4 || ((size - 4) % 9) != 0)
> > +			return 0;
> > +		ts = data[1] >> 6 | data[2] << 2 | data[3] << 10;
> > +		msc->delta_time = (ts - msc->last_timestamp) & 0x3ffff;
> > +		msc->last_timestamp = ts;
> 
> 
> The delta_time and last_timestamp do not seem to be used anywhere?

Good point. I've removed them in my next submission.

> > +		msc->ntouches = (size - 4) / 9;
> > +		for (ii = 0; ii < msc->ntouches; ii++)
> > +			magicmouse_emit_touch(msc, ii, data + ii * 9 + 4);
> > +		clicks = data[1];
> > +		break;
> > +	case MOUSE_REPORT_ID:
> >  		/* Expect six bytes of prefix, and N*8 bytes of touch data. */
> >  		if (size < 6 || ((size - 6) % 8) != 0)
> >  			return 0;
> > @@ -269,19 +308,6 @@ static int magicmouse_raw_event(struct hid_device *hdev,
> >  		for (ii = 0; ii < msc->ntouches; ii++)
> >  			magicmouse_emit_touch(msc, ii, data + ii * 8 + 6);
> >  
> > -		if (report_touches) {
> > -			last_up = 1;
> > -			for (ii = 0; ii < ARRAY_SIZE(msc->touches); ii++) {
> > -				if (msc->touches[ii].down) {
> > -					last_up = 0;
> > -					msc->touches[ii].down = 0;
> > -				}
> > -			}
> > -			if (last_up) {
> > -				input_mt_sync(input);
> > -			}
> > -		}
> > -
> >  		/* When emulating three-button mode, it is important
> >  		 * to have the current touch information before
> >  		 * generating a click event.
> > @@ -290,6 +316,14 @@ static int magicmouse_raw_event(struct hid_device *hdev,
> >  		y = (int)(((data[3] & 0x30) << 26) | (data[2] << 22)) >> 22;
> >  		clicks = data[3];
> >  		break;
> > +	case DOUBLE_REPORT_ID:
> > +		/* Sometimes the trackpad sends two touch reports in one
> > +		 * packet.
> > +		 */
> > +		magicmouse_raw_event(hdev, report, data + 2, data[1]);
> > +		magicmouse_raw_event(hdev, report, data + 2 + data[1],
> > +			size - 2 - data[1]);
> > +		break;
> 
> 
> Nice find.
> 
> >  	case 0x20: /* Theoretically battery status (0-100), but I have
> >  		    * never seen it -- maybe it is only upon request.
> >  		    */
> > @@ -301,9 +335,41 @@ static int magicmouse_raw_event(struct hid_device *hdev,
> >  		return 0;
> >  	}
> >  
> > -	magicmouse_emit_buttons(msc, clicks & 3);
> > -	input_report_rel(input, REL_X, x);
> > -	input_report_rel(input, REL_Y, y);
> > +	if ((data[0] == MOUSE_REPORT_ID || data[0] == TRACKPAD_REPORT_ID)) {
> > +		last_up = 1;
> > +		for (ii = 0; ii < ARRAY_SIZE(msc->touches); ii++) {
> > +			if (msc->touches[ii].down) {
> > +				last_up = 0;
> > +				msc->touches[ii].down = 0;
> > +			}
> > +		}
> > +		if (last_up) {
> > +			msc->single_touch_id = -1;
> > +			msc->ntouches = 0;
> > +			if (report_touches)
> > +				input_mt_sync(input);
> > +		}
> 
> 
> If the pointer emulation was handled differently, and the above was replaced
> with something like
> 
>    if (!msc->ntouches)
>   	input_mt_sync(input);
> 
> it would be short enough not to need to be broken out of the switch... Besides,
> BTN_TOUCH is emitted for the trackpad case, so the above code is not strictly
> needed.

I've rewritten the touch down logic, and this does get simple enough to
keep inside the switch scope.

> > +	}
> > +
> > +	if (input->id.product == USB_DEVICE_ID_APPLE_MAGICMOUSE) {
> > +		magicmouse_emit_buttons(msc, clicks & 3);
> > +		input_report_rel(input, REL_X, x);
> > +		input_report_rel(input, REL_Y, y);
> > +	} else { /* USB_DEVICE_ID_APPLE_MAGICTRACKPAD */
> > +		input_report_key(input, BTN_MOUSE, clicks & 1);
> > +		input_report_key(input, BTN_TOUCH, msc->ntouches > 0);
> > +		input_report_key(input, BTN_TOOL_FINGER, msc->ntouches == 1);
> > +		input_report_key(input, BTN_TOOL_DOUBLETAP, msc->ntouches == 2);
> > +		input_report_key(input, BTN_TOOL_TRIPLETAP, msc->ntouches == 3);
> > +		input_report_key(input, BTN_TOOL_QUADTAP, msc->ntouches == 4);
> > +		if (msc->single_touch_id >= 0) {
> > +			input_report_abs(input, ABS_X,
> > +				msc->touches[msc->single_touch_id].x);
> > +			input_report_abs(input, ABS_Y,
> > +				msc->touches[msc->single_touch_id].y);
> > +		}
> > +	}
> > +
> >  	input_sync(input);
> >  	return 1;
> >  }
> > @@ -339,18 +405,27 @@ static void magicmouse_setup_input(struct input_dev *input, struct hid_device *h
> >  	input->dev.parent = hdev->dev.parent;
> >  
> >  	__set_bit(EV_KEY, input->evbit);
> > -	__set_bit(BTN_LEFT, input->keybit);
> > -	__set_bit(BTN_RIGHT, input->keybit);
> > -	if (emulate_3button)
> > -		__set_bit(BTN_MIDDLE, input->keybit);
> > -	__set_bit(BTN_TOOL_FINGER, input->keybit);
> > -
> > -	__set_bit(EV_REL, input->evbit);
> > -	__set_bit(REL_X, input->relbit);
> > -	__set_bit(REL_Y, input->relbit);
> > -	if (emulate_scroll_wheel) {
> > -		__set_bit(REL_WHEEL, input->relbit);
> > -		__set_bit(REL_HWHEEL, input->relbit);
> > +
> > +	if (input->id.product == USB_DEVICE_ID_APPLE_MAGICMOUSE) {
> > +		__set_bit(BTN_LEFT, input->keybit);
> > +		__set_bit(BTN_RIGHT, input->keybit);
> > +		if (emulate_3button)
> > +			__set_bit(BTN_MIDDLE, input->keybit);
> > +
> > +		__set_bit(EV_REL, input->evbit);
> > +		__set_bit(REL_X, input->relbit);
> > +		__set_bit(REL_Y, input->relbit);
> > +		if (emulate_scroll_wheel) {
> > +			__set_bit(REL_WHEEL, input->relbit);
> > +			__set_bit(REL_HWHEEL, input->relbit);
> > +		}
> > +	} else { /* USB_DEVICE_ID_APPLE_MAGICTRACKPAD */
> > +		__set_bit(BTN_MOUSE, input->keybit);
> > +		__set_bit(BTN_TOOL_FINGER, input->keybit);
> > +		__set_bit(BTN_TOOL_DOUBLETAP, input->keybit);
> > +		__set_bit(BTN_TOOL_TRIPLETAP, input->keybit);
> > +		__set_bit(BTN_TOOL_QUADTAP, input->keybit);
> > +		__set_bit(BTN_TOUCH, input->keybit);
> >  	}
> >  
> >  	if (report_touches) {
> > @@ -360,16 +435,26 @@ static void magicmouse_setup_input(struct input_dev *input, struct hid_device *h
> >  		input_set_abs_params(input, ABS_MT_TOUCH_MAJOR, 0, 255, 0, 0);
> >  		input_set_abs_params(input, ABS_MT_TOUCH_MINOR, 0, 255, 0, 0);
> >  		input_set_abs_params(input, ABS_MT_ORIENTATION, -32, 31, 0, 0);
> > -		input_set_abs_params(input, ABS_MT_POSITION_X, -1100, 1358,
> > -				0, 0);
> > +
> >  		/* Note: Touch Y position from the device is inverted relative
> >  		 * to how pointer motion is reported (and relative to how USB
> >  		 * HID recommends the coordinates work).  This driver keeps
> >  		 * the origin at the same position, and just uses the additive
> >  		 * inverse of the reported Y.
> >  		 */
> > -		input_set_abs_params(input, ABS_MT_POSITION_Y, -1589, 2047,
> > -				0, 0);
> > +		if (input->id.product == USB_DEVICE_ID_APPLE_MAGICMOUSE) {
> > +			input_set_abs_params(input, ABS_MT_POSITION_X, -1100,
> > +				1358, 0, 0);
> > +			input_set_abs_params(input, ABS_MT_POSITION_Y, -1589,
> > +				2047, 0, 0);
> > +		} else { /* USB_DEVICE_ID_APPLE_MAGICTRACKPAD */
> > +			input_set_abs_params(input, ABS_X, -2909, 3167, 0, 0);
> > +			input_set_abs_params(input, ABS_Y, -2456, 2565, 0, 0);
> > +			input_set_abs_params(input, ABS_MT_POSITION_X, -2909,
> > +				3167, 0, 0);
> > +			input_set_abs_params(input, ABS_MT_POSITION_Y, -2456,
> > +				2565, 0, 0);
> > +		}
> >  	}
> >  
> >  	if (report_undeciphered) {
> > @@ -388,12 +473,29 @@ static struct feature mouse_features[] = {
> >  	{ { 0xf8, 0x01, 0x32 }, 3 }
> >  };
> >  
> > +static struct feature trackpad_features[] = {
> > +	{ { 0xf1, 0xdb }, 2 },
> > +	{ { 0xf1, 0xdc }, 2 },
> > +	{ { 0xf0, 0x00 }, 2 },
> > +	{ { 0xf1, 0xdd }, 2 },
> > +	{ { 0xf0, 0x02 }, 2 },
> > +	{ { 0xf1, 0xc8 }, 2 },
> > +	{ { 0xf0, 0x09 }, 2 },
> > +	{ { 0xf1, 0xdc }, 2 },
> > +	{ { 0xf0, 0x00 }, 2 },
> > +	{ { 0xf1, 0xdd }, 2 },
> > +	{ { 0xf0, 0x02 }, 2 },
> > +	{ { 0xd7, 0x01 }, 2 },
> > +};
> 
> 
> As noted by Michael, this could likely be simplified. the "0x01" on the last
> line could be the same coding as wellspring mode for bcm5974.

I've simplified this for the next submission.

-- Chase

